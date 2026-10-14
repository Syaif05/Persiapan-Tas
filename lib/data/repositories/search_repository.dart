import 'package:drift/drift.dart';
import '../database/app_database.dart';

enum SearchResultType {
  selectedTrip, // Perjalanan dipilih
  homeInventory, // Inventaris rumah
  otherTrip, // Perjalanan lain
}

class UnifiedSearchResult {
  final SearchResultType type;
  final String itemId;
  final String itemName;
  final String? categoryName;
  final String? storageLocationName;
  final int totalQuantity;
  final String unit;
  final bool isImportant;

  // Data perjalanan
  final String? tripId;
  final String? tripName;
  final String? tripItemId;
  final int? plannedQuantity;
  final int? packedQuantity;
  final int? inUseQuantity;
  final String? packingStatus; // 'belum_dikemas', 'sebagian', 'selesai', 'tidak_dibawa', 'sedang_dipakai'
  final String? bagOrLocationDisplay;
  final String? lastPhysicallyConfirmedAt;
  final bool isPackedLast;

  const UnifiedSearchResult({
    required this.type,
    required this.itemId,
    required this.itemName,
    this.categoryName,
    this.storageLocationName,
    required this.totalQuantity,
    this.unit = 'buah',
    this.isImportant = false,
    this.tripId,
    this.tripName,
    this.tripItemId,
    this.plannedQuantity,
    this.packedQuantity,
    this.inUseQuantity,
    this.packingStatus,
    this.bagOrLocationDisplay,
    this.lastPhysicallyConfirmedAt,
    this.isPackedLast = false,
  });
}

class UnifiedSearchResults {
  final String query;
  final List<UnifiedSearchResult> selectedTripResults;
  final List<UnifiedSearchResult> homeInventoryResults;
  final List<UnifiedSearchResult> otherTripResults;

  const UnifiedSearchResults({
    required this.query,
    this.selectedTripResults = const [],
    this.homeInventoryResults = const [],
    this.otherTripResults = const [],
  });

  bool get isEmpty =>
      selectedTripResults.isEmpty &&
      homeInventoryResults.isEmpty &&
      otherTripResults.isEmpty;

  int get totalCount =>
      selectedTripResults.length +
      homeInventoryResults.length +
      otherTripResults.length;
}

class UnifiedSearchRepository {
  final AppDatabase _db;

  UnifiedSearchRepository(this._db);

  // Kamus alias sederhana untuk normalisasi pencarian (FIND-01)
  static final Map<String, List<String>> _termAliases = {
    'charger': ['pengisi daya', 'adaptor', 'casan', 'kabel data'],
    'casan': ['charger', 'adaptor', 'pengisi daya'],
    'adaptor': ['charger', 'casan', 'pengisi daya'],
    'kabel': ['charger', 'kabel data', 'usb'],
    'hp': ['handphone', 'smartphone', 'ponsel', 'telepon'],
    'handphone': ['hp', 'smartphone', 'ponsel'],
    'ponsel': ['hp', 'smartphone', 'handphone'],
    'obat': ['paracetamol', 'medisin', 'vitamin', 'p3k'],
    'p3k': ['obat', 'perban', 'plester', 'betadine'],
    'sikat gigi': ['odol', 'pasta gigi', 'toiletries'],
    'odol': ['sikat gigi', 'pasta gigi'],
    'kaus': ['kaos', 'baju', 't-shirt', 'tshirt'],
    'kaos': ['kaus', 'baju', 't-shirt'],
    'baju': ['kaus', 'kaos', 'kemeja', 'pakaian'],
    'celana': ['pants', 'bawahan', 'jeans'],
    'sepatu': ['sneakers', 'sandal', 'alas kaki'],
    'sandal': ['sepatu', 'alas kaki', 'selop'],
    'jaket': ['sweater', 'hoodie', 'outer', 'mantel'],
  };

  /// Memperluas query dengan kamus alias lokal
  Set<String> _expandQueryTerms(String rawQuery) {
    final clean = rawQuery.trim().toLowerCase();
    final terms = <String>{clean};

    // Cek alias langsung untuk kata kunci
    for (final entry in _termAliases.entries) {
      if (clean.contains(entry.key)) {
        terms.addAll(entry.value);
      }
      for (final alt in entry.value) {
        if (clean.contains(alt)) {
          terms.add(entry.key);
        }
      }
    }
    return terms;
  }

  /// Melakukan pencarian terpadu dari satu tempat (FIND-01)
  Future<UnifiedSearchResults> searchAcrossAll({
    required String rawQuery,
    String? selectedTripId,
  }) async {
    final cleanQuery = rawQuery.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      return const UnifiedSearchResults(query: '');
    }

    final searchTerms = _expandQueryTerms(cleanQuery);

    // 1. Cari di Inventaris Rumah (Items + StorageLocations + Categories)
    final invQuery = _db.select(_db.items).join([
      leftOuterJoin(_db.storageLocations,
          _db.storageLocations.id.equalsExp(_db.items.storageLocationId)),
      leftOuterJoin(
          _db.categories, _db.categories.id.equalsExp(_db.items.categoryId)),
    ])
      ..where(_db.items.archivedAt.isNull());

    final invRows = await invQuery.get();
    final List<UnifiedSearchResult> homeResults = [];

