import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

enum PackingFilter {
  all('Semua'),
  unpacked('Belum dikemas'),
  partial('Sebagian'),
  completed('Selesai'),
  packedLast('Disiapkan terakhir'),
  notCarried('Tidak dibawa');

  final String label;
  const PackingFilter(this.label);

  static PackingFilter fromLabel(String label) {
    return PackingFilter.values.firstWhere(
      (f) => f.label.toLowerCase() == label.toLowerCase(),
      orElse: () => PackingFilter.all,
    );
  }
}

/// Detail alokasi unit pada wadah perjalanan (LOC-01)
class ItemAllocationWithDetails {
  final ItemAllocationEntry allocation;
  final String? bagName;
  final String? compartmentName;

  const ItemAllocationWithDetails({
    required this.allocation,
    this.bagName,
    this.compartmentName,
  });

  String get id => allocation.id;
  String get tripItemId => allocation.tripItemId;
  String get targetType => allocation.targetType; // 'bag' | 'on_person' | 'in_hand' | 'unspecified'
  int get quantity => allocation.quantity;
  String? get tripBagId => allocation.tripBagId;
  String? get compartmentId => allocation.compartmentId;
  String? get notes => allocation.notes;
  String? get lastConfirmedAt => allocation.lastConfirmedAt;

  String get displayLocation {
    switch (targetType) {
      case 'on_person':
        return 'Dipakai di badan';
      case 'in_hand':
        return 'Dibawa di tangan';
      case 'bag':
        if (bagName != null && compartmentName != null) {
          return '$bagName → $compartmentName';
        }
        return bagName ?? 'Tas perjalanan';
      case 'unspecified':
      default:
        return 'Lokasi tas belum dicatat';
    }
  }
}

/// Draft alokasi unit fisik untuk pembagian wadah (LOC-01, QA-09)
class AllocationDraft {
  final String targetType; // 'bag' | 'on_person' | 'in_hand' | 'unspecified'
  final String? tripBagId;
  final String? compartmentId;
  final int quantity;
  final String? notes;

  const AllocationDraft({
    required this.targetType,
    this.tripBagId,
    this.compartmentId,
    required this.quantity,
    this.notes,
  });
}

/// Hasil evaluasi potensi konflik inventaris antarrute & perjalanan (CORE-05)
class ItemConflictResult {
  final bool hasConflict;
  final String? message;
  final int peakSimultaneousDemand;
  final int availableStock;
  final int deficiency;
  final List<String> conflictingTripNames;
  final List<String> conflictingDateRanges;
  final bool isUncertainDate;
  final bool hasUnconfirmedFromPreviousTrip;
  final bool isUnderstockedReviewNeeded;

  const ItemConflictResult({
    this.hasConflict = false,
    this.message,
    this.peakSimultaneousDemand = 0,
    this.availableStock = 0,
    this.deficiency = 0,
    this.conflictingTripNames = const [],
    this.conflictingDateRanges = const [],
    this.isUncertainDate = false,
    this.hasUnconfirmedFromPreviousTrip = false,
    this.isUnderstockedReviewNeeded = false,
  });
}

class TripItemWithDetails {
  final TripItemEntry tripItem;
  final ItemEntry? item;
  final String? storageLocationName;
  final String? categoryName;
  final String? tripBagName;
  final bool isImportant;
  final String status; // 'belum_dikemas', 'sebagian', 'selesai', 'tidak_dibawa', 'sedang_dipakai'
  final bool hasConflict;
  final String? conflictMessage;
  final ItemConflictResult? conflictResult;
  final List<ItemAllocationWithDetails> allocations;

  const TripItemWithDetails({
    required this.tripItem,
    this.item,
    this.storageLocationName,
    this.categoryName,
    this.tripBagName,
    this.isImportant = false,
    required this.status,
    this.hasConflict = false,
    this.conflictMessage,
    this.conflictResult,
    this.allocations = const [],
  });

  bool get isCompleted => status == 'selesai' && tripItem.inUseQuantity == 0;
  bool get isInUse => tripItem.inUseQuantity > 0;
  bool get isCarried => tripItem.decision == 'carried';
  bool get isPackedLast => tripItem.isPackedLast;
  String get displayName => item?.name ?? tripItem.nameSnapshot;
  String get displayLocation => storageLocationName ?? tripItem.sourceLabelSnapshot ?? 'Lokasi belum dicatat';
  int get packedQuantity => tripItem.packedQuantity;
  int get plannedQuantity => tripItem.plannedQuantity;
  int get inUseQuantity => tripItem.inUseQuantity;
  String? get lastPhysicallyConfirmedAt => tripItem.lastPhysicallyConfirmedAt;

  String get allocationSummary {
    if (allocations.isEmpty) {
      return tripBagName ?? 'Lokasi tas belum dicatat';
    }
    return allocations.map((a) => '${a.quantity}x ${a.displayLocation}').join(', ');
  }
}

class TripPackingRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  TripPackingRepository(this._db);

  /// Watch trip items joined with item, location, category, and bag information
  Stream<List<TripItemWithDetails>> watchTripItems(String tripId, {PackingFilter filter = PackingFilter.all}) {
    // We join TripItems with Items, StorageLocations, Categories, and TripBags
    final query = _db.select(_db.tripItems).join([
      leftOuterJoin(_db.items, _db.items.id.equalsExp(_db.tripItems.itemId)),
      leftOuterJoin(_db.storageLocations, _db.storageLocations.id.equalsExp(_db.items.storageLocationId)),
      leftOuterJoin(_db.categories, _db.categories.id.equalsExp(_db.items.categoryId)),
      leftOuterJoin(_db.tripBags, _db.tripBags.id.equalsExp(_db.tripItems.tripBagId)),
    ])
      ..where(_db.tripItems.tripId.equals(tripId))
      ..orderBy([
        OrderingTerm(expression: _db.tripItems.decision, mode: OrderingMode.asc), // carried first
        OrderingTerm(expression: _db.tripItems.updatedAt, mode: OrderingMode.desc),
      ]);

    return query.watch().asyncMap((rows) async {
      final List<TripItemWithDetails> items = [];

      for (final row in rows) {
        final tripItem = row.readTable(_db.tripItems);
        final item = row.readTableOrNull(_db.items);
        final location = row.readTableOrNull(_db.storageLocations);
        final category = row.readTableOrNull(_db.categories);
        final bag = row.readTableOrNull(_db.tripBags);

        // Derive packing status (CORE-01)
        final String status;
        if (tripItem.decision == 'not_carried') {
          status = 'tidak_dibawa';
        } else if (tripItem.inUseQuantity > 0 && tripItem.packedQuantity == 0) {
          status = 'sedang_dipakai';
        } else if (tripItem.packedQuantity == 0) {
          status = 'belum_dikemas';
        } else if (tripItem.packedQuantity < tripItem.plannedQuantity || tripItem.inUseQuantity > 0) {
          status = 'sebagian';
        } else {
          status = 'selesai';
        }

        // Apply filter
        if (filter == PackingFilter.unpacked && (status != 'belum_dikemas' && status != 'sedang_dipakai')) continue;
        if (filter == PackingFilter.partial && status != 'sebagian') continue;
        if (filter == PackingFilter.completed && status != 'selesai') continue;
        if (filter == PackingFilter.notCarried && status != 'tidak_dibawa') continue;
        if (filter == PackingFilter.packedLast && !tripItem.isPackedLast) continue;

        // Check potential date overlap conflict (PCK-09, CORE-05)
        final conflictResult = await checkItemConflictResult(tripId, tripItem.itemId, tripItem.plannedQuantity);
        final conflict = conflictResult?.hasConflict == true ? conflictResult?.message : null;

        // Load allocations for this item (LOC-01)
        final allocRows = await (_db.select(_db.itemAllocations).join([
          leftOuterJoin(_db.tripBags, _db.tripBags.id.equalsExp(_db.itemAllocations.tripBagId)),
          leftOuterJoin(_db.bagCompartments, _db.bagCompartments.id.equalsExp(_db.itemAllocations.compartmentId)),
        ])..where(_db.itemAllocations.tripItemId.equals(tripItem.id))).get();

        final allocations = allocRows.map((aRow) {
          final alloc = aRow.readTable(_db.itemAllocations);
          final bagEntry = aRow.readTableOrNull(_db.tripBags);
          final compEntry = aRow.readTableOrNull(_db.bagCompartments);
          return ItemAllocationWithDetails(
            allocation: alloc,
            bagName: bagEntry?.name,
            compartmentName: compEntry?.name,
          );
        }).toList();

        items.add(TripItemWithDetails(
          tripItem: tripItem,
          item: item,
          storageLocationName: location?.name,
          categoryName: category?.name,
          tripBagName: bag?.name,
          isImportant: item?.isImportant ?? false,
          status: status,
          hasConflict: conflict != null,
          conflictMessage: conflict,
          conflictResult: conflictResult,
          allocations: allocations,
        ));
      }

      return items;
    });
  }

  /// Get trip items once (snapshot)
  Future<List<TripItemWithDetails>> getTripItemsWithDetails(String tripId, {PackingFilter filter = PackingFilter.all}) async {
    return watchTripItems(tripId, filter: filter).first;
  }

  static String _formatYmd(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static List<String> _groupConsecutiveDays(List<DateTime> days) {
    if (days.isEmpty) return [];
    final sortedDays = days.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()..sort();
    final ranges = <String>[];
    DateTime rangeStart = sortedDays.first;
    DateTime rangeEnd = sortedDays.first;

    for (int i = 1; i < sortedDays.length; i++) {
      final current = sortedDays[i];
      if (current.difference(rangeEnd).inDays == 1) {
        rangeEnd = current;
      } else {
        if (rangeStart == rangeEnd) {
          ranges.add(_formatYmd(rangeStart));
        } else {
          ranges.add('${_formatYmd(rangeStart)} s/d ${_formatYmd(rangeEnd)}');
        }
        rangeStart = current;
        rangeEnd = current;
      }
    }

    if (rangeStart == rangeEnd) {
      ranges.add(_formatYmd(rangeStart));
    } else {
      ranges.add('${_formatYmd(rangeStart)} s/d ${_formatYmd(rangeEnd)}');
    }

    return ranges;
  }

  /// Evaluasi potensi konflik inventaris antarrute & perjalanan (CORE-05, QA-30..QA-35)
  Future<ItemConflictResult?> checkItemConflictResult(
    String tripId,
    String itemId,
    int plannedQuantity,
  ) async {
    final currentTrip = await (_db.select(_db.trips)..where((t) => t.id.equals(tripId))).getSingleOrNull();
    final item = await (_db.select(_db.items)..where((i) => i.id.equals(itemId))).getSingleOrNull();
    if (currentTrip == null || item == null) return null;

    // 1. Validasi QA-29: Stok master diturunkan di bawah rencana perjalanan lama
    if (plannedQuantity > item.quantity) {
      final deficiency = plannedQuantity - item.quantity;
      final msg = item.quantity == 0
          ? 'Perlu ditinjau: Stok master barang ini habis (0 ${item.unit}), rencana membawa $plannedQuantity ${item.unit}.'
          : 'Perlu ditinjau: Rencana membawa ($plannedQuantity ${item.unit}) melebihi stok master terkini (${item.quantity} ${item.unit}, kurang $deficiency).';
      return ItemConflictResult(
        hasConflict: true,
        message: msg,
        peakSimultaneousDemand: plannedQuantity,
        availableStock: item.quantity,
        deficiency: deficiency,
        isUnderstockedReviewNeeded: true,
      );
    }

    // 2. Query perjalanan aktif lainnya yang membawa item ini (CORE-05, QA-35)
    // Filter hanya status 'planning' atau 'ongoing'. Selesai ('completed') dan dibatalkan ('cancelled') tidak memesan stok baru.
    final otherCarriedItems = await (_db.select(_db.tripItems).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.tripItems.tripId)),
    ])
          ..where(_db.tripItems.itemId.equals(itemId) &
              _db.tripItems.decision.equals('carried') &
              _db.trips.id.equals(tripId).not() &
              _db.trips.isArchived.equals(false) &
              _db.trips.status.isIn(['planning', 'ongoing'])))
        .get();

    // 3. Pengecekan QA-34: Perjalanan sebelumnya yang barangnya belum dikonfirmasi kembali
    final previousTripsWithItem = await (_db.select(_db.tripItems).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.tripItems.tripId)),
    ])
          ..where(_db.tripItems.itemId.equals(itemId) &
              _db.tripItems.decision.equals('carried') &
              _db.trips.id.equals(tripId).not() &
              _db.trips.status.equals('cancelled').not()))
        .get();

    for (final row in previousTripsWithItem) {
      final prevTrip = row.readTable(_db.trips);
      final prevTripItem = row.readTable(_db.tripItems);

      // Cek apakah perjalanan ini secara kronologis mendahului currentTrip
      final isPreceding = (prevTrip.endDate != null && prevTrip.endDate!.compareTo(currentTrip.startDate) < 0) ||
          (prevTrip.endDate == null && prevTrip.startDate.compareTo(currentTrip.startDate) < 0 && prevTrip.status == 'completed');

      if (isPreceding) {
        // Cek apakah ada checkpoint dengan unit belum terkonfirmasi untuk item ini
        final returnEntries = await (_db.select(_db.returnEntries).join([
          innerJoin(_db.returnCheckpoints, _db.returnCheckpoints.id.equalsExp(_db.returnEntries.checkpointId)),
        ])
              ..where(_db.returnEntries.tripItemId.equals(prevTripItem.id) &
                  _db.returnCheckpoints.tripId.equals(prevTrip.id)))
            .get();

        for (final reRow in returnEntries) {
          final re = reRow.readTable(_db.returnEntries);
          final accounted = re.returnedQuantity + re.consumedQuantity + re.leftQuantity + re.lostQuantity;
          final unconfirmed = re.expectedQuantity - accounted;
          if (unconfirmed > 0) {
            return ItemConflictResult(
              hasConflict: true,
              message: 'Ketersediaan belum dikonfirmasi: Masih ada $unconfirmed unit belum ditemukan pada pemeriksaan perjalanan sebelumnya ("${prevTrip.name}").',
              availableStock: item.quantity,
              hasUnconfirmedFromPreviousTrip: true,
              conflictingTripNames: [prevTrip.name],
            );
          }
        }
      }
    }

    if (otherCarriedItems.isEmpty) {
      return const ItemConflictResult(hasConflict: false);
    }

    final curStart = currentTrip.startDate;
    final curEnd = currentTrip.endDate;

    // 4. Pengecekan QA-33: Tanggal akhir kosong menghasilkan ketidakpastian
    for (final row in otherCarriedItems) {
      final otherTrip = row.readTable(_db.trips);
      final otherStart = otherTrip.startDate;
      final otherEnd = otherTrip.endDate;

      if (curEnd == null) {
        // Perjalanan saat ini belum ada tanggal selesai
        // Berpotensi bentrok jika otherTrip mulai setelah atau saat curStart
        if (otherEnd == null || otherEnd.compareTo(curStart) >= 0) {
          return ItemConflictResult(
            hasConflict: true,
            message: 'Belum dapat memastikan ketersediaan karena rentang tanggal perjalanan fleksibel/belum ada tanggal selesai ("${otherTrip.name}").',
            isUncertainDate: true,
            availableStock: item.quantity,
            conflictingTripNames: [otherTrip.name],
          );
        }
      } else if (otherEnd == null) {
        // Perjalanan lain belum ada tanggal selesai
        if (otherStart.compareTo(curEnd) <= 0) {
          return ItemConflictResult(
            hasConflict: true,
            message: 'Belum dapat memastikan ketersediaan karena rentang tanggal perjalanan fleksibel/belum ada tanggal selesai ("${otherTrip.name}").',
            isUncertainDate: true,
            availableStock: item.quantity,
            conflictingTripNames: [otherTrip.name],
          );
        }
      }
    }

    // Jika sampai di sini dan curEnd == null, tidak ada overlap yang terdeteksi
    if (curEnd == null) {
      return const ItemConflictResult(hasConflict: false);
    }

    // 5. Algoritma Konflik Simultan (CORE-05, QA-30, QA-31, QA-32)
    // Filter hanya trip yang memiliki interval overlap inklusif dengan [curStart, curEnd]
    final overlappingRows = <({TripEntry trip, TripItemEntry item})>[];
    for (final row in otherCarriedItems) {
      final oTrip = row.readTable(_db.trips);
      final oItem = row.readTable(_db.tripItems);
      if (oTrip.endDate != null) {
        // Interval inklusif: curStart <= otherEnd && otherStart <= curEnd
        final isOverlap = (curStart.compareTo(oTrip.endDate!) <= 0) && (oTrip.startDate.compareTo(curEnd) <= 0);
        if (isOverlap) {
          overlappingRows.add((trip: oTrip, item: oItem));
        }
      }
    }

    if (overlappingRows.isEmpty) {
      return const ItemConflictResult(hasConflict: false);
    }

    // Evaluasi kebutuhan simultan hari demi hari pada interval [curStart, curEnd]
    final curStartDate = DateTime.parse(curStart);
    final curEndDate = DateTime.parse(curEnd);

    int peakSimultaneousDemand = plannedQuantity;
    int maxDeficiency = 0;
    final Set<String> conflictingTripNames = {};
    final List<DateTime> conflictDays = [];

    DateTime dayCursor = curStartDate;
    while (!dayCursor.isAfter(curEndDate)) {
      final dayStr = _formatYmd(dayCursor);
      int dayDemand = plannedQuantity;
      final activeTripNamesOnDay = <String>[];

      for (final o in overlappingRows) {
        if (dayStr.compareTo(o.trip.startDate) >= 0 && dayStr.compareTo(o.trip.endDate!) <= 0) {
          dayDemand += o.item.plannedQuantity;
          activeTripNamesOnDay.add(o.trip.name);
        }
      }

      if (dayDemand > peakSimultaneousDemand) {
        peakSimultaneousDemand = dayDemand;
      }

      if (dayDemand > item.quantity) {
        final def = dayDemand - item.quantity;
        if (def > maxDeficiency) {
          maxDeficiency = def;
        }
        conflictingTripNames.addAll(activeTripNamesOnDay);
        conflictDays.add(dayCursor);
      }

      dayCursor = dayCursor.add(const Duration(days: 1));
    }

    if (maxDeficiency > 0) {
      final dateRanges = _groupConsecutiveDays(conflictDays);
      final tripsListStr = conflictingTripNames.map((n) => '"$n"').join(', ');
      final msg = 'Potensi bentrok: Dibutuhkan puncak $peakSimultaneousDemand ${item.unit} (stok: ${item.quantity}, kurang $maxDeficiency) pada tanggal ${dateRanges.join(', ')} bersama perjalanan $tripsListStr.';

      return ItemConflictResult(
        hasConflict: true,
        message: msg,
        peakSimultaneousDemand: peakSimultaneousDemand,
        availableStock: item.quantity,
        deficiency: maxDeficiency,
        conflictingTripNames: conflictingTripNames.toList(),
        conflictingDateRanges: dateRanges,
      );
    }

    return ItemConflictResult(
      hasConflict: false,
      peakSimultaneousDemand: peakSimultaneousDemand,
      availableStock: item.quantity,
    );
  }

  /// Check potential conflict for an item across overlapping trips (PCK-09, CORE-05)
  Future<String?> checkItemConflict(String tripId, String itemId, int plannedQuantity) async {
    final result = await checkItemConflictResult(tripId, itemId, plannedQuantity);
    return result?.hasConflict == true ? result?.message : null;
  }

  /// Get a single trip item entry by tripId and itemId
  Future<TripItemEntry?> getTripItem(String tripId, String itemId) async {
    return (_db.select(_db.tripItems)
          ..where((ti) => ti.tripId.equals(tripId) & ti.itemId.equals(itemId)))
        .getSingleOrNull();
  }

  /// Add or update a trip item from inventory (PCK-01, PCK-02, PCK-03, INV-01)
  Future<void> setPlannedItem({
    required String tripId,
    required String itemId,
    required int plannedQuantity,
    String? tripBagId,
    String? notes,
  }) async {
    final item = await (_db.select(_db.items)..where((i) => i.id.equals(itemId))).getSingleOrNull();
    if (item == null) {
      throw StateError('Barang inventaris tidak ditemukan');
    }

    if (plannedQuantity < 1) {
      throw ArgumentError('Jumlah rencana minimal 1');
    }

    if (item.quantity <= 0) {
      throw ArgumentError('Stok barang "${item.name}" saat ini 0. Perbarui stok inventaris terlebih dahulu.');
    }

    if (plannedQuantity > item.quantity) {
      throw ArgumentError('Jumlah rencana ($plannedQuantity) tidak boleh melebihi stok inventaris (${item.quantity})');
    }

    // Resolve location name for snapshot
    String? locationName;
    if (item.storageLocationId != null) {
      final loc = await (_db.select(_db.storageLocations)..where((l) => l.id.equals(item.storageLocationId!))).getSingleOrNull();
      locationName = loc?.name;
    }

    final nowIso = DateTime.now().toIso8601String();

    // Check if item is already in trip
    final existing = await getTripItem(tripId, itemId);

    if (existing != null) {
      // CORE-06 / QA-07: Tolak clamp diam-diam jika rencana baru lebih kecil dari jumlah fisik yang sudah disiapkan/dipakai
      final physicalTotal = existing.packedQuantity + existing.inUseQuantity;
      if (plannedQuantity < physicalTotal) {
        throw ArgumentError(
          'Jumlah rencana ($plannedQuantity) lebih kecil dari jumlah yang sudah dikemas/sedang dipakai ($physicalTotal). Keluarkan unit terlebih dahulu sebelum mengurangi rencana.',
        );
      }

      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(existing.id))).write(
        TripItemsCompanion(
          decision: const Value('carried'),
          plannedQuantity: Value(plannedQuantity),
          packedQuantity: Value(existing.packedQuantity),
          inUseQuantity: Value(existing.inUseQuantity),
          tripBagId: Value(tripBagId ?? existing.tripBagId),
          notes: Value(notes ?? existing.notes),
          nameSnapshot: Value(item.name),
          sourceLabelSnapshot: Value(locationName ?? existing.sourceLabelSnapshot),
          lastPhysicallyConfirmedAt: Value(existing.lastPhysicallyConfirmedAt),
          updatedAt: Value(nowIso),
        ),
      );
    } else {
      await _db.into(_db.tripItems).insert(
            TripItemsCompanion.insert(
              id: _uuid.v4(),
              tripId: tripId,
              itemId: itemId,
              decision: const Value('carried'),
              plannedQuantity: Value(plannedQuantity),
              packedQuantity: const Value(0),
              inUseQuantity: const Value(0),
              tripBagId: Value(tripBagId),
              notes: Value(notes),
              nameSnapshot: item.name,
              sourceLabelSnapshot: Value(locationName),
              lastPhysicallyConfirmedAt: const Value(null),
              updatedAt: nowIso,
            ),
          );
    }
  }

  /// Mark item as NOT CARRIED (PCK-02, AT-04, CORE-06)
  /// Resets packed_quantity to 0 and inUseQuantity to 0.
  Future<void> setItemNotCarried(String tripItemId) async {
    final nowIso = DateTime.now().toIso8601String();
    await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
      TripItemsCompanion(
        decision: const Value('not_carried'),
        plannedQuantity: const Value(0),
        packedQuantity: const Value(0),
        inUseQuantity: const Value(0),
        updatedAt: Value(nowIso),
      ),
    );
  }

  /// Menyalin barang dari satu perjalanan ke perjalanan lain (Duplikasi/Share Item)
  Future<void> copyItemToTrip({
    required String sourceTripItemId,
    required String targetTripId,
    int? customPlannedQuantity,
  }) async {
    final source = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(sourceTripItemId))).getSingleOrNull();
    if (source == null) return;
    await setPlannedItem(
      tripId: targetTripId,
      itemId: source.itemId,
      plannedQuantity: customPlannedQuantity ?? source.plannedQuantity,
      notes: source.notes,
    );
  }

  /// Alias for setPlannedItem
  Future<void> setItemCarried({
    required String tripId,
    required String itemId,
    required int plannedQuantity,
    String? tripBagId,
    String? notes,
  }) => setPlannedItem(
    tripId: tripId,
    itemId: itemId,
    plannedQuantity: plannedQuantity,
    tripBagId: tripBagId,
    notes: notes,
  );

  /// Menghapus item dari daftar bawaan perjalanan secara aman (CORE-06)
  Future<void> removeTripItem(String tripItemId) async {
    await (_db.delete(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).go();
  }

  /// Alias deleteTripItem for backward compatibility
  Future<void> deleteTripItem(String tripItemId) => removeTripItem(tripItemId);

  /// Kemas sejumlah unit barang secara serial dan transaksional (CORE-01, QA-02, QA-04, LOC-01)
  Future<int> packUnit(
    String tripItemId, {
    int delta = 1,
    String targetType = 'bag',
    String? tripBagId,
    String? compartmentId,
  }) async {
    if (delta <= 0) return 0;
    return await _db.transaction(() async {
      final existing = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (existing == null) throw StateError('Bawaan perjalanan tidak ditemukan');

      final maxPackable = existing.plannedQuantity;
      final newPacked = (existing.packedQuantity + delta).clamp(0, maxPackable);
      final actualDelta = newPacked - existing.packedQuantity;
      if (actualDelta <= 0) return existing.packedQuantity;

      final nowIso = DateTime.now().toIso8601String();

      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
        TripItemsCompanion(
          packedQuantity: Value(newPacked),
          lastPhysicallyConfirmedAt: Value(nowIso),
          updatedAt: Value(nowIso),
        ),
      );

      // Auto-alokasi (LOC-01, QA-09, QA-11)
      final effectiveTarget = targetType != 'bag'
          ? targetType
          : ((tripBagId ?? existing.tripBagId) != null ? 'bag' : 'unspecified');
      final effectiveBagId = effectiveTarget == 'bag' ? (tripBagId ?? existing.tripBagId) : null;
      final effectiveCompId = effectiveTarget == 'bag' ? compartmentId : null;

      final existingAlloc = await (_db.select(_db.itemAllocations)
            ..where((a) =>
                a.tripItemId.equals(tripItemId) &
                a.targetType.equals(effectiveTarget) &
                (effectiveBagId != null ? a.tripBagId.equals(effectiveBagId) : a.tripBagId.isNull()) &
                (effectiveCompId != null ? a.compartmentId.equals(effectiveCompId) : a.compartmentId.isNull())))
          .getSingleOrNull();

      if (existingAlloc != null) {
        await (_db.update(_db.itemAllocations)..where((a) => a.id.equals(existingAlloc.id))).write(
          ItemAllocationsCompanion(
            quantity: Value(existingAlloc.quantity + actualDelta),
            lastConfirmedAt: Value(nowIso),
          ),
        );
      } else {
        await _db.into(_db.itemAllocations).insert(
              ItemAllocationsCompanion.insert(
                id: _uuid.v4(),
                tripItemId: tripItemId,
                targetType: Value(effectiveTarget),
                tripBagId: Value(effectiveBagId),
                compartmentId: Value(effectiveCompId),
                quantity: Value(actualDelta),
                lastConfirmedAt: Value(nowIso),
              ),
            );
      }

      return newPacked;
    });
  }

  /// Keluarkan sejumlah unit barang dari kemasan (CORE-01, QA-05, LOC-01)
  Future<int> unpackUnit(String tripItemId, {int delta = 1, String? allocationId}) async {
    if (delta <= 0) return 0;
    return await _db.transaction(() async {
      final existing = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (existing == null) throw StateError('Bawaan perjalanan tidak ditemukan');

      final newPacked = (existing.packedQuantity - delta).clamp(0, existing.plannedQuantity);
      final actualReduction = existing.packedQuantity - newPacked;
      if (actualReduction <= 0) return existing.packedQuantity;

      final nowIso = DateTime.now().toIso8601String();

      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
        TripItemsCompanion(
          packedQuantity: Value(newPacked),
          updatedAt: Value(nowIso),
        ),
      );

      // Kurangi alokasi sesuai delta (LOC-01)
      if (allocationId != null) {
        final alloc = await (_db.select(_db.itemAllocations)..where((a) => a.id.equals(allocationId))).getSingleOrNull();
        if (alloc != null) {
          if (alloc.quantity <= actualReduction) {
            await (_db.delete(_db.itemAllocations)..where((a) => a.id.equals(allocationId))).go();
          } else {
            await (_db.update(_db.itemAllocations)..where((a) => a.id.equals(allocationId))).write(
              ItemAllocationsCompanion(
                quantity: Value(alloc.quantity - actualReduction),
              ),
            );
          }
        }
      } else {
        var remainingToReduce = actualReduction;
        final allocs = await (_db.select(_db.itemAllocations)
              ..where((a) => a.tripItemId.equals(tripItemId))
              ..orderBy([(a) => OrderingTerm(expression: a.id, mode: OrderingMode.desc)]))
            .get();

        for (final alloc in allocs) {
          if (remainingToReduce <= 0) break;
          if (alloc.quantity <= remainingToReduce) {
            remainingToReduce -= alloc.quantity;
            await (_db.delete(_db.itemAllocations)..where((a) => a.id.equals(alloc.id))).go();
          } else {
            await (_db.update(_db.itemAllocations)..where((a) => a.id.equals(alloc.id))).write(
              ItemAllocationsCompanion(
                quantity: Value(alloc.quantity - remainingToReduce),
              ),
            );
            remainingToReduce = 0;
          }
        }
      }

      return newPacked;
    });
  }

  /// Tandai barang sedang dipakai (CORE-01, QA-05)
  /// Mengeluarkan unit dari tas dan mencatatnya ke inUseQuantity
  Future<void> setUnitInUse(String tripItemId, {int count = 1}) async {
    if (count <= 0) return;
    await _db.transaction(() async {
      final existing = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (existing == null) throw StateError('Bawaan perjalanan tidak ditemukan');

      final reducePacked = count.clamp(0, existing.packedQuantity);
      final newPacked = existing.packedQuantity - reducePacked;
      final newInUse = existing.inUseQuantity + count;

      final nowIso = DateTime.now().toIso8601String();
      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
        TripItemsCompanion(
          packedQuantity: Value(newPacked),
          inUseQuantity: Value(newInUse),
          updatedAt: Value(nowIso),
        ),
      );
    });
  }

  /// Masukkan kembali barang yang sedang dipakai (CORE-01, QA-06)
  Future<void> returnInUseUnit(String tripItemId, {int count = 1}) async {
    if (count <= 0) return;
    await _db.transaction(() async {
      final existing = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (existing == null) throw StateError('Bawaan perjalanan tidak ditemukan');

      final actualReturn = count.clamp(0, existing.inUseQuantity);
      final newInUse = existing.inUseQuantity - actualReturn;
      final newPacked = (existing.packedQuantity + actualReturn).clamp(0, existing.plannedQuantity);

      final nowIso = DateTime.now().toIso8601String();
      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
        TripItemsCompanion(
          packedQuantity: Value(newPacked),
          inUseQuantity: Value(newInUse),
          lastPhysicallyConfirmedAt: Value(nowIso),
          updatedAt: Value(nowIso),
        ),
      );
    });
  }

  /// Toggle penanda 'Disiapkan terakhir' (PACK-01)
  Future<void> togglePackedLast(String tripItemId, bool isPackedLast) async {
    final nowIso = DateTime.now().toIso8601String();
    await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
      TripItemsCompanion(
        isPackedLast: Value(isPackedLast),
        updatedAt: Value(nowIso),
      ),
    );
  }

  /// Update packed quantity (PCK-04). Returns previous packed quantity for Undo.
  Future<int> updatePackedQuantity(String tripItemId, int newPacked) async {
    return await _db.transaction(() async {
      final existing = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (existing == null) {
        throw StateError('Bawaan perjalanan tidak ditemukan');
      }

      if (newPacked < 0 || newPacked > existing.plannedQuantity) {
        throw ArgumentError('Jumlah dikemas harus antara 0 dan ${existing.plannedQuantity}');
      }

      final previous = existing.packedQuantity;
      final nowIso = DateTime.now().toIso8601String();

      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
        TripItemsCompanion(
          packedQuantity: Value(newPacked),
          lastPhysicallyConfirmedAt: newPacked > previous ? Value(nowIso) : Value(existing.lastPhysicallyConfirmedAt),
          updatedAt: Value(nowIso),
        ),
      );

      return previous;
    });
  }

  /// Rapid quick toggle for single or multi unit (PCK-05, CORE-01). Atomic and race-condition free.
  Future<({int previous, int current})> quickTogglePacked(String tripItemId) async {
    return await _db.transaction(() async {
      final existing = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (existing == null) {
        throw StateError('Bawaan perjalanan tidak ditemukan');
      }

      final previous = existing.packedQuantity;
      final int newPacked;
      final nowIso = DateTime.now().toIso8601String();

      if (existing.plannedQuantity == 1) {
        // 1 unit: toggle between 0 and 1
        newPacked = (previous == 1 && existing.inUseQuantity == 0) ? 0 : 1;
      } else {
        // Multi unit: if already complete, uncheck all (0); otherwise mark all complete
        newPacked = (previous == existing.plannedQuantity && existing.inUseQuantity == 0) ? 0 : existing.plannedQuantity;
      }

      await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
        TripItemsCompanion(
          packedQuantity: Value(newPacked),
          inUseQuantity: const Value(0),
          lastPhysicallyConfirmedAt: newPacked > 0 ? Value(nowIso) : Value(existing.lastPhysicallyConfirmedAt),
          updatedAt: Value(nowIso),
        ),
      );

      // Sinkronisasi alokasi fisik (LOC-01)
      if (newPacked > 0) {
        final existingAllocs = await (_db.select(_db.itemAllocations)..where((a) => a.tripItemId.equals(tripItemId))).get();
        if (existingAllocs.isEmpty) {
          final target = existing.tripBagId != null ? 'bag' : 'unspecified';
          await _db.into(_db.itemAllocations).insert(
                ItemAllocationsCompanion.insert(
                  id: _uuid.v4(),
                  tripItemId: tripItemId,
                  targetType: Value(target),
                  tripBagId: Value(existing.tripBagId),
                  quantity: Value(newPacked),
                  lastConfirmedAt: Value(nowIso),
                ),
              );
        }
      } else {
        await (_db.delete(_db.itemAllocations)..where((a) => a.tripItemId.equals(tripItemId))).go();
      }

      return (previous: previous, current: newPacked);
    });
  }

  // --- TRIP BAGS & COMPARTMENTS MANAGEMENT (PCK-08, LOC-01) ---

  /// Watch trip bags
  Stream<List<TripBagEntry>> watchTripBags(String tripId) {
    return (_db.select(_db.tripBags)
          ..where((b) => b.tripId.equals(tripId))
          ..orderBy([(b) => OrderingTerm(expression: b.name, mode: OrderingMode.asc)]))
        .watch();
  }

  /// Create trip bag (PCK-08)
  Future<String> createTripBag(String tripId, String name, {String? description}) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Nama tas wajib diisi');
    }

    final bagId = _uuid.v4();
    await _db.into(_db.tripBags).insert(
          TripBagsCompanion.insert(
            id: bagId,
            tripId: tripId,
            name: trimmedName,
            description: Value(description?.trim()),
          ),
        );
    return bagId;
  }

  /// Buat kompartemen/kantong di dalam tas (LOC-01)
  Future<BagCompartmentEntry> createBagCompartment({
    required String tripBagId,
    required String name,
    int sortOrder = 0,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('Nama kompartemen tidak boleh kosong');

    final compId = _uuid.v4();
    await _db.into(_db.bagCompartments).insert(
          BagCompartmentsCompanion.insert(
            id: compId,
            tripBagId: tripBagId,
            name: trimmed,
            sortOrder: Value(sortOrder),
          ),
        );
    return await (_db.select(_db.bagCompartments)..where((c) => c.id.equals(compId))).getSingle();
  }

  /// Ambil daftar kompartemen tas
  Future<List<BagCompartmentEntry>> getBagCompartments(String tripBagId) async {
    return (_db.select(_db.bagCompartments)
          ..where((c) => c.tripBagId.equals(tripBagId))
          ..orderBy([(c) => OrderingTerm(expression: c.sortOrder, mode: OrderingMode.asc)]))
        .get();
  }

  /// Watch kompartemen tas
  Stream<List<BagCompartmentEntry>> watchBagCompartments(String tripBagId) {
    return (_db.select(_db.bagCompartments)
          ..where((c) => c.tripBagId.equals(tripBagId))
          ..orderBy([(c) => OrderingTerm(expression: c.sortOrder, mode: OrderingMode.asc)]))
        .watch();
  }

  /// Hapus kompartemen tas
  Future<void> deleteBagCompartment(String compartmentId) async {
    await (_db.delete(_db.bagCompartments)..where((c) => c.id.equals(compartmentId))).go();
  }

  /// Membagi dan mengalokasikan unit barang secara eksplisit (LOC-01, QA-09)
  Future<void> setItemAllocations({
    required String tripItemId,
    required List<AllocationDraft> drafts,
  }) async {
    return await _db.transaction(() async {
      final tripItem = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).getSingleOrNull();
      if (tripItem == null) throw StateError('Bawaan perjalanan tidak ditemukan');

      int totalAllocated = 0;
      for (final draft in drafts) {
        if (draft.quantity < 1) {
          throw ArgumentError('Jumlah alokasi tiap wadah minimal 1');
        }
        if (draft.targetType != 'bag' && (draft.tripBagId != null || draft.compartmentId != null)) {
          throw ArgumentError('Hanya target tas yang dapat memiliki referensi tas atau kompartemen');
        }
        totalAllocated += draft.quantity;
      }

      if (totalAllocated != tripItem.packedQuantity) {
        throw ArgumentError(
          'Total alokasi ($totalAllocated) harus sama dengan jumlah unit yang sudah dikemas (${tripItem.packedQuantity})',
        );
      }

      await (_db.delete(_db.itemAllocations)..where((a) => a.tripItemId.equals(tripItemId))).go();

      final nowIso = DateTime.now().toIso8601String();
      for (final draft in drafts) {
        await _db.into(_db.itemAllocations).insert(
              ItemAllocationsCompanion.insert(
                id: _uuid.v4(),
                tripItemId: tripItemId,
                targetType: Value(draft.targetType),
                tripBagId: Value(draft.tripBagId),
                compartmentId: Value(draft.compartmentId),
                quantity: Value(draft.quantity),
                notes: Value(draft.notes),
                lastConfirmedAt: Value(nowIso),
              ),
            );
      }
    });
  }

  /// Memindahkan sejumlah unit dari satu alokasi ke alokasi lain dalam satu transaksi (LOC-01, QA-10)
  Future<void> moveAllocatedUnit({
    required String sourceAllocationId,
    required String targetType, // 'bag' | 'on_person' | 'in_hand' | 'unspecified'
    String? targetBagId,
    String? targetCompartmentId,
    int delta = 1,
  }) async {
    if (delta <= 0) return;
    return await _db.transaction(() async {
      final source = await (_db.select(_db.itemAllocations)..where((a) => a.id.equals(sourceAllocationId))).getSingleOrNull();
      if (source == null) throw StateError('Alokasi asal tidak ditemukan');

      if (delta > source.quantity) {
        throw ArgumentError('Jumlah perpindahan ($delta) melebihi isi alokasi asal (${source.quantity})');
      }

      final nowIso = DateTime.now().toIso8601String();

      if (source.quantity == delta) {
        await (_db.delete(_db.itemAllocations)..where((a) => a.id.equals(sourceAllocationId))).go();
      } else {
        await (_db.update(_db.itemAllocations)..where((a) => a.id.equals(sourceAllocationId))).write(
          ItemAllocationsCompanion(
            quantity: Value(source.quantity - delta),
            lastConfirmedAt: Value(nowIso),
          ),
        );
      }

      final effectiveBagId = targetType == 'bag' ? targetBagId : null;
      final effectiveCompId = targetType == 'bag' ? targetCompartmentId : null;

      final existingTarget = await (_db.select(_db.itemAllocations)
            ..where((a) =>
                a.tripItemId.equals(source.tripItemId) &
                a.targetType.equals(targetType) &
                (effectiveBagId != null ? a.tripBagId.equals(effectiveBagId) : a.tripBagId.isNull()) &
                (effectiveCompId != null ? a.compartmentId.equals(effectiveCompId) : a.compartmentId.isNull())))
          .getSingleOrNull();

      if (existingTarget != null) {
        await (_db.update(_db.itemAllocations)..where((a) => a.id.equals(existingTarget.id))).write(
          ItemAllocationsCompanion(
            quantity: Value(existingTarget.quantity + delta),
            lastConfirmedAt: Value(nowIso),
          ),
        );
      } else {
        await _db.into(_db.itemAllocations).insert(
              ItemAllocationsCompanion.insert(
                id: _uuid.v4(),
                tripItemId: source.tripItemId,
                targetType: Value(targetType),
                tripBagId: Value(effectiveBagId),
                compartmentId: Value(effectiveCompId),
                quantity: Value(delta),
                lastConfirmedAt: Value(nowIso),
              ),
            );
      }
    });
  }

  /// Ambil seluruh alokasi aktif untuk sebuah tripItem (LOC-01)
  Future<List<ItemAllocationWithDetails>> getItemAllocations(String tripItemId) async {
    final query = _db.select(_db.itemAllocations).join([
      leftOuterJoin(_db.tripBags, _db.tripBags.id.equalsExp(_db.itemAllocations.tripBagId)),
      leftOuterJoin(_db.bagCompartments, _db.bagCompartments.id.equalsExp(_db.itemAllocations.compartmentId)),
    ])..where(_db.itemAllocations.tripItemId.equals(tripItemId));

    final rows = await query.get();
    return rows.map((r) {
      final alloc = r.readTable(_db.itemAllocations);
      final bag = r.readTableOrNull(_db.tripBags);
      final comp = r.readTableOrNull(_db.bagCompartments);
      return ItemAllocationWithDetails(
        allocation: alloc,
        bagName: bag?.name,
        compartmentName: comp?.name,
      );
    }).toList();
  }

  /// Assign or unassign item to bag (PCK-08)
  Future<void> assignItemToBag(String tripItemId, String? tripBagId) async {
    final nowIso = DateTime.now().toIso8601String();
    await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItemId))).write(
      TripItemsCompanion(
        tripBagId: Value(tripBagId),
        updatedAt: Value(nowIso),
      ),
    );
  }

  /// Delete trip bag secara aman dengan resolusi alokasi (LOC-01, QA-12)
  Future<void> deleteTripBagSafely(String bagId, {required String resolution}) async {
    final nowIso = DateTime.now().toIso8601String();
    await _db.transaction(() async {
      if (resolution == 'move_to_unspecified') {
        await (_db.update(_db.itemAllocations)..where((a) => a.tripBagId.equals(bagId))).write(
          ItemAllocationsCompanion(
            targetType: const Value('unspecified'),
            tripBagId: const Value(null),
            compartmentId: const Value(null),
            lastConfirmedAt: Value(nowIso),
          ),
        );
      } else if (resolution == 'unpack') {
        final bagAllocs = await (_db.select(_db.itemAllocations)..where((a) => a.tripBagId.equals(bagId))).get();
        for (final alloc in bagAllocs) {
          final tripItem = await (_db.select(_db.tripItems)..where((ti) => ti.id.equals(alloc.tripItemId))).getSingleOrNull();
          if (tripItem != null) {
            final newPacked = (tripItem.packedQuantity - alloc.quantity).clamp(0, tripItem.plannedQuantity);
            await (_db.update(_db.tripItems)..where((ti) => ti.id.equals(tripItem.id))).write(
              TripItemsCompanion(
                packedQuantity: Value(newPacked),
                updatedAt: Value(nowIso),
              ),
            );
          }
        }
        await (_db.delete(_db.itemAllocations)..where((a) => a.tripBagId.equals(bagId))).go();
      }

      // Detach all items assigned to this bag
      await (_db.update(_db.tripItems)..where((ti) => ti.tripBagId.equals(bagId))).write(
        TripItemsCompanion(
          tripBagId: const Value(null),
          updatedAt: Value(nowIso),
        ),
      );

      // Delete bag
      await (_db.delete(_db.tripBags)..where((b) => b.id.equals(bagId))).go();
    });
  }

  /// Delete trip bag (detaches items first, fallback safe delete)
  Future<void> deleteTripBag(String bagId) => deleteTripBagSafely(bagId, resolution: 'move_to_unspecified');
}
