import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

/// Model pembantu untuk satu entri barang di dalam checkpoint (CORE-04)
class ReturnEntryWithItem {
  final ReturnEntryEntry entry;
  final ItemEntry? item;

  const ReturnEntryWithItem({
    required this.entry,
    this.item,
  });

  String get id => entry.id;
  String get checkpointId => entry.checkpointId;
  String get tripItemId => entry.tripItemId;
  String get nameSnapshot => entry.nameSnapshot;
  int get expectedQuantity => entry.expectedQuantity;
  int get returnedQuantity => entry.returnedQuantity;
  int get consumedQuantity => entry.consumedQuantity;
  int get leftQuantity => entry.leftQuantity;
  int get lostQuantity => entry.lostQuantity;
  String? get notes => entry.notes;

  // Rumus CORE-04:
  // accounted = returned + consumed + left + lost
  // unconfirmed = expected - accounted
  int get accountedQuantity => returnedQuantity + consumedQuantity + leftQuantity + lostQuantity;
  int get confirmedQuantity => accountedQuantity; // alias backward compatibility
  int get unconfirmedQuantity => (expectedQuantity - accountedQuantity).clamp(0, expectedQuantity);
  bool get isFullyConfirmed => unconfirmedQuantity == 0;
  int get nextStageBalance => returnedQuantity + unconfirmedQuantity;
}

/// Model pembantu untuk checkpoint kepulangan/perpindahan lengkap dengan entri-entrinya (CORE-04)
class CheckpointWithDetails {
  final ReturnCheckpointEntry checkpoint;
  final TripStopEntry? tripStop;
  final List<ReturnEntryWithItem> entries;

  const CheckpointWithDetails({
    required this.checkpoint,
    this.tripStop,
    required this.entries,
  });

  String get id => checkpoint.id;
  String get tripId => checkpoint.tripId;
  String? get tripStopId => checkpoint.tripStopId;
  String get title => checkpoint.title;
  String get createdAt => checkpoint.createdAt;
  String? get closedAt => checkpoint.closedAt;
  String get closeState => checkpoint.closeState; // 'open' | 'completed' | 'closed_with_unconfirmed'

  bool get isOpen => closeState == 'open';
  bool get isCompleted => closeState == 'completed';
  bool get isClosedWithUnconfirmed => closeState == 'closed_with_unconfirmed';

  int get totalExpected => entries.fold(0, (sum, e) => sum + e.expectedQuantity);
  int get totalReturned => entries.fold(0, (sum, e) => sum + e.returnedQuantity);
  int get totalConsumed => entries.fold(0, (sum, e) => sum + e.consumedQuantity);
  int get totalLeft => entries.fold(0, (sum, e) => sum + e.leftQuantity);
  int get totalLost => entries.fold(0, (sum, e) => sum + e.lostQuantity);
  int get totalAccounted => totalReturned + totalConsumed + totalLeft + totalLost;
  int get totalConfirmed => totalAccounted; // alias backward compatibility
  int get totalUnconfirmed => (totalExpected - totalAccounted).clamp(0, totalExpected);
  bool get isFullyConfirmed => totalUnconfirmed == 0;
  int get totalNextStageBalance => totalReturned + totalUnconfirmed;
}

class CheckpointsRepository {
  final AppDatabase _db;
  final Uuid _uuid = const Uuid();

  CheckpointsRepository(this._db);

  /// Menghitung jumlah barang yang sudah dikemas pada perjalanan
  Future<int> getPackedItemsCount(String tripId) async {
    final packed = await (_db.select(_db.tripItems)
          ..where((t) =>
              t.tripId.equals(tripId) &
              t.decision.equals('carried') &
              t.packedQuantity.isBiggerThanValue(0)))
        .get();
    return packed.length;
  }

