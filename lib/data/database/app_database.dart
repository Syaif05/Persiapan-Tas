import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
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
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
      await _selfHealDatabase();
    },
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaultData();
    },
    onUpgrade: (m, from, to) async {
      await _selfHealDatabase();
    },
  );

  /// Self-healing migration yang aman, idempotent, dan tidak pernah melempar unhandled exception
  Future<void> _selfHealDatabase() async {
    try {
      // 1. Pastikan kolom-kolom penting di trip_items ada
      await _ensureColumn('trip_items', 'in_use_quantity', 'INTEGER NOT NULL DEFAULT 0');
      await _ensureColumn('trip_items', 'last_physically_confirmed_at', 'TEXT');
      await _ensureColumn('trip_items', 'departure_check_confirmed_at', 'TEXT');
      await _ensureColumn('trip_items', 'is_packed_last', 'INTEGER NOT NULL DEFAULT 0');

      // 2. Pastikan kolom di return_entries ada
      await _ensureColumn('return_entries', 'lost_quantity', 'INTEGER NOT NULL DEFAULT 0');

      // 3. Pastikan tabel-tabel sekunder ada (IF NOT EXISTS)
      await customStatement('''
        CREATE TABLE IF NOT EXISTS bag_compartments (
          id TEXT NOT NULL PRIMARY KEY,
          trip_bag_id TEXT NOT NULL REFERENCES trip_bags(id) ON DELETE CASCADE,
          name TEXT NOT NULL,
          sort_order INTEGER NOT NULL DEFAULT 0
        );
      ''');

      await customStatement('''
        CREATE TABLE IF NOT EXISTS item_allocations (
          id TEXT NOT NULL PRIMARY KEY,
          trip_item_id TEXT NOT NULL REFERENCES trip_items(id) ON DELETE CASCADE,
          target_type TEXT NOT NULL DEFAULT 'unspecified',
          trip_bag_id TEXT REFERENCES trip_bags(id) ON DELETE SET NULL,
          compartment_id TEXT REFERENCES bag_compartments(id) ON DELETE SET NULL,
          quantity INTEGER NOT NULL DEFAULT 1,
          notes TEXT,
          last_confirmed_at TEXT
        );
      ''');

      await customStatement('''
        CREATE TABLE IF NOT EXISTS departure_manifests (
          id TEXT NOT NULL PRIMARY KEY,
          trip_id TEXT NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
          departure_notes TEXT,
          is_departed_with_issues INTEGER NOT NULL DEFAULT 0,
          version INTEGER NOT NULL DEFAULT 1,
          source_label TEXT NOT NULL DEFAULT 'departure_check',
          created_at TEXT NOT NULL
        );
      ''');

      await customStatement('''
        CREATE TABLE IF NOT EXISTS departure_manifest_items (
          id TEXT NOT NULL PRIMARY KEY,
          manifest_id TEXT NOT NULL REFERENCES departure_manifests(id) ON DELETE CASCADE,
          trip_item_id TEXT,
          item_id TEXT,
          item_name_snapshot TEXT NOT NULL,
          item_unit_snapshot TEXT NOT NULL DEFAULT 'buah',
          is_important INTEGER NOT NULL DEFAULT 0,
          storage_location_snapshot TEXT,
          planned_quantity INTEGER NOT NULL DEFAULT 1,
          carried_quantity INTEGER NOT NULL DEFAULT 0,
          deficiency_quantity INTEGER NOT NULL DEFAULT 0,
          allocations_snapshot TEXT,
          notes TEXT
        );
      ''');

      // 4. Pastikan default lokasi simpan dan kategori ter-seed jika masih kosong
      await _ensureDefaultSeedIfEmpty();
    } catch (e, stack) {
      debugPrint('Self-healing database warning (non-fatal): $e\n$stack');
    }
  }

  Future<void> _ensureColumn(String tableName, String columnName, String definition) async {
    try {
      final rows = await customSelect("PRAGMA table_info('$tableName');").get();
      final hasColumn = rows.any((r) => r.data['name'] == columnName);
      if (!hasColumn) {
        await customStatement("ALTER TABLE $tableName ADD COLUMN $columnName $definition;");
      }
    } catch (e) {
      debugPrint('Column check $tableName.$columnName: $e');
    }
  }

  Future<void> _ensureDefaultSeedIfEmpty() async {
    try {
      final locRows = await customSelect("SELECT COUNT(*) AS c FROM storage_locations WHERE archived_at IS NULL;").getSingle();
      final locCount = (locRows.data['c'] as num?)?.toInt() ?? 0;
      if (locCount == 0) {
        await _seedDefaultStorageLocations();
      }
    } catch (_) {}

    try {
      final catRows = await customSelect("SELECT COUNT(*) AS c FROM categories;").getSingle();
      final catCount = (catRows.data['c'] as num?)?.toInt() ?? 0;
      if (catCount == 0) {
        await _seedDefaultCategories();
      }
    } catch (_) {}
  }

  Future<void> _seedDefaultCategories() async {
    const uuid = Uuid();
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
  }

  Future<void> _seedDefaultStorageLocations() async {
    const uuid = Uuid();
    final now = DateTime.now().toIso8601String();

    await into(storageLocations).insert(
      StorageLocationsCompanion.insert(
        id: uuid.v4(),
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

  Future<void> _seedDefaultData() async {
    await _seedDefaultCategories();
    await _seedDefaultStorageLocations();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bawa.sqlite'));
    return NativeDatabase(file);
  });
}
