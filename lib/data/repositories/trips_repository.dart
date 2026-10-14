import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import 'reminders_repository.dart';

class TripWithDetails {
  final TripEntry trip;
  final List<TripStopEntry> stops;
  final List<TripBagEntry> bags;
  final TripPackingSummary summary;

  const TripWithDetails({
    required this.trip,
    required this.stops,
    required this.bags,
    required this.summary,
  });
}

class TripPackingSummary {
  final int totalCarriedRows;
  final int completedRows;
  final double progress; // 0.0 to 1.0
  final int totalPlannedUnits;
  final int totalPackedUnits;
  final bool hasUnfinishedEssential;
  final int unfinishedCount;

  const TripPackingSummary({
    required this.totalCarriedRows,
    required this.completedRows,
    required this.progress,
    required this.totalPlannedUnits,
    required this.totalPackedUnits,
    required this.hasUnfinishedEssential,
    required this.unfinishedCount,
  });

  bool get hasItems => totalCarriedRows > 0;
  bool get isAllCompleted => hasItems && completedRows == totalCarriedRows;
  
  String get progressLabel {
    if (!hasItems) return 'Belum ada daftar bawaan';
    final percentage = (progress * 100).toInt();
    return '$percentage% selesai ($completedRows/$totalCarriedRows)';
  }

  String get unitsLabel => '$totalPackedUnits/$totalPlannedUnits unit dikemas';
}

class TripsRepository {
  final AppDatabase _db;
  final RemindersRepository? _remindersRepository;
  final _uuid = const Uuid();

  TripsRepository(this._db, [this._remindersRepository]);

  /// Watch list of trips sorted by startDate ASC, filtered by status if provided
  Stream<List<TripEntry>> watchTrips({String? status, bool includeArchived = false}) {
    final query = _db.select(_db.trips)
      ..orderBy([
        (t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.asc),
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
      ]);

    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }

    if (status != null) {
      query.where((t) => t.status.equals(status));
    }

