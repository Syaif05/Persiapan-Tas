import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../repositories/categories_repository.dart';
import '../repositories/inventory_repository.dart';
import '../repositories/locations_repository.dart';
import '../repositories/trips_repository.dart';
import '../repositories/trip_packing_repository.dart';
import '../repositories/trip_departure_repository.dart';
import '../repositories/schedules_repository.dart';
import '../repositories/tickets_repository.dart';
import '../repositories/reminders_repository.dart';
import '../repositories/checkpoints_repository.dart';
import '../repositories/templates_repository.dart';
import '../repositories/search_repository.dart';
import '../services/asset_storage_service.dart';
import '../services/notification_service.dart';
import '../services/backup_service.dart';

// Database Instance Singleton Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Asset Storage Service Provider
final assetStorageServiceProvider = Provider<AssetStorageService>((ref) {
  final db = ref.watch(databaseProvider);
  return AssetStorageService(db);
});

// Locations Repository Provider
final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return LocationsRepository(db);
});

// Categories Repository Provider
final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoriesRepository(db);
});

// Inventory Repository Provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryRepository(db);
});

// Stream Provider: Lokasi Simpan Aktif
final activeLocationsStreamProvider = StreamProvider<List<StorageLocationEntry>>((ref) {
  final repo = ref.watch(locationsRepositoryProvider);
  return repo.watchActiveLocations();
});

// Stream Provider: Kategori Aktif
final categoriesStreamProvider = StreamProvider<List<CategoryEntry>>((ref) {
  final repo = ref.watch(categoriesRepositoryProvider);
  return repo.watchAllCategories();
});

// Filter State Model untuk Layar Inventaris
class InventoryFilterState {
  final String searchQuery;
  final String? categoryId;
  final String? locationId;
  final bool? isImportantOnly;
  final bool includeArchived;
  final bool sortByNameAsc;

  const InventoryFilterState({
    this.searchQuery = '',
    this.categoryId,
    this.locationId,
    this.isImportantOnly,
    this.includeArchived = false,
    this.sortByNameAsc = true,
  });

  InventoryFilterState copyWith({
    String? searchQuery,
    String? categoryId,
    bool clearCategory = false,
    String? locationId,
    bool clearLocation = false,
    bool? isImportantOnly,
    bool? includeArchived,
    bool? sortByNameAsc,
  }) {
    return InventoryFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      locationId: clearLocation ? null : (locationId ?? this.locationId),
      isImportantOnly: isImportantOnly ?? this.isImportantOnly,
      includeArchived: includeArchived ?? this.includeArchived,
      sortByNameAsc: sortByNameAsc ?? this.sortByNameAsc,
    );
  }
}

// Notifier Provider untuk Filter Inventaris
class InventoryFilterNotifier extends Notifier<InventoryFilterState> {
  @override
  InventoryFilterState build() => const InventoryFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String? categoryId) {
    if (state.categoryId == categoryId) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(categoryId: categoryId);
    }
  }

  void setLocation(String? locationId) {
    if (state.locationId == locationId) {
      state = state.copyWith(clearLocation: true);
    } else {
      state = state.copyWith(locationId: locationId);
    }
  }

  void toggleImportantOnly() {
    final current = state.isImportantOnly ?? false;
    state = state.copyWith(isImportantOnly: current ? null : true);
  }

  void toggleArchived() {
    state = state.copyWith(includeArchived: !state.includeArchived);
  }

  void toggleSort() {
    state = state.copyWith(sortByNameAsc: !state.sortByNameAsc);
  }

  void reset() {
    state = const InventoryFilterState();
  }
}

final inventoryFilterProvider =
    NotifierProvider<InventoryFilterNotifier, InventoryFilterState>(
  InventoryFilterNotifier.new,
);

// Stream Provider: Daftar Barang Inventaris berdasarkan Filter Terkini
final filteredInventoryStreamProvider = StreamProvider<List<ItemWithDetails>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  final filter = ref.watch(inventoryFilterProvider);

  return repo.watchItemsWithDetails(
    searchQuery: filter.searchQuery,
    categoryId: filter.categoryId,
    locationId: filter.locationId,
    isImportantOnly: filter.isImportantOnly,
    includeArchived: filter.includeArchived,
    sortByNameAsc: filter.sortByNameAsc,
  );
});

