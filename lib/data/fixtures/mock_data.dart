library;

/// Model dan data fixture lokal untuk prototipe Fase 1
/// Digunakan semata-mata untuk preview antarmuka pengguna
/// sesuai ketentuan PRD Bawa.

class MockStorageLocation {
  final String id;
  final String name;
  final String type; // 'box' | 'wardrobe' | 'drawer' | 'other'
  final String description;
  final int itemCount;

  const MockStorageLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.itemCount,
  });
}

class MockItem {
  final String id;
  final String name;
  final int quantity;
  final String unit;
  final String category;
  final String? storageLocationId;
  final String? storageLocationName;
  final String notes;
  final bool isImportant;
  final String? photoPlaceholder;

  const MockItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit = 'buah',
    required this.category,
    this.storageLocationId,
    this.storageLocationName,
    this.notes = '',
    this.isImportant = false,
    this.photoPlaceholder,
  });

  MockItem copyWith({
    String? name,
    int? quantity,
    String? unit,
    String? category,
    String? storageLocationId,
    String? storageLocationName,
    String? notes,
    bool? isImportant,
  }) {
    return MockItem(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      storageLocationId: storageLocationId ?? this.storageLocationId,
      storageLocationName: storageLocationName ?? this.storageLocationName,
      notes: notes ?? this.notes,
      isImportant: isImportant ?? this.isImportant,
      photoPlaceholder: photoPlaceholder,
    );
  }
}

class MockTripBag {
  final String id;
  final String name;
  final String description;

  const MockTripBag({
    required this.id,
    required this.name,
    required this.description,
  });
}

class MockTripItem {
  final String id;
  final String tripId;
  final String itemId;
  final String itemName;
  final String? sourceLocationName;
  final String decision; // 'carried' | 'not_carried'
  final int plannedQuantity;
  final int packedQuantity;
  final String? bagName;
  final bool isImportant;
  final String notes;

  const MockTripItem({
    required this.id,
    required this.tripId,
    required this.itemId,
    required this.itemName,
    this.sourceLocationName,
    this.decision = 'carried',
    required this.plannedQuantity,
    required this.packedQuantity,
    this.bagName,
    this.isImportant = false,
    this.notes = '',
  });

  bool get isCompleted => decision == 'carried' && packedQuantity >= plannedQuantity;
  bool get isPartial => decision == 'carried' && packedQuantity > 0 && packedQuantity < plannedQuantity;
  bool get isNotPacked => decision == 'carried' && packedQuantity == 0;
  bool get isNotCarried => decision == 'not_carried';

  MockTripItem copyWith({
    int? packedQuantity,
    int? plannedQuantity,
    String? decision,
    String? bagName,
    String? notes,
  }) {
    return MockTripItem(
      id: id,
      tripId: tripId,
      itemId: itemId,
      itemName: itemName,
      sourceLocationName: sourceLocationName,
      decision: decision ?? this.decision,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      packedQuantity: packedQuantity ?? this.packedQuantity,
      bagName: bagName ?? this.bagName,
      isImportant: isImportant,
      notes: notes ?? this.notes,
    );
  }
}

class MockScheduleEvent {
  final String id;
  final String tripId;
  final String tripName;
  final String title;
  final String type; // 'transport' | 'lodging' | 'activity' | 'preparation'
  final String dateText;
  final String? timeText; // null jika isDateOnly = true
  final String timeZone;
  final String location;
  final bool isDateOnly;
  final String? ticketId;

  const MockScheduleEvent({
    required this.id,
    required this.tripId,
    required this.tripName,
    required this.title,
    required this.type,
    required this.dateText,
    this.timeText,
    this.timeZone = 'Asia/Jakarta (WIB)',
    required this.location,
    this.isDateOnly = false,
    this.ticketId,
  });
}

class MockTicket {
  final String id;
  final String tripId;
  final String title;
  final String provider;
  final String? bookingCode;
  final String eventTime;
  final String origin;
  final String destination;
  final String attachmentType; // 'pdf' | 'image'
  final String attachmentName;
  final String notes;

  const MockTicket({
    required this.id,
    required this.tripId,
    required this.title,
    required this.provider,
    this.bookingCode,
    required this.eventTime,
    required this.origin,
    required this.destination,
    required this.attachmentType,
    required this.attachmentName,
    this.notes = '',
  });
}

class MockTrip {
  final String id;
  final String name;
  final String startDate;
  final String? endDate;
  final List<String> stops; // contoh: ['Bandung', 'Jakarta']
  final String status; // 'planning' | 'ongoing' | 'completed'
  final List<MockTripItem> items;
  final List<MockTripBag> bags;

  const MockTrip({
    required this.id,
    required this.name,
    required this.startDate,
    this.endDate,
    required this.stops,
    this.status = 'planning',
    required this.items,
    this.bags = const [],
  });

