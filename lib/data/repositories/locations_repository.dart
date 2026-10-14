import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class LocationsRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  LocationsRepository(this._db);

  Stream<List<StorageLocationEntry>> watchActiveLocations() {
    return (_db.select(_db.storageLocations)
          ..where((l) => l.archivedAt.isNull())
          ..orderBy([(l) => OrderingTerm.asc(l.name)]))
        .watch();
  }

  Future<List<StorageLocationEntry>> getActiveLocations() {
    return (_db.select(_db.storageLocations)
          ..where((l) => l.archivedAt.isNull())
          ..orderBy([(l) => OrderingTerm.asc(l.name)]))
        .get();
  }

  Future<StorageLocationEntry?> getLocationById(String id) {
    return (_db.select(_db.storageLocations)..where((l) => l.id.equals(id)))
        .getSingleOrNull();
  }

  Future<StorageLocationEntry> createLocation({
    required String name,
    required String type, // 'box' | 'wardrobe' | 'drawer' | 'other'
    String? description,
    String? photoAssetId,
  }) async {
    final now = DateTime.now().toIso8601String();
    final newId = _uuid.v4();

    final entry = StorageLocationsCompanion.insert(
      id: newId,
      name: name.trim(),
      type: type,
      description: Value(description?.trim()),
      photoAssetId: Value(photoAssetId),
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.storageLocations).insert(entry);
    return (await getLocationById(newId))!;
  }

  Future<void> updateLocation({
    required String id,
    required String name,
    required String type,
    String? description,
    String? photoAssetId,
  }) async {
    final now = DateTime.now().toIso8601String();
    await (_db.update(_db.storageLocations)..where((l) => l.id.equals(id))).write(
      StorageLocationsCompanion(
        name: Value(name.trim()),
        type: Value(type),
        description: Value(description?.trim()),
        photoAssetId: Value(photoAssetId),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> archiveLocation(String id) async {
    final now = DateTime.now().toIso8601String();
    await (_db.update(_db.storageLocations)..where((l) => l.id.equals(id))).write(
      StorageLocationsCompanion(
        archivedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<int> getItemCountInLocation(String locationId) async {
    final countExp = _db.items.id.count();
    final query = _db.selectOnly(_db.items)
      ..where(_db.items.storageLocationId.equals(locationId) & _db.items.archivedAt.isNull())
      ..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// Menghapus lokasi sesuai PRD:
  /// Jika ada barang terkait, pindahkan ke targetLocationId atau lepaskan lokasi (set null).
  /// Barang TIDAK IKUT TERHAPUS.
  Future<void> deleteLocation(String id, {String? targetLocationId}) async {
    final now = DateTime.now().toIso8601String();
    await _db.transaction(() async {
      // Reassign or detach items
      await (_db.update(_db.items)..where((i) => i.storageLocationId.equals(id))).write(
        ItemsCompanion(
          storageLocationId: Value(targetLocationId),
          updatedAt: Value(now),
        ),
      );

      // Hapus lokasi
      await (_db.delete(_db.storageLocations)..where((l) => l.id.equals(id))).go();
    });
  }
}
