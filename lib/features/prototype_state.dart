import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/fixtures/mock_data.dart';

/// State untuk mengontrol interaksi prototipe Fase 1 secara reaktif
class PrototypeState {
  final List<MockTripItem> tripItems;
  final List<MockItem> inventoryItems;
  final List<MockStorageLocation> locations;
  final List<MockTrip> trips;
  final List<MockScheduleEvent> events;
  final List<MockTicket> tickets;
  final bool showEmptyState; // Mode toggle untuk preview Empty State

  const PrototypeState({
    required this.tripItems,
    required this.inventoryItems,
    required this.locations,
    required this.trips,
    required this.events,
    required this.tickets,
    this.showEmptyState = false,
  });

  PrototypeState copyWith({
    List<MockTripItem>? tripItems,
    List<MockItem>? inventoryItems,
    List<MockStorageLocation>? locations,
    List<MockTrip>? trips,
    List<MockScheduleEvent>? events,
    List<MockTicket>? tickets,
    bool? showEmptyState,
  }) {
    return PrototypeState(
      tripItems: tripItems ?? this.tripItems,
      inventoryItems: inventoryItems ?? this.inventoryItems,
      locations: locations ?? this.locations,
      trips: trips ?? this.trips,
      events: events ?? this.events,
      tickets: tickets ?? this.tickets,
      showEmptyState: showEmptyState ?? this.showEmptyState,
    );
  }
}

class PrototypeNotifier extends Notifier<PrototypeState> {
  @override
  PrototypeState build() {
    return PrototypeState(
      tripItems: List.from(MockData.tripItemsBandung),
      inventoryItems: List.from(MockData.items),
      locations: List.from(MockData.locations),
      trips: List.from(MockData.trips),
      events: List.from(MockData.scheduleEvents),
      tickets: List.from(MockData.tickets),
      showEmptyState: false,
    );
  }

  // Toggle mode empty-state untuk memeriksa kelayakan UI keadaan kosong
  void toggleEmptyState() {
    state = state.copyWith(showEmptyState: !state.showEmptyState);
  }

  // Centang cepat packing
  MockTripItem? togglePacking(String tripItemId) {
    final index = state.tripItems.indexWhere((i) => i.id == tripItemId);
    if (index == -1) return null;

    final current = state.tripItems[index];
    final int newPacked;
    if (current.isCompleted) {
      newPacked = 0; // uncheck
    } else {
      newPacked = current.plannedQuantity; // check all
    }

    final updated = current.copyWith(packedQuantity: newPacked);
    final newList = List<MockTripItem>.from(state.tripItems);
    newList[index] = updated;

    state = state.copyWith(tripItems: newList);
    return current; // return previous state for undo
  }

  // Restore previous state (Undo)
  void restoreTripItem(MockTripItem previous) {
    final index = state.tripItems.indexWhere((i) => i.id == previous.id);
    if (index != -1) {
      final newList = List<MockTripItem>.from(state.tripItems);
      newList[index] = previous;
      state = state.copyWith(tripItems: newList);
    }
  }

  // Update packed quantity eksplisit
  void setPackedQuantity(String tripItemId, int quantity) {
    final index = state.tripItems.indexWhere((i) => i.id == tripItemId);
    if (index != -1) {
      final current = state.tripItems[index];
      final clamped = quantity.clamp(0, current.plannedQuantity);
      final updated = current.copyWith(packedQuantity: clamped);
      final newList = List<MockTripItem>.from(state.tripItems);
      newList[index] = updated;
      state = state.copyWith(tripItems: newList);
    }
  }

  // Ubah keputusan bawaan (dengan konfirmasi reset jika sudah dikemas)
  void setDecision(String tripItemId, String decision) {
    final index = state.tripItems.indexWhere((i) => i.id == tripItemId);
    if (index != -1) {
      final current = state.tripItems[index];
      final updated = current.copyWith(
        decision: decision,
        packedQuantity: decision == 'not_carried' ? 0 : current.packedQuantity,
        plannedQuantity: decision == 'not_carried' ? 0 : (current.plannedQuantity == 0 ? 1 : current.plannedQuantity),
      );
      final newList = List<MockTripItem>.from(state.tripItems);
      newList[index] = updated;
      state = state.copyWith(tripItems: newList);
    }
  }

  // Tambah barang baru ke inventaris
  void addInventoryItem(MockItem item) {
    state = state.copyWith(inventoryItems: [item, ...state.inventoryItems]);
  }

  // Tambah perjalanan baru
  void addTrip(MockTrip trip) {
    state = state.copyWith(trips: [trip, ...state.trips]);
  }

  // Tambah jadwal
  void addScheduleEvent(MockScheduleEvent event) {
    state = state.copyWith(events: [...state.events, event]);
  }

  // Tambah tiket
  void addTicket(MockTicket ticket) {
    state = state.copyWith(tickets: [...state.tickets, ticket]);
  }
}

final prototypeProvider = NotifierProvider<PrototypeNotifier, PrototypeState>(PrototypeNotifier.new);