// --- FASE 3: TRIPS & PACKING PROVIDERS ---

// Trips Repository Provider
final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final remindersRepo = ref.watch(remindersRepositoryProvider);
  return TripsRepository(db, remindersRepo);
});

// Trip Packing Repository Provider
final tripPackingRepositoryProvider = Provider<TripPackingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TripPackingRepository(db);
});

// Stream Provider: Daftar Perjalanan Berdasarkan Status
final tripsStreamProvider = StreamProvider.family<List<TripEntry>, String?>((ref, status) {
  final repo = ref.watch(tripsRepositoryProvider);
  return repo.watchTrips(status: status);
});

// Stream Provider: Detail Lengkap Perjalanan (dengan Stops, Bags, dan Summary)
final tripDetailStreamProvider = StreamProvider.family<TripWithDetails?, String>((ref, tripId) {
  final repo = ref.watch(tripsRepositoryProvider);
  return repo.watchTripWithDetails(tripId);
});

// Stream Provider: Seluruh Perjalanan Lengkap dengan Stops dan Summary
final allTripsWithDetailsStreamProvider =
    StreamProvider.family<List<TripWithDetails>, String?>((ref, status) {
  final repo = ref.watch(tripsRepositoryProvider);
  return repo.watchAllTripsWithDetails(status: status);
});

// Stream Provider: Perjalanan Terdekat / Sedang Berlangsung (untuk Layar Beranda)
final upcomingTripStreamProvider = StreamProvider<TripWithDetails?>((ref) {
  final repo = ref.watch(tripsRepositoryProvider);
  return repo.watchUpcomingTrip();
});

// Stream Provider: Bawaan Perjalanan Terfilter
final tripItemsStreamProvider =
    StreamProvider.family<List<TripItemWithDetails>, ({String tripId, PackingFilter filter})>(
        (ref, params) {
  final repo = ref.watch(tripPackingRepositoryProvider);
  return repo.watchTripItems(params.tripId, filter: params.filter);
});

// Stream Provider: Tas Perjalanan (Trip Bags)
final tripBagsStreamProvider = StreamProvider.family<List<TripBagEntry>, String>((ref, tripId) {
  final repo = ref.watch(tripPackingRepositoryProvider);
  return repo.watchTripBags(tripId);
});

// Trip Departure Repository Provider (CORE-02, CORE-03)
final tripDepartureRepositoryProvider = Provider<TripDepartureRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final packingRepo = ref.watch(tripPackingRepositoryProvider);
  return TripDepartureRepository(db, packingRepo);
});

// Stream Provider: Manifest Keberangkatan Perjalanan (CORE-03)
final departureManifestStreamProvider =
    StreamProvider.family<DepartureManifestWithDetails?, String>((ref, tripId) {
  final repo = ref.watch(tripDepartureRepositoryProvider);
  return repo.watchDepartureManifest(tripId);
});

// --- FASE 4: SCHEDULES & TICKETS PROVIDERS ---

// Schedules Repository Provider
final schedulesRepositoryProvider = Provider<SchedulesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final remindersRepo = ref.watch(remindersRepositoryProvider);
  return SchedulesRepository(db, remindersRepo);
});

// Tickets Repository Provider
final ticketsRepositoryProvider = Provider<TicketsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final storage = ref.watch(assetStorageServiceProvider);
  return TicketsRepository(db, storage);
});

// --- FASE 5: REMINDERS & NOTIFICATIONS PROVIDERS ---

// Notification Service Provider (Singleton)
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Reminders Repository Provider
final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return RemindersRepository(db, notificationService);
});

// Backup Service Provider (TECH-01)
final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  final assetService = ref.watch(assetStorageServiceProvider);
  final remindersRepo = ref.watch(remindersRepositoryProvider);
  return BackupService(db, assetService, remindersRepository: remindersRepo);
});

