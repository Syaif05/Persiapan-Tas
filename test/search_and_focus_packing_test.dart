import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/locations_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/search_repository.dart';

void main() {
  late AppDatabase db;
  late InventoryRepository inventoryRepo;
  late LocationsRepository locationsRepo;
  late TripsRepository tripsRepo;
  late TripPackingRepository packingRepo;
  late UnifiedSearchRepository searchRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    inventoryRepo = InventoryRepository(db);
    locationsRepo = LocationsRepository(db);
    tripsRepo = TripsRepository(db);
    packingRepo = TripPackingRepository(db);
    searchRepo = UnifiedSearchRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Tahap 8: FIND-01 & PACK-01 Pencarian Terpadu & Packing Fokus', () {
    test('FIND-01: Pencarian terpadu membedakan Inventaris Rumah, Perjalanan Dipilih, dan Perjalanan Lain', () async {
      // 1. Setup Lokasi Simpan Rumah
      final loc = await locationsRepo.createLocation(
        name: 'Kotak Elektronik',
        type: 'box',
        description: 'Rak bawah meja',
      );

      // 2. Setup Barang di Rumah
      final chargerItem = await inventoryRepo.createItem(
        name: 'Charger USB-C 65W',
        quantity: 2,
        storageLocationId: loc.id,
      );

      await inventoryRepo.createItem(
        name: 'Sikat Gigi Travel',
        quantity: 3,
      );

      // 3. Setup Perjalanan A (Dipilih)
      final tripAId = await tripsRepo.createTrip(
        name: 'Bandung Trip',
        startDate: '2026-10-18',
        stops: ['Bandung'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripAId,
        itemId: chargerItem.item.id,
        plannedQuantity: 1,
      );
      final tripItemA = await packingRepo.getTripItem(tripAId, chargerItem.item.id);
      await packingRepo.packUnit(tripItemA!.id, delta: 1);

      // 4. Setup Perjalanan B (Perjalanan Lain)
      final tripBId = await tripsRepo.createTrip(
        name: 'Jakarta Meeting',
        startDate: '2026-10-25',
        stops: ['Jakarta'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripBId,
        itemId: chargerItem.item.id,
        plannedQuantity: 1,
      );

      // 5. Jalankan Pencarian Terpadu untuk kata "charger" dengan Perjalanan A sebagai pilihan
      final results = await searchRepo.searchAcrossAll(
        rawQuery: 'charger',
        selectedTripId: tripAId,
      );

      // Verifikasi Perjalanan Dipilih
      expect(results.selectedTripResults.length, 1);
      final selResult = results.selectedTripResults.first;
      expect(selResult.itemName, 'Charger USB-C 65W');
      expect(selResult.tripName, 'Bandung Trip');
      expect(selResult.packingStatus, 'selesai');
      expect(selResult.type, SearchResultType.selectedTrip);

      // Verifikasi Inventaris Rumah
      expect(results.homeInventoryResults.length, 1);
      final homeResult = results.homeInventoryResults.first;
      expect(homeResult.itemName, 'Charger USB-C 65W');
      expect(homeResult.storageLocationName, 'Kotak Elektronik');
      expect(homeResult.type, SearchResultType.homeInventory);

      // Verifikasi Perjalanan Lain
      expect(results.otherTripResults.length, 1);
      final otherResult = results.otherTripResults.first;
      expect(otherResult.itemName, 'Charger USB-C 65W');
      expect(otherResult.tripName, 'Jakarta Meeting');
      expect(otherResult.type, SearchResultType.otherTrip);
    });

    test('FIND-01: Pencarian mengenali alias lokal (casan / adaptor -> Charger)', () async {
      final loc = await locationsRepo.createLocation(name: 'Kotak Kabel', type: 'box');
      await inventoryRepo.createItem(
        name: 'Charger Laptop Anker',
        quantity: 1,
        storageLocationId: loc.id,
      );

      // Cari menggunakan kata 'casan'
      final resultsCasan = await searchRepo.searchAcrossAll(rawQuery: 'casan');
      expect(resultsCasan.homeInventoryResults.isNotEmpty, isTrue);
      expect(resultsCasan.homeInventoryResults.first.itemName, 'Charger Laptop Anker');

      // Cari menggunakan kata 'adaptor'
      final resultsAdaptor = await searchRepo.searchAcrossAll(rawQuery: 'adaptor');
      expect(resultsAdaptor.homeInventoryResults.isNotEmpty, isTrue);
      expect(resultsAdaptor.homeInventoryResults.first.itemName, 'Charger Laptop Anker');
    });

    test('PACK-01: Barang disiapkan terakhir (isPackedLast) dapat ditandai dan difilter tanpa mengubah stok atau packing palsu', () async {
      final item = await inventoryRepo.createItem(
        name: 'Smartphone Pixel',
        quantity: 1,
      );

      final tripId = await tripsRepo.createTrip(
        name: 'Liburan Santai',
        startDate: '2026-11-01',
        stops: ['Surabaya'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: item.item.id,
        plannedQuantity: 1,
      );

      var tripItem = await packingRepo.getTripItem(tripId, item.item.id);
      expect(tripItem!.isPackedLast, isFalse);
      expect(tripItem.packedQuantity, 0);

      // Tandai disiapkan terakhir
      await packingRepo.togglePackedLast(tripItem.id, true);

      tripItem = await packingRepo.getTripItem(tripId, item.item.id);
      expect(tripItem!.isPackedLast, isTrue);
      // PACK-01: Penanda ini tidak berarti sudah disiapkan!
      expect(tripItem.packedQuantity, 0);

      // Verifikasi Filter packing PackingFilter.packedLast
      final allStreamItems = await packingRepo.watchTripItems(tripId, filter: PackingFilter.all).first;
      expect(allStreamItems.length, 1);
      expect(allStreamItems.first.isPackedLast, isTrue);

      final packedLastItems = await packingRepo.watchTripItems(tripId, filter: PackingFilter.packedLast).first;
      expect(packedLastItems.length, 1);
      expect(packedLastItems.first.displayName, 'Smartphone Pixel');

      // Batal tandai disiapkan terakhir
      await packingRepo.togglePackedLast(tripItem.id, false);
      final emptyPackedLastItems = await packingRepo.watchTripItems(tripId, filter: PackingFilter.packedLast).first;
      expect(emptyPackedLastItems.isEmpty, isTrue);
    });
  });
}
