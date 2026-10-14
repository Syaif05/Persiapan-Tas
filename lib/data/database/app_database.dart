import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  StorageLocations,
  Categories,
  Assets,
  Items,
  ItemPhotos,
  Trips,
  TripStops,
  TripBags,
  BagCompartments,
  TripItems,
  ItemAllocations,
  ScheduleEvents,
  Tickets,
  TicketAttachments,
  Reminders,
  ReturnCheckpoints,
  ReturnEntries,
  PackingTemplates,
  TemplateItems,
  AppSettings,
  DepartureManifests,
  DepartureManifestItems,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  AppDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaultData();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(tripItems, tripItems.inUseQuantity);
        await m.addColumn(tripItems, tripItems.lastPhysicallyConfirmedAt);
        await m.addColumn(returnEntries, returnEntries.lostQuantity);
      }
      if (from < 3) {
        await m.createTable(bagCompartments);
        await m.createTable(itemAllocations);

        // Migrasi alokasi untuk data legacy yang sudah memiliki packedQuantity > 0 (Section 10.4)
        final existingPacked = await (select(tripItems)..where((ti) => ti.packedQuantity.isBiggerThanValue(0))).get();
        for (final item in existingPacked) {
          final target = item.tripBagId != null ? 'bag' : 'unspecified';
          await into(itemAllocations).insert(
            ItemAllocationsCompanion.insert(
              id: const Uuid().v4(),
              tripItemId: item.id,
              targetType: Value(target),
              tripBagId: Value(item.tripBagId),
              quantity: Value(item.packedQuantity),
              lastConfirmedAt: Value(item.lastPhysicallyConfirmedAt),
            ),
          );
        }
      }
      if (from < 4) {
        await m.addColumn(tripItems, tripItems.departureCheckConfirmedAt);
        await m.createTable(departureManifests);
        await m.createTable(departureManifestItems);
      }
      if (from < 5) {
        await m.addColumn(tripItems, tripItems.isPackedLast);
      }
    },
  );

  Future<void> _seedDefaultData() async {
    const uuid = Uuid();
    final now = DateTime.now().toIso8601String();

    // 1. Seed Default Categories
    final defaultCategories = [
      'Elektronik',
      'Pakaian',
      'Dokumen',
      'Obat & P3K',
      'Alat Mandi',
      'Aksesori',
      'Lainnya',
    ];

    for (var i = 0; i < defaultCategories.length; i++) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: uuid.v4(),
          name: defaultCategories[i],
          sortOrder: Value(i + 1),
        ),
      );
    }

    // 2. Seed Default Storage Location (Kotak Elektronik & Lemari Utama)
    final loc1Id = uuid.v4();
    await into(storageLocations).insert(
      StorageLocationsCompanion.insert(
        id: loc1Id,
        name: 'Kotak Elektronik',
        type: 'box',
        description: const Value('Rak bawah meja kerja'),
        createdAt: now,
        updatedAt: now,
      ),
    );

    await into(storageLocations).insert(
      StorageLocationsCompanion.insert(
        id: uuid.v4(),
        name: 'Lemari Utama',
        type: 'wardrobe',
        description: const Value('Kamar tidur lantai 2'),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bawa.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