// Future Provider: Terakhir Ekspor Cadangan (BAK-07)
final lastBackupDateProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(backupServiceProvider);
  return service.getLastBackupDate();
});

// Stream Provider: Pengingat untuk Suatu Jadwal
final scheduleRemindersStreamProvider =
    StreamProvider.family<List<ReminderEntry>, String>((ref, scheduleEventId) {
  final repo = ref.watch(remindersRepositoryProvider);
  return repo.watchRemindersForSchedule(scheduleEventId);
});

// Future Provider: Status Izin Notifikasi & Exact Alarm
final notificationPermissionStatusProvider =
    FutureProvider<NotificationPermissionStatus>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return service.checkPermissionStatus();
});

// Stream Provider: Jadwal per Perjalanan
final tripSchedulesStreamProvider =
    StreamProvider.family<List<ScheduleEventWithDetails>, String>((ref, tripId) {
  final repo = ref.watch(schedulesRepositoryProvider);
  return repo.watchTripSchedules(tripId);
});

// Stream Provider: Agenda Kronologis Global (semua perjalanan aktif, opsional filter tanggal)
final globalAgendaStreamProvider =
    StreamProvider.family<List<ScheduleEventWithDetails>, String?>((ref, filterDate) {
  final repo = ref.watch(schedulesRepositoryProvider);
  return repo.watchGlobalAgenda(filterDate: filterDate);
});

// Stream Provider: Tiket per Perjalanan
final tripTicketsStreamProvider =
    StreamProvider.family<List<TicketWithDetails>, String>((ref, tripId) {
  final repo = ref.watch(ticketsRepositoryProvider);
  return repo.watchTripTickets(tripId);
});

// Stream Provider: Detail Tiket Tunggal
final ticketDetailStreamProvider =
    StreamProvider.family<TicketWithDetails?, String>((ref, ticketId) {
  final repo = ref.watch(ticketsRepositoryProvider);
  return repo.watchTicketById(ticketId);
});

// --- FASE 6: CHECKPOINTS & TEMPLATES PROVIDERS ---

// Checkpoints Repository Provider
final checkpointsRepositoryProvider = Provider<CheckpointsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CheckpointsRepository(db);
});

// Templates Repository Provider
final templatesRepositoryProvider = Provider<TemplatesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TemplatesRepository(db);
});

// Stream Provider: Checkpoints per Perjalanan
final tripCheckpointsStreamProvider =
    StreamProvider.family<List<CheckpointWithDetails>, String>((ref, tripId) {
  final repo = ref.watch(checkpointsRepositoryProvider);
  return repo.watchTripCheckpoints(tripId);
});

// Stream Provider: Detail Checkpoint Tunggal
final checkpointDetailStreamProvider =
    StreamProvider.family<CheckpointWithDetails?, String>((ref, checkpointId) {
  final repo = ref.watch(checkpointsRepositoryProvider);
  return repo.watchCheckpointWithDetails(checkpointId);
});

// Stream Provider: Semua Template Packing
final templatesStreamProvider = StreamProvider<List<TemplateWithDetails>>((ref) {
  final repo = ref.watch(templatesRepositoryProvider);
  return repo.watchTemplates();
});

// Stream Provider: Detail Template Tunggal
final templateDetailStreamProvider =
    StreamProvider.family<TemplateWithDetails?, String>((ref, templateId) {
  final repo = ref.watch(templatesRepositoryProvider);
  return repo.watchTemplates().map((list) {
    return list.where((t) => t.id == templateId).firstOrNull;
  });
});

// --- FASE 8: UNIFIED SEARCH PROVIDERS (FIND-01) ---

// Unified Search Repository Provider
final unifiedSearchRepositoryProvider = Provider<UnifiedSearchRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return UnifiedSearchRepository(db);
});

// Future Provider: Hasil Pencarian Terpadu (FIND-01)
final unifiedSearchProvider = FutureProvider.family<UnifiedSearchResults, ({String query, String? selectedTripId})>((ref, params) async {
  final repo = ref.watch(unifiedSearchRepositoryProvider);
  return repo.searchAcrossAll(rawQuery: params.query, selectedTripId: params.selectedTripId);
});


