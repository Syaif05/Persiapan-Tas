import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/schedules_repository.dart';
import 'package:bawa/data/repositories/reminders_repository.dart';
import 'package:bawa/data/services/notification_service.dart';
import 'package:bawa/core/utils/datetime_utils.dart';

void main() {
  late AppDatabase db;
  late NotificationService notificationService;
  late RemindersRepository remindersRepo;
  late SchedulesRepository schedulesRepo;
  late TripsRepository tripsRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    notificationService = NotificationService(isTestMode: true);
    await notificationService.initialize();
    remindersRepo = RemindersRepository(db, notificationService);
    schedulesRepo = SchedulesRepository(db, remindersRepo);
    tripsRepo = TripsRepository(db, remindersRepo);
  });

  tearDown(() async {
    notificationService.dispose();
    await db.close();
  });

  group('Tahap 7: TECH-02 & TECH-03 Pengingat, Alarm Android, & Audit Offline', () {
    test('QA-46: Izin notifikasi dan exact alarm ditolak/dibatasi (fallback status ramah & non-blocking)', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Bali',
        startDate: '2026-11-01',
        stops: ['Denpasar'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Pesawat ke Bali',
        type: 'transport',
        localDate: '2026-11-01',
        localStart: '10:00',
        startZone: 'Asia/Jakarta',
      );

      // Skenario A: Notifikasi diizinkan tetapi exact alarm DITOLAK
      notificationService.setNotificationsAllowedForTesting(true);
      notificationService.setExactAlarmsAllowedForTesting(false);

      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: scheduleId,
        configs: const [
          ReminderConfig(type: '1_hour_before', precisionPreference: 'exact'),
        ],
      );

      var reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.length, 1);
      // Status fallback adalah 'approximate' (perkiraan)
      expect(reminders.first.schedulingState, 'approximate');
      expect(notificationService.scheduledNotificationIds.length, 1);

      // Skenario B: Izin notifikasi sama sekali DITOLAK
      notificationService.setNotificationsAllowedForTesting(false);
      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: scheduleId,
        configs: const [
          ReminderConfig(type: '1_hour_before'),
        ],
      );

      reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.length, 1);
      // Status adalah 'permission_required'
      expect(reminders.first.schedulingState, 'permission_required');
    });

    test('QA-47: Edit agenda, reboot, restore (rekonsiliasi tanpa alarm ganda atau ID bentrok)', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Yogyakarta',
        startDate: '2026-12-15',
        stops: ['Yogyakarta'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Check-in Hotel Jogja',
        type: 'lodging',
        localDate: '2026-12-15',
        localStart: '14:00',
        startZone: 'Asia/Jakarta',
      );

      notificationService.setNotificationsAllowedForTesting(true);
      notificationService.setExactAlarmsAllowedForTesting(true);

      // Simpan pengingat awal
      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: scheduleId,
        configs: const [
          ReminderConfig(type: '30_mins_before'),
        ],
      );

      var reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      final initialNotificationId = reminders.first.notificationId;
      expect(notificationService.scheduledNotificationIds.contains(initialNotificationId), isTrue);

      // Edit pengingat menjadi 1 jam sebelumnya
      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: scheduleId,
        configs: const [
          ReminderConfig(type: '1_hour_before'),
        ],
      );

      // Alarm lama harus dibatalkan
      expect(notificationService.cancelledNotificationIds.contains(initialNotificationId), isTrue);

      reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.length, 1);
      final newNotificationId = reminders.first.notificationId;
      expect(notificationService.scheduledNotificationIds.contains(newNotificationId), isTrue);

      // Simulasikan Reboot: Rekonsiliasi seluruh pengingat
      await remindersRepo.reconcileAllReminders();
      // Status tetap active
      reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.first.schedulingState, 'active');
    });

    test('QA-48: Semua pengingat lama sudah lewat (masuk status missed, tidak menembakkan alarm)', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Masa Lalu',
        startDate: '2020-01-01',
        stops: ['Kota Lama'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Kegiatan Tahun 2020',
        type: 'activity',
        localDate: '2020-01-01',
        localStart: '08:00',
        startZone: 'Asia/Jakarta',
      );

      notificationService.scheduledNotificationIds.clear();

      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: scheduleId,
        configs: const [
          ReminderConfig(type: 'at_time'),
        ],
      );

      final reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.length, 1);
      // Pengingat di masa lalu langsung ditandai 'missed'
      expect(reminders.first.schedulingState, 'missed');
      // Tidak ada notifikasi yang dijadwalkan ke OS
      expect(notificationService.scheduledNotificationIds.isEmpty, isTrue);
    });

    test('QA-49: Zona waktu WIB vs WITA menjaga instant UTC yang sama', () {
      // 08:00 WIB (UTC+7) = 01:00 UTC
      final instantWib = AppDateTimeUtils.computeUtcInstant(
        '2026-10-18',
        '08:00',
        'Asia/Jakarta',
      );

      // 09:00 WITA (UTC+8) = 01:00 UTC
      final instantWita = AppDateTimeUtils.computeUtcInstant(
        '2026-10-18',
        '09:00',
        'Asia/Makassar',
      );

      // 10:00 WIT (UTC+9) = 01:00 UTC
      final instantWit = AppDateTimeUtils.computeUtcInstant(
        '2026-10-18',
        '10:00',
        'Asia/Jayapura',
      );

      expect(instantWib, '2026-10-18T01:00:00.000Z');
      expect(instantWita, '2026-10-18T01:00:00.000Z');
      expect(instantWit, '2026-10-18T01:00:00.000Z');
      expect(instantWib, equals(instantWita));
      expect(instantWita, equals(instantWit));

      // Label waktu dan zona terformat jelas
      expect(AppDateTimeUtils.formatEventTime('08:00', 'Asia/Jakarta'), '08:00 WIB');
      expect(AppDateTimeUtils.formatEventTime('09:00', 'Asia/Makassar'), '09:00 WITA');
      expect(AppDateTimeUtils.formatEventTime('10:00', 'Asia/Jayapura'), '10:00 WIT');
    });

    test('QA-50: Agenda hanya tanggal (tidak dipaksa 00:00, jam pengingat dipilih eksplisit)', () async {
      // Agenda tanpa jam (isDateOnly: true)
      final instant = AppDateTimeUtils.computeUtcInstant(
        '2026-10-18',
        null,
        'Asia/Jakarta',
        isDateOnly: true,
      );
      // Instant harus null, tidak boleh dipaksa 00:00
      expect(instant, isNull);
      expect(AppDateTimeUtils.formatEventTime(null, 'Asia/Jakarta', isDateOnly: true), 'Sepanjang hari');

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Santai',
        startDate: '2026-10-25',
        stops: ['Semarang'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Eksplor Kota Lama',
        type: 'activity',
        localDate: '2026-10-25',
        isDateOnly: true,
        startZone: 'Asia/Jakarta',
      );

      final schedule = await schedulesRepo.getScheduleById(scheduleId);
      expect(schedule!.isDateOnly, isTrue);
      expect(schedule.localStart, isNull);

      // Pengingat menggunakan jam pilihan eksplisit (misal 09:00 pagi)
      final triggerUtc = remindersRepo.computeTriggerUtc(
        schedule: schedule.schedule,
        config: const ReminderConfig(
          type: 'at_time',
          explicitTimeForDateOnly: '09:00',
        ),
      );

      // 2026-10-25 09:00 WIB = 2026-10-25 02:00 UTC
      expect(triggerUtc.toIso8601String(), '2026-10-25T02:00:00.000Z');
    });

    test('QA-35: Batalkan perjalanan membatalkan dan menonaktifkan seluruh alarm terkait', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Trip yang Dibatalkan',
        startDate: '2026-11-20',
        stops: ['Surabaya'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Kereta ke Surabaya',
        type: 'transport',
        localDate: '2026-11-20',
        localStart: '07:00',
        startZone: 'Asia/Jakarta',
      );

      notificationService.setNotificationsAllowedForTesting(true);
      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: scheduleId,
        configs: const [
          ReminderConfig(type: '1_hour_before'),
        ],
      );

      var reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.length, 1);
      expect(reminders.first.schedulingState, 'active');
      final notifId = reminders.first.notificationId;

      // Batalkan perjalanan
      await tripsRepo.updateTripStatus(tripId, 'cancelled');

      // Pengingat di database dinonaktifkan
      reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.first.enabled, isFalse);
      expect(reminders.first.schedulingState, 'disabled');

      // Alarm OS dibatalkan
      expect(notificationService.cancelledNotificationIds.contains(notifId), isTrue);

      // Simulasikan rekonsiliasi reboot: pengingat tidak boleh aktif kembali
      await remindersRepo.reconcileAllReminders();
      reminders = await remindersRepo.getRemindersForSchedule(scheduleId);
      expect(reminders.first.schedulingState, 'disabled');
    });
  });
}