    return query.watch();
  }

  /// Get a single trip by ID
  Future<TripEntry?> getTripById(String id) {
    return (_db.select(_db.trips)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Watch single trip with its stops, bags, and packing summary
  Stream<TripWithDetails?> watchTripWithDetails(String tripId) {
    // Watch the trip
    return (_db.select(_db.trips)..where((t) => t.id.equals(tripId)))
        .watchSingleOrNull()
        .asyncMap((trip) async {
      if (trip == null) return null;

      final stops = await (_db.select(_db.tripStops)
            ..where((s) => s.tripId.equals(tripId))
            ..orderBy([(s) => OrderingTerm(expression: s.sortOrder, mode: OrderingMode.asc)]))
          .get();

      final bags = await (_db.select(_db.tripBags)
            ..where((b) => b.tripId.equals(tripId))
            ..orderBy([(b) => OrderingTerm(expression: b.name, mode: OrderingMode.asc)]))
          .get();

      final summary = await calculateTripSummary(tripId);

      return TripWithDetails(
        trip: trip,
        stops: stops,
        bags: bags,
        summary: summary,
      );
    });
  }

  /// Stream daftar seluruh perjalanan beserta rincian rute & status bawaan
  Stream<List<TripWithDetails>> watchAllTripsWithDetails({String? status, bool includeArchived = false}) {
    return watchTrips(status: status, includeArchived: includeArchived).asyncMap((trips) async {
      final list = <TripWithDetails>[];
      for (final trip in trips) {
        final details = await getTripWithDetails(trip.id);
        if (details != null) {
          list.add(details);
        }
      }
      return list;
    });
  }

  /// Watch upcoming active trip for Home screen
  Stream<TripWithDetails?> watchUpcomingTrip() {
    final query = _db.select(_db.trips)
      ..where((t) =>
          t.isArchived.equals(false) &
          (t.status.equals('planning') | t.status.equals('ongoing')))
      ..orderBy([
        (t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.asc),
      ])
      ..limit(1);

    return query.watchSingleOrNull().asyncMap((trip) async {
      if (trip == null) return null;
      return watchTripWithDetails(trip.id).first;
    });
  }

  /// Ambil daftar perjalanan aktif (planning / ongoing) yang belum diarsipkan
  Future<List<TripEntry>> getActiveTrips() async {
    final query = _db.select(_db.trips)
      ..where((t) =>
          t.isArchived.equals(false) &
          (t.status.equals('planning') | t.status.equals('ongoing')))
      ..orderBy([
        (t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.asc),
      ]);
    return query.get();
  }

  /// Ambil detail perjalanan lengkap sekali baca (Future)
  Future<TripWithDetails?> getTripWithDetails(String tripId) async {
    final trip = await (_db.select(_db.trips)..where((t) => t.id.equals(tripId))).getSingleOrNull();
    if (trip == null) return null;

    final stops = await (_db.select(_db.tripStops)
          ..where((s) => s.tripId.equals(tripId))
          ..orderBy([(s) => OrderingTerm(expression: s.sortOrder, mode: OrderingMode.asc)]))
        .get();

    final bags = await (_db.select(_db.tripBags)
          ..where((b) => b.tripId.equals(tripId))
          ..orderBy([(b) => OrderingTerm(expression: b.name, mode: OrderingMode.asc)]))
        .get();

    final summary = await calculateTripSummary(tripId);

    return TripWithDetails(
      trip: trip,
      stops: stops,
      bags: bags,
      summary: summary,
    );
  }

  /// Calculate packing summary for a trip according to PRD section 6.3
  Future<TripPackingSummary> calculateTripSummary(String tripId) async {
    // Join trip items with items table to check isImportant
    final query = _db.select(_db.tripItems).join([
      leftOuterJoin(_db.items, _db.items.id.equalsExp(_db.tripItems.itemId)),
    ])..where(_db.tripItems.tripId.equals(tripId));

    final rows = await query.get();

    int totalCarriedRows = 0;
    int completedRows = 0;
    int totalPlannedUnits = 0;
    int totalPackedUnits = 0;
    bool hasUnfinishedEssential = false;
    int unfinishedCount = 0;

    for (final row in rows) {
      final tripItem = row.readTable(_db.tripItems);
      final item = row.readTableOrNull(_db.items);

      if (tripItem.decision == 'carried' && tripItem.plannedQuantity > 0) {
        totalCarriedRows++;
        totalPlannedUnits += tripItem.plannedQuantity;
        totalPackedUnits += tripItem.packedQuantity;

        if (tripItem.packedQuantity >= tripItem.plannedQuantity) {
          completedRows++;
        } else {
          unfinishedCount++;
          if (item?.isImportant ?? false) {
            hasUnfinishedEssential = true;
          }
        }
      }
    }

    final double progress = totalCarriedRows > 0 ? (completedRows / totalCarriedRows) : 0.0;

    return TripPackingSummary(
      totalCarriedRows: totalCarriedRows,
      completedRows: completedRows,
      progress: progress,
      totalPlannedUnits: totalPlannedUnits,
      totalPackedUnits: totalPackedUnits,
      hasUnfinishedEssential: hasUnfinishedEssential,
      unfinishedCount: unfinishedCount,
    );
  }

  /// Create a new trip (TRP-01, TRP-02, TRP-03, TRP-04)
  Future<String> createTrip({
    required String name,
    required String startDate,
    String? endDate,
    String dateZoneId = 'Asia/Jakarta',
    String? notes,
    required List<String> stops, // e.g. ['Bandung', 'Jakarta', 'Bandung']
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Nama perjalanan wajib diisi');
    }
    if (stops.isEmpty) {
      throw ArgumentError('Minimal satu tujuan perjalanan wajib diisi');
    }

    // Validate dates if endDate is given
    if (endDate != null && endDate.isNotEmpty && endDate.compareTo(startDate) < 0) {
      throw ArgumentError('Tanggal akhir harus sama atau setelah tanggal mulai');
    }

    final tripId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      await _db.into(_db.trips).insert(
            TripsCompanion.insert(
              id: tripId,
              name: trimmedName,
              startDate: startDate,
              endDate: Value(endDate != null && endDate.isNotEmpty ? endDate : null),
              dateZoneId: dateZoneId,
              status: const Value('planning'),
              notes: Value(notes?.trim()),
              createdAt: nowIso,
              updatedAt: nowIso,
            ),
          );

      // Insert stops preserving order and handling duplicate city names
      for (int i = 0; i < stops.length; i++) {
        final stopLabel = stops[i].trim();
        if (stopLabel.isEmpty) continue;
        await _db.into(_db.tripStops).insert(
              TripStopsCompanion.insert(
                id: _uuid.v4(),
                tripId: tripId,
                label: stopLabel,
                sortOrder: Value(i),
              ),
            );
      }
    });

    return tripId;
  }

  /// Update an existing trip
  Future<void> updateTrip({
    required String id,
    required String name,
    required String startDate,
    String? endDate,
    String? notes,
    required List<String> stops,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Nama perjalanan wajib diisi');
    }
    if (stops.isEmpty) {
      throw ArgumentError('Minimal satu tujuan perjalanan wajib diisi');
    }
    if (endDate != null && endDate.isNotEmpty && endDate.compareTo(startDate) < 0) {
      throw ArgumentError('Tanggal akhir harus sama atau setelah tanggal mulai');
    }

    final nowIso = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      await (_db.update(_db.trips)..where((t) => t.id.equals(id))).write(
        TripsCompanion(
          name: Value(trimmedName),
          startDate: Value(startDate),
          endDate: Value(endDate != null && endDate.isNotEmpty ? endDate : null),
          notes: Value(notes?.trim()),
          updatedAt: Value(nowIso),
        ),
      );

      // Replace stops
      await (_db.delete(_db.tripStops)..where((s) => s.tripId.equals(id))).go();
      for (int i = 0; i < stops.length; i++) {
        final stopLabel = stops[i].trim();
        if (stopLabel.isEmpty) continue;
        await _db.into(_db.tripStops).insert(
              TripStopsCompanion.insert(
                id: _uuid.v4(),
                tripId: id,
                label: stopLabel,
                sortOrder: Value(i),
              ),
            );
      }
    });
  }

  /// Update trip status ('planning', 'ongoing', 'completed', 'cancelled')
  Future<void> updateTripStatus(String id, String status) async {
    final nowIso = DateTime.now().toIso8601String();
    await (_db.update(_db.trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(
        status: Value(status),
        updatedAt: Value(nowIso),
      ),
    );

    // Batalkan pengingat yang masih akan datang bila dibatalkan atau selesai (PRD 6.2, QA-35)
    if (status == 'cancelled' || status == 'completed') {
      await _remindersRepository?.cancelRemindersForTrip(id);
    }
  }

  /// Archive or unarchive a trip (TRP-05)
  Future<void> archiveTrip(String id, bool isArchived) async {
    final nowIso = DateTime.now().toIso8601String();
    await (_db.update(_db.trips)..where((t) => t.id.equals(id))).write(
      TripsCompanion(
        isArchived: Value(isArchived),
        updatedAt: Value(nowIso),
      ),
    );

    if (isArchived) {
      await _remindersRepository?.cancelRemindersForTrip(id);
    }
  }

  /// Delete a trip
  Future<void> deleteTrip(String id) async {
    await _remindersRepository?.cancelRemindersForTrip(id);
    await (_db.delete(_db.trips)..where((t) => t.id.equals(id))).go();
  }

  /// Duplicate a trip (TRP-07 & AT-18)
  /// Planned items are copied, but packed_quantity is reset to 0.
  /// Old tickets, checkpoints, bags, and reminders are not copied by default.
  Future<String> duplicateTrip({
    required String originalTripId,
    required String newName,
    required String newStartDate,
    String? newEndDate,
    bool copyStops = true,
  }) async {
    final original = await getTripById(originalTripId);
    if (original == null) {
      throw StateError('Perjalanan asli tidak ditemukan');
    }

    final newTripId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();

    await _db.transaction(() async {
      // 1. Insert new trip
      await _db.into(_db.trips).insert(
            TripsCompanion.insert(
              id: newTripId,
              name: newName.trim(),
              startDate: newStartDate,
              endDate: Value(newEndDate != null && newEndDate.isNotEmpty ? newEndDate : null),
              dateZoneId: original.dateZoneId,
              status: const Value('planning'),
              notes: Value(original.notes),
              createdAt: nowIso,
              updatedAt: nowIso,
            ),
          );

      // 2. Copy stops if requested
      if (copyStops) {
        final originalStops = await (_db.select(_db.tripStops)
              ..where((s) => s.tripId.equals(originalTripId))
              ..orderBy([(s) => OrderingTerm(expression: s.sortOrder, mode: OrderingMode.asc)]))
            .get();

        for (final stop in originalStops) {
          await _db.into(_db.tripStops).insert(
                TripStopsCompanion.insert(
                  id: _uuid.v4(),
                  tripId: newTripId,
                  label: stop.label,
                  sortOrder: Value(stop.sortOrder),
                ),
              );
        }
      }

      // 3. Copy planned items with packedQuantity reset to 0 (AT-18)
      final originalItems = await (_db.select(_db.tripItems)
            ..where((i) => i.tripId.equals(originalTripId)))
          .get();

      for (final item in originalItems) {
        if (item.decision == 'carried') {
          await _db.into(_db.tripItems).insert(
                TripItemEntry(
                  id: _uuid.v4(),
                  tripId: newTripId,
                  itemId: item.itemId,
                  decision: item.decision,
                  plannedQuantity: item.plannedQuantity,
                  packedQuantity: 0, // RESET to 0!
                  inUseQuantity: 0, // RESET to 0!
                  tripBagId: null, // Bags not copied
                  notes: item.notes,
                  nameSnapshot: item.nameSnapshot,
                  sourceLabelSnapshot: item.sourceLabelSnapshot,
                  lastPhysicallyConfirmedAt: null, // RESET confirmation timestamp
                  isPackedLast: item.isPackedLast,
                  updatedAt: nowIso,
                ),
              );
        }
      }
    });

    return newTripId;
  }
}