  /// Membuat checkpoint baru dengan penurunan baseline bertahap (CORE-04, QA-19, QA-20, QA-21, QA-26)
  Future<String> createCheckpoint({
    required String tripId,
    String? tripStopId,
    String? title,
  }) async {
    // 1. Validasi QA-26: Batasi hanya satu checkpoint aktif yang berstatus 'open'
    final openCheckpoint = await (_db.select(_db.returnCheckpoints)
          ..where((c) => c.tripId.equals(tripId) & c.closeState.equals('open')))
        .getSingleOrNull();

    if (openCheckpoint != null) {
      throw StateError(
        'Selesaikan atau tutup checkpoint aktif terlebih dahulu sebelum membuat checkpoint baru.',
      );
    }

    final checkpointId = _uuid.v4();
    final nowIso = DateTime.now().toIso8601String();
    final effectiveTitle = title ??
        (tripStopId != null ? 'Cek Pindah Perhentian' : 'Cek Sebelum Pulang');

    return await _db.transaction(() async {
      // 2. Buat checkpoint header
      await _db.into(_db.returnCheckpoints).insert(
            ReturnCheckpointsCompanion.insert(
              id: checkpointId,
              tripId: tripId,
              tripStopId: Value(tripStopId),
              title: effectiveTitle,
              createdAt: nowIso,
              closeState: const Value('open'),
            ),
          );

      // 3. Tentukan baseline tahap (CORE-04, QA-19, QA-20, QA-21)
      // Cek apakah ada checkpoint sebelumnya yang sudah ditutup
      final prevCheckpoint = await (_db.select(_db.returnCheckpoints)
            ..where((c) => c.tripId.equals(tripId) & c.closedAt.isNotNull()))
            .get()
            .then((list) {
          if (list.isEmpty) return null;
          // Urutkan berdasarkan waktu tutup terbaru
          list.sort((a, b) => (b.closedAt ?? b.createdAt).compareTo(a.closedAt ?? a.createdAt));
          return list.first;
        });

      if (prevCheckpoint != null) {
        // BASELINE DARI CHECKPOINT SEBELUMNYA (QA-20)
        final prevEntries = await (_db.select(_db.returnEntries)
              ..where((e) => e.checkpointId.equals(prevCheckpoint.id)))
            .get();

        final Set<String> processedTripItemIds = {};

        for (final prevEntry in prevEntries) {
          processedTripItemIds.add(prevEntry.tripItemId);
          // Rumus saldo lanjut: nextStageBalance = carriedConfirmed + unconfirmed
          final accounted = prevEntry.returnedQuantity + prevEntry.consumedQuantity + prevEntry.leftQuantity + prevEntry.lostQuantity;
          final unconfirmed = (prevEntry.expectedQuantity - accounted).clamp(0, prevEntry.expectedQuantity);
          final nextStageBalance = prevEntry.returnedQuantity + unconfirmed;

          // Hanya bawa barang yang masih memiliki saldo positif (> 0)
          if (nextStageBalance > 0) {
            await _db.into(_db.returnEntries).insert(
                  ReturnEntriesCompanion.insert(
                    id: _uuid.v4(),
                    checkpointId: checkpointId,
                    tripItemId: prevEntry.tripItemId,
                    nameSnapshot: prevEntry.nameSnapshot,
                    expectedQuantity: nextStageBalance,
                    returnedQuantity: Value(nextStageBalance), // default dibawa kembali
                    consumedQuantity: const Value(0),
                    leftQuantity: const Value(0),
                    lostQuantity: const Value(0),
                  ),
                );
          }
        }

        // Cek apakah ada barang baru yang dibeli / ditambahkan di perjalanan (QA-21)
        final currentTripItems = await (_db.select(_db.tripItems)
              ..where((t) =>
                  t.tripId.equals(tripId) &
                  t.decision.equals('carried') &
                  t.packedQuantity.isBiggerThanValue(0)))
            .get();

        for (final item in currentTripItems) {
          if (!processedTripItemIds.contains(item.id)) {
            // Barang baru di perjalanan!
            await _db.into(_db.returnEntries).insert(
                  ReturnEntriesCompanion.insert(
                    id: _uuid.v4(),
                    checkpointId: checkpointId,
                    tripItemId: item.id,
                    nameSnapshot: item.nameSnapshot,
                    expectedQuantity: item.packedQuantity,
                    returnedQuantity: Value(item.packedQuantity),
                    consumedQuantity: const Value(0),
                    leftQuantity: const Value(0),
                    lostQuantity: const Value(0),
                  ),
                );
          }
        }
      } else {
        // CHECKPOINT PERTAMA DALAM PERJALANAN
        // Cek apakah ada DepartureManifest (QA-16, QA-19)
        final latestManifest = await (_db.select(_db.departureManifests)
              ..where((m) => m.tripId.equals(tripId))
              ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.desc)])
              ..limit(1))
            .getSingleOrNull();

        if (latestManifest != null) {
          final manifestItems = await (_db.select(_db.departureManifestItems)
                ..where((i) => i.manifestId.equals(latestManifest.id) & i.carriedQuantity.isBiggerThanValue(0)))
              .get();

          for (final mItem in manifestItems) {
            String effectiveTripItemId = mItem.tripItemId ?? '';
            if (effectiveTripItemId.isEmpty) {
              final ti = await (_db.select(_db.tripItems)
                    ..where((t) => t.tripId.equals(tripId) & t.itemId.equals(mItem.itemId ?? '')))
                  .getSingleOrNull();
              effectiveTripItemId = ti?.id ?? _uuid.v4();
            }

            await _db.into(_db.returnEntries).insert(
                  ReturnEntriesCompanion.insert(
                    id: _uuid.v4(),
                    checkpointId: checkpointId,
                    tripItemId: effectiveTripItemId,
                    nameSnapshot: mItem.itemNameSnapshot,
                    expectedQuantity: mItem.carriedQuantity, // Baseline dari jumlah aktual fisik keberangkatan!
                    returnedQuantity: Value(mItem.carriedQuantity),
                    consumedQuantity: const Value(0),
                    leftQuantity: const Value(0),
                    lostQuantity: const Value(0),
                  ),
                );
          }
        } else {
          // Fallback legacy trip tanpa manifest
          final packedItems = await (_db.select(_db.tripItems)
                ..where((t) =>
                    t.tripId.equals(tripId) &
                    t.decision.equals('carried') &
                    t.packedQuantity.isBiggerThanValue(0)))
              .get();

          for (final tripItem in packedItems) {
            await _db.into(_db.returnEntries).insert(
                  ReturnEntriesCompanion.insert(
                    id: _uuid.v4(),
                    checkpointId: checkpointId,
                    tripItemId: tripItem.id,
                    nameSnapshot: tripItem.nameSnapshot,
                    expectedQuantity: tripItem.packedQuantity,
                    returnedQuantity: Value(tripItem.packedQuantity),
                    consumedQuantity: const Value(0),
                    leftQuantity: const Value(0),
                    lostQuantity: const Value(0),
                  ),
                );
          }
        }
      }

