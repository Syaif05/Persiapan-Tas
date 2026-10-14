import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/checkpoints_repository.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/trip_departure_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';

void main() {
  late AppDatabase db;
  late TripsRepository tripsRepo;
  late TripPackingRepository packingRepo;
  late TripDepartureRepository departureRepo;
  late CheckpointsRepository checkpointsRepo;
  late InventoryRepository inventoryRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    tripsRepo = TripsRepository(db);
    packingRepo = TripPackingRepository(db);
    departureRepo = TripDepartureRepository(db, packingRepo);
    checkpointsRepo = CheckpointsRepository(db);
    inventoryRepo = InventoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('QA-19: Expected checkpoint berasal dari baseline keberangkatan, bukan live packing yang diubah kemudian', () async {
    final itemRes = await inventoryRepo.createItem(name: 'Kaus Kaki', quantity: 10);
    final itemId = itemRes.item.id;

    final tripId = await tripsRepo.createTrip(
      name: 'Liburan Malang',
      startDate: '2026-11-20',
      stops: ['Malang'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 4);

    final tripItems = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(tripItems.first.tripItem.id, delta: 4);

    // 1. Berangkat dengan 4 unit -> snapshot tersimpan di DepartureManifest
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    // 2. Di tengah perjalanan, live packing diubah (misal dikurangi atau dihapus)
    await packingRepo.unpackUnit(tripItems.first.tripItem.id, delta: 2);

    // 3. Buat checkpoint kepulangan
    final cpId = await checkpointsRepo.createCheckpoint(tripId: tripId);
    final cpDetails = await checkpointsRepo.getCheckpointWithDetails(cpId);

    // Expected HARUS 4 (dari baseline manifest keberangkatan), BUKAN 2 dari live packing!
    expect(cpDetails, isNotNull);
    expect(cpDetails!.entries.length, equals(1));
    expect(cpDetails.entries.first.expectedQuantity, equals(4));
  });

  test('QA-20: Empat minuman, habis dua, lanjut dua -> Checkpoint ke-2 hanya memeriksa 2, konsumsi lama tidak ditanyakan lagi', () async {
    final drinkRes = await inventoryRepo.createItem(name: 'Botol Minuman Energi', quantity: 10);
    final drinkId = drinkRes.item.id;

    final tripId = await tripsRepo.createTrip(
      name: 'Roadtrip Jawa',
      startDate: '2026-12-05',
      stops: ['Cirebon', 'Semarang'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: drinkId, plannedQuantity: 4);

    final tripItems = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(tripItems.first.tripItem.id, delta: 4);

    // Berangkat membawa 4 minuman
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    // Checkpoint 1 (Kota Cirebon): 4 minuman, 2 habis dikonsumsi, 2 dibawa lanjut
    final cp1Id = await checkpointsRepo.createCheckpoint(tripId: tripId, title: 'Cek Keluar Cirebon');
    var cp1 = await checkpointsRepo.getCheckpointWithDetails(cp1Id);
    expect(cp1!.entries.first.expectedQuantity, equals(4));

    await checkpointsRepo.updateReturnEntryQuantities(
      entryId: cp1.entries.first.id,
      returnedQuantity: 2, // dibawa lanjut 2
      consumedQuantity: 2, // habis 2
      leftQuantity: 0,
    );
    await checkpointsRepo.closeCheckpoint(cp1Id);

    // Checkpoint 2 (Kota Semarang): Baseline tahap berikutnya mengambil saldo lanjut = 2
    final cp2Id = await checkpointsRepo.createCheckpoint(tripId: tripId, title: 'Cek Keluar Semarang');
    final cp2 = await checkpointsRepo.getCheckpointWithDetails(cp2Id);

    expect(cp2, isNotNull);
    expect(cp2!.entries.first.expectedQuantity, equals(2)); // HANYA 2!
    // Konsumsi 2 botol pertama TIDAK muncul lagi sebagai kekurangan
    expect(cp2.totalUnconfirmed, equals(0));
  });

  test('QA-21: Beli 1 barang baru pada kota kedua -> Baseline tahap berikutnya menambahkan 1 dengan identitas jelas', () async {
    final res1 = await inventoryRepo.createItem(name: 'Roti Gandum', quantity: 2);
    final res2 = await inventoryRepo.createItem(name: 'Kopi Kaleng Baru Dibeli', quantity: 5);
    final item1 = res1.item.id;
    final item2 = res2.item.id;

    final tripId = await tripsRepo.createTrip(
      name: 'Touring Selatan',
      startDate: '2026-12-10',
      stops: ['Pelabuhan Ratu', 'Pangandaran'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: item1, plannedQuantity: 2);
    final items1 = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items1.first.tripItem.id, delta: 2);

    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    // Checkpoint 1: Roti habis 1, lanjut 1
    final cp1Id = await checkpointsRepo.createCheckpoint(tripId: tripId);
    final cp1 = await checkpointsRepo.getCheckpointWithDetails(cp1Id);
    await checkpointsRepo.updateReturnEntryQuantities(
      entryId: cp1!.entries.first.id,
      returnedQuantity: 1,
      consumedQuantity: 1,
      leftQuantity: 0,
    );
    await checkpointsRepo.closeCheckpoint(cp1Id);

    // Di kota kedua, pengguna membeli barang baru (Kopi Kaleng) dan memasukkannya ke bawaan perjalanan
    await packingRepo.setPlannedItem(tripId: tripId, itemId: item2, plannedQuantity: 1);
    final allItems = await packingRepo.watchTripItems(tripId).first;
    final coffeeItem = allItems.firstWhere((i) => i.tripItem.itemId == item2);
    await packingRepo.packUnit(coffeeItem.tripItem.id, delta: 1);

    // Checkpoint 2: Roti (1 lanjut) + Kopi Kaleng baru (1 unit) -> Total expected = 2
    final cp2Id = await checkpointsRepo.createCheckpoint(tripId: tripId);
    final cp2 = await checkpointsRepo.getCheckpointWithDetails(cp2Id);

    expect(cp2!.entries.length, equals(2));
    final rotiEntry = cp2.entries.firstWhere((e) => e.nameSnapshot.contains('Roti'));
    final coffeeEntry = cp2.entries.firstWhere((e) => e.nameSnapshot.contains('Kopi'));

    expect(rotiEntry.expectedQuantity, equals(1));
    expect(coffeeEntry.expectedQuantity, equals(1));
  });

  test('QA-22: Unit hasil checkpoint melebihi expected -> operasi ditolak & data lama aman', () async {
    final itemRes = await inventoryRepo.createItem(name: 'Handuk', quantity: 2);
    final tripId = await tripsRepo.createTrip(
      name: 'Staycation',
      startDate: '2026-12-12',
      stops: ['Resort'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemRes.item.id, plannedQuantity: 1);
    final items = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items.first.tripItem.id, delta: 1);
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    final cpId = await checkpointsRepo.createCheckpoint(tripId: tripId);
    final cp = await checkpointsRepo.getCheckpointWithDetails(cpId);
    final entry = cp!.entries.first;

    // Coba masukkan konfirmasi 2 unit padahal expected cuma 1
    expect(
      () => checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 1,
        consumedQuantity: 1, // total 2 > 1
        leftQuantity: 0,
      ),
      throwsArgumentError,
    );

    // Data lama tetap aman
    final unchanged = await checkpointsRepo.getCheckpointWithDetails(cpId);
    expect(unchanged!.entries.first.returnedQuantity, equals(1));
    expect(unchanged.entries.first.consumedQuantity, equals(0));
  });

  test('QA-23, QA-24, QA-25: Charger belum ditemukan -> ditutup dengan masalah; konfirmasi hilang mengurangi saldo lanjut', () async {
    final chargerRes = await inventoryRepo.createItem(name: 'Charger USB-C', quantity: 2);
    final tripId = await tripsRepo.createTrip(
      name: 'Perjalanan Bisnis',
      startDate: '2026-12-15',
      stops: ['Jakarta', 'Tangerang'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: chargerRes.item.id, plannedQuantity: 1);
    final items = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items.first.tripItem.id, delta: 1);
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    // Checkpoint 1: Charger BELUM DITEMUKAN (returned: 0, unconfirmed: 1)
    final cp1Id = await checkpointsRepo.createCheckpoint(tripId: tripId, title: 'Cek Jakarta');
    final cp1 = await checkpointsRepo.getCheckpointWithDetails(cp1Id);

    await checkpointsRepo.updateReturnEntryQuantities(
      entryId: cp1!.entries.first.id,
      returnedQuantity: 0,
      consumedQuantity: 0,
      leftQuantity: 0,
      lostQuantity: 0,
      notes: 'Terselip di kamar hotel, masih dicari',
    );

    // QA-23: Tutup checkpoint dengan sisa belum terkonfirmasi -> status closed_with_unconfirmed (BUKAN completed)
    await checkpointsRepo.closeCheckpoint(cp1Id);
    final closedCp1 = await checkpointsRepo.getCheckpointWithDetails(cp1Id);
    expect(closedCp1!.closeState, equals('closed_with_unconfirmed'));
    expect(closedCp1.isClosedWithUnconfirmed, isTrue);

    // Saldo lanjut ke tahap berikutnya: charger tetap masuk daftar pencarian (expected = 1)
    final cp2Id = await checkpointsRepo.createCheckpoint(tripId: tripId, title: 'Cek Tangerang');
    final cp2 = await checkpointsRepo.getCheckpointWithDetails(cp2Id);
    expect(cp2!.entries.first.expectedQuantity, equals(1));

    // QA-25: Sekarang charger DIKONFIRMASI HILANG (lostQuantity: 1)
    await checkpointsRepo.updateReturnEntryQuantities(
      entryId: cp2.entries.first.id,
      returnedQuantity: 0,
      consumedQuantity: 0,
      leftQuantity: 0,
      lostQuantity: 1, // Konfirmasi hilang resmi
      notes: 'Ketinggalan di stopkontak lobi Jakarta dan tidak ditemukan',
    );
    await checkpointsRepo.closeCheckpoint(cp2Id);
    final closedCp2 = await checkpointsRepo.getCheckpointWithDetails(cp2Id);
    expect(closedCp2!.closeState, equals('completed')); // Semua terkonfirmasi (1 hilang)

    // Checkpoint 3 (Pulang): Karena kehilangan sudah dikonfirmasi, saldo lanjut berikutnya berkurang menjadi 0!
    // Tidak ada lagi entri charger yang ditagih
    final cp3Id = await checkpointsRepo.createCheckpoint(tripId: tripId, title: 'Pulang ke Rumah');
    final cp3 = await checkpointsRepo.getCheckpointWithDetails(cp3Id);
    expect(cp3!.entries.isEmpty, isTrue);
  });

  test('QA-26: Dua checkpoint terbuka bersamaan dalam tahap yang sama ditolak', () async {
    final itemRes = await inventoryRepo.createItem(name: 'Topi', quantity: 2);
    final tripId = await tripsRepo.createTrip(
      name: 'Pantai',
      startDate: '2026-12-18',
      stops: ['Anyer'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemRes.item.id, plannedQuantity: 1);
    final items = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items.first.tripItem.id, delta: 1);
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    // Buat checkpoint 1 (status open)
    await checkpointsRepo.createCheckpoint(tripId: tripId);

    // Coba buat checkpoint ke-2 saat checkpoint 1 masih open
    expect(
      () => checkpointsRepo.createCheckpoint(tripId: tripId),
      throwsStateError,
    );
  });

  test('QA-27: Checkpoint yang sudah ditutup tetap immutable setelah live item diubah', () async {
    final itemRes = await inventoryRepo.createItem(name: 'Biskuit', quantity: 5);
    final tripId = await tripsRepo.createTrip(
      name: 'Kemah',
      startDate: '2026-12-20',
      stops: ['Gunung'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemRes.item.id, plannedQuantity: 3);
    final items = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items.first.tripItem.id, delta: 3);
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    final cpId = await checkpointsRepo.createCheckpoint(tripId: tripId);
    final cp = await checkpointsRepo.getCheckpointWithDetails(cpId);
    await checkpointsRepo.updateReturnEntryQuantities(
      entryId: cp!.entries.first.id,
      returnedQuantity: 1,
      consumedQuantity: 2,
      leftQuantity: 0,
    );
    await checkpointsRepo.closeCheckpoint(cpId);

    // Ubah live packing setelah checkpoint ditutup
    await packingRepo.packUnit(items.first.tripItem.id, delta: 1);

    // Checkpoint lama yang sudah ditutup tetap immutable!
    final closedCp = await checkpointsRepo.getCheckpointWithDetails(cpId);
    expect(closedCp!.entries.first.expectedQuantity, equals(3));
    expect(closedCp.entries.first.consumedQuantity, equals(2));
    expect(closedCp.entries.first.returnedQuantity, equals(1));
  });
}
