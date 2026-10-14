import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import 'trip_packing_repository.dart';

class DepartureIssue {
  final String tripItemId;
  final String itemName;
  final String issueType; // 'unpacked' | 'in_use' | 'important_unconfirmed' | 'conflict'
  final String description;
  final bool isImportant;
  final int missingQuantity;
  final int inUseQuantity;
  final String? location;

  const DepartureIssue({
    required this.tripItemId,
    required this.itemName,
    required this.issueType,
    required this.description,
    this.isImportant = false,
    this.missingQuantity = 0,
    this.inUseQuantity = 0,
    this.location,
  });
}

class TripReadinessReport {
  final String tripId;
  final String tripName;
  final int totalCarriedItems;
  final int fullyPackedItems;
  final List<TripItemWithDetails> unpackedItems;
  final List<TripItemWithDetails> inUseItems;
  final List<TripItemWithDetails> unconfirmedImportantItems;
  final List<TripItemWithDetails> conflictItems;
  final List<DepartureIssue> allIssues;

  const TripReadinessReport({
    required this.tripId,
    required this.tripName,
    required this.totalCarriedItems,
    required this.fullyPackedItems,
    required this.unpackedItems,
    required this.inUseItems,
    required this.unconfirmedImportantItems,
    required this.conflictItems,
    required this.allIssues,
  });

  bool get isReadyForDeparture => allIssues.isEmpty && totalCarriedItems > 0;
  bool get hasNoCarriedItems => totalCarriedItems == 0;
  int get totalIssuesCount => allIssues.length;
}

class DepartureManifestWithDetails {
  final DepartureManifestEntry manifest;
  final List<DepartureManifestItemEntry> items;

  const DepartureManifestWithDetails({
    required this.manifest,
    required this.items,
  });

  int get totalCarriedQuantity => items.fold(0, (sum, i) => sum + i.carriedQuantity);
  int get totalDeficiencyQuantity => items.fold(0, (sum, i) => sum + i.deficiencyQuantity);
  bool get hasDeficiencies => items.any((i) => i.deficiencyQuantity > 0);
  int get itemCount => items.length;
}

class TripDepartureRepository {
  final AppDatabase _db;
  final TripPackingRepository _packingRepo;
  final _uuid = const Uuid();

  TripDepartureRepository(this._db, this._packingRepo);