      return checkpointId;
    });
  }

  /// Mengamati daftar seluruh checkpoint pada suatu perjalanan
  Stream<List<CheckpointWithDetails>> watchTripCheckpoints(String tripId) {
    return (_db.select(_db.returnCheckpoints)
          ..where((c) => c.tripId.equals(tripId))
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .watch()
        .asyncMap((checkpoints) async {
      final results = <CheckpointWithDetails>[];
      for (final cp in checkpoints) {
        final details = await getCheckpointWithDetails(cp.id);
        if (details != null) {
          results.add(details);
        }
      }
      return results;
    });
  }

  /// Mengambil data rincian checkpoint tunggal beserta entri barangnya (RET-03, CORE-04)
  Future<CheckpointWithDetails?> getCheckpointWithDetails(String checkpointId) async {
    final checkpoint = await (_db.select(_db.returnCheckpoints)
          ..where((c) => c.id.equals(checkpointId)))
        .getSingleOrNull();

    if (checkpoint == null) return null;

    TripStopEntry? stop;
    if (checkpoint.tripStopId != null) {
      stop = await (_db.select(_db.tripStops)
            ..where((s) => s.id.equals(checkpoint.tripStopId!)))
          .getSingleOrNull();
    }

    // Ambil semua entri barang di checkpoint
    final entries = await (_db.select(_db.returnEntries)
          ..where((e) => e.checkpointId.equals(checkpointId)))
        .get();

    final entryDetails = <ReturnEntryWithItem>[];
    for (final entry in entries) {
      final tripItem = await (_db.select(_db.tripItems)
            ..where((ti) => ti.id.equals(entry.tripItemId)))
          .getSingleOrNull();

      ItemEntry? masterItem;
      if (tripItem != null) {
        masterItem = await (_db.select(_db.items)
              ..where((i) => i.id.equals(tripItem.itemId)))
            .getSingleOrNull();
      }

      entryDetails.add(ReturnEntryWithItem(
        entry: entry,
        item: masterItem,
      ));
    }

    return CheckpointWithDetails(
      checkpoint: checkpoint,
      tripStop: stop,
      entries: entryDetails,
    );
  }

  /// Mengamati satu checkpoint dengan detail secara reaktif
  Stream<CheckpointWithDetails?> watchCheckpointWithDetails(String checkpointId) {
    return (_db.select(_db.returnCheckpoints)
          ..where((c) => c.id.equals(checkpointId)))
        .watchSingleOrNull()
        .asyncMap((cp) async {
      if (cp == null) return null;
      return getCheckpointWithDetails(cp.id);
    });
  }

  /// Memperbarui konfirmasi kuantitas per barang (RET-03, CORE-04, QA-22)
  /// Aturan PRD: accounted = returned + consumed + left + lost <= expected
  Future<void> updateReturnEntryQuantities({
    required String entryId,
    required int returnedQuantity,
    required int consumedQuantity,
    required int leftQuantity,
    int lostQuantity = 0,
    String? notes,
  }) async {
    final entry = await (_db.select(_db.returnEntries)
          ..where((e) => e.id.equals(entryId)))
        .getSingleOrNull();

    if (entry == null) return;

    if (returnedQuantity < 0 || consumedQuantity < 0 || leftQuantity < 0 || lostQuantity < 0) {
      throw ArgumentError('Kuantitas konfirmasi tidak boleh bernilai negatif');
    }

    final totalAccounted = returnedQuantity + consumedQuantity + leftQuantity + lostQuantity;
    if (totalAccounted > entry.expectedQuantity) {
      throw ArgumentError(
        'Total terkonfirmasi ($totalAccounted) tidak boleh melebihi kuantitas expected (${entry.expectedQuantity})',
      );
    }

    await (_db.update(_db.returnEntries)..where((e) => e.id.equals(entryId))).write(
      ReturnEntriesCompanion(
        returnedQuantity: Value(returnedQuantity),
        consumedQuantity: Value(consumedQuantity),
        leftQuantity: Value(leftQuantity),
        lostQuantity: Value(lostQuantity),
        notes: notes != null ? Value(notes) : const Value.absent(),
      ),
    );
  }

  /// Menutup checkpoint kepulangan / transit (RET-05, CORE-04, QA-23)
  /// Jika ada item belum selesai (unconfirmed > 0), status = closed_with_unconfirmed (BUKAN selesai/lengkap)
  Future<void> closeCheckpoint(String checkpointId) async {
    final details = await getCheckpointWithDetails(checkpointId);
    if (details == null) return;

    final nowIso = DateTime.now().toIso8601String();
    final closeState = details.isFullyConfirmed ? 'completed' : 'closed_with_unconfirmed';

    await (_db.update(_db.returnCheckpoints)
          ..where((c) => c.id.equals(checkpointId)))
        .write(
      ReturnCheckpointsCompanion(
        closedAt: Value(nowIso),
        closeState: Value(closeState),
      ),
    );
  }

  /// Mendapatkan proposal penyesuaian stok master berdasarkan hasil checkpoint (INV-01, QA-28)
  Future<List<StockAdjustmentProposal>> getStockAdjustmentProposals(String checkpointId) async {
    final details = await getCheckpointWithDetails(checkpointId);
    if (details == null) return [];

    final proposals = <StockAdjustmentProposal>[];
    for (final entry in details.entries) {
      final reduction = entry.consumedQuantity + entry.lostQuantity + entry.leftQuantity;
      if (reduction > 0 && entry.item != null) {
        final currentStock = entry.item!.quantity;
        final proposed = (currentStock - reduction).clamp(0, currentStock);
        proposals.add(StockAdjustmentProposal(
          itemId: entry.item!.id,
          itemName: entry.nameSnapshot,
          unit: entry.item!.unit,
          currentStock: currentStock,
          totalReduction: reduction,
          proposedStock: proposed,
          consumed: entry.consumedQuantity,
          lost: entry.lostQuantity,
          left: entry.leftQuantity,
        ));
      }
    }
    return proposals;
  }

  /// Menerapkan penyesuaian stok yang telah disetujui pengguna secara eksplisit (INV-01, QA-28)
  Future<void> applyStockAdjustments(List<StockAdjustmentProposal> proposals) async {
    final nowIso = DateTime.now().toIso8601String();
    await _db.transaction(() async {
      for (final prop in proposals) {
        await (_db.update(_db.items)..where((i) => i.id.equals(prop.itemId))).write(
          ItemsCompanion(
            quantity: Value(prop.proposedStock),
            updatedAt: Value(nowIso),
          ),
        );
      }
    });
  }

  /// Menghapus checkpoint
  Future<void> deleteCheckpoint(String checkpointId) async {
    await (_db.delete(_db.returnCheckpoints)
          ..where((c) => c.id.equals(checkpointId)))
        .go();
  }
}

/// Proposal penyesuaian stok master setelah checkpoint selesai (INV-01, QA-28)
class StockAdjustmentProposal {
  final String itemId;
  final String itemName;
  final String unit;
  final int currentStock;
  final int totalReduction; // consumed + lost + left
  final int proposedStock; // max(0, currentStock - totalReduction)
  final int consumed;
  final int lost;
  final int left;

  const StockAdjustmentProposal({
    required this.itemId,
    required this.itemName,
    required this.unit,
    required this.currentStock,
    required this.totalReduction,
    required this.proposedStock,
    required this.consumed,
    required this.lost,
    required this.left,
  });
}
