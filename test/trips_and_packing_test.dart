import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/locations_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';

void main() {
  late AppDatabase db;
  late TripsRepository tripsRepo;
  late TripPackingRepository packingRepo;
  late InventoryRepository inventoryRepo;
  late LocationsRepository locationsRepo;

  setUp(() {
    db = AppDatabase.inMemory();
    tripsRepo = TripsRepository(db);
    packingRepo = TripPackingRepository(db);
    inventoryRepo = InventoryRepository(db);
    locationsRepo = LocationsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Fase 3: Trips Repository Tests (TRP-01 .. TRP-08)', () {
    test('TRP-01, TRP-02: Create multiple trips with validation', () async {
      final trip1Id = await tripsRepo.createTrip(
        name: 'Bandung Akhir Pekan',
        startDate: '2026-10-18',
        endDate: '2026-10-20',
        stops: ['Bandung'],
      );

      final trip2Id = await tripsRepo.createTrip(
        name: 'Jakarta Bisnis',
        startDate: '2026-10-25',
        stops: ['Jakarta'],
      );

      final trips = await tripsRepo.watchTrips().first;
      expect(trips.length, equals(2));
      expect(trips.any((t) => t.id == trip1Id && t.name == 'Bandung Akhir Pekan'), isTrue);
      expect(trips.any((t) => t.id == trip2Id && t.name == 'Jakarta Bisnis'), isTrue);

      // Validation: empty name throws
      expect(
        () => tripsRepo.createTrip(name: '', startDate: '2026-10-18', stops: ['Bandung']),
        throwsArgumentError,
      );

      // Validation: endDate before startDate throws
      expect(
        () => tripsRepo.createTrip(
          name: 'Liburan',
          startDate: '2026-10-20',
          endDate: '2026-10-18',
          stops: ['Bandung'],
        ),
        throwsArgumentError,
      );

      // Validation: empty stops throws
      expect(
        () => tripsRepo.createTrip(name: 'Liburan', startDate: '2026-10-20', stops: []),
        throwsArgumentError,
      );
    });

    test('TRP-03, TRP-04 & AT-06: Multi-stop with repeated destination (Bandung-Jakarta-Bandung)', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Roadtrip Jawa Barat',
        startDate: '2026-11-01',
        endDate: '2026-11-05',
        stops: ['Bandung', 'Jakarta', 'Bandung'],
      );

      final details = await tripsRepo.watchTripWithDetails(tripId).first;
      expect(details, isNotNull);
      expect(details!.stops.length, equals(3));
      expect(details.stops[0].label, equals('Bandung'));
      expect(details.stops[0].sortOrder, equals(0));
      expect(details.stops[1].label, equals('Jakarta'));
      expect(details.stops[1].sortOrder, equals(1));
      expect(details.stops[2].label, equals('Bandung'));
      expect(details.stops[2].sortOrder, equals(2));
      // Unique stop IDs even for repeated label
      expect(details.stops[0].id, isNot(equals(details.stops[2].id)));
    });

    test('TRP-05: Status transitions and archiving', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Yogyakarta Tour',
        startDate: '2026-12-01',
        stops: ['Yogyakarta'],
      );

      var trip = await tripsRepo.getTripById(tripId);
      expect(trip!.status, equals('planning'));
      expect(trip.isArchived, isFalse);

      await tripsRepo.updateTripStatus(tripId, 'ongoing');
      trip = await tripsRepo.getTripById(tripId);
      expect(trip!.status, equals('ongoing'));

      await tripsRepo.updateTripStatus(tripId, 'completed');
      trip = await tripsRepo.getTripById(tripId);
      expect(trip!.status, equals('completed'));

      await tripsRepo.archiveTrip(tripId, true);
      trip = await tripsRepo.getTripById(tripId);
      expect(trip!.isArchived, isTrue);

      // Active trips query should exclude archived
      final activeTrips = await tripsRepo.watchTrips().first;
      expect(activeTrips.any((t) => t.id == tripId), isFalse);

      // Query with includeArchived: true should include it
      final allTrips = await tripsRepo.watchTrips(includeArchived: true).first;
      expect(allTrips.any((t) => t.id == tripId), isTrue);
    });

    test('TRP-07 & AT-18: Trip duplication copies planned items, RESETS packed_quantity to 0', () async {
      // 1. Setup item in inventory
      final createdItem = await inventoryRepo.createItem(name: 'Jaket Parasut', quantity: 2);
      final itemId = createdItem.item.id;

      // 2. Setup trip 1 with carried item and packed
      final trip1Id = await tripsRepo.createTrip(
        name: 'Bromo Trip 1',
        startDate: '2026-10-01',
        stops: ['Malang', 'Bromo'],
      );

      await packingRepo.setPlannedItem(
        tripId: trip1Id,
        itemId: itemId,
        plannedQuantity: 1,
      );

      // Pack item in trip 1
      await packingRepo.quickTogglePacked(
        (await packingRepo.watchTripItems(trip1Id).first).first.tripItem.id,
      );
      final trip1Items = await packingRepo.watchTripItems(trip1Id).first;
      expect(trip1Items.first.tripItem.packedQuantity, equals(1));

      // 3. Duplicate trip 1
      final trip2Id = await tripsRepo.duplicateTrip(
        originalTripId: trip1Id,
        newName: 'Bromo Trip 2 (Duplikat)',
        newStartDate: '2026-11-01',
      );

      final trip2Details = await tripsRepo.watchTripWithDetails(trip2Id).first;
      expect(trip2Details!.trip.name, equals('Bromo Trip 2 (Duplikat)'));
      expect(trip2Details.stops.length, equals(2));

      // Check items in trip 2: planned = 1, packed = 0 (AT-18 reset!)
      final trip2Items = await packingRepo.watchTripItems(trip2Id).first;
      expect(trip2Items.length, equals(1));
      expect(trip2Items.first.tripItem.plannedQuantity, equals(1));
      expect(trip2Items.first.tripItem.packedQuantity, equals(0));
      expect(trip2Items.first.status, equals('belum_dikemas'));

      // Original trip 1 packing remains untouched
      final trip1ItemsAfter = await packingRepo.watchTripItems(trip1Id).first;
      expect(trip1ItemsAfter.first.tripItem.packedQuantity, equals(1));
    });

    test('TRP-08 & AT-05: Progress calculation and empty packing list status', () async {
      final tripId = await tripsRepo.createTrip(
        name: 'Empty Trip',
        startDate: '2026-10-18',
        stops: ['Bandung'],
      );

      final summary = await tripsRepo.calculateTripSummary(tripId);
      expect(summary.hasItems, isFalse);
      expect(summary.progressLabel, equals('Belum ada daftar bawaan')); // AT-05: not 100%!
      expect(summary.progress, equals(0.0));
    });
  });

  group('Fase 3: Trip Packing & Item Lifecycle Tests (PCK-01 .. PCK-12)', () {
    test('PCK-01, PCK-02, AT-01 & AT-02: Strict trip isolation between trip A and B', () async {
      // Create Box and Item
      final loc = await locationsRepo.createLocation(name: 'Kotak Elektronik', type: 'box');
      final charger = await inventoryRepo.createItem(
        name: 'Charger USB-C',
        quantity: 1,
        storageLocationId: loc.id,
      );
      final chargerId = charger.item.id;

      // Create Trip Bandung and Trip Jakarta
      final bandungTripId = await tripsRepo.createTrip(
        name: 'Bandung',
        startDate: '2026-10-18',
        stops: ['Bandung'],
      );

      final jakartaTripId = await tripsRepo.createTrip(
        name: 'Jakarta',
        startDate: '2026-10-25',
        stops: ['Jakarta'],
      );

      // Add to Bandung
      await packingRepo.setPlannedItem(
        tripId: bandungTripId,
        itemId: chargerId,
        plannedQuantity: 1,
      );

      // Add to Jakarta
      await packingRepo.setPlannedItem(
        tripId: jakartaTripId,
        itemId: chargerId,
        plannedQuantity: 1,
      );

      // AT-01: Check source box visible, initial status belum_dikemas
      final bandungItems = await packingRepo.watchTripItems(bandungTripId).first;
      expect(bandungItems.first.displayLocation, equals('Kotak Elektronik'));
      expect(bandungItems.first.status, equals('belum_dikemas'));

      // Pack in Bandung
      await packingRepo.quickTogglePacked(bandungItems.first.tripItem.id);

      final bandungItemsAfter = await packingRepo.watchTripItems(bandungTripId).first;
      expect(bandungItemsAfter.first.status, equals('selesai'));
      expect(bandungItemsAfter.first.tripItem.packedQuantity, equals(1));

      // AT-02: Jakarta MUST remain untouched (belum_dikemas)
      final jakartaItems = await packingRepo.watchTripItems(jakartaTripId).first;
      expect(jakartaItems.first.status, equals('belum_dikemas'));
      expect(jakartaItems.first.tripItem.packedQuantity, equals(0));

      // Global inventory quantity did not change (PCK-01)
      final invItem = await inventoryRepo.getItemWithDetailsById(chargerId);
      expect(invItem!.item.quantity, equals(1));
    });

    test('PCK-03: Planned quantity cannot exceed inventory quantity', () async {
      final item = await inventoryRepo.createItem(name: 'Kamera', quantity: 1);
      final itemId = item.item.id;
      final tripId = await tripsRepo.createTrip(
        name: 'Bali Trip',
        startDate: '2026-11-01',
        stops: ['Denpasar'],
      );

      expect(
        () => packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 2),
        throwsArgumentError,
      );

      expect(
        () => packingRepo.setPlannedItem(tripId: tripId, itemId: itemId, plannedQuantity: 0),
        throwsArgumentError,
      );
    });

    test('PCK-04 & AT-03: Partial packing calculation (5 planned, 3 packed -> sebagian)', () async {
      final kaus = await inventoryRepo.createItem(name: 'Kaus Hitam', quantity: 5);
      final kausId = kaus.item.id;
      final tripId = await tripsRepo.createTrip(
        name: 'Semarang',
        startDate: '2026-11-10',
        stops: ['Semarang'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: kausId,
        plannedQuantity: 5,
      );

      final tripItemId = (await packingRepo.watchTripItems(tripId).first).first.tripItem.id;

      // Pack 3
      await packingRepo.updatePackedQuantity(tripItemId, 3);

      final items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.status, equals('sebagian'));
      expect(items.first.isCompleted, isFalse);

      final summary = await tripsRepo.calculateTripSummary(tripId);
      expect(summary.totalCarriedRows, equals(1));
      expect(summary.completedRows, equals(0)); // AT-03: Row is not completed
      expect(summary.progress, equals(0.0));
      expect(summary.unitsLabel, equals('3/5 unit dikemas'));

      // Pack remaining 2 (now 5)
      await packingRepo.updatePackedQuantity(tripItemId, 5);
      final summaryAfter = await tripsRepo.calculateTripSummary(tripId);
      expect(summaryAfter.completedRows, equals(1));
      expect(summaryAfter.progress, equals(1.0));
      expect(summaryAfter.isAllCompleted, isTrue);
    });

    test('PCK-05 & PCK-10: Rapid check toggle and undo', () async {
      final item = await inventoryRepo.createItem(name: 'Sikat Gigi', quantity: 2);
      final itemId = item.item.id;
      final tripId = await tripsRepo.createTrip(
        name: 'Solo',
        startDate: '2026-10-20',
        stops: ['Solo'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemId,
        plannedQuantity: 2,
      );

      final tripItemId = (await packingRepo.watchTripItems(tripId).first).first.tripItem.id;

      // Rapid check multi-unit -> completes all
      final toggleResult = await packingRepo.quickTogglePacked(tripItemId);
      expect(toggleResult.previous, equals(0));
      expect(toggleResult.current, equals(2));

      var items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.tripItem.packedQuantity, equals(2));

      // PCK-10: Undo packed quantity back to previous
      await packingRepo.updatePackedQuantity(tripItemId, toggleResult.previous);
      items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.tripItem.packedQuantity, equals(0));
    });

    test('PCK-08 & AT-07: Optional trip bags creation and item assignment', () async {
      final item = await inventoryRepo.createItem(name: 'Sandal Jepit', quantity: 1);
      final itemId = item.item.id;
      final tripId = await tripsRepo.createTrip(
        name: 'Anyer',
        startDate: '2026-10-30',
        stops: ['Anyer'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemId,
        plannedQuantity: 1,
      );

      // AT-07: Packing works seamlessly without creating any bags
      final itemBeforeBag = (await packingRepo.watchTripItems(tripId).first).first;
      await packingRepo.quickTogglePacked(itemBeforeBag.tripItem.id);
      expect((await packingRepo.watchTripItems(tripId).first).first.isCompleted, isTrue);

      // Create optional bag (PCK-08)
      final bagId = await packingRepo.createTripBag(tripId, 'Ransel Hitam');
      final bags = await packingRepo.watchTripBags(tripId).first;
      expect(bags.length, equals(1));
      expect(bags.first.name, equals('Ransel Hitam'));

      // Assign item to bag
      await packingRepo.assignItemToBag(itemBeforeBag.tripItem.id, bagId);
      final itemsWithBag = await packingRepo.watchTripItems(tripId).first;
      expect(itemsWithBag.first.tripBagName, equals('Ransel Hitam'));

      // Delete bag -> item is NOT deleted, bagId becomes null
      await packingRepo.deleteTripBag(bagId);
      final itemsAfterBagDelete = await packingRepo.watchTripItems(tripId).first;
      expect(itemsAfterBagDelete.length, equals(1));
      expect(itemsAfterBagDelete.first.tripBagName, isNull);
    });

    test('PCK-09: Conflict warning detection for overlapping trips', () async {
      // 1 powerbank in stock
      final pb = await inventoryRepo.createItem(name: 'Powerbank 20000mAh', quantity: 1);
      final pbId = pb.item.id;

      // Trip 1: 18-22 Okt
      final trip1Id = await tripsRepo.createTrip(
        name: 'Trip A',
        startDate: '2026-10-18',
        endDate: '2026-10-22',
        stops: ['A'],
      );

      // Trip 2: 20-25 Okt (Overlaps 20-22 Okt!)
      final trip2Id = await tripsRepo.createTrip(
        name: 'Trip B',
        startDate: '2026-10-20',
        endDate: '2026-10-25',
        stops: ['B'],
      );

      await packingRepo.setPlannedItem(
        tripId: trip1Id,
        itemId: pbId,
        plannedQuantity: 1,
      );

      await packingRepo.setPlannedItem(
        tripId: trip2Id,
        itemId: pbId,
        plannedQuantity: 1,
      );

      // Trip 2 should detect conflict with Trip 1!
      final trip2Items = await packingRepo.watchTripItems(trip2Id).first;
      expect(trip2Items.first.hasConflict, isTrue);
      expect(trip2Items.first.conflictMessage, contains('Potensi bentrok'));
    });

    test('AT-04: Changing packed item to not carried resets packed quantity', () async {
      final item = await inventoryRepo.createItem(name: 'Topi', quantity: 1);
      final itemId = item.item.id;
      final tripId = await tripsRepo.createTrip(
        name: 'Puncak',
        startDate: '2026-11-15',
        stops: ['Bogor'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemId,
        plannedQuantity: 1,
      );

      final tripItemId = (await packingRepo.watchTripItems(tripId).first).first.tripItem.id;
      await packingRepo.quickTogglePacked(tripItemId); // packed = 1

      // Set to not carried
      await packingRepo.setItemNotCarried(tripItemId);

      final items = await packingRepo.watchTripItems(tripId).first;
      expect(items.first.tripItem.decision, equals('not_carried'));
      expect(items.first.tripItem.packedQuantity, equals(0));
      expect(items.first.tripItem.plannedQuantity, equals(0));
      expect(items.first.status, equals('tidak_dibawa'));
    });

    test('PCK-11: Unfinished essential items warning in summary', () async {
      final obat = await inventoryRepo.createItem(
        name: 'Obat Pribadi & Paspor',
        quantity: 1,
        isImportant: true,
      );
      final obatId = obat.item.id;

      final tripId = await tripsRepo.createTrip(
        name: 'Luar Negeri',
        startDate: '2026-12-20',
        stops: ['Singapura'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: obatId,
        plannedQuantity: 1,
      );

      // Summary before packing essential item
      var summary = await tripsRepo.calculateTripSummary(tripId);
      expect(summary.hasUnfinishedEssential, isTrue);

      // Pack the essential item
      final tripItemId = (await packingRepo.watchTripItems(tripId).first).first.tripItem.id;
      await packingRepo.quickTogglePacked(tripItemId);

      summary = await tripsRepo.calculateTripSummary(tripId);
      expect(summary.hasUnfinishedEssential, isFalse);
    });
  });
}