  /// Evaluasi kesiapan keberangkatan berdasarkan aturan CORE-02 (QA-14, QA-15)
  Future<TripReadinessReport> evaluateReadiness(String tripId) async {
    final trip = await (_db.select(_db.trips)..where((t) => t.id.equals(tripId))).getSingleOrNull();
    if (trip == null) {
      throw StateError('Perjalanan tidak ditemukan');
    }

    // Ambil semua item bawaan untuk trip ini
    final allTripItems = await _packingRepo.watchTripItems(tripId).first;
    final carriedItems = allTripItems.where((i) => i.tripItem.decision == 'carried').toList();

    final List<TripItemWithDetails> unpacked = [];
    final List<TripItemWithDetails> inUse = [];
    final List<TripItemWithDetails> unconfirmedImportant = [];
    final List<TripItemWithDetails> withConflict = [];
    final List<DepartureIssue> issues = [];

    int fullyPackedCount = 0;

    for (final item in carriedItems) {
      final isPacked = item.tripItem.packedQuantity >= item.tripItem.plannedQuantity;
      final isInUse = item.tripItem.inUseQuantity > 0;

      if (isPacked && !isInUse) {
        fullyPackedCount++;
      }

      // 1. Belum siap dikemas (packed < planned)
      if (item.tripItem.packedQuantity < item.tripItem.plannedQuantity && !isInUse) {
        unpacked.add(item);
        final missing = item.tripItem.plannedQuantity - item.tripItem.packedQuantity;
        issues.add(
          DepartureIssue(
            tripItemId: item.tripItem.id,
            itemName: item.displayName,
            issueType: 'unpacked',
            description: 'Kurang $missing unit dari rencana ${item.tripItem.plannedQuantity}',
            isImportant: item.isImportant,
            missingQuantity: missing,
            location: item.displayLocation,
          ),
        );
      }

      // 2. Sedang dipakai (inUse > 0)
      if (isInUse) {
        inUse.add(item);
        issues.add(
          DepartureIssue(
            tripItemId: item.tripItem.id,
            itemName: item.displayName,
            issueType: 'in_use',
            description: '${item.tripItem.inUseQuantity} unit masih dipakai dan belum dimasukkan kembali',
            isImportant: item.isImportant,
            inUseQuantity: item.tripItem.inUseQuantity,
            location: item.displayLocation,
          ),
        );
      }

      // 3. Barang penting belum dikonfirmasi (CORE-02, QA-15)
      // Invalidasi terjadi jika departureCheckConfirmedAt null atau lebih lama dari updatedAt (QA-14)
      if (item.isImportant) {
        final confirmedAt = item.tripItem.departureCheckConfirmedAt;
        final updatedAt = item.tripItem.updatedAt;
        final isCheckCurrent = confirmedAt != null && confirmedAt.compareTo(updatedAt) >= 0;

        if (!isCheckCurrent) {
          unconfirmedImportant.add(item);
          issues.add(
            DepartureIssue(
              tripItemId: item.tripItem.id,
              itemName: item.displayName,
              issueType: 'important_unconfirmed',
              description: 'Barang penting belum diverifikasi untuk keberangkatan ini',
              isImportant: true,
              location: item.displayLocation,
            ),
          );
        }
      }

      // 4. Konflik jadwal / stok
      if (item.hasConflict) {
        withConflict.add(item);
        issues.add(
          DepartureIssue(
            tripItemId: item.tripItem.id,
            itemName: item.displayName,
            issueType: 'conflict',
            description: item.conflictMessage ?? 'Potensi bentrok jadwal dengan perjalanan lain',
            isImportant: item.isImportant,
            location: item.displayLocation,
          ),
        );
      }
    }

    return TripReadinessReport(
      tripId: tripId,
      tripName: trip.name,
      totalCarriedItems: carriedItems.length,
      fullyPackedItems: fullyPackedCount,
      unpackedItems: unpacked,
      inUseItems: inUse,
      unconfirmedImportantItems: unconfirmedImportant,
      conflictItems: withConflict,
      allIssues: issues,
    );
  }

  /// Konfirmasi satu barang dalam pemeriksaan keberangkatan (CORE-02, QA-14)
  Future<void> confirmItemDepartureCheck(String tripItemId) async {
    final nowIso = DateTime.now().toIso8601String();
    await (_db.update(_db.tripItems)..where((t) => t.id.equals(tripItemId))).write(
      TripItemsCompanion(
        departureCheckConfirmedAt: Value(nowIso),
        // updatedAt tidak diperbarui di sini agar departureCheckConfirmedAt >= updatedAt tetap valid
      ),
    );
  }

  /// Konfirmasi semua barang penting sekaligus dalam satu ketukan (CORE-02)
  Future<void> confirmAllImportantItems(String tripId) async {
    final nowIso = DateTime.now().toIso8601String();
    final items = await _packingRepo.watchTripItems(tripId).first;
    for (final item in items) {
      if (item.isImportant && item.tripItem.decision == 'carried') {
        await (_db.update(_db.tripItems)..where((t) => t.id.equals(item.tripItem.id))).write(
          TripItemsCompanion(
            departureCheckConfirmedAt: Value(nowIso),
          ),
        );
      }
    }
  }

