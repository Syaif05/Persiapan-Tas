import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';

void main() {
  late AppDatabase db;
  late TripPackingRepository packingRepo;
  late TripsRepository tripsRepo;
  late InventoryRepository inventoryRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    packingRepo = TripPackingRepository(db);
    tripsRepo = TripsRepository(db);
    inventoryRepo = InventoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('CORE-01 & CORE-06: Operasi Inti Packing dan Pengamanan Data', () {
    test('QA-01: Tambah barang ke rencana tidak mengubah packing atau stok master', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Kaus Hitam',
        quantity: 5,
        unit: 'buah',
      );
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Bali',
        startDate: '2026-11-01',
        stops: ['Denpasar'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemId,
        plannedQuantity: 3,
      );

      // Verify item master stock is still 5
      final masterItem = await (db.select(db.items)..where((i) => i.id.equals(itemId))).getSingle();
      expect(masterItem.quantity, 5);

      // Verify trip item packing is 0 and inUse is 0
      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      expect(tripItem.plannedQuantity, 3);
      expect(tripItem.packedQuantity, 0);
      expect(tripItem.inUseQuantity, 0);
      expect(tripItem.lastPhysicallyConfirmedAt, isNull);
    });

    test('QA-02: Kemas barang mencatat waktu konfirmasi fisik dan bertahan setelah reload', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Charger USB-C',
        quantity: 2,
        unit: 'buah',
      );
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Bandung',
        startDate: '2026-10-20',
        stops: ['Bandung'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 1);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();

      // Quick toggle pack
      final res = await packingRepo.quickTogglePacked(tripItem.id);
      expect(res.current, 1);

      final reloaded = await (db.select(db.tripItems)..where((ti) => ti.id.equals(tripItem.id))).getSingle();
      expect(reloaded.packedQuantity, 1);
      expect(reloaded.lastPhysicallyConfirmedAt, isNotNull);
    });

    test('QA-03: 5 unit rencana, kemas 2 unit -> status sebagian, sisa 3', () async {
      final itemRes = await inventoryRepo.createItem(name: 'Kaus', quantity: 10, unit: 'buah');
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Jogja',
        startDate: '2026-10-25',
        stops: ['Yogyakarta'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 5);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      await packingRepo.packUnit(tripItem.id, delta: 2);

      final items = await packingRepo.watchTripItems(tripId).first;
      expect(items.length, 1);
      expect(items.first.packedQuantity, 2);
      expect(items.first.plannedQuantity, 5);
      expect(items.first.status, 'sebagian');
      expect(items.first.isCompleted, isFalse);
    });

    test('QA-04: Tidak ada overshooting rencana saat packUnit melebihi rencana', () async {
      final itemRes = await inventoryRepo.createItem(name: 'Jaket', quantity: 2, unit: 'buah');
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Malang',
        startDate: '2026-10-30',
        stops: ['Malang'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 2);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      // Try to pack 5 units when plan is only 2
      final packed = await packingRepo.packUnit(tripItem.id, delta: 5);
      expect(packed, 2);

      final reloaded = await (db.select(db.tripItems)..where((ti) => ti.id.equals(tripItem.id))).getSingle();
      expect(reloaded.packedQuantity, 2);
    });

    test('QA-05: Barang siap lalu dikeluarkan untuk dipakai (setUnitInUse)', () async {
      final itemRes = await inventoryRepo.createItem(name: 'Charger Laptop', quantity: 1, unit: 'buah');
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Jakarta',
        startDate: '2026-11-05',
        stops: ['Jakarta'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 1);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      // Kemas dulu
      await packingRepo.packUnit(tripItem.id, delta: 1);

      var items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.isCompleted, isTrue);

      // Keluarkan untuk dipakai di hotel
      await packingRepo.setUnitInUse(tripItem.id, count: 1);

      items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.packedQuantity, 0);
      expect(items.first.inUseQuantity, 1);
      expect(items.first.isInUse, isTrue);
      expect(items.first.isCompleted, isFalse);
      expect(items.first.status, 'sedang_dipakai');
    });

    test('QA-06: Masukkan kembali sebagian jumlah yang dipakai (returnInUseUnit)', () async {
      final itemRes = await inventoryRepo.createItem(name: 'Masker Medis', quantity: 10, unit: 'buah');
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Semarang',
        startDate: '2026-11-10',
        stops: ['Semarang'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 4);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      await packingRepo.packUnit(tripItem.id, delta: 4);
      // Ambil 2 untuk dipakai
      await packingRepo.setUnitInUse(tripItem.id, count: 2);

      var items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.packedQuantity, 2);
      expect(items.first.inUseQuantity, 2);

      // Kembalikan 1 unit
      await packingRepo.returnInUseUnit(tripItem.id, count: 1);

      items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.packedQuantity, 3);
      expect(items.first.inUseQuantity, 1);
      expect(items.first.lastPhysicallyConfirmedAt, isNotNull);
    });

    test('QA-07: Mengurangi rencana di bawah jumlah yang sudah dikemas/sedang dipakai ditolak (anti-clamp)', () async {
      final itemRes = await inventoryRepo.createItem(name: 'Buku Catatan', quantity: 5, unit: 'buah');
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Solo',
        startDate: '2026-11-15',
        stops: ['Solo'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 3);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      await packingRepo.packUnit(tripItem.id, delta: 3);

      // Attempt to change planned to 2 while 3 are packed
      await expectLater(
        packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 2),
        throwsA(isA<ArgumentError>()),
      );

      // Unpack 1 unit first
      await packingRepo.unpackUnit(tripItem.id, delta: 1);

      // Now reducing planned to 2 is allowed
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 2);
      final reloaded = await (db.select(db.tripItems)..where((ti) => ti.id.equals(tripItem.id))).getSingle();
      expect(reloaded.plannedQuantity, 2);
      expect(reloaded.packedQuantity, 2);
    });

    test('QA-08: Menyetel tidak dibawa mereset packedQuantity ke 0 dan menghapus item dari bawaan', () async {
      final itemRes = await inventoryRepo.createItem(name: 'Kamera', quantity: 1, unit: 'buah');
      final itemId = itemRes.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Trip Lombok',
        startDate: '2026-11-20',
        stops: ['Mataram'],
      );
      await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 1);

      final tripItem = await (db.select(db.tripItems)..where((ti) => ti.tripId.equals(tripId))).getSingle();
      await packingRepo.packUnit(tripItem.id, delta: 1);

      // Set to not carried resets packed quantity
      await packingRepo.setItemNotCarried(tripItem.id);
      final reloaded = await (db.select(db.tripItems)..where((ti) => ti.id.equals(tripItem.id))).getSingle();
      expect(reloaded.decision, 'not_carried');
      expect(reloaded.packedQuantity, 0);

      // Remove from trip bawaan
      await packingRepo.removeTripItem(tripItem.id);
      final remaining = await (db.select(db.tripItems)..where((ti) => ti.id.equals(tripItem.id))).getSingleOrNull();
      expect(remaining, isNull);
    });
  });
}
