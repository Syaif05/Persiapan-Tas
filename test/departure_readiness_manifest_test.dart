import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/locations_repository.dart';
import 'package:bawa/data/repositories/trip_departure_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';

void main() {
  late AppDatabase db;
  late TripsRepository tripsRepo;
  late TripPackingRepository packingRepo;
  late TripDepartureRepository departureRepo;
  late InventoryRepository inventoryRepo;
  late LocationsRepository locationsRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    tripsRepo = TripsRepository(db);
    packingRepo = TripPackingRepository(db);
    departureRepo = TripDepartureRepository(db, packingRepo);
    inventoryRepo = InventoryRepository(db);
    locationsRepo = LocationsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('QA-15: Packing 100% tetapi barang penting belum diverifikasi -> kesiapan belum lulus', () async {
    // 1. Buat barang penting (Paspor)
    final passportRes = await inventoryRepo.createItem(
      name: 'Buku Paspor',
      quantity: 1,
      isImportant: true,
    );
    final passportId = passportRes.item.id;

    // 2. Buat perjalanan & tambahkan paspor
    final tripId = await tripsRepo.createTrip(
      name: 'Liburan ke Jepang',
      startDate: '2026-11-01',
      stops: ['Tokyo'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: passportId, plannedQuantity: 1);

    // 3. Kemas 100% paspor
    final items = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items.first.tripItem.id, delta: 1);

    // 4. Evaluasi kesiapan keberangkatan
    var readiness = await departureRepo.evaluateReadiness(tripId);
    expect(readiness.totalCarriedItems, equals(1));
    expect(readiness.fullyPackedItems, equals(1));
    expect(readiness.isReadyForDeparture, isFalse);
    expect(readiness.unconfirmedImportantItems.length, equals(1));
    expect(readiness.allIssues.any((i) => i.issueType == 'important_unconfirmed'), isTrue);

    // 5. Konfirmasi barang penting dalam pemeriksaan keberangkatan
    final tripItemId = readiness.unconfirmedImportantItems.first.tripItem.id;
    await departureRepo.confirmItemDepartureCheck(tripItemId);

    // 6. Evaluasi ulang -> sekarang harus lulus!
    readiness = await departureRepo.evaluateReadiness(tripId);
    expect(readiness.isReadyForDeparture, isTrue);
    expect(readiness.allIssues.isEmpty, isTrue);
  });

  test('QA-14: Pemeriksaan lulus lalu edit satu item -> hanya item tersebut yang terinvalidasi', () async {
    // 1. Buat barang: Kaus (biasa) & Charger (penting)
    final shirtRes = await inventoryRepo.createItem(name: 'Kaus Hitam', quantity: 5);
    final chargerRes = await inventoryRepo.createItem(name: 'Charger Laptop', quantity: 2, isImportant: true);
    final shirtId = shirtRes.item.id;
    final chargerId = chargerRes.item.id;

    final tripId = await tripsRepo.createTrip(
      name: 'Workshop Surabaya',
      startDate: '2026-11-10',
      stops: ['Surabaya'],
    );

    await packingRepo.setPlannedItem(tripId: tripId, itemId: shirtId, plannedQuantity: 2);
    await packingRepo.setPlannedItem(tripId: tripId, itemId: chargerId, plannedQuantity: 1);

    final items = await packingRepo.watchTripItems(tripId).first;
    final shirtTripItem = items.firstWhere((i) => i.tripItem.itemId == shirtId);
    final chargerTripItem = items.firstWhere((i) => i.tripItem.itemId == chargerId);

    // Kemas keduanya
    await packingRepo.packUnit(shirtTripItem.tripItem.id, delta: 2);
    await packingRepo.packUnit(chargerTripItem.tripItem.id, delta: 1);

    // Konfirmasi charger
    await departureRepo.confirmItemDepartureCheck(chargerTripItem.tripItem.id);

    var readiness = await departureRepo.evaluateReadiness(tripId);
    expect(readiness.isReadyForDeparture, isTrue);

    // Sekarang edit rencana kaus dari 2 menjadi 3 (tambah kebutuhan di perjalanan)
    await packingRepo.setPlannedItem(tripId: tripId, itemId: shirtId, plannedQuantity: 3);

    // Evaluasi ulang
    readiness = await departureRepo.evaluateReadiness(tripId);
    expect(readiness.isReadyForDeparture, isFalse);
    expect(readiness.unpackedItems.length, equals(1));
    expect(readiness.unpackedItems.first.tripItem.itemId, equals(shirtId));

    // Charger TETAP terkonfirmasi dan tidak terinvalidasi!
    expect(readiness.unconfirmedImportantItems.isEmpty, isTrue);
  });

  test('QA-16: Berangkat dengan catatan saat ada kekurangan packing atau barang sedang dipakai', () async {
    final resA = await inventoryRepo.createItem(name: 'Jaket Tebal', quantity: 2);
    final resB = await inventoryRepo.createItem(name: 'Payung Lipat', quantity: 2);
    final resC = await inventoryRepo.createItem(name: 'Earphone', quantity: 1);
    final itemA = resA.item.id;
    final itemB = resB.item.id;
    final itemC = resC.item.id;

    final tripId = await tripsRepo.createTrip(
      name: 'Dinas Bandung',
      startDate: '2026-11-15',
      stops: ['Bandung'],
    );

    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemA, plannedQuantity: 2);
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemB, plannedQuantity: 2);
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemC, plannedQuantity: 1);

    final items = await packingRepo.watchTripItems(tripId).first;
    final tripItemA = items.firstWhere((i) => i.tripItem.itemId == itemA);
    final tripItemB = items.firstWhere((i) => i.tripItem.itemId == itemB);
    final tripItemC = items.firstWhere((i) => i.tripItem.itemId == itemC);

    // Item A: 2/2 kemas penuh
    await packingRepo.packUnit(tripItemA.tripItem.id, delta: 2);
    // Item B: 1/2 kemas sebagian (kurang 1)
    await packingRepo.packUnit(tripItemB.tripItem.id, delta: 1);
    // Item C: 0/1 dikeluarkan untuk dipakai saat ini
    await packingRepo.setUnitInUse(tripItemC.tripItem.id, count: 1);

    // Berangkat dengan catatan
    final manifest = await departureRepo.startTripAndCreateManifest(
      tripId: tripId,
      departedWithIssues: true,
      departureNotes: 'Payung cadangan ditinggal di rumah, earphone dipakai di jalan',
    );

    expect(manifest.isDepartedWithIssues, isTrue);
    expect(manifest.departureNotes, contains('Payung cadangan ditinggal'));

    // Status perjalanan menjadi 'ongoing'
    final trip = await tripsRepo.getTripById(tripId);
    expect(trip?.status, equals('ongoing'));

    // Cek rincian manifest
    final manifestDetails = await departureRepo.getDepartureManifest(tripId);
    expect(manifestDetails, isNotNull);
    expect(manifestDetails!.items.length, equals(3));
    expect(manifestDetails.totalCarriedQuantity, equals(3)); // 2 + 1 + 0
    expect(manifestDetails.totalDeficiencyQuantity, equals(2)); // 0 + 1 + 1

    final mItemA = manifestDetails.items.firstWhere((i) => i.itemId == itemA);
    final mItemB = manifestDetails.items.firstWhere((i) => i.itemId == itemB);
    final mItemC = manifestDetails.items.firstWhere((i) => i.itemId == itemC);

    expect(mItemA.carriedQuantity, equals(2));
    expect(mItemA.deficiencyQuantity, equals(0));

    expect(mItemB.carriedQuantity, equals(1));
    expect(mItemB.deficiencyQuantity, equals(1));

    expect(mItemC.carriedQuantity, equals(0));
    expect(mItemC.deficiencyQuantity, equals(1));
  });

  test('QA-18: Edit/arsip master inventaris setelah berangkat tidak mengubah snapshot manifest historis', () async {
    // 1. Buat lokasi penyimpanan & barang master
    final loc = await locationsRepo.createLocation(name: 'Kotak Pakaian A', type: 'box');
    final shirtRes = await inventoryRepo.createItem(
      name: 'Kaus Oblong Hitam',
      quantity: 3,
      storageLocationId: loc.id,
    );
    final shirtId = shirtRes.item.id;

    final tripId = await tripsRepo.createTrip(
      name: 'Solo Trip Bali',
      startDate: '2026-12-01',
      stops: ['Denpasar'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: shirtId, plannedQuantity: 3);

    final items = await packingRepo.watchTripItems(tripId).first;
    await packingRepo.packUnit(items.first.tripItem.id, delta: 3);

    // 2. Berangkat & simpan manifest
    await departureRepo.startTripAndCreateManifest(tripId: tripId);

    // 3. Pengguna mengedit master inventaris (misal ganti nama, ubah jumlah, dan arsipkan)
    await inventoryRepo.updateItem(
      id: shirtId,
      name: 'Kaus Hitam Distro (Nama Baru)',
      quantity: 10,
    );
    await inventoryRepo.archiveItem(shirtId);

    // 4. Periksa manifest: data historis TETAP menampilkan nama dan lokasi asli saat keberangkatan!
    final manifestDetails = await departureRepo.getDepartureManifest(tripId);
    expect(manifestDetails, isNotNull);
    final manifestItem = manifestDetails!.items.first;

    expect(manifestItem.itemNameSnapshot, equals('Kaus Oblong Hitam'));
    expect(manifestItem.storageLocationSnapshot, equals('Kotak Pakaian A'));
    expect(manifestItem.carriedQuantity, equals(3));
  });

  test('QA-37: Perjalanan legacy tanpa manifest ditandai dengan benar dan dapat dibuat baseline manual', () async {
    final itemRes = await inventoryRepo.createItem(name: 'Sandal Jepit', quantity: 2);
    final itemId = itemRes.item.id;
    final tripId = await tripsRepo.createTrip(
      name: 'Perjalanan Lama',
      startDate: '2026-09-01',
      stops: ['Yogyakarta'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 1);
    final tripItem = (await packingRepo.watchTripItems(tripId).first).first;
    await packingRepo.packUnit(tripItem.tripItem.id, delta: 1);

    // Ubah status ke ongoing langsung tanpa lewat departure flow (meniru data lama)
    await tripsRepo.updateTripStatus(tripId, 'ongoing');

    // Cek manifest -> belum ada
    var manifest = await departureRepo.getDepartureManifest(tripId);
    expect(manifest, isNull);

    // Buat legacy baseline manifest
    await departureRepo.createLegacyBaselineManifest(tripId);

    manifest = await departureRepo.getDepartureManifest(tripId);
    expect(manifest, isNotNull);
    expect(manifest!.manifest.sourceLabel, equals('legacy_packing_record'));
    expect(manifest.manifest.departureNotes, equals('Diambil dari catatan packing lama'));
    expect(manifest.items.first.carriedQuantity, equals(1));
  });

  test('Koreksi manifest historis menyimpan catatan alasan tanpa merusak versi manifest', () async {
    final itemRes = await inventoryRepo.createItem(name: 'Botol Minum', quantity: 2);
    final itemId = itemRes.item.id;
    final tripId = await tripsRepo.createTrip(
      name: 'Pendakian Gunung',
      startDate: '2026-10-20',
      stops: ['Basecamp'],
    );
    await packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 2);
    final tripItem = (await packingRepo.watchTripItems(tripId).first).first;
    await packingRepo.packUnit(tripItem.tripItem.id, delta: 1);

    await departureRepo.startTripAndCreateManifest(tripId: tripId, departedWithIssues: true);

    var manifestDetails = await departureRepo.getDepartureManifest(tripId);
    final mItem = manifestDetails!.items.first;
    expect(mItem.carriedQuantity, equals(1));
    expect(mItem.deficiencyQuantity, equals(1));

    // Lakukan koreksi resmi
    await departureRepo.correctManifestItem(
      manifestItemId: mItem.id,
      newCarriedQuantity: 2,
      reason: 'Botol kedua ternyata sudah ada di dalam ransel',
    );

    manifestDetails = await departureRepo.getDepartureManifest(tripId);
    final updatedItem = manifestDetails!.items.first;
    expect(updatedItem.carriedQuantity, equals(2));
    expect(updatedItem.deficiencyQuantity, equals(0));
    expect(updatedItem.notes, contains('[Koreksi]: Botol kedua ternyata sudah ada di dalam ransel'));
    expect(updatedItem.notes, contains('(Sebelumnya: 1 unit)'));
  });
}
