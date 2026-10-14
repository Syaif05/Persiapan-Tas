import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class ItemWithDetails {
  final ItemEntry item;
  final CategoryEntry? category;
  final StorageLocationEntry? location;
  final List<AssetEntry> photos;

  const ItemWithDetails({
    required this.item,
    this.category,
    this.location,
    this.photos = const [],
  });

  String? get primaryPhotoPath => photos.isNotEmpty ? photos.first.relativePath : null;
}

class InventoryRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  InventoryRepository(this._db);

  /// Memeriksa nama serupa untuk peringatan kemungkinan duplikat (INV-09)
  Future<List<ItemEntry>> checkDuplicateName(String name, {String? excludeId}) async {
    final clean = name.trim().toLowerCase();
    if (clean.isEmpty) return [];

    final query = _db.select(_db.items)
      ..where((i) {
        var expr = i.archivedAt.isNull() & i.name.lower().like('%$clean%');
        if (excludeId != null) {
          expr = expr & i.id.isNotValue(excludeId);
        }
        return expr;
      });

    return await query.get();
  }

  /// Menambah barang baru (INV-01, INV-02, INV-05, INV-06)
  Future<ItemWithDetails> createItem({
    required String name,
    required int quantity,
    String unit = 'buah',
    String? categoryId,
    String? storageLocationId,
    String? notes,
    bool isImportant = false,
    List<String> photoAssetIds = const [],
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Nama barang wajib diisi');
    }
    if (quantity < 1) {
      throw ArgumentError('Jumlah barang harus berupa bilangan bulat minimal 1');
    }

    final now = DateTime.now().toIso8601String();
    final itemId = _uuid.v4();

    await _db.transaction(() async {
      await _db.into(_db.items).insert(
            ItemsCompanion.insert(
              id: itemId,
              name: name.trim(),
              quantity: Value(quantity),
              unit: Value(unit.trim().isEmpty ? 'buah' : unit.trim()),
              categoryId: Value(categoryId),
              storageLocationId: Value(storageLocationId),
              notes: Value(notes?.trim()),
              isImportant: Value(isImportant),
              createdAt: now,
              updatedAt: now,
            ),
          );

      // Simpan relasi foto (maksimal 5: 1 utama + hingga 4 tambahan per INV-06)
      final limitedPhotos = photoAssetIds.take(5).toList();
      for (var i = 0; i < limitedPhotos.length; i++) {
        await _db.into(_db.itemPhotos).insert(
              ItemPhotosCompanion.insert(
                id: _uuid.v4(),
                itemId: itemId,
                assetId: limitedPhotos[i],
                sortOrder: Value(i),
              ),
            );
      }
    });

    return (await getItemWithDetailsById(itemId))!;
  }

  /// Mengubah data barang
  Future<void> updateItem({
    required String id,
    required String name,
    required int quantity,
    String unit = 'buah',
    String? categoryId,
    String? storageLocationId,
    String? notes,
    bool isImportant = false,
    List<String>? photoAssetIds,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Nama barang wajib diisi');
    }
    if (quantity < 0) {
      throw ArgumentError('Jumlah barang harus berupa bilangan bulat minimal 0');
    }

    final now = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      await (_db.update(_db.items)..where((i) => i.id.equals(id))).write(
        ItemsCompanion(
          name: Value(name.trim()),
          quantity: Value(quantity),
          unit: Value(unit.trim().isEmpty ? 'buah' : unit.trim()),
          categoryId: Value(categoryId),
          storageLocationId: Value(storageLocationId),
          notes: Value(notes?.trim()),
          isImportant: Value(isImportant),
          updatedAt: Value(now),
        ),
      );

      if (photoAssetIds != null) {
        // Hapus relasi lama
        await (_db.delete(_db.itemPhotos)..where((p) => p.itemId.equals(id))).go();

        // Masukkan relasi baru
        final limitedPhotos = photoAssetIds.take(5).toList();
        for (var i = 0; i < limitedPhotos.length; i++) {
          await _db.into(_db.itemPhotos).insert(
                ItemPhotosCompanion.insert(
                  id: _uuid.v4(),
                  itemId: id,
                  assetId: limitedPhotos[i],
                  sortOrder: Value(i),
                ),
              );
        }
      }
    });
  }

  /// Duplikasi barang untuk varian (INPUT-01)
  /// Menyalin nama, satuan, kategori, lokasi simpan, catatan, dan foto.
  /// Status packing tidak ikut tersalin karena ini membuat master baru.
  Future<ItemWithDetails> duplicateItem({
    required String originalItemId,
    String? newName,
    int? newQuantity,
  }) async {
    final original = await getItemWithDetailsById(originalItemId);
    if (original == null) {
      throw StateError('Barang asli tidak ditemukan');
    }

    final targetName = newName?.trim() ?? '${original.item.name} (Salinan)';
    final targetQuantity = newQuantity ?? original.item.quantity;
    final photoIds = original.photos.map((p) => p.id).toList();

    return createItem(
      name: targetName,
      quantity: targetQuantity > 0 ? targetQuantity : 1,
      unit: original.item.unit,
      categoryId: original.item.categoryId,
      storageLocationId: original.item.storageLocationId,
      notes: original.item.notes,
      isImportant: original.item.isImportant,
      photoAssetIds: photoIds,
    );
  }

  /// Deteksi barang bernama mirip sebagai saran, bukan larangan (INV-09, INPUT-01)
  Future<List<ItemEntry>> findSimilarItems(String name, {String? excludeItemId}) async {
    final cleanName = name.trim().toLowerCase();
    if (cleanName.length < 2) return [];

    final allItems = await (_db.select(_db.items)..where((i) => i.archivedAt.isNull())).get();
    return allItems.where((i) {
      if (excludeItemId != null && i.id == excludeItemId) return false;
      final otherName = i.name.trim().toLowerCase();
      if (otherName == cleanName) return true;
      if (otherName.contains(cleanName) || cleanName.contains(otherName)) return true;
      return false;
    }).toList();
  }

  /// Mengarsipkan barang (INV-08: riwayat perjalanan lama tetap aman)
  Future<void> archiveItem(String id) async {
    final now = DateTime.now().toIso8601String();
    await (_db.update(_db.items)..where((i) => i.id.equals(id))).write(
      ItemsCompanion(
        archivedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Memulihkan barang dari arsip
  Future<void> unarchiveItem(String id) async {
    final now = DateTime.now().toIso8601String();
    await (_db.update(_db.items)..where((i) => i.id.equals(id))).write(
      ItemsCompanion(
        archivedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  /// Menghapus permanen barang hanya jika tidak memiliki referensi ke perjalanan/template (INV-08)
  Future<void> deleteItem(String id) async {
    final tripCount = await (_db.selectOnly(_db.tripItems)
          ..where(_db.tripItems.itemId.equals(id))
          ..addColumns([_db.tripItems.id.count()]))
        .getSingle();
    final count = tripCount.read(_db.tripItems.id.count()) ?? 0;

    if (count > 0) {
      throw StateError(
        'Barang ini sudah pernah digunakan dalam rencana perjalanan dan tidak dapat dihapus permanen. Silakan gunakan fitur Arsipkan agar riwayat perjalanan tidak rusak.',
      );
    }

    await (_db.delete(_db.items)..where((i) => i.id.equals(id))).go();
  }

  /// Mengambil detail barang lengkap dengan kategori, lokasi, dan foto
  Future<ItemWithDetails?> getItemWithDetailsById(String id) async {
    final item = await (_db.select(_db.items)..where((i) => i.id.equals(id))).getSingleOrNull();
    if (item == null) return null;

    CategoryEntry? category;
    if (item.categoryId != null) {
      category = await (_db.select(_db.categories)..where((c) => c.id.equals(item.categoryId!))).getSingleOrNull();
    }

    StorageLocationEntry? location;
    if (item.storageLocationId != null) {
      location = await (_db.select(_db.storageLocations)..where((l) => l.id.equals(item.storageLocationId!))).getSingleOrNull();
    }

    // Ambil foto terurut
    final photoRows = await (_db.select(_db.itemPhotos)
          ..where((p) => p.itemId.equals(id))
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
        .get();

    final photos = <AssetEntry>[];
    for (var pr in photoRows) {
      final asset = await (_db.select(_db.assets)..where((a) => a.id.equals(pr.assetId))).getSingleOrNull();
      if (asset != null) photos.add(asset);
    }

    return ItemWithDetails(
      item: item,
      category: category,
      location: location,
      photos: photos,
    );
  }

  /// Mengambil barang dalam lokasi penyimpanan tertentu (INV-04)
  Future<List<ItemWithDetails>> getItemsByLocationId(String locationId) async {
    final items = await (_db.select(_db.items)
          ..where((i) => i.storageLocationId.equals(locationId) & i.archivedAt.isNull())
          ..orderBy([(i) => OrderingTerm.asc(i.name)]))
        .get();

    final result = <ItemWithDetails>[];
    for (var item in items) {
      final details = await getItemWithDetailsById(item.id);
      if (details != null) result.add(details);
    }
    return result;
  }

  /// Query dan Stream reaktif untuk inventaris dengan fitur pencarian dan filter (INV-01, INV-07)
  Stream<List<ItemWithDetails>> watchItemsWithDetails({
    String? searchQuery,
    String? categoryId,
    String? locationId,
    bool? isImportantOnly,
    bool? zeroStockOnly,
    bool? unassignedLocationOnly,
    bool includeArchived = false,
    bool sortByNameAsc = true,
  }) {
    final query = _db.select(_db.items).join([
      leftOuterJoin(_db.categories, _db.categories.id.equalsExp(_db.items.categoryId)),
      leftOuterJoin(_db.storageLocations, _db.storageLocations.id.equalsExp(_db.items.storageLocationId)),
    ]);

    // Filter arsip
    if (!includeArchived) {
      query.where(_db.items.archivedAt.isNull());
    }

    // Filter kategori
    if (categoryId != null && categoryId.isNotEmpty) {
      query.where(_db.items.categoryId.equals(categoryId));
    }

    // Filter lokasi
    if (locationId != null && locationId.isNotEmpty) {
      query.where(_db.items.storageLocationId.equals(locationId));
    }

    // Filter penting
    if (isImportantOnly == true) {
      query.where(_db.items.isImportant.equals(true));
    }

    // Filter stok nol (INV-01)
    if (zeroStockOnly == true) {
      query.where(_db.items.quantity.equals(0));
    }

    // Filter lokasi belum dicatat (INV-01)
    if (unassignedLocationOnly == true) {
      query.where(_db.items.storageLocationId.isNull());
    }

    // Filter pencarian teks nama, kategori, atau kotak (INV-07)
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final term = '%${searchQuery.trim().toLowerCase()}%';
      query.where(
        _db.items.name.lower().like(term) |
            _db.categories.name.lower().like(term) |
            _db.storageLocations.name.lower().like(term),
      );
    }

    // Sorting
    if (sortByNameAsc) {
      query.orderBy([OrderingTerm.asc(_db.items.name)]);
    } else {
      query.orderBy([OrderingTerm.desc(_db.items.createdAt)]);
    }

    return query.watch().asyncMap((rows) async {
      final list = <ItemWithDetails>[];
      for (var row in rows) {
        final item = row.readTable(_db.items);
        final category = row.readTableOrNull(_db.categories);
        final location = row.readTableOrNull(_db.storageLocations);

        // Ambil foto pertama / utama
        final photoRows = await (_db.select(_db.itemPhotos)
              ..where((p) => p.itemId.equals(item.id))
              ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
            .get();

        final photos = <AssetEntry>[];
        for (var pr in photoRows) {
          final asset = await (_db.select(_db.assets)..where((a) => a.id.equals(pr.assetId))).getSingleOrNull();
          if (asset != null) photos.add(asset);
        }

        list.add(ItemWithDetails(
          item: item,
          category: category,
          location: location,
          photos: photos,
        ));
      }
      return list;
    });
  }
}
