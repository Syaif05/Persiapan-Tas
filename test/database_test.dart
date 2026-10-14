import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.inMemory();
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Schema & Seeding Tests', () {
    test('Initial seeding populates default categories and storage locations', () async {
      final categories = await db.select(db.categories).get();
      expect(categories.length, greaterThanOrEqualTo(7));
      expect(categories.any((c) => c.name == 'Elektronik'), isTrue);
      expect(categories.any((c) => c.name == 'Pakaian'), isTrue);
      expect(categories.any((c) => c.name == 'Dokumen'), isTrue);

      final locations = await db.select(db.storageLocations).get();
      expect(locations.length, greaterThanOrEqualTo(2));
      expect(locations.any((l) => l.name == 'Kotak Elektronik'), isTrue);
      expect(locations.any((l) => l.name == 'Lemari Utama'), isTrue);
    });

    test('Foreign key enforcement cascades itemPhotos deletion when item is deleted', () async {
      const itemId = 'test-item-1';
      const assetId = 'test-asset-1';

      // Insert asset
      await db.into(db.assets).insert(
        AssetsCompanion.insert(
          id: assetId,
          relativePath: 'assets/test.jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 1024,
          sha256: 'dummy-sha256',
          originalName: 'test.jpg',
          kind: 'item_photo',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      // Insert item
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: itemId,
          name: 'Kabel Charger',
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );

      // Insert itemPhoto link
      await db.into(db.itemPhotos).insert(
        ItemPhotosCompanion.insert(
          id: 'photo-link-1',
          itemId: itemId,
          assetId: assetId,
          sortOrder: const Value(0),
        ),
      );

      // Verify photo link exists
      var photos = await (db.select(db.itemPhotos)..where((p) => p.itemId.equals(itemId))).get();
      expect(photos.length, 1);

      // Delete item
      await (db.delete(db.items)..where((i) => i.id.equals(itemId))).go();

      // Verify photo link was cascaded and deleted automatically
      photos = await (db.select(db.itemPhotos)..where((p) => p.itemId.equals(itemId))).get();
      expect(photos.isEmpty, isTrue);
    });
  });
}