  /// Memulai perjalanan dan membuat manifest keberangkatan fisik yang stabil (CORE-03, QA-16, QA-18)
  Future<DepartureManifestEntry> startTripAndCreateManifest({
    required String tripId,
    String? departureNotes,
    bool departedWithIssues = false,
  }) async {
    final nowIso = DateTime.now().toIso8601String();
    final manifestId = _uuid.v4();

    return await _db.transaction(() async {
      // 1. Ubah status perjalanan menjadi 'ongoing'
      await (_db.update(_db.trips)..where((t) => t.id.equals(tripId))).write(
        TripsCompanion(
          status: const Value('ongoing'),
          updatedAt: Value(nowIso),
        ),
      );

      // 2. Buat header manifest keberangkatan
      final manifest = DepartureManifestEntry(
        id: manifestId,
        tripId: tripId,
        departureNotes: departureNotes?.trim().isNotEmpty == true ? departureNotes!.trim() : null,
        isDepartedWithIssues: departedWithIssues,
        version: 1,
        sourceLabel: 'departure_check',
        createdAt: nowIso,
      );

      await _db.into(_db.departureManifests).insert(manifest);

      // 3. Snapshot seluruh barang bawaan yang diputuskan dibawa
      final tripItemsList = await (_db.select(_db.tripItems)
            ..where((ti) => ti.tripId.equals(tripId) & ti.decision.equals('carried')))
          .get();

      for (final tripItem in tripItemsList) {
        // Ambil info master item snapshot
        final masterItem = await (_db.select(_db.items)..where((i) => i.id.equals(tripItem.itemId))).getSingleOrNull();

        // Ambil lokasi simpan asal snapshot
        String? locationName;
        if (masterItem?.storageLocationId != null) {
          final loc = await (_db.select(_db.storageLocations)..where((l) => l.id.equals(masterItem!.storageLocationId!))).getSingleOrNull();
          locationName = loc?.name;
        }

        // Ambil alokasi wadah snapshot
        final allocRows = await (_db.select(_db.itemAllocations).join([
          leftOuterJoin(_db.tripBags, _db.tripBags.id.equalsExp(_db.itemAllocations.tripBagId)),
          leftOuterJoin(_db.bagCompartments, _db.bagCompartments.id.equalsExp(_db.itemAllocations.compartmentId)),
        ])..where(_db.itemAllocations.tripItemId.equals(tripItem.id))).get();

        String? allocationsJson;
        if (allocRows.isNotEmpty) {
          final allocData = allocRows.map((r) {
            final a = r.readTable(_db.itemAllocations);
            final b = r.readTableOrNull(_db.tripBags);
            final c = r.readTableOrNull(_db.bagCompartments);
            return {
              'targetType': a.targetType,
              'bagName': b?.name,
              'compartmentName': c?.name,
              'quantity': a.quantity,
              'notes': a.notes,
            };
          }).toList();
          allocationsJson = jsonEncode(allocData);
        }

        // Manifest memakai JUMLAH AKTUAL FISIK yang dikemas (QA-16)
        final carriedQty = tripItem.packedQuantity;
        final deficiencyQty = tripItem.plannedQuantity > carriedQty ? (tripItem.plannedQuantity - carriedQty) : 0;

        await _db.into(_db.departureManifestItems).insert(
              DepartureManifestItemEntry(
                id: _uuid.v4(),
                manifestId: manifestId,
                tripItemId: tripItem.id,
                itemId: tripItem.itemId,
                itemNameSnapshot: masterItem?.name ?? tripItem.nameSnapshot,
                itemUnitSnapshot: masterItem?.unit ?? 'buah',
                isImportant: masterItem?.isImportant ?? false,
                storageLocationSnapshot: locationName ?? tripItem.sourceLabelSnapshot,
                plannedQuantity: tripItem.plannedQuantity,
                carriedQuantity: carriedQty,
                deficiencyQuantity: deficiencyQty,
                allocationsSnapshot: allocationsJson,
                notes: tripItem.notes,
              ),
            );
      }

      return manifest;
    });
  }