  int get carriedCount => items.where((i) => i.decision == 'carried').length;
  int get completedCount => items.where((i) => i.isCompleted).length;
  int get remainingCount => carriedCount - completedCount;
}

/// Kumpulan dataset fixture realistis
abstract class MockData {
  static final List<MockStorageLocation> locations = [
    const MockStorageLocation(
      id: 'loc-1',
      name: 'Kotak Elektronik',
      type: 'box',
      description: 'Rak bawah meja kerja kamar tidur',
      itemCount: 4,
    ),
    const MockStorageLocation(
      id: 'loc-2',
      name: 'Lemari Pakaian',
      type: 'wardrobe',
      description: 'Lemari kayu 2 pintu',
      itemCount: 6,
    ),
    const MockStorageLocation(
      id: 'loc-3',
      name: 'Laci Meja Kerja',
      type: 'drawer',
      description: 'Laci tengah terkunci dokumen penting',
      itemCount: 3,
    ),
  ];

  static final List<MockItem> items = [
    const MockItem(
      id: 'item-1',
      name: 'Charger USB-C 65W',
      quantity: 2,
      unit: 'buah',
      category: 'Elektronik',
      storageLocationId: 'loc-1',
      storageLocationName: 'Kotak Elektronik',
      notes: 'Warna hitam dan putih',
      isImportant: true,
    ),
    const MockItem(
      id: 'item-2',
      name: 'Powerbank 10.000 mAh',
      quantity: 1,
      unit: 'buah',
      category: 'Elektronik',
      storageLocationId: 'loc-1',
      storageLocationName: 'Kotak Elektronik',
      notes: 'Bisa dibawa ke kabin pesawat',
      isImportant: true,
    ),
    const MockItem(
      id: 'item-3',
      name: 'Kabel USB-C ke Lightning',
      quantity: 2,
      unit: 'buah',
      category: 'Elektronik',
      storageLocationId: 'loc-1',
      storageLocationName: 'Kotak Elektronik',
      notes: 'Panjang 1 meter',
    ),
    const MockItem(
      id: 'item-4',
      name: 'Kaus Hitam Polos',
      quantity: 5,
      unit: 'helai',
      category: 'Pakaian',
      storageLocationId: 'loc-2',
      storageLocationName: 'Lemari Pakaian',
      notes: 'Bahan katun combed 30s',
    ),
    const MockItem(
      id: 'item-5',
      name: 'Celana Jeans Denim',
      quantity: 2,
      unit: 'helai',
      category: 'Pakaian',
      storageLocationId: 'loc-2',
      storageLocationName: 'Lemari Pakaian',
    ),
    const MockItem(
      id: 'item-6',
      name: 'Jaket Windbreaker',
      quantity: 1,
      unit: 'buah',
      category: 'Pakaian',
      storageLocationId: 'loc-2',
      storageLocationName: 'Lemari Pakaian',
      notes: 'Tahan gerimis ringan',
    ),
    const MockItem(
      id: 'item-7',
      name: 'Paspor RI',
      quantity: 1,
      unit: 'buku',
      category: 'Dokumen',
      storageLocationId: 'loc-3',
      storageLocationName: 'Laci Meja Kerja',
      notes: 'Berlaku s/d 2031',
      isImportant: true,
    ),
    const MockItem(
      id: 'item-8',
      name: 'Kotak Obat Darurat & Parasetamol',
      quantity: 1,
      unit: 'kotak',
      category: 'Kesehatan',
      storageLocationId: 'loc-3',
      storageLocationName: 'Laci Meja Kerja',
      notes: 'Obat sakit kepala & flu',
      isImportant: true,
    ),
  ];

  static final List<MockTripBag> sampleBags = [
    const MockTripBag(id: 'bag-1', name: 'Ransel Hitam Laptop', description: 'Tas utama kabin'),
    const MockTripBag(id: 'bag-2', name: 'Tote Bag Jinjing', description: 'Barang yang sering diambil'),
  ];

  static final List<MockTripItem> tripItemsBandung = [
    const MockTripItem(
      id: 'ti-1',
      tripId: 'trip-1',
      itemId: 'item-1',
      itemName: 'Charger USB-C 65W',
      sourceLocationName: 'Kotak Elektronik',
      decision: 'carried',
      plannedQuantity: 1,
      packedQuantity: 1,
      bagName: 'Ransel Hitam Laptop',
      isImportant: true,
    ),
    const MockTripItem(
      id: 'ti-2',
      tripId: 'trip-1',
      itemId: 'item-2',
      itemName: 'Powerbank 10.000 mAh',
      sourceLocationName: 'Kotak Elektronik',
      decision: 'carried',
      plannedQuantity: 1,
      packedQuantity: 0,
      isImportant: true,
    ),
    const MockTripItem(
      id: 'ti-3',
      tripId: 'trip-1',
      itemId: 'item-4',
      itemName: 'Kaus Hitam Polos',
      sourceLocationName: 'Lemari Pakaian',
      decision: 'carried',
      plannedQuantity: 3,
      packedQuantity: 2,
      bagName: 'Ransel Hitam Laptop',
    ),
    const MockTripItem(
      id: 'ti-4',
      tripId: 'trip-1',
      itemId: 'item-8',
      itemName: 'Kotak Obat Darurat & Parasetamol',
      sourceLocationName: 'Laci Meja Kerja',
      decision: 'carried',
      plannedQuantity: 1,
      packedQuantity: 1,
      bagName: 'Tote Bag Jinjing',
      isImportant: true,
    ),
    const MockTripItem(
      id: 'ti-5',
      tripId: 'trip-1',
      itemId: 'item-6',
      itemName: 'Jaket Windbreaker',
      sourceLocationName: 'Lemari Pakaian',
      decision: 'not_carried',
      plannedQuantity: 0,
      packedQuantity: 0,
      notes: 'Cuaca Bandung diprediksi cerah hangat',
    ),
  ];

