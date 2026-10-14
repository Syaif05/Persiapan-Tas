import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/checkpoints_repository.dart';
import 'package:bawa/data/repositories/templates_repository.dart';

void main() {
  late AppDatabase db;
  late CheckpointsRepository checkpointsRepo;
  late TemplatesRepository templatesRepo;

  setUp(() {
    db = AppDatabase.inMemory();
    checkpointsRepo = CheckpointsRepository(db);
    templatesRepo = TemplatesRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Fase 6: Checkpoint Pulang (RET-01..RET-05, AT-17)', () {
    const tripId = 'trip-bandung-1';
    const kausId = 'item-kaus-1';
    const chargerId = 'item-charger-1';

    setUp(() async {
      final now = DateTime.now().toIso8601String();

      // Buat master item
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: kausId,
          name: 'Kaus Hitam Polos',
          quantity: const Value(10), // Stok master: 10
          unit: const Value('buah'),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: chargerId,
          name: 'Charger USB-C',
          quantity: const Value(2), // Stok master: 2
          unit: const Value('buah'),
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Buat perjalanan
      await db.into(db.trips).insert(
        TripsCompanion.insert(
          id: tripId,
          name: 'Liburan Bandung',
          startDate: '2026-10-15',
          dateZoneId: 'Asia/Jakarta',
          status: const Value('ongoing'),
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Buat barang perjalanan:
      // 1. Kaus: Rencana 5, Dikemas 5
      await db.into(db.tripItems).insert(
        TripItemsCompanion.insert(
          id: 'trip-item-kaus',
          tripId: tripId,
          itemId: kausId,
          decision: const Value('carried'),
          plannedQuantity: const Value(5),
          packedQuantity: const Value(5), // SUDAH DIKEMAS
          nameSnapshot: 'Kaus Hitam Polos',
          updatedAt: now,
        ),
      );

      // 2. Charger: Rencana 1, Dikemas 0 (BELUM DIKEMAS)
      await db.into(db.tripItems).insert(
        TripItemsCompanion.insert(
          id: 'trip-item-charger',
          tripId: tripId,
          itemId: chargerId,
          decision: const Value('carried'),
          plannedQuantity: const Value(1),
          packedQuantity: const Value(0), // BELUM DIKEMAS
          nameSnapshot: 'Charger USB-C',
          updatedAt: now,
        ),
      );
    });

    test('RET-01 & RET-02: Checkpoint snapshot HANYA mengambil barang yang benar-benar dikemas (packed_quantity > 0)', () async {
      final checkpointId = await checkpointsRepo.createCheckpoint(tripId: tripId);
      final details = await checkpointsRepo.getCheckpointWithDetails(checkpointId);

      expect(details, isNotNull);
      expect(details!.tripId, equals(tripId));
      expect(details.title, equals('Cek Sebelum Pulang'));
      expect(details.closeState, equals('open'));

      // RET-02: Charger dengan packed_quantity = 0 TIDAK boleh masuk ke entri checkpoint
      expect(details.entries.length, equals(1));
      final entry = details.entries.first;
      expect(entry.nameSnapshot, equals('Kaus Hitam Polos'));
      expect(entry.expectedQuantity, equals(5));
      expect(entry.returnedQuantity, equals(5)); // Default awal dibawa kembali
    });

    test('RET-03 & AT-17: Konfirmasi parsial: 5 kaus berangkat -> 3 kembali, 1 habis -> sisa 1 belum terkonfirmasi', () async {
      final checkpointId = await checkpointsRepo.createCheckpoint(tripId: tripId);
      final detailsInitial = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      final entry = detailsInitial!.entries.first;

      // Konfirmasi: 3 kembali, 1 habis dipakai, 0 ditinggal (AT-17)
      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 3,
        consumedQuantity: 1,
        leftQuantity: 0,
        notes: '1 kaus belum ketemu',
      );

      final detailsAfter = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      final updatedEntry = detailsAfter!.entries.first;

      expect(updatedEntry.expectedQuantity, equals(5));
      expect(updatedEntry.returnedQuantity, equals(3));
      expect(updatedEntry.consumedQuantity, equals(1));
      expect(updatedEntry.leftQuantity, equals(0));
      expect(updatedEntry.confirmedQuantity, equals(4));
      expect(updatedEntry.unconfirmedQuantity, equals(1)); // Sisa 1
      expect(updatedEntry.isFullyConfirmed, isFalse);

      expect(detailsAfter.totalExpected, equals(5));
      expect(detailsAfter.totalConfirmed, equals(4));
      expect(detailsAfter.totalUnconfirmed, equals(1));
      expect(detailsAfter.isFullyConfirmed, isFalse);
    });

    test('RET-03: Validasi constraint: total konfirmasi tidak boleh melebihi expectedQuantity atau negatif', () async {
      final checkpointId = await checkpointsRepo.createCheckpoint(tripId: tripId);
      final details = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      final entry = details!.entries.first;

      // Melebihi expected (expected = 5, total = 6)
      expect(
        () => checkpointsRepo.updateReturnEntryQuantities(
          entryId: entry.id,
          returnedQuantity: 4,
          consumedQuantity: 2,
          leftQuantity: 0,
        ),
        throwsArgumentError,
      );

      // Nilai negatif
      expect(
        () => checkpointsRepo.updateReturnEntryQuantities(
          entryId: entry.id,
          returnedQuantity: -1,
          consumedQuantity: 1,
          leftQuantity: 0,
        ),
        throwsArgumentError,
      );
    });

    test('RET-04 & AT-17: Konfirmasi checkpoint TIDAK mengubah stok master inventaris', () async {
      final checkpointId = await checkpointsRepo.createCheckpoint(tripId: tripId);
      final details = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      final entry = details!.entries.first;

      // Konfirmasi 1 kaus habis dipakai dan 1 kaus ditinggal
      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 3,
        consumedQuantity: 1,
        leftQuantity: 1,
      );

      // Periksa tabel master Items: stok awal kaus = 10
      final masterItem = await (db.select(db.items)..where((i) => i.id.equals(kausId))).getSingle();
      expect(masterItem.quantity, equals(10), reason: 'Stok master TIDAK boleh berkurang otomatis');
    });

    test('RET-05 & AT-17: Menutup checkpoint dengan sisa belum terkonfirmasi mencatat closed_with_unconfirmed (BUKAN selesai/lengkap)', () async {
      final checkpointId = await checkpointsRepo.createCheckpoint(tripId: tripId);
      final details = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      final entry = details!.entries.first;

      // 3 kembali, 1 habis -> 1 sisa belum terkonfirmasi
      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 3,
        consumedQuantity: 1,
        leftQuantity: 0,
      );

      // Tutup checkpoint
      await checkpointsRepo.closeCheckpoint(checkpointId);

      final closedDetails = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      expect(closedDetails!.isOpen, isFalse);
      expect(closedDetails.closeState, equals('closed_with_unconfirmed'), reason: 'AT-17: Harus tercatat ditutup dengan sisa');
      expect(closedDetails.isCompleted, isFalse);
      expect(closedDetails.isClosedWithUnconfirmed, isTrue);
      expect(closedDetails.closedAt, isNotNull);
    });

    test('RET-05: Menutup checkpoint jika SEMUA barang terkonfirmasi mencatat completed', () async {
      final checkpointId = await checkpointsRepo.createCheckpoint(tripId: tripId);
      final details = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      final entry = details!.entries.first;

      // 4 kembali, 1 habis -> total 5 = expected 5 (0 unconfirmed)
      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 4,
        consumedQuantity: 1,
        leftQuantity: 0,
      );

      await checkpointsRepo.closeCheckpoint(checkpointId);

      final closedDetails = await checkpointsRepo.getCheckpointWithDetails(checkpointId);
      expect(closedDetails!.closeState, equals('completed'));
      expect(closedDetails.isCompleted, isTrue);
      expect(closedDetails.isClosedWithUnconfirmed, isFalse);
    });
  });

  group('Fase 6: Template Packing (TPL-01..TPL-03, AT-18)', () {
    const itemJaketId = 'item-jaket-1';
    const itemObatId = 'item-obat-1';
    const tripSurabayaId = 'trip-surabaya-1';
    const tripBaliId = 'trip-bali-1';

    setUp(() async {
      final now = DateTime.now().toIso8601String();

      // Master items
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: itemJaketId,
          name: 'Jaket Gunung',
          quantity: const Value(2),
          unit: const Value('buah'),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: itemObatId,
          name: 'Kotak P3K',
          quantity: const Value(1),
          unit: const Value('kotak'),
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Perjalanan 1 (Surabaya)
      await db.into(db.trips).insert(
        TripsCompanion.insert(
          id: tripSurabayaId,
          name: 'Surabaya Trip',
          startDate: '2026-11-01',
          dateZoneId: 'Asia/Jakarta',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Masukkan item ke trip Surabaya
      await db.into(db.tripItems).insert(
        TripItemsCompanion.insert(
          id: 'ti-jaket-surabaya',
          tripId: tripSurabayaId,
          itemId: itemJaketId,
          decision: const Value('carried'),
          plannedQuantity: const Value(2),
          packedQuantity: const Value(2), // Dikemas 2
          nameSnapshot: 'Jaket Gunung',
          updatedAt: now,
        ),
      );
      await db.into(db.tripItems).insert(
        TripItemsCompanion.insert(
          id: 'ti-obat-surabaya',
          tripId: tripSurabayaId,
          itemId: itemObatId,
          decision: const Value('carried'),
          plannedQuantity: const Value(1),
          packedQuantity: const Value(1), // Dikemas 1
          nameSnapshot: 'Kotak P3K',
          updatedAt: now,
        ),
      );

      // Perjalanan 2 (Bali) - kosong
      await db.into(db.trips).insert(
        TripsCompanion.insert(
          id: tripBaliId,
          name: 'Bali Vacation',
          startDate: '2026-12-01',
          dateZoneId: 'Asia/Jakarta',
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    test('TPL-01 & AT-18: Buat template packing dari perjalanan aktif', () async {
      final templateId = await templatesRepo.createTemplateFromTrip(
        name: 'Template Dingin',
        tripId: tripSurabayaId,
        notes: 'Untuk perjalanan ke daerah sejuk',
      );

      final template = await templatesRepo.getTemplateWithDetails(templateId);
      expect(template, isNotNull);
      expect(template!.name, equals('Template Dingin'));
      expect(template.items.length, equals(2));
      expect(template.totalUnits, equals(3)); // 2 jaket + 1 p3k
    });

    test('TPL-02 & AT-18: Terapkan template ke perjalanan baru mereset packed_quantity = 0 dan TIDAK menggandakan stok', () async {
      // 1. Buat template
      final templateId = await templatesRepo.createTemplateFromTrip(
        name: 'Template Standar',
        tripId: tripSurabayaId,
      );

      // Periksa total item master sebelum apply
      final masterCountBefore = (await db.select(db.items).get()).length;

      // 2. Terapkan template ke perjalanan Bali
      final result = await templatesRepo.applyTemplateToTrip(
        templateId: templateId,
        tripId: tripBaliId,
      );

      expect(result.appliedCount, equals(2));
      expect(result.warnings, isEmpty);

      // Pastikan master items TIDAK digandakan (AT-18)
      final masterCountAfter = (await db.select(db.items).get()).length;
      expect(masterCountAfter, equals(masterCountBefore));

      // Pastikan TripItems untuk Bali memiliki packed_quantity = 0 (AT-18)
      final baliItems = await (db.select(db.tripItems)..where((t) => t.tripId.equals(tripBaliId))).get();
      expect(baliItems.length, equals(2));
      for (final ti in baliItems) {
        expect(ti.decision, equals('carried'));
        expect(ti.packedQuantity, equals(0), reason: 'packed_quantity HARUS selalu direset ke 0 pada perjalanan baru');
      }
    });

    test('TPL-03 & AT-18: Peringatan jika stok inventaris master kurang dari kebutuhan atau barang diarsipkan', () async {
      final now = DateTime.now().toIso8601String();
      const archivedItemId = 'item-archived-1';
      const lowStockItemId = 'item-lowstock-1';

      // Item diarsipkan
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: archivedItemId,
          name: 'Payung Rusak',
          quantity: const Value(1),
          archivedAt: Value(now), // DIARSIPKAN
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Item stok kurang (tersedia 2, template minta 5)
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: lowStockItemId,
          name: 'Kaus Kaki Tebal',
          quantity: const Value(2), // Stok master: 2
          createdAt: now,
          updatedAt: now,
        ),
      );

      // Buat template manual yang meminta 5 kaus kaki dan 1 payung rusak
      final templateId = await templatesRepo.createTemplate(
        name: 'Template Ekstrem',
        items: [
          (itemId: lowStockItemId, plannedQuantity: 5, notes: null),
          (itemId: archivedItemId, plannedQuantity: 1, notes: null),
        ],
      );

      // Terapkan ke Bali
      final result = await templatesRepo.applyTemplateToTrip(
        templateId: templateId,
        tripId: tripBaliId,
      );

      // TPL-03: Menghasilkan peringatan
      expect(result.warnings.length, equals(2));
      expect(result.warnings.any((w) => w.contains('diarsipkan')), isTrue);
      expect(result.warnings.any((w) => w.contains('inventaris hanya memiliki 2')), isTrue);

      // Rencana dibatasi maksimal stok tersedia (2)
      final baliItems = await (db.select(db.tripItems)..where((t) => t.tripId.equals(tripBaliId))).get();
      final lowStockTripItem = baliItems.firstWhere((t) => t.itemId == lowStockItemId);
      expect(lowStockTripItem.plannedQuantity, equals(2));
      expect(lowStockTripItem.packedQuantity, equals(0));
    });
  });
}