  /// Ambil manifest keberangkatan terakhir untuk perjalanan tertentu
  Future<DepartureManifestWithDetails?> getDepartureManifest(String tripId) async {
    final manifest = await (_db.select(_db.departureManifests)
          ..where((m) => m.tripId.equals(tripId))
          ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();

    if (manifest == null) return null;

    final items = await (_db.select(_db.departureManifestItems)
          ..where((i) => i.manifestId.equals(manifest.id))
          ..orderBy([(i) => OrderingTerm(expression: i.itemNameSnapshot, mode: OrderingMode.asc)]))
        .get();

    return DepartureManifestWithDetails(manifest: manifest, items: items);
  }

  /// Watch manifest keberangkatan untuk perjalanan
  Stream<DepartureManifestWithDetails?> watchDepartureManifest(String tripId) {
    return (_db.select(_db.departureManifests)
          ..where((m) => m.tripId.equals(tripId))
          ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .watchSingleOrNull()
        .asyncMap((manifest) async {
      if (manifest == null) return null;

      final items = await (_db.select(_db.departureManifestItems)
            ..where((i) => i.manifestId.equals(manifest.id))
            ..orderBy([(i) => OrderingTerm(expression: i.itemNameSnapshot, mode: OrderingMode.asc)]))
          .get();

      return DepartureManifestWithDetails(manifest: manifest, items: items);
    });
  }

  /// Membuat baseline manifest untuk data legacy (QA-37, CORE-03)
  Future<DepartureManifestEntry> createLegacyBaselineManifest(String tripId) async {
    final nowIso = DateTime.now().toIso8601String();
    final manifestId = _uuid.v4();

    return await _db.transaction(() async {
      final manifest = DepartureManifestEntry(
        id: manifestId,
        tripId: tripId,
        departureNotes: 'Diambil dari catatan packing lama',
        isDepartedWithIssues: false,
        version: 1,
        sourceLabel: 'legacy_packing_record',
        createdAt: nowIso,
      );

      await _db.into(_db.departureManifests).insert(manifest);

      final tripItemsList = await (_db.select(_db.tripItems)
            ..where((ti) => ti.tripId.equals(tripId) & ti.decision.equals('carried')))
          .get();

      for (final tripItem in tripItemsList) {
        final masterItem = await (_db.select(_db.items)..where((i) => i.id.equals(tripItem.itemId))).getSingleOrNull();

        await _db.into(_db.departureManifestItems).insert(
              DepartureManifestItemEntry(
                id: _uuid.v4(),
                manifestId: manifestId,
                tripItemId: tripItem.id,
                itemId: tripItem.itemId,
                itemNameSnapshot: masterItem?.name ?? tripItem.nameSnapshot,
                itemUnitSnapshot: masterItem?.unit ?? 'buah',
                isImportant: masterItem?.isImportant ?? false,
                storageLocationSnapshot: tripItem.sourceLabelSnapshot,
                plannedQuantity: tripItem.plannedQuantity,
                carriedQuantity: tripItem.packedQuantity,
                deficiencyQuantity: tripItem.plannedQuantity > tripItem.packedQuantity ? (tripItem.plannedQuantity - tripItem.packedQuantity) : 0,
                allocationsSnapshot: null,
                notes: tripItem.notes,
              ),
            );
      }

      return manifest;
    });
  }

  /// Koreksi jumlah pada manifest historis dengan catatan alasan (CORE-03)
  Future<void> correctManifestItem({
    required String manifestItemId,
    required int newCarriedQuantity,
    required String reason,
  }) async {
    final existing = await (_db.select(_db.departureManifestItems)
          ..where((i) => i.id.equals(manifestItemId)))
        .getSingleOrNull();

    if (existing == null) {
      throw StateError('Item manifest tidak ditemukan');
    }

    final oldNotes = existing.notes ?? '';
    final correctionNote = '[Koreksi]: $reason (Sebelumnya: ${existing.carriedQuantity} unit)';
    final newNotes = oldNotes.isEmpty ? correctionNote : '$oldNotes\n$correctionNote';
    final newDeficiency = existing.plannedQuantity > newCarriedQuantity ? (existing.plannedQuantity - newCarriedQuantity) : 0;

    await (_db.update(_db.departureManifestItems)..where((i) => i.id.equals(manifestItemId))).write(
      DepartureManifestItemsCompanion(
        carriedQuantity: Value(newCarriedQuantity),
        deficiencyQuantity: Value(newDeficiency),
        notes: Value(newNotes),
      ),
    );
  }
}
