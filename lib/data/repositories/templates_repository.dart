import 'dart:math';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

/// Model pembantu untuk satu barang di dalam template packing
class TemplateItemWithDetails {
  final TemplateItemEntry templateItem;
  final ItemEntry item;
  final StorageLocationEntry? location;
  final CategoryEntry? category;

  const TemplateItemWithDetails({
    required this.templateItem,
    required this.item,
    this.location,
    this.category,
  });

  String get id => templateItem.id;
  String get templateId => templateItem.templateId;
  String get itemId => templateItem.itemId;
  int get plannedQuantity => templateItem.plannedQuantity;
  String? get notes => templateItem.notes;

  String get itemName => item.name;
  int get availableQuantity => item.quantity;
  String get unit => item.unit;
  bool get isArchived => item.archivedAt != null;
  String? get locationName => location?.name;
}

/// Model pembantu template packing lengkap dengan daftar barangnya
class TemplateWithDetails {
  final PackingTemplateEntry template;
  final List<TemplateItemWithDetails> items;

  const TemplateWithDetails({
    required this.template,
    required this.items,
  });

  String get id => template.id;
  String get name => template.name;
  String? get notes => template.notes;
  String get createdAt => template.createdAt;
  String get updatedAt => template.updatedAt;

  int get totalItemTypes => items.length;
  int get totalUnits => items.fold(0, (sum, i) => sum + i.plannedQuantity);
}

/// Hasil dari penerapan template ke perjalanan (TPL-03)
class TemplateApplyResult {
  final int appliedCount;
  final List<String> warnings;

  const TemplateApplyResult({
    required this.appliedCount,
    required this.warnings,
  });
}

class TemplatesRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  TemplatesRepository(this._db);

  /// Membuat template packing baru (TPL-01)
  Future<String> createTemplate({
    required String name,
    String? notes,
    required List<({String itemId, int plannedQuantity, String? notes})> items,
  }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw ArgumentError('Nama template tidak boleh kosong');
    }

    final templateId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      await _db.into(_db.packingTemplates).insert(
            PackingTemplatesCompanion.insert(
              id: templateId,
              name: cleanName,
              notes: Value(notes?.trim()),
              createdAt: nowIso,
              updatedAt: nowIso,
            ),
          );

      for (final item in items) {
        if (item.plannedQuantity <= 0) continue;
        final templateItemId = _uuid.v4();
        await _db.into(_db.templateItems).insert(
              TemplateItemsCompanion.insert(
                id: templateItemId,
                templateId: templateId,
                itemId: item.itemId,
                plannedQuantity: Value(item.plannedQuantity),
                notes: Value(item.notes?.trim()),
              ),
            );
      }
    });

    return templateId;
  }

  /// Membuat template dari daftar barang perjalanan aktif (TPL-01, AT-18)
  Future<String> createTemplateFromTrip({
    required String name,
    required String tripId,
    String? notes,
  }) async {
    // Ambil semua barang yang dibawa pada perjalanan tersebut
    final tripItems = await (_db.select(_db.tripItems)
          ..where((t) => t.tripId.equals(tripId) & t.decision.equals('carried')))
        .get();

    final items = tripItems.map((ti) {
      return (
        itemId: ti.itemId,
        plannedQuantity: ti.plannedQuantity,
        notes: ti.notes,
      );
    }).toList();

    return createTemplate(
      name: name,
      notes: notes,
      items: items,
    );
  }

  /// Mengamati daftar semua template packing
  Stream<List<TemplateWithDetails>> watchTemplates() {
    return (_db.select(_db.packingTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch()
        .asyncMap((templates) async {
      final results = <TemplateWithDetails>[];
      for (final t in templates) {
        final details = await getTemplateWithDetails(t.id);
        if (details != null) {
          results.add(details);
        }
      }
      return results;
    });
  }

  /// Mengambil rincian template tunggal beserta item-itemnya
  Future<TemplateWithDetails?> getTemplateWithDetails(String templateId) async {
    final template = await (_db.select(_db.packingTemplates)
          ..where((t) => t.id.equals(templateId)))
        .getSingleOrNull();

    if (template == null) return null;

    final query = _db.select(_db.templateItems).join([
      innerJoin(_db.items, _db.items.id.equalsExp(_db.templateItems.itemId)),
      leftOuterJoin(_db.storageLocations,
          _db.storageLocations.id.equalsExp(_db.items.storageLocationId)),
      leftOuterJoin(_db.categories,
          _db.categories.id.equalsExp(_db.items.categoryId)),
    ])..where(_db.templateItems.templateId.equals(templateId));

    final rows = await query.get();
    final items = <TemplateItemWithDetails>[];

    for (final row in rows) {
      final ti = row.readTable(_db.templateItems);
      final item = row.readTable(_db.items);
      final loc = row.readTableOrNull(_db.storageLocations);
      final cat = row.readTableOrNull(_db.categories);

      items.add(TemplateItemWithDetails(
        templateItem: ti,
        item: item,
        location: loc,
        category: cat,
      ));
    }

    return TemplateWithDetails(
      template: template,
      items: items,
    );
  }

  /// Menerapkan template ke suatu perjalanan (TPL-02, TPL-03, AT-18)
  /// Aturan PRD:
  /// 1. packed_quantity SELALU direset ke 0.
  /// 2. TIDAK menggandakan stok master di tabel Items.
  /// 3. Menghasilkan peringatan jika barang diarsipkan atau stok master kurang.
  Future<TemplateApplyResult> applyTemplateToTrip({
    required String templateId,
    required String tripId,
  }) async {
    final details = await getTemplateWithDetails(templateId);
    if (details == null) {
      throw ArgumentError('Template tidak ditemukan');
    }

    int applied = 0;
    final warnings = <String>[];
    final nowIso = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      for (final tItem in details.items) {
        final master = tItem.item;

        // TPL-03: Peringatan jika barang diarsipkan
        if (master.archivedAt != null) {
          warnings.add('"${master.name}" sedang diarsipkan di inventaris.');
        }

        // TPL-03: Peringatan jika stok master kurang dari kebutuhan rencana
        if (master.quantity < tItem.plannedQuantity) {
          warnings.add(
            '"${master.name}": kebutuhan template ${tItem.plannedQuantity} ${master.unit}, tetapi inventaris hanya memiliki ${master.quantity} ${master.unit}.',
          );
        }

        // Batasi kuantitas rencana maksimal sebanyak kuantitas inventaris yang tersedia
        final effectivePlanned = max(1, min(tItem.plannedQuantity, master.quantity));

        // Cek apakah item sudah ada di TripItem untuk perjalanan ini
        final existingTripItem = await (_db.select(_db.tripItems)
              ..where((ti) => ti.tripId.equals(tripId) & ti.itemId.equals(master.id)))
            .getSingleOrNull();

        if (existingTripItem == null) {
          // Buat entri baru
          final newTripItemId = _uuid.v4();
          await _db.into(_db.tripItems).insert(
                TripItemsCompanion.insert(
                  id: newTripItemId,
                  tripId: tripId,
                  itemId: master.id,
                  decision: const Value('carried'),
                  plannedQuantity: Value(effectivePlanned),
                  packedQuantity: const Value(0), // SELALU 0 (TPL-02)
                  nameSnapshot: master.name,
                  sourceLabelSnapshot: Value(tItem.locationName),
                  updatedAt: nowIso,
                ),
              );
          applied++;
        } else {
          // Perbarui entri yang sudah ada (reset packed_quantity ke 0 sesuai template baru)
          await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(existingTripItem.id))).write(
            TripItemsCompanion(
              decision: const Value('carried'),
              plannedQuantity: Value(effectivePlanned),
              packedQuantity: const Value(0), // SELALU RESET (TPL-02)
              nameSnapshot: Value(master.name),
              sourceLabelSnapshot: Value(tItem.locationName),
              updatedAt: Value(nowIso),
            ),
          );
          applied++;
        }
      }
    });

    return TemplateApplyResult(
      appliedCount: applied,
      warnings: warnings,
    );
  }

  /// Menghapus template packing
  Future<void> deleteTemplate(String templateId) async {
    await (_db.delete(_db.packingTemplates)
          ..where((t) => t.id.equals(templateId)))
        .go();
  }
}
