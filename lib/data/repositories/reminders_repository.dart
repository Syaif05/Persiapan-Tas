import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../services/notification_service.dart';
import '../../core/utils/datetime_utils.dart';

/// Konfigurasi draft pengingat sebelum disimpan
class ReminderConfig {
  final String? id;
  final String type; // 'at_time' | '15_mins_before' | '30_mins_before' | '1_hour_before' | '2_hours_before' | '1_day_before' | 'custom'
  final DateTime? customDateTime;
  final String explicitTimeForDateOnly; // HH:mm, default '09:00'
  final String precisionPreference; // 'exact' | 'inexact'
  final bool enabled;

  const ReminderConfig({
    this.id,
    required this.type,
    this.customDateTime,
    this.explicitTimeForDateOnly = '09:00',
    this.precisionPreference = 'exact',
    this.enabled = true,
  });

  ReminderConfig copyWith({
    String? id,
    String? type,
    DateTime? customDateTime,
    String? explicitTimeForDateOnly,
    String? precisionPreference,
    bool? enabled,
  }) {
    return ReminderConfig(
      id: id ?? this.id,
      type: type ?? this.type,
      customDateTime: customDateTime ?? this.customDateTime,
      explicitTimeForDateOnly:
          explicitTimeForDateOnly ?? this.explicitTimeForDateOnly,
      precisionPreference: precisionPreference ?? this.precisionPreference,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Label teks ramah pengguna dalam Bahasa Indonesia
  String get displayLabel {
    switch (type) {
      case 'at_time':
        return 'Tepat saat acara';
      case '15_mins_before':
        return '15 menit sebelumnya';
      case '30_mins_before':
        return '30 menit sebelumnya';
      case '1_hour_before':
        return '1 jam sebelumnya';
      case '2_hours_before':
        return '2 jam sebelumnya';
      case '1_day_before':
        return '1 hari sebelumnya';
      case 'custom':
        if (customDateTime != null) {
          try {
            final fmt = DateFormat('dd MMM yyyy, HH:mm', 'id');
            return 'Waktu khusus: ${fmt.format(customDateTime!)}';
          } catch (_) {
            return 'Waktu khusus: ${DateFormat('dd MMM yyyy, HH:mm').format(customDateTime!)}';
          }
        }
        return 'Waktu khusus';
      default:
        return 'Pengingat';
    }
  }
}

/// Model pengingat dengan entri database dan rincian jadwal
class ReminderWithDetails {
  final ReminderEntry reminder;
  final ScheduleEventEntry schedule;
  final TripEntry trip;

  const ReminderWithDetails({
    required this.reminder,
    required this.schedule,
    required this.trip,
  });

  String get id => reminder.id;
  String get scheduleEventId => reminder.scheduleEventId;
  String get triggerUtc => reminder.triggerUtc;
  int get notificationId => reminder.notificationId;
  String get precisionPreference => reminder.precisionPreference;
  String get schedulingState => reminder.schedulingState;
  bool get enabled => reminder.enabled;

  /// Label status dalam Bahasa Indonesia
  String get stateBadgeLabel {
    switch (schedulingState) {
      case 'active':
        return 'Aktif (Tepat waktu)';
      case 'approximate':
        return 'Aktif (Perkiraan)';
      case 'permission_required':
        return 'Izin diperlukan';
      case 'missed':
        return 'Terlewat';
      case 'disabled':
        return 'Nonaktif';
      default:
        return schedulingState;
    }
  }
}

class RemindersRepository {
  final AppDatabase _db;
  final NotificationService _notificationService;
  final Uuid _uuid = const Uuid();

  RemindersRepository(this._db, this._notificationService);

  /// Menghitung waktu trigger UTC dari konfigurasi dan data jadwal
  DateTime computeTriggerUtc({
    required ScheduleEventEntry schedule,
    required ReminderConfig config,
  }) {
    if (config.type == 'custom' && config.customDateTime != null) {
      return config.customDateTime!.toUtc();
    }

    final effectiveZone = schedule.startZone ?? AppDateTimeUtils.defaultZoneId;

    if (schedule.isDateOnly) {
      // Aturan PRD SCH-12: Jadwal tanpa jam membutuhkan jam eksplisit (misal 09:00)
      final parts = schedule.localDate.split('-');
      final eventDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );

      DateTime targetDate;
      if (config.type == '1_day_before') {
        targetDate = eventDate.subtract(const Duration(days: 1));
      } else {
        targetDate = eventDate;
      }

      final dateStr =
          "${targetDate.year.toString().padLeft(4, '0')}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}";

      final triggerUtcStr = AppDateTimeUtils.computeUtcInstant(
        dateStr,
        config.explicitTimeForDateOnly,
        effectiveZone,
      );

      if (triggerUtcStr != null) {
        return DateTime.parse(triggerUtcStr).toUtc();
      }
      return targetDate.toUtc();
    } else {
      // Jadwal berjam: basis waktu adalah startUtc
      final baseUtcStr = schedule.startUtc;
      final DateTime baseUtc = baseUtcStr != null
          ? DateTime.parse(baseUtcStr).toUtc()
          : DateTime.parse('${schedule.localDate}T${schedule.localStart ?? "09:00"}:00Z');

      switch (config.type) {
        case 'at_time':
          return baseUtc;
        case '15_mins_before':
          return baseUtc.subtract(const Duration(minutes: 15));
        case '30_mins_before':
          return baseUtc.subtract(const Duration(minutes: 30));
        case '1_hour_before':
          return baseUtc.subtract(const Duration(hours: 1));
        case '2_hours_before':
          return baseUtc.subtract(const Duration(hours: 2));
        case '1_day_before':
          return baseUtc.subtract(const Duration(days: 1));
        default:
          return baseUtc;
      }
    }
  }

  /// Menghasilkan ID notifikasi integer 31-bit positif unik yang bebas collision
  int _generateUniqueNotificationId(String id, Set<int> existingIds) {
    var candidate = (id.hashCode & 0x7FFFFFFF);
    if (candidate == 0) candidate = 1;
    while (existingIds.contains(candidate)) {
      candidate = (candidate + 1) & 0x7FFFFFFF;
      if (candidate == 0) candidate = 1;
    }
    existingIds.add(candidate);
    return candidate;
  }

  /// Menyimpan dan menjadwalkan ulang seluruh pengingat untuk suatu jadwal (SCH-08, SCH-10, AT-14)
  Future<void> saveRemindersForSchedule({
    required String scheduleEventId,
    required List<ReminderConfig> configs,
  }) async {
    // 1. Ambil jadwal terkait dari database
    final schedule = await (_db.select(_db.scheduleEvents)
          ..where((s) => s.id.equals(scheduleEventId)))
        .getSingleOrNull();

    if (schedule == null) return;

    // 2. Ambil pengingat lama untuk jadwal ini dan batalkan alarm di OS (AT-14)
    final existingReminders = await (_db.select(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(scheduleEventId)))
        .get();

    for (final oldReminder in existingReminders) {
      await _notificationService.cancelNotification(oldReminder.notificationId);
    }

    // 3. Hapus entri lama dari tabel database
    await (_db.delete(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(scheduleEventId)))
        .go();

    if (configs.isEmpty) return;

    // 4. Kumpulkan seluruh ID notifikasi aktif di database untuk memastikan keunikan mutlak
    final allReminders = await _db.select(_db.reminders).get();
    final existingIds = allReminders.map((r) => r.notificationId).toSet();

    // 5. Periksa status izin sistem saat ini
    final permissionStatus = await _notificationService.checkPermissionStatus();
    final nowUtc = DateTime.now().toUtc();

    // 6. Buat pengingat baru dan jadwalkan
    for (final config in configs) {
      final reminderId = config.id ?? _uuid.v4();
      final notificationId = _generateUniqueNotificationId(reminderId, existingIds);
      final triggerUtc = computeTriggerUtc(schedule: schedule, config: config);

      String schedulingState = 'active';

      if (!config.enabled) {
        schedulingState = 'disabled';
      } else if (triggerUtc.isBefore(nowUtc)) {
        // Terlewat (tidak dijadwalkan ulang sebagai alarm baru - PRD line 280)
        schedulingState = 'missed';
      } else if (!permissionStatus.notificationsAllowed) {
        // Izin notifikasi belum diizinkan oleh sistem (AT-12)
        schedulingState = 'permission_required';
      } else {
        // Izin notifikasi tersedia
        final isExact = (config.precisionPreference == 'exact') &&
            permissionStatus.exactAlarmsAllowed;

        schedulingState = isExact ? 'active' : 'approximate';

        final payload = NotificationPayloadData(
          tripId: schedule.tripId,
          scheduleEventId: schedule.id,
          reminderId: reminderId,
        );

        final eventTimeStr = AppDateTimeUtils.formatEventTime(
          schedule.localStart,
          schedule.startZone,
          isDateOnly: schedule.isDateOnly,
        );

        final bodyText = schedule.locationText != null &&
                schedule.locationText!.isNotEmpty
            ? "$eventTimeStr di ${schedule.locationText}"
            : "Waktu: $eventTimeStr";

        await _notificationService.scheduleReminder(
          notificationId: notificationId,
          title: "Pengingat: ${schedule.title}",
          body: bodyText,
          scheduledUtc: triggerUtc,
          payload: payload,
          isExact: isExact,
        );
      }

      await _db.into(_db.reminders).insert(
            RemindersCompanion.insert(
              id: reminderId,
              scheduleEventId: scheduleEventId,
              triggerUtc: triggerUtc.toIso8601String(),
              notificationId: notificationId,
              precisionPreference: Value(config.precisionPreference),
              schedulingState: Value(schedulingState),
              enabled: Value(config.enabled && schedulingState != 'missed'),
            ),
          );
    }
  }

  /// Menghapus seluruh pengingat untuk suatu jadwal dan membatalkan alarm OS (SCH-10)
  Future<void> deleteRemindersForSchedule(String scheduleEventId) async {
    final existingReminders = await (_db.select(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(scheduleEventId)))
        .get();

    for (final reminder in existingReminders) {
      await _notificationService.cancelNotification(reminder.notificationId);
    }

    await (_db.delete(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(scheduleEventId)))
        .go();
  }

  /// Mengamati daftar pengingat untuk suatu jadwal kegiatan
  Stream<List<ReminderEntry>> watchRemindersForSchedule(String scheduleEventId) {
    return (_db.select(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(scheduleEventId))
          ..orderBy([(r) => OrderingTerm.asc(r.triggerUtc)]))
        .watch();
  }

  /// Mengambil daftar pengingat untuk suatu jadwal
  Future<List<ReminderEntry>> getRemindersForSchedule(String scheduleEventId) {
    return (_db.select(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(scheduleEventId))
          ..orderBy([(r) => OrderingTerm.asc(r.triggerUtc)]))
        .get();
  }

  /// Mengaktifkan atau menonaktifkan pengingat tunggal
  Future<void> toggleReminder(String reminderId, bool enabled) async {
    final reminder = await (_db.select(_db.reminders)
          ..where((r) => r.id.equals(reminderId)))
        .getSingleOrNull();

    if (reminder == null) return;

    if (!enabled) {
      await _notificationService.cancelNotification(reminder.notificationId);
      await (_db.update(_db.reminders)..where((r) => r.id.equals(reminderId))).write(
        const RemindersCompanion(
          enabled: Value(false),
          schedulingState: Value('disabled'),
        ),
      );
    } else {
      final schedule = await (_db.select(_db.scheduleEvents)
            ..where((s) => s.id.equals(reminder.scheduleEventId)))
          .getSingleOrNull();

      if (schedule == null) return;

      final triggerUtc = DateTime.parse(reminder.triggerUtc).toUtc();
      final nowUtc = DateTime.now().toUtc();

      if (triggerUtc.isBefore(nowUtc)) {
        await (_db.update(_db.reminders)..where((r) => r.id.equals(reminderId))).write(
          const RemindersCompanion(
            enabled: Value(false),
            schedulingState: Value('missed'),
          ),
        );
        return;
      }

      final permissionStatus = await _notificationService.checkPermissionStatus();
      if (!permissionStatus.notificationsAllowed) {
        await (_db.update(_db.reminders)..where((r) => r.id.equals(reminderId))).write(
          const RemindersCompanion(
            enabled: Value(true),
            schedulingState: Value('permission_required'),
          ),
        );
        return;
      }

      final isExact = (reminder.precisionPreference == 'exact') &&
          permissionStatus.exactAlarmsAllowed;

      final payload = NotificationPayloadData(
        tripId: schedule.tripId,
        scheduleEventId: schedule.id,
        reminderId: reminder.id,
      );

      final eventTimeStr = AppDateTimeUtils.formatEventTime(
        schedule.localStart,
        schedule.startZone,
        isDateOnly: schedule.isDateOnly,
      );

      await _notificationService.scheduleReminder(
        notificationId: reminder.notificationId,
        title: "Pengingat: ${schedule.title}",
        body: "Waktu: $eventTimeStr",
        scheduledUtc: triggerUtc,
        payload: payload,
        isExact: isExact,
      );

      await (_db.update(_db.reminders)..where((r) => r.id.equals(reminderId))).write(
        RemindersCompanion(
          enabled: const Value(true),
          schedulingState: Value(isExact ? 'active' : 'approximate'),
        ),
      );
    }
  }

  /// Membatalkan dan menonaktifkan seluruh pengingat untuk suatu perjalanan (QA-35, SCH-10)
  Future<void> cancelRemindersForTrip(String tripId) async {
    final schedules = await (_db.select(_db.scheduleEvents)
          ..where((s) => s.tripId.equals(tripId)))
        .get();

    for (final schedule in schedules) {
      final reminders = await (_db.select(_db.reminders)
            ..where((r) => r.scheduleEventId.equals(schedule.id)))
          .get();

      for (final r in reminders) {
        await _notificationService.cancelNotification(r.notificationId);
      }

      await (_db.update(_db.reminders)
            ..where((r) => r.scheduleEventId.equals(schedule.id)))
          .write(
        const RemindersCompanion(
          enabled: Value(false),
          schedulingState: Value('disabled'),
        ),
      );
    }
  }

  /// Rekonsiliasi pengingat setelah reboot atau start aplikasi (AT-15, BAK-06, QA-47, QA-48)
  Future<void> reconcileAllReminders() async {
    final reminders = await (_db.select(_db.reminders)
          ..where((r) => r.enabled.equals(true)))
        .get();

    if (reminders.isEmpty) return;

    final permissionStatus = await _notificationService.checkPermissionStatus();
    final nowUtc = DateTime.now().toUtc();

    for (final reminder in reminders) {
      final triggerUtc = DateTime.parse(reminder.triggerUtc).toUtc();

      if (triggerUtc.isBefore(nowUtc)) {
        // Terlewat saat perangkat mati (QA-48: tidak membunyikan alarm lama)
        await (_db.update(_db.reminders)..where((r) => r.id.equals(reminder.id))).write(
          const RemindersCompanion(
            enabled: Value(false),
            schedulingState: Value('missed'),
          ),
        );
        continue;
      }

      final schedule = await (_db.select(_db.scheduleEvents)
            ..where((s) => s.id.equals(reminder.scheduleEventId)))
          .getSingleOrNull();

      if (schedule == null) continue;

      // Jika perjalanan dibatalkan/selesai/diarsipkan, jangan aktifkan alarm (QA-35)
      final trip = await (_db.select(_db.trips)
            ..where((t) => t.id.equals(schedule.tripId)))
          .getSingleOrNull();

        if (trip != null &&
            (trip.status == 'cancelled' || trip.status == 'completed' || trip.isArchived)) {
          await _notificationService.cancelNotification(reminder.notificationId);
          await (_db.update(_db.reminders)..where((r) => r.id.equals(reminder.id))).write(
            const RemindersCompanion(
              enabled: Value(false),
              schedulingState: Value('disabled'),
            ),
          );
          continue;
        }

      if (!permissionStatus.notificationsAllowed) {
        await (_db.update(_db.reminders)..where((r) => r.id.equals(reminder.id))).write(
          const RemindersCompanion(
            schedulingState: Value('permission_required'),
          ),
        );
        continue;
      }

      final isExact = (reminder.precisionPreference == 'exact') &&
          permissionStatus.exactAlarmsAllowed;

      final payload = NotificationPayloadData(
        tripId: schedule.tripId,
        scheduleEventId: schedule.id,
        reminderId: reminder.id,
      );

      final eventTimeStr = AppDateTimeUtils.formatEventTime(
        schedule.localStart,
        schedule.startZone,
        isDateOnly: schedule.isDateOnly,
      );

      await _notificationService.scheduleReminder(
        notificationId: reminder.notificationId,
        title: "Pengingat: ${schedule.title}",
        body: "Waktu: $eventTimeStr",
        scheduledUtc: triggerUtc,
        payload: payload,
        isExact: isExact,
      );

      await (_db.update(_db.reminders)..where((r) => r.id.equals(reminder.id))).write(
        RemindersCompanion(
          schedulingState: Value(isExact ? 'active' : 'approximate'),
        ),
      );
    }
  }
}