    for (final row in invRows) {
      final item = row.readTable(_db.items);
      final loc = row.readTableOrNull(_db.storageLocations);
      final cat = row.readTableOrNull(_db.categories);

      final itemNameLower = item.name.toLowerCase();
      final locNameLower = loc?.name.toLowerCase() ?? '';
      final catNameLower = cat?.name.toLowerCase() ?? '';
      final notesLower = item.notes?.toLowerCase() ?? '';

      final matches = searchTerms.any((term) =>
          itemNameLower.contains(term) ||
          locNameLower.contains(term) ||
          catNameLower.contains(term) ||
          notesLower.contains(term));

      if (matches) {
        homeResults.add(UnifiedSearchResult(
          type: SearchResultType.homeInventory,
          itemId: item.id,
          itemName: item.name,
          categoryName: cat?.name,
          storageLocationName: loc?.name ?? 'Lokasi belum dicatat',
          totalQuantity: item.quantity,
          unit: item.unit,
          isImportant: item.isImportant,
        ));
      }
    }

    // 2. Cari di Perjalanan (TripItems + Trips + Items + TripBags)
    final tripItemQuery = _db.select(_db.tripItems).join([
      innerJoin(_db.trips, _db.trips.id.equalsExp(_db.tripItems.tripId)),
      leftOuterJoin(_db.items, _db.items.id.equalsExp(_db.tripItems.itemId)),
      leftOuterJoin(
          _db.tripBags, _db.tripBags.id.equalsExp(_db.tripItems.tripBagId)),
    ])
      ..where(_db.trips.isArchived.equals(false))
      ..where(_db.trips.status.isNotIn(const ['cancelled']));

    final tripRows = await tripItemQuery.get();
    final List<UnifiedSearchResult> selectedTripResults = [];
    final List<UnifiedSearchResult> otherTripResults = [];

    // Ambil alokasi untuk detail lokasi tas/kompartemen
    final allocations = await (_db.select(_db.itemAllocations).join([
      leftOuterJoin(_db.tripBags,
          _db.tripBags.id.equalsExp(_db.itemAllocations.tripBagId)),
      leftOuterJoin(_db.bagCompartments,
          _db.bagCompartments.id.equalsExp(_db.itemAllocations.compartmentId)),
    ])).get();

    final Map<String, List<String>> allocationMap = {};
    for (final allocRow in allocations) {
      final alloc = allocRow.readTable(_db.itemAllocations);
      final bag = allocRow.readTableOrNull(_db.tripBags);
      final comp = allocRow.readTableOrNull(_db.bagCompartments);

      String locStr;
      if (alloc.targetType == 'on_person') {
        locStr = 'Dipakai di badan';
      } else if (alloc.targetType == 'in_hand') {
        locStr = 'Dibawa di tangan';
      } else if (bag != null) {
        locStr = comp != null ? '${bag.name} → ${comp.name}' : bag.name;
      } else {
        locStr = 'Lokasi belum dicatat';
      }

      allocationMap.putIfAbsent(alloc.tripItemId, () => []).add('${alloc.quantity}x $locStr');
    }

    for (final row in tripRows) {
      final tripItem = row.readTable(_db.tripItems);
      final trip = row.readTable(_db.trips);
      final item = row.readTableOrNull(_db.items);
      final bag = row.readTableOrNull(_db.tripBags);

      final name = item?.name ?? tripItem.nameSnapshot;
      final nameLower = name.toLowerCase();
      final tripNameLower = trip.name.toLowerCase();
      final bagNameLower = bag?.name.toLowerCase() ?? '';
      final sourceLower = tripItem.sourceLabelSnapshot?.toLowerCase() ?? '';

      final matches = searchTerms.any((term) =>
          nameLower.contains(term) ||
          tripNameLower.contains(term) ||
          bagNameLower.contains(term) ||
          sourceLower.contains(term));

      if (!matches) continue;

      String status;
      if (tripItem.decision == 'not_carried') {
        status = 'tidak_dibawa';
      } else if (tripItem.inUseQuantity > 0) {
        status = 'sedang_dipakai';
      } else if (tripItem.packedQuantity >= tripItem.plannedQuantity &&
          tripItem.plannedQuantity > 0) {
        status = 'selesai';
      } else if (tripItem.packedQuantity > 0) {
        status = 'sebagian';
      } else {
        status = 'belum_dikemas';
      }

      final allocList = allocationMap[tripItem.id];
      final bagDisplay = allocList != null && allocList.isNotEmpty
          ? allocList.join(', ')
          : (bag?.name ?? 'Lokasi tas belum dicatat');

      final result = UnifiedSearchResult(
        type: (selectedTripId != null && trip.id == selectedTripId)
            ? SearchResultType.selectedTrip
            : SearchResultType.otherTrip,
        itemId: item?.id ?? tripItem.itemId,
        itemName: name,
        storageLocationName: tripItem.sourceLabelSnapshot,
        totalQuantity: item?.quantity ?? tripItem.plannedQuantity,
        unit: item?.unit ?? 'buah',
        isImportant: item?.isImportant ?? false,
        tripId: trip.id,
        tripName: trip.name,
        tripItemId: tripItem.id,
        plannedQuantity: tripItem.plannedQuantity,
        packedQuantity: tripItem.packedQuantity,
        inUseQuantity: tripItem.inUseQuantity,
        packingStatus: status,
        bagOrLocationDisplay: bagDisplay,
        lastPhysicallyConfirmedAt: tripItem.lastPhysicallyConfirmedAt,
        isPackedLast: tripItem.isPackedLast,
      );

      if (selectedTripId != null && trip.id == selectedTripId) {
        selectedTripResults.add(result);
      } else {
        otherTripResults.add(result);
      }
    }

    return UnifiedSearchResults(
      query: rawQuery,
      selectedTripResults: selectedTripResults,
      homeInventoryResults: homeResults,
      otherTripResults: otherTripResults,
    );
  }
}
