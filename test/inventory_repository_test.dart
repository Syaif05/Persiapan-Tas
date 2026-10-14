import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/categories_repository.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/locations_repository.dart';

void main() {
  late AppDatabase db;
  late InventoryRepository inventoryRepo;
  late LocationsRepository locationsRepo;
  late CategoriesRepository categoriesRepo;

  setUp(() {
    db = AppDatabase.inMemory();
    inventoryRepo = InventoryRepository(db);
    locationsRepo = LocationsRepository(db);
    categoriesRepo = CategoriesRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Fase 2: Inventory & Locations Functional Tests (INV-01 .. INV-09)', () {
    test('INV-01 & INV-02: Create, read, update, and archive item with validation', () async {
      // Rejects empty name
      expect(
        () => inventoryRepo.createItem(name: '  ', quantity: 1),
        throwsA(isA<ArgumentError>()),
      );

      // Rejects quantity < 1
      expect(
        () => inventoryRepo.createItem(name: 'Obat Pusing', quantity: 0),
        throwsA(isA<ArgumentError>()),
      );

      // Create item successfully
      final created = await inventoryRepo.createItem(
        name: 'Charger USB-C 65W',
        quantity: 2,
        unit: 'buah',
        notes: 'Warna putih',
        isImportant: true,
      );

      expect(created.item.name, 'Charger USB-C 65W');
      expect(created.item.quantity, 2);
      expect(created.item.unit, 'buah');
      expect(created.item.isImportant, isTrue);
      expect(created.item.notes, 'Warna putih');

      // Update item
      await inventoryRepo.updateItem(
        id: created.item.id,
        name: 'Charger USB-C 65W Fast Charge',
        quantity: 3,
        unit: 'buah',
        isImportant: true,
      );

      final updated = await inventoryRepo.getItemWithDetailsById(created.item.id);
      expect(updated?.item.name, 'Charger USB-C 65W Fast Charge');
      expect(updated?.item.quantity, 3);

      // Archive item (INV-08)
      await inventoryRepo.archiveItem(created.item.id);
      final archived = await inventoryRepo.getItemWithDetailsById(created.item.id);
      expect(archived?.item.archivedAt, isNotNull);

      // Active items query excludes archived item
      final activeItems = await inventoryRepo.watchItemsWithDetails().first;
      expect(activeItems.any((i) => i.item.id == created.item.id), isFalse);

      // Include archived query shows archived item
      final allItems = await inventoryRepo.watchItemsWithDetails(includeArchived: true).first;
      expect(allItems.any((i) => i.item.id == created.item.id), isTrue);

      // Unarchive
      await inventoryRepo.unarchiveItem(created.item.id);
      final unarchived = await inventoryRepo.getItemWithDetailsById(created.item.id);
      expect(unarchived?.item.archivedAt, isNull);
    });

    test('INV-03 & INV-04: Storage locations CRUD and list contents without unpacking', () async {
      // Create new storage location
      final location = await locationsRepo.createLocation(
        name: 'Kotak Kabel & Audio',
        type: 'box',
        description: 'Lemari ruang tengah rak 2',
      );

      expect(location.name, 'Kotak Kabel & Audio');
      expect(location.type, 'box');

      // Put items into this location
      await inventoryRepo.createItem(
        name: 'Headphone Bluetooth',
        quantity: 1,
        storageLocationId: location.id,
      );
      await inventoryRepo.createItem(
        name: 'Kabel Aux 3.5mm',
        quantity: 2,
        storageLocationId: location.id,
      );

      // Verify seeing items inside location (INV-04)
      final itemsInLoc = await inventoryRepo.getItemsByLocationId(location.id);
      expect(itemsInLoc.length, 2);
      expect(itemsInLoc.map((i) => i.item.name), containsAll(['Headphone Bluetooth', 'Kabel Aux 3.5mm']));

      final count = await locationsRepo.getItemCountInLocation(location.id);
      expect(count, 2);
    });

    test('INV-05: Item without storage location is fully supported', () async {
      final item = await inventoryRepo.createItem(
        name: 'Kartu E-Money',
        quantity: 1,
        storageLocationId: null, // Tanpa lokasi
      );

      final details = await inventoryRepo.getItemWithDetailsById(item.item.id);
      expect(details?.location, isNull);
      expect(details?.item.storageLocationId, isNull);
    });

    test('INV-06: Item can hold up to 5 photos', () async {
      // Create 5 assets
      final assetIds = <String>[];
      for (var i = 0; i < 6; i++) {
        final id = 'asset-$i';
        assetIds.add(id);
        await db.into(db.assets).insert(
          AssetsCompanion.insert(
            id: id,
            relativePath: 'assets/$id.jpg',
            mimeType: 'image/jpeg',
            sizeBytes: 1000,
            sha256: 'sha-$i',
            originalName: 'photo-$i.jpg',
            kind: 'item_photo',
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      }

      // Create item with 6 assets, should clamp to max 5 per INV-06
      final item = await inventoryRepo.createItem(
        name: 'Kamera DSLR',
        quantity: 1,
        photoAssetIds: assetIds,
      );

      expect(item.photos.length, 5);
      expect(item.primaryPhotoPath, 'assets/asset-0.jpg');
    });

    test('INV-07: Search by name, category, or location', () async {
      final loc = await locationsRepo.createLocation(
        name: 'Kotak Darurat',
        type: 'box',
      );
      final cat = await categoriesRepo.getOrCreateCategory('Peralatan');

      await inventoryRepo.createItem(
        name: 'Senter LED Tahan Air',
        quantity: 1,
        categoryId: cat.id,
        storageLocationId: loc.id,
      );

      // Search by item name
      var result = await inventoryRepo.watchItemsWithDetails(searchQuery: 'senter').first;
      expect(result.length, 1);

      // Search by location name
      result = await inventoryRepo.watchItemsWithDetails(searchQuery: 'darurat').first;
      expect(result.length, 1);

      // Search by category name
      result = await inventoryRepo.watchItemsWithDetails(searchQuery: 'peralatan').first;
      expect(result.length, 1);

      // Search unmatched query
      result = await inventoryRepo.watchItemsWithDetails(searchQuery: 'kacamata').first;
      expect(result.isEmpty, isTrue);
    });

    test('INV-08: Deleting item referenced in trip items is rejected', () async {
      final item = await inventoryRepo.createItem(name: 'Kaus Kaki', quantity: 3);

      // Simulate trip item referencing this item
      await db.into(db.trips).insert(
        TripsCompanion.insert(
          id: 'trip-test',
          name: 'Perjalanan Uji',
          startDate: '2026-11-01',
          dateZoneId: 'Asia/Jakarta',
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );

      await db.into(db.tripItems).insert(
        TripItemsCompanion.insert(
          id: 'ti-1',
          tripId: 'trip-test',
          itemId: item.item.id,
          nameSnapshot: 'Kaus Kaki',
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );

      // Attempt permanent deletion should throw StateError
      expect(
        () => inventoryRepo.deleteItem(item.item.id),
        throwsA(isA<StateError>()),
      );

      // Item still exists
      final stillExists = await inventoryRepo.getItemWithDetailsById(item.item.id);
      expect(stillExists, isNotNull);
    });

    test('INV-09: Duplicate name detection warns but allows saving', () async {
      await inventoryRepo.createItem(name: 'Charger USB-C 65W', quantity: 1);

      // Exact or partial case-insensitive check
      final duplicates = await inventoryRepo.checkDuplicateName('charger usb-c');
      expect(duplicates.length, 1);
      expect(duplicates.first.name, 'Charger USB-C 65W');

      // Unrelated name check
      final noDuplicates = await inventoryRepo.checkDuplicateName('Jaket Gunung');
      expect(noDuplicates.isEmpty, isTrue);
    });

    test('Storage location deletion safely reassigns or detaches items (items not deleted)', () async {
      final loc1 = await locationsRepo.createLocation(name: 'Kotak A', type: 'box');
      final loc2 = await locationsRepo.createLocation(name: 'Kotak B', type: 'box');

      final item1 = await inventoryRepo.createItem(
        name: 'Gunting Kuku',
        quantity: 1,
        storageLocationId: loc1.id,
      );

      // Delete loc1 with target transfer to loc2
      await locationsRepo.deleteLocation(loc1.id, targetLocationId: loc2.id);

      var updatedItem = await inventoryRepo.getItemWithDetailsById(item1.item.id);
      expect(updatedItem?.item.storageLocationId, loc2.id);

      // Delete loc2 with detach (targetLocationId: null)
      await locationsRepo.deleteLocation(loc2.id, targetLocationId: null);

      updatedItem = await inventoryRepo.getItemWithDetailsById(item1.item.id);
      expect(updatedItem?.item.storageLocationId, isNull);
      expect(updatedItem?.item.name, 'Gunting Kuku'); // Item is safe!
    });
  });
}
