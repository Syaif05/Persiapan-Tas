import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import 'reminders_repository.dart';
import '../../core/utils/datetime_utils.dart';

class ScheduleEventWithDetails {
  final ScheduleEventEntry schedule;
  final TripEntry trip;
  final TripStopEntry? tripStop;
  final List<TicketEntry> linkedTickets;
  final List<ReminderEntry> reminders;

  ScheduleEventWithDetails({
    required this.schedule,
    required this.trip,
    this.tripStop,
    this.linkedTickets = const [],
    this.reminders = const [],
  });

  bool get hasReminders => reminders.isNotEmpty;
  bool get hasActiveReminders =>
      reminders.any((r) => r.enabled && (r.schedulingState == 'active' || r.schedulingState == 'approximate'));
  bool get hasPendingPermissionReminders =>
      reminders.any((r) => r.schedulingState == 'permission_required');

  String get id => schedule.id;
  String get title => schedule.title;
  String get type => schedule.type;
  String get localDate => schedule.localDate;
  bool get isDateOnly => schedule.isDateOnly;
  String? get localStart => schedule.localStart;
  String? get startZone => schedule.startZone;
  String? get startUtc => schedule.startUtc;
  String? get localEnd => schedule.localEnd;
  String? get endZone => schedule.endZone;
  String? get endUtc => schedule.endUtc;
  String? get locationText => schedule.locationText;
  String? get notes => schedule.notes;
  String get status => schedule.status;

  String get formattedTime => AppDateTimeUtils.formatEventTime(
        localStart,
        startZone,
        isDateOnly: isDateOnly,
        localEndTime: localEnd,
        endZoneId: endZone,
      );

  String get formattedDate => AppDateTimeUtils.formatLocalDate(localDate);
}

class SchedulesRepository {
  final AppDatabase _db;
  final RemindersRepository? _remindersRepository;
  final Uuid _uuid = const Uuid();

  SchedulesRepository(this._db, [this._remindersRepository]);

  /// Menambah jadwal baru ke dalam perjalanan
  Future<String> createSchedule({
    required String tripId,
    required String title,
    required String type, // 'transport' | 'lodging' | 'activity' | 'preparation' | 'other'
    required String localDate, // YYYY-MM-DD
    bool isDateOnly = false,
    String? localStart, // HH:mm
    String? startZone,
    String? localEnd, // HH:mm
    String? endZone,
    String? locationText,
    String? notes,
    String? tripStopId,
    String status = 'planned',
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Judul jadwal tidak boleh kosong');
    }

    final id = _uuid.v4();
    final effectiveZone = startZone ?? AppDateTimeUtils.defaultZoneId;

    // Hitung UTC instant (SCH-04 & SCH-12: jika isDateOnly, startUtc adalah null)
    final startUtc = AppDateTimeUtils.computeUtcInstant(
      localDate,
      localStart,
      effectiveZone,
      isDateOnly: isDateOnly,
    );

    final endUtc = AppDateTimeUtils.computeUtcInstant(
      localDate,
      localEnd,
      endZone ?? effectiveZone,
      isDateOnly: isDateOnly,
    );

    // Validasi urutan jika kedua waktu diisi
    if (startUtc != null && endUtc != null && endUtc.compareTo(startUtc) < 0) {
      throw ArgumentError('Waktu selesai tidak boleh lebih awal dari waktu mulai');
    }

    await _db.into(_db.scheduleEvents).insert(
          ScheduleEventsCompanion.insert(
            id: id,
            tripId: tripId,
            tripStopId: Value(tripStopId),
            title: cleanTitle,
            type: type,
            isDateOnly: Value(isDateOnly),
            localDate: localDate,
            localStart: Value(isDateOnly ? null : localStart),
            startZone: Value(isDateOnly ? null : effectiveZone),
            startUtc: Value(startUtc),
            localEnd: Value(isDateOnly ? null : localEnd),
            endZone: Value(isDateOnly ? null : (endZone ?? effectiveZone)),
            endUtc: Value(endUtc),
            locationText: Value(locationText?.trim()),
            notes: Value(notes?.trim()),
            status: Value(status),
          ),
        );

    return id;
  }

  /// Memperbarui jadwal
  Future<void> updateSchedule(
    String scheduleId, {
    required String title,
    required String type,
    required String localDate,
    bool isDateOnly = false,
    String? localStart,
    String? startZone,
    String? localEnd,
    String? endZone,
    String? locationText,
    String? notes,
    String? tripStopId,
    String? status,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Judul jadwal tidak boleh kosong');
    }

    final effectiveZone = startZone ?? AppDateTimeUtils.defaultZoneId;

    final startUtc = AppDateTimeUtils.computeUtcInstant(
      localDate,
      localStart,
      effectiveZone,
      isDateOnly: isDateOnly,
    );

    final endUtc = AppDateTimeUtils.computeUtcInstant(
      localDate,
      localEnd,
      endZone ?? effectiveZone,
      isDateOnly: isDateOnly,
    );

    if (startUtc != null && endUtc != null && endUtc.compareTo(startUtc) < 0) {
      throw ArgumentError('Waktu selesai tidak boleh lebih awal dari waktu mulai');
    }

    await (_db.update(_db.scheduleEvents)..where((s) => s.id.equals(scheduleId))).write(
      ScheduleEventsCompanion(
        title: Value(cleanTitle),
        type: Value(type),
        isDateOnly: Value(isDateOnly),
        localDate: Value(localDate),
        localStart: Value(isDateOnly ? null : localStart),
        startZone: Value(isDateOnly ? null : effectiveZone),
        startUtc: Value(startUtc),
        localEnd: Value(isDateOnly ? null : localEnd),
        endZone: Value(isDateOnly ? null : (endZone ?? effectiveZone)),
        endUtc: Value(endUtc),
        locationText: Value(locationText?.trim()),
        notes: Value(notes?.trim()),
        tripStopId: Value(tripStopId),
        status: status != null ? Value(status) : const Value.absent(),
      ),
    );
  }

