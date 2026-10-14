import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/templates_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/services/asset_storage_service.dart';

void main() {
  late AppDatabase db;
  late InventoryRepository inventoryRepo;
  late TripsRepository tripsRepo;
  late TemplatesRepository templatesRepo;
  late TripPackingRepository tripPackingRepo;
  late AssetStorageService assetService;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase.inMemory();
    inventoryRepo = InventoryRepository(db);
    tripsRepo = TripsRepository(db);
    templatesRepo = TemplatesRepository(db);
    tripPackingRepo = TripPackingRepository(db);
    tempDir = await Directory.systemTemp.createTemp('bawa_input_tpl_test_');
    assetService = AssetStorageService(db, baseDirOverride: tempDir);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Tahap 9: INPUT-01, TPL-01..TPL-03, FILE-01 Tests', () {
    test('INPUT-01 & INV-09: duplicateItem creates an independent copy for variants without copying trip status', () async {
      // 1. Create original item
      final original = await inventoryRepo.createItem(
        name: 'Kaus Hitam Polos',
        quantity: 5,
        unit: 'helai',
        notes: 'Bahan katun combed 30s',
        isImportant: false,
      );

      // 2. Duplicate item for a variant (e.g. Putih)
      final duplicate = await inventoryRepo.duplicateItem(
        originalItemId: original.item.id,
        newName: 'Kaus Putih Polos',
      );

      expect(duplicate.item.id, isNot(equals(original.item.id)));
      expect(duplicate.item.name, equals('Kaus Putih Polos'));
      expect(duplicate.item.quantity, equals(5));
      expect(duplicate.item.unit, equals('helai'));
      expect(duplicate.item.notes, equals('Bahan katun combed 30s'));

      // Check duplicate name detection / similar items (INV-09, INPUT-01)
      final similar = await inventoryRepo.findSimilarItems('Kaus');
      expect(similar.length, equals(2));
      expect(similar.map((i) => i.name), containsAll(['Kaus Hitam Polos', 'Kaus Putih Polos']));
    });

    test('TPL-01 & QA-51: applyTemplateToTrip idempotency (reapplying does not duplicate rows or stock)', () async {
      final now = DateTime.now().toIso8601String();
      const tripId = 'trip-test-tpl-1';
      const itemId = 'item-shampoo-1';

      // 1. Create master item
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: itemId,
          name: 'Shampoo Travel',
          quantity: const Value(3),
          unit: const Value('botol'),
          createdAt: now,
          updatedAt: now,
        ),
      );

      // 2. Create destination trip
      await db.into(db.trips).insert(
        TripsCompanion.insert(
          id: tripId,
          name: 'Perjalanan Bisnis',
          startDate: '2026-11-10',
          dateZoneId: 'Asia/Jakarta',
          createdAt: now,
          updatedAt: now,
        ),
      );

      // 3. Create a template
      final templateId = await templatesRepo.createTemplate(
        name: 'Perlengkapan Mandi',
        items: [
          (itemId: itemId, plannedQuantity: 1, notes: 'Kemasan 50ml'),
        ],
      );

      // 4. Apply template first time
      final result1 = await templatesRepo.applyTemplateToTrip(
        templateId: templateId,
        tripId: tripId,
      );
      expect(result1.appliedCount, equals(1));

      var tripItems = await (db.select(db.tripItems)..where((t) => t.tripId.equals(tripId))).get();
      expect(tripItems.length, equals(1));
      expect(tripItems.first.plannedQuantity, equals(1));
      expect(tripItems.first.packedQuantity, equals(0));

      // Pack 1 item
      await tripPackingRepo.packUnit(tripItems.first.id, delta: 1);
      final packedBefore = (await (db.select(db.tripItems)..where((t) => t.tripId.equals(tripId))).get()).first.packedQuantity;
      expect(packedBefore, equals(1));

      // 5. Apply template second time (idempotency check)
      final result2 = await templatesRepo.applyTemplateToTrip(
        templateId: templateId,
        tripId: tripId,
      );
      expect(result2.appliedCount, equals(1)); // 1 item reapplied

      // Ensure no duplicate rows were added (strict idempotency)
      tripItems = await (db.select(db.tripItems)..where((t) => t.tripId.equals(tripId))).get();
      expect(tripItems.length, equals(1));
      expect(tripItems.first.packedQuantity, equals(0), reason: 'Reapplying template resets packed_quantity to 0 (TPL-02)');
    });

    test('QA-51 & TRP-07: duplicateTrip resets packed quantity, status, and allocations', () async {
      // 1. Create source trip with items and allocations
      final sourceTripId = await tripsRepo.createTrip(
        name: 'Perjalanan Sumber',
        startDate: '2026-10-20',
        stops: ['Yogyakarta'],
      );

      final item = await inventoryRepo.createItem(
        name: 'Topi Fedora',
        quantity: 2,
      );

      // Add to trip
      await tripPackingRepo.setItemCarried(
        tripId: sourceTripId,
        itemId: item.item.id,
        plannedQuantity: 2,
      );

      final sourceTripItems = await (db.select(db.tripItems)..where((t) => t.tripId.equals(sourceTripId))).get();
      final sourceTripItemId = sourceTripItems.first.id;

      // Pack and allocate
      final bagId = await tripPackingRepo.createTripBag(sourceTripId, 'Koper Utama');
      await tripPackingRepo.packUnit(
        sourceTripItemId,
        delta: 2,
        targetType: 'bag',
        tripBagId: bagId,
      );
      await tripPackingRepo.togglePackedLast(sourceTripItemId, true);

      // Verify packed
      final packedSource = await (db.select(db.tripItems)..where((t) => t.id.equals(sourceTripItemId))).getSingle();
      expect(packedSource.packedQuantity, equals(2));
      expect(packedSource.isPackedLast, isTrue);

      // 2. Duplicate trip
      final duplicatedTripId = await tripsRepo.duplicateTrip(
        originalTripId: sourceTripId,
        newName: 'Perjalanan Duplikat',
        newStartDate: '2026-11-20',
      );

      final duplicatedTrip = await tripsRepo.getTripById(duplicatedTripId);
      expect(duplicatedTrip, isNotNull);
      expect(duplicatedTrip!.name, equals('Perjalanan Duplikat'));
      expect(duplicatedTrip.status, equals('planning')); // Status reset to planning

      // Stops are carried over
      final stops = await (db.select(db.tripStops)..where((s) => s.tripId.equals(duplicatedTripId))).get();
      expect(stops.length, equals(1));
      expect(stops.first.label, equals('Yogyakarta'));

      // Check items in duplicated trip:
      final duplicatedTripItems = await (db.select(db.tripItems)..where((t) => t.tripId.equals(duplicatedTripId))).get();
      expect(duplicatedTripItems.length, equals(1));
      final dupItem = duplicatedTripItems.first;
      expect(dupItem.plannedQuantity, equals(2));
      expect(dupItem.packedQuantity, equals(0), reason: 'packed_quantity must be reset to 0 in duplicated trips');
      expect(dupItem.isPackedLast, isTrue, reason: 'isPackedLast preference is preserved');

      // Check that allocations are reset (no allocations created for the new trip item)
      final duplicatedAllocations = await (db.select(db.itemAllocations)..where((a) => a.tripItemId.equals(dupItem.id))).get();
      expect(duplicatedAllocations, isEmpty, reason: 'Allocations must be clean for a newly duplicated trip');
    });

    test('FILE-01: AssetStorageService enforces 20MB limit and protects referenced assets from deletion', () async {
      // 1. Test 20MB limit rejection
      final oversizedBytes = List<int>.filled(21 * 1024 * 1024, 65); // 21 MB
      final oversizedFile = File('${tempDir.path}/huge_video.mp4');
      await oversizedFile.writeAsBytes(oversizedBytes);

      expect(
        () async => await assetService.saveFile(oversizedFile, kind: 'ticket_attachment'),
        throwsA(predicate((e) => e is Exception && e.toString().contains('21.0 MB') && e.toString().contains('20 MB'))),
      );

      // 2. Test saving a normal file
      final normalFile = File('${tempDir.path}/valid_doc.pdf');
      await normalFile.writeAsBytes([1, 2, 3, 4, 5]);

      final asset = await assetService.saveFile(
        normalFile,
        kind: 'item_photo',
        originalName: 'valid_doc.pdf',
      );

      expect(asset.id, isNotEmpty);
      expect(asset.mimeType, equals('application/pdf'));

      // 3. Link asset to an item photo
      final now = DateTime.now().toIso8601String();
      await db.into(db.items).insert(
        ItemsCompanion.insert(
          id: 'item-ref-test',
          name: 'Item Referencing Asset',
          quantity: const Value(1),
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.into(db.itemPhotos).insert(
        ItemPhotosCompanion.insert(
          id: 'photo-ref-1',
          itemId: 'item-ref-test',
          assetId: asset.id,
        ),
      );

      // 4. Try deleting the asset while referenced
      await assetService.deleteAsset(asset.id);

      // Verify asset still exists because it is actively referenced (orphan protection)
      final resolved = await assetService.resolveRelativeFile(asset.relativePath);
      expect(await resolved.exists(), isTrue);

      final assetInDb = await (db.select(db.assets)..where((a) => a.id.equals(asset.id))).getSingleOrNull();
      expect(assetInDb, isNotNull);

      // 5. Remove reference and then delete
      await (db.delete(db.itemPhotos)..where((p) => p.id.equals('photo-ref-1'))).go();
      await assetService.deleteAsset(asset.id);

      // Now it should be cleanly deleted
      expect(await resolved.exists(), isFalse);
      final assetInDbAfter = await (db.select(db.assets)..where((a) => a.id.equals(asset.id))).getSingleOrNull();
      expect(assetInDbAfter, isNull);
    });
  });
}