  static final List<MockScheduleEvent> scheduleEvents = [
    const MockScheduleEvent(
      id: 'ev-1',
      tripId: 'trip-1',
      tripName: 'Bandung Akhir Pekan',
      title: 'Kereta Argo Parahyangan ke Bandung',
      type: 'transport',
      dateText: '18 Okt 2026',
      timeText: '07:30 WIB',
      location: 'Stasiun Gambir (GMR) -> Stasiun Bandung (BDG)',
      ticketId: 'tkt-1',
    ),
    const MockScheduleEvent(
      id: 'ev-2',
      tripId: 'trip-1',
      tripName: 'Bandung Akhir Pekan',
      title: 'Check-in Hotel De Paviljoen',
      type: 'lodging',
      dateText: '18 Okt 2026',
      timeText: '14:00 WIB',
      location: 'Jl. R.E. Martadinata No.68, Bandung',
      ticketId: 'tkt-2',
    ),
    const MockScheduleEvent(
      id: 'ev-3',
      tripId: 'trip-1',
      tripName: 'Bandung Akhir Pekan',
      title: 'Makan Malam Keluarga',
      type: 'activity',
      dateText: '19 Okt 2026',
      timeText: '18:30 WIB',
      location: 'Dago Atas, Bandung',
    ),
    const MockScheduleEvent(
      id: 'ev-4',
      tripId: 'trip-1',
      tripName: 'Bandung Akhir Pekan',
      title: 'Packing Ulang & Persiapan Checkout',
      type: 'preparation',
      dateText: '20 Okt 2026',
      isDateOnly: true,
      location: 'Kamar Hotel',
    ),
  ];

  static final List<MockTicket> tickets = [
    const MockTicket(
      id: 'tkt-1',
      tripId: 'trip-1',
      title: 'Tiket Kereta Api Argo Parahyangan Eksekutif',
      provider: 'PT Kereta Api Indonesia (Persero)',
      bookingCode: 'KAI-88392-BDG',
      eventTime: '18 Okt 2026, 07:30 WIB',
      origin: 'Gambir (GMR)',
      destination: 'Bandung (BDG)',
      attachmentType: 'pdf',
      attachmentName: 'E-Ticket_ArgoParahyangan_18Okt.pdf',
      notes: 'Gerbong Eksekutif 2 / Kursi 11A. Tunjukkan kode QR di boarding gate.',
    ),
    const MockTicket(
      id: 'tkt-2',
      tripId: 'trip-1',
      title: 'Voucher Menginap De Paviljoen Bandung',
      provider: 'De Paviljoen Bandung',
      bookingCode: 'HTL-DPV-7712',
      eventTime: '18–20 Okt 2026 (2 Malam)',
      origin: 'Check-in 14:00',
      destination: 'Check-out 12:00',
      attachmentType: 'image',
      attachmentName: 'Voucher_Hotel_DePaviljoen.png',
      notes: 'Tipe kamar Deluxe King Room with Breakfast.',
    ),
  ];

  static final List<MockTrip> trips = [
    MockTrip(
      id: 'trip-1',
      name: 'Bandung Akhir Pekan',
      startDate: '18 Okt 2026',
      endDate: '20 Okt 2026',
      stops: const ['Bandung'],
      status: 'planning',
      items: tripItemsBandung,
      bags: sampleBags,
    ),
    const MockTrip(
      id: 'trip-2',
      name: 'Kunjungan Kerja Jakarta & Surabaya',
      startDate: '25 Okt 2026',
      endDate: '29 Okt 2026',
      stops: ['Jakarta', 'Surabaya'],
      status: 'planning',
      items: [],
      bags: [],
    ),
    const MockTrip(
      id: 'trip-3',
      name: 'Liburan Yogyakarta',
      startDate: '12 Sep 2026',
      endDate: '15 Sep 2026',
      stops: ['Yogyakarta'],
      status: 'completed',
      items: [],
      bags: [],
    ),
  ];
}