  /// Menghapus jadwal dan melepas tautan tiket terkait
  Future<void> deleteSchedule(String scheduleId) async {
    // 1. Batalkan dan hapus pengingat jika reminders repository tersedia
    final remindersRepo = _remindersRepository;
    if (remindersRepo != null) {
      await remindersRepo.deleteRemindersForSchedule(scheduleId);
    }

    // 2. Lepas relasi tiket yang merujuk jadwal ini agar tiket tidak hilang
    await (_db.update(_db.tickets)..where((t) => t.scheduleEventId.equals(scheduleId))).write(
      const TicketsCompanion(scheduleEventId: Value(null)),
    );

    // 3. Hapus jadwal
    await (_db.delete(_db.scheduleEvents)..where((s) => s.id.equals(scheduleId))).go();
  }

  /// Mengamati daftar jadwal pada suatu perjalanan
  Stream<List<ScheduleEventWithDetails>> watchTripSchedules(String tripId) {
    final query = _db.select(_db.scheduleEvents).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.scheduleEvents.tripId)),
      leftOuterJoin(_db.tripStops, _db.tripStops.id.equalsExp(_db.scheduleEvents.tripStopId)),
    ])
      ..where(_db.scheduleEvents.tripId.equals(tripId))
      ..orderBy([
        OrderingTerm.asc(_db.scheduleEvents.localDate),
        OrderingTerm.asc(_db.scheduleEvents.isDateOnly),
        OrderingTerm.asc(_db.scheduleEvents.localStart),
      ]);

    return query.watch().asyncMap((rows) async {
      final results = <ScheduleEventWithDetails>[];
      for (final row in rows) {
        final schedule = row.readTable(_db.scheduleEvents);
        final trip = row.readTable(_db.trips);
        final stop = row.readTableOrNull(_db.tripStops);

        // Ambil tiket yang terhubung
        final tickets = await (_db.select(_db.tickets)
              ..where((t) => t.scheduleEventId.equals(schedule.id)))
            .get();

        // Ambil pengingat untuk jadwal ini
        final reminders = await (_db.select(_db.reminders)
              ..where((r) => r.scheduleEventId.equals(schedule.id))
              ..orderBy([(r) => OrderingTerm.asc(r.triggerUtc)]))
            .get();

        results.add(ScheduleEventWithDetails(
          schedule: schedule,
          trip: trip,
          tripStop: stop,
          linkedTickets: tickets,
          reminders: reminders,
        ));
      }
      return results;
    });
  }

  /// Mengamati seluruh agenda kronologis global (semua perjalanan aktif)
  Stream<List<ScheduleEventWithDetails>> watchGlobalAgenda({String? filterDate}) {
    final query = _db.select(_db.scheduleEvents).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.scheduleEvents.tripId)),
      leftOuterJoin(_db.tripStops, _db.tripStops.id.equalsExp(_db.scheduleEvents.tripStopId)),
    ])
      ..where(_db.trips.status.isNotValue('cancelled') & _db.trips.isArchived.equals(false))
      ..orderBy([
        OrderingTerm.asc(_db.scheduleEvents.localDate),
        OrderingTerm.asc(_db.scheduleEvents.isDateOnly),
        OrderingTerm.asc(_db.scheduleEvents.localStart),
      ]);

    if (filterDate != null && filterDate.isNotEmpty) {
      query.where(_db.scheduleEvents.localDate.equals(filterDate));
    }

    return query.watch().asyncMap((rows) async {
      final results = <ScheduleEventWithDetails>[];
      for (final row in rows) {
        final schedule = row.readTable(_db.scheduleEvents);
        final trip = row.readTable(_db.trips);
        final stop = row.readTableOrNull(_db.tripStops);

        final tickets = await (_db.select(_db.tickets)
              ..where((t) => t.scheduleEventId.equals(schedule.id)))
            .get();

        final reminders = await (_db.select(_db.reminders)
              ..where((r) => r.scheduleEventId.equals(schedule.id))
              ..orderBy([(r) => OrderingTerm.asc(r.triggerUtc)]))
            .get();

        results.add(ScheduleEventWithDetails(
          schedule: schedule,
          trip: trip,
          tripStop: stop,
          linkedTickets: tickets,
          reminders: reminders,
        ));
      }
      return results;
    });
  }

  /// Ambil detail jadwal berdasarkan ID
  Future<ScheduleEventWithDetails?> getScheduleById(String scheduleId) async {
    final query = _db.select(_db.scheduleEvents).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.scheduleEvents.tripId)),
      leftOuterJoin(_db.tripStops, _db.tripStops.id.equalsExp(_db.scheduleEvents.tripStopId)),
    ])..where(_db.scheduleEvents.id.equals(scheduleId));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final schedule = row.readTable(_db.scheduleEvents);
    final trip = row.readTable(_db.trips);
    final stop = row.readTableOrNull(_db.tripStops);

    final tickets = await (_db.select(_db.tickets)
          ..where((t) => t.scheduleEventId.equals(schedule.id)))
        .get();

    final reminders = await (_db.select(_db.reminders)
          ..where((r) => r.scheduleEventId.equals(schedule.id))
          ..orderBy([(r) => OrderingTerm.asc(r.triggerUtc)]))
        .get();

    return ScheduleEventWithDetails(
      schedule: schedule,
      trip: trip,
      tripStop: stop,
      linkedTickets: tickets,
      reminders: reminders,
    );
  }
}
