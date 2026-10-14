import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/core/utils/datetime_utils.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/schedules_repository.dart';
import 'package:bawa/data/repositories/tickets_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/services/asset_storage_service.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late AssetStorageService storageService;
  late TripsRepository tripsRepo;
  late SchedulesRepository schedulesRepo;
  late TicketsRepository ticketsRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    tempDir = await Directory.systemTemp.createTemp('bawa_fase4_test_');
    storageService = AssetStorageService(db, baseDirOverride: tempDir);
    tripsRepo = TripsRepository(db);
    schedulesRepo = SchedulesRepository(db);
    ticketsRepo = TicketsRepository(db, storageService);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Fase 4: Schedules Repository & Date/Time Handling (SCH-01..04, SCH-12)', () {
    test('SCH-01, SCH-02: Create and update schedule with multiple types', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Bandung Liburan',
        startDate: '2026-10-18',
        endDate: '2026-10-20',
        stops: ['Bandung'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Kereta Argo Parahyangan',
        type: 'transport',
        localDate: '2026-10-18',
        localStart: '07:30',
        startZone: 'Asia/Jakarta',
        localEnd: '10:15',
        endZone: 'Asia/Jakarta',
        locationText: 'Stasiun Gambir',
        notes: 'Gerbong 3 Kursi 12A',
      );

      final schedules = await schedulesRepo.watchTripSchedules(tripId).first;
      expect(schedules.length, equals(1));
      final s = schedules.first;
      expect(s.id, equals(scheduleId));
      expect(s.title, equals('Kereta Argo Parahyangan'));
      expect(s.type, equals('transport'));
      expect(s.localDate, equals('2026-10-18'));
      expect(s.localStart, equals('07:30'));
      expect(s.startZone, equals('Asia/Jakarta'));
      expect(s.localEnd, equals('10:15'));
      expect(s.locationText, equals('Stasiun Gambir'));
      expect(s.notes, equals('Gerbong 3 Kursi 12A'));
      expect(s.formattedTime, equals('07:30 - 10:15 WIB'));

      // Update schedule
      await schedulesRepo.updateSchedule(
        scheduleId,
        title: 'Kereta Argo Parahyangan Eksekutif',
        type: 'transport',
        localDate: '2026-10-18',
        localStart: '07:45',
        startZone: 'Asia/Jakarta',
        locationText: 'Stasiun Gambir Gate 2',
      );

      final updated = await schedulesRepo.getScheduleById(scheduleId);
      expect(updated, isNotNull);
      expect(updated!.title, equals('Kereta Argo Parahyangan Eksekutif'));
      expect(updated.localStart, equals('07:45'));
      expect(updated.locationText, equals('Stasiun Gambir Gate 2'));
    });

    test('SCH-04, AT-11: Timezone preservation and instant UTC computation across WIB, WITA, WIT', () async {
      // 07:30 WIB (UTC+7) = 00:30 UTC
      final utcWib = AppDateTimeUtils.computeUtcInstant('2026-10-18', '07:30', 'Asia/Jakarta');
      expect(utcWib, equals('2026-10-18T00:30:00.000Z'));

      // 08:30 WITA (UTC+8) = 00:30 UTC
      final utcWita = AppDateTimeUtils.computeUtcInstant('2026-10-18', '08:30', 'Asia/Makassar');
      expect(utcWita, equals('2026-10-18T00:30:00.000Z'));

      // 09:30 WIT (UTC+9) = 00:30 UTC
      final utcWit = AppDateTimeUtils.computeUtcInstant('2026-10-18', '09:30', 'Asia/Jayapura');
      expect(utcWit, equals('2026-10-18T00:30:00.000Z'));

      // Formatted text with zone badges
      expect(AppDateTimeUtils.formatEventTime('07:30', 'Asia/Jakarta'), equals('07:30 WIB'));
      expect(AppDateTimeUtils.formatEventTime('08:30', 'Asia/Makassar'), equals('08:30 WITA'));
      expect(AppDateTimeUtils.formatEventTime('09:30', 'Asia/Jayapura'), equals('09:30 WIT'));
      expect(
        AppDateTimeUtils.formatEventTime('07:30', 'Asia/Jakarta', localEndTime: '10:00', endZoneId: 'Asia/Makassar'),
        equals('07:30 WIB - 10:00 WITA'),
      );
    });

    test('SCH-12, AT-10: Date-only schedules preserve local date and are NEVER converted to 00.00 midnight', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Jogja Santai',
        startDate: '2026-10-25',
        stops: ['Yogyakarta'],
      );

      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Jalan Santai Malioboro',
        type: 'activity',
        localDate: '2026-10-25',
        isDateOnly: true,
      );

      final s = await schedulesRepo.getScheduleById(scheduleId);
      expect(s, isNotNull);
      expect(s!.isDateOnly, isTrue);
      expect(s.localDate, equals('2026-10-25'));
      expect(s.localStart, isNull);
      expect(s.startUtc, isNull); // PRD: Must NOT be mutated into midnight
      expect(s.formattedTime, equals('Sepanjang hari'));
    });

    test('SCH-01: Time sequence validation rejects end time before start time', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Uji',
        startDate: '2026-10-18',
        stops: ['Bandung'],
      );

      // Start 10:00, End 08:00 (invalid)
      expect(
        () => schedulesRepo.createSchedule(
          tripId: tripId,
          title: 'Kegiatan Terbalik',
          type: 'activity',
          localDate: '2026-10-18',
          localStart: '10:00',
          localEnd: '08:00',
          startZone: 'Asia/Jakarta',
          endZone: 'Asia/Jakarta',
        ),
        throwsArgumentError,
      );
    });

    test('SCH-01: Date within trip range validation', () {
      expect(AppDateTimeUtils.isDateWithinTripRange('2026-10-19', '2026-10-18', '2026-10-20'), isTrue);
      expect(AppDateTimeUtils.isDateWithinTripRange('2026-10-17', '2026-10-18', '2026-10-20'), isFalse);
      expect(AppDateTimeUtils.isDateWithinTripRange('2026-10-21', '2026-10-18', '2026-10-20'), isFalse);
      // Flexible trip without end date
      expect(AppDateTimeUtils.isDateWithinTripRange('2026-11-01', '2026-10-18', null), isTrue);
    });

    test('SCH-03: Chronological ordering of global agenda', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Tur Jawa',
        startDate: '2026-10-18',
        stops: ['Bandung'],
      );

      await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Makan Siang',
        type: 'activity',
        localDate: '2026-10-18',
        localStart: '12:00',
        startZone: 'Asia/Jakarta',
      );

      await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Keberangkatan Pagi',
        type: 'transport',
        localDate: '2026-10-18',
        localStart: '07:00',
        startZone: 'Asia/Jakarta',
      );

      await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Kegiatan Hari Kedua',
        type: 'activity',
        localDate: '2026-10-19',
        localStart: '09:00',
        startZone: 'Asia/Jakarta',
      );

      final globalAgenda = await schedulesRepo.watchGlobalAgenda().first;
      expect(globalAgenda.length, equals(3));
      expect(globalAgenda[0].title, equals('Keberangkatan Pagi'));
      expect(globalAgenda[1].title, equals('Makan Siang'));
      expect(globalAgenda[2].title, equals('Kegiatan Hari Kedua'));
    });
  });

  group('Fase 4: Tickets Repository & Offline Attachments (SCH-05..07, AT-09)', () {
    test('SCH-05, SCH-07: Create ticket without schedule and link later', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Bandung Liburan',
        startDate: '2026-10-18',
        stops: ['Bandung'],
      );

      // Create ticket independently (SCH-07)
      final ticketId = await ticketsRepo.createTicket(
        tripId: tripId,
        title: 'Tiket Kereta Parahyangan',
        provider: 'PT Kereta Api Indonesia',
        bookingCode: 'ABC123XYZ',
        notes: 'Pintu masuk selatan',
      );

      final ticket = await ticketsRepo.getTicketById(ticketId);
      expect(ticket, isNotNull);
      expect(ticket!.title, equals('Tiket Kereta Parahyangan'));
      expect(ticket.provider, equals('PT Kereta Api Indonesia'));
      expect(ticket.bookingCode, equals('ABC123XYZ'));
      expect(ticket.scheduleEventId, isNull);

      // Create a schedule and link the ticket
      final scheduleId = await schedulesRepo.createSchedule(
        tripId: tripId,
        title: 'Perjalanan ke Bandung',
        type: 'transport',
        localDate: '2026-10-18',
        localStart: '07:30',
      );

      await ticketsRepo.updateTicket(
        ticketId,
        title: 'Tiket Kereta Parahyangan',
        provider: 'PT Kereta Api Indonesia',
        bookingCode: 'ABC123XYZ',
        scheduleEventId: scheduleId,
      );

      final linkedTicket = await ticketsRepo.getTicketById(ticketId);
      expect(linkedTicket!.scheduleEventId, equals(scheduleId));

      // Deleting schedule unlinks the ticket without deleting the ticket (SCH-07)
      await schedulesRepo.deleteSchedule(scheduleId);
      final preservedTicket = await ticketsRepo.getTicketById(ticketId);
      expect(preservedTicket, isNotNull);
      expect(preservedTicket!.scheduleEventId, isNull);
    });

    test('SCH-06, AT-09: Offline ticket attachments (PDF & Image) preserved in sandbox with SHA-256', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Surabaya Perjalanan',
        startDate: '2026-11-01',
        stops: ['Surabaya'],
      );

      final ticketId = await ticketsRepo.createTicket(
        tripId: tripId,
        title: 'Tiket Pesawat Garuda',
        provider: 'Garuda Indonesia',
        bookingCode: 'GA12345',
      );

      // Create dummy PDF file
      final dummyPdf = File('${tempDir.path}/boarding_pass.pdf');
      await dummyPdf.writeAsBytes([0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34]); // PDF header

      // Create dummy high-res image file (preserving QR resolution, AT-09)
      final dummyImg = File('${tempDir.path}/qr_barcode.jpg');
      await dummyImg.writeAsBytes([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46]); // JPEG header

      // Attach PDF
      final pdfAtt = await ticketsRepo.addAttachment(
        ticketId: ticketId,
        file: dummyPdf,
        originalName: 'boarding_pass.pdf',
      );

      expect(pdfAtt.isPdf, isTrue);
      expect(pdfAtt.isImage, isFalse);
      expect(pdfAtt.sha256, isNotEmpty);
      expect(pdfAtt.sizeBytes, equals(8));

      // Attach Image
      final imgAtt = await ticketsRepo.addAttachment(
        ticketId: ticketId,
        file: dummyImg,
        originalName: 'qr_barcode.jpg',
      );

      expect(imgAtt.isImage, isTrue);
      expect(imgAtt.isPdf, isFalse);

      // Verify files exist in sandbox
      final pdfOnDisk = await storageService.resolveRelativeFile(pdfAtt.relativePath);
      final imgOnDisk = await storageService.resolveRelativeFile(imgAtt.relativePath);
      expect(await pdfOnDisk.exists(), isTrue);
      expect(await imgOnDisk.exists(), isTrue);

      // Delete single attachment
      await ticketsRepo.removeAttachment(pdfAtt.id);
      expect(await pdfOnDisk.exists(), isFalse); // Disk file deleted
      expect(await imgOnDisk.exists(), isTrue); // Other file preserved

      // Delete ticket cascades and cleans up remaining assets
      await ticketsRepo.deleteTicket(ticketId);
      expect(await imgOnDisk.exists(), isFalse); // Disk file deleted
      final deletedTicket = await ticketsRepo.getTicketById(ticketId);
      expect(deletedTicket, isNull);
    });
  });
}
