import 'package:drift/drift.dart';

// 1. Lokasi Penyimpanan Fisik (Kotak, Lemari, Laci, dll)
@DataClassName('StorageLocationEntry')
class StorageLocations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'box' | 'wardrobe' | 'drawer' | 'other'
  TextColumn get description => text().nullable()();
  TextColumn get photoAssetId => text().nullable()();
  TextColumn get archivedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Kategori Barang
@DataClassName('CategoryEntry')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().customConstraint('NOT NULL UNIQUE')();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. File Asset Terisolasi (Foto Barang, Tiket, Foto Lokasi)
@DataClassName('AssetEntry')
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get relativePath => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get sha256 => text()();
  TextColumn get originalName => text()();
  TextColumn get kind => text()(); // 'item_photo' | 'ticket_attachment' | 'location_photo'
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Inventaris Barang Master
@DataClassName('ItemEntry')
class Items extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 150)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get unit => text().withDefault(const Constant('buah'))();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get storageLocationId => text().nullable().references(StorageLocations, #id)();
  TextColumn get notes => text().nullable()();
  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();
  TextColumn get archivedAt => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Relasi Foto Barang (1 foto utama + hingga 4 foto tambahan)
@DataClassName('ItemPhotoEntry')
class ItemPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text().references(Items, #id, onDelete: KeyAction.cascade)();
  TextColumn get assetId => text().references(Assets, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Perjalanan
@DataClassName('TripEntry')
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get startDate => text()(); // YYYY-MM-DD
  TextColumn get endDate => text().nullable()(); // YYYY-MM-DD
  TextColumn get dateZoneId => text()();
  TextColumn get status => text().withDefault(const Constant('planning'))(); // 'planning' | 'ongoing' | 'completed' | 'cancelled'
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Titik Tujuan Perjalanan (Multi-kota, berulang)
@DataClassName('TripStopEntry')
class TripStops extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get arrivalLocal => text().nullable()();
  TextColumn get arrivalZone => text().nullable()();
  TextColumn get departureLocal => text().nullable()();
  TextColumn get departureZone => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 8. Tas Perjalanan (Opsional per perjalanan)
@DataClassName('TripBagEntry')
class TripBags extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 8b. Kompartemen / Kantong Tas Perjalanan (LOC-01)
@DataClassName('BagCompartmentEntry')
class BagCompartments extends Table {
  TextColumn get id => text()();
  TextColumn get tripBagId => text().references(TripBags, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()(); // e.g. 'Kantong depan', 'Ruang utama'
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// 9. Bawaan Perjalanan (Status packing lokal per perjalanan)
@DataClassName('TripItemEntry')
class TripItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemId => text().references(Items, #id)();
  TextColumn get decision => text().withDefault(const Constant('carried'))(); // 'carried' | 'not_carried'
  IntColumn get plannedQuantity => integer().withDefault(const Constant(1))();
  IntColumn get packedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get inUseQuantity => integer().withDefault(const Constant(0))(); // Sedang dipakai (CORE-01)
  TextColumn get tripBagId => text().nullable().references(TripBags, #id)();
  TextColumn get notes => text().nullable()();
  TextColumn get nameSnapshot => text()();
  TextColumn get sourceLabelSnapshot => text().nullable()();
  TextColumn get lastPhysicallyConfirmedAt => text().nullable()(); // Waktu konfirmasi fisik terpisah dari updatedAt (CORE-01)
  TextColumn get departureCheckConfirmedAt => text().nullable()(); // Waktu konfirmasi dalam pemeriksaan keberangkatan (CORE-02)
  BoolColumn get isPackedLast => boolean().withDefault(const Constant(false))(); // Disiapkan terakhir (PACK-01)
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tripId, itemId},
  ];
}

// 9b. Alokasi Fisik Unit Bawaan per Tas/Kantong/Badan (LOC-01)
@DataClassName('ItemAllocationEntry')
class ItemAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get tripItemId => text().references(TripItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetType => text().withDefault(const Constant('bag'))(); // 'bag' | 'on_person' | 'in_hand' | 'unspecified'
  TextColumn get tripBagId => text().nullable().references(TripBags, #id, onDelete: KeyAction.setNull)();
  TextColumn get compartmentId => text().nullable().references(BagCompartments, #id, onDelete: KeyAction.setNull)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();
  TextColumn get lastConfirmedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 10. Jadwal / Kegiatan
@DataClassName('ScheduleEventEntry')
class ScheduleEvents extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get tripStopId => text().nullable().references(TripStops, #id)();
  TextColumn get title => text()();
  TextColumn get type => text()(); // 'transport' | 'lodging' | 'activity' | 'preparation' | 'other'
  BoolColumn get isDateOnly => boolean().withDefault(const Constant(false))();
  TextColumn get localDate => text()();
  TextColumn get localStart => text().nullable()();
  TextColumn get startZone => text().nullable()();
  TextColumn get startUtc => text().nullable()();
  TextColumn get localEnd => text().nullable()();
  TextColumn get endZone => text().nullable()();
  TextColumn get endUtc => text().nullable()();
  TextColumn get locationText => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('planned'))();

  @override
  Set<Column> get primaryKey => {id};
}

// 11. Tiket & Reservasi
@DataClassName('TicketEntry')
class Tickets extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get scheduleEventId => text().nullable().references(ScheduleEvents, #id)();
  TextColumn get title => text()();
  TextColumn get provider => text().nullable()();
  TextColumn get bookingCode => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 12. Lampiran Tiket
@DataClassName('TicketAttachmentEntry')
class TicketAttachments extends Table {
  TextColumn get id => text()();
  TextColumn get ticketId => text().references(Tickets, #id, onDelete: KeyAction.cascade)();
  TextColumn get assetId => text().references(Assets, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// 13. Pengingat Lokal
@DataClassName('ReminderEntry')
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get scheduleEventId => text().references(ScheduleEvents, #id, onDelete: KeyAction.cascade)();
  TextColumn get triggerUtc => text()();
  IntColumn get notificationId => integer().customConstraint('NOT NULL UNIQUE')();
  TextColumn get precisionPreference => text().withDefault(const Constant('exact'))(); // 'exact' | 'inexact'
  TextColumn get schedulingState => text().withDefault(const Constant('active'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// 14. Checkpoint Pulang / Perpindahan
@DataClassName('ReturnCheckpointEntry')
class ReturnCheckpoints extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get tripStopId => text().nullable().references(TripStops, #id)();
  TextColumn get title => text()();
  TextColumn get createdAt => text()();
  TextColumn get closedAt => text().nullable()();
  TextColumn get closeState => text().withDefault(const Constant('open'))(); // 'open' | 'completed' | 'closed_with_unconfirmed'

  @override
  Set<Column> get primaryKey => {id};
}

// 15. Item Entri Checkpoint Pulang
@DataClassName('ReturnEntryEntry')
class ReturnEntries extends Table {
  TextColumn get id => text()();
  TextColumn get checkpointId => text().references(ReturnCheckpoints, #id, onDelete: KeyAction.cascade)();
  TextColumn get tripItemId => text().references(TripItems, #id)();
  TextColumn get nameSnapshot => text()();
  IntColumn get expectedQuantity => integer()();
  IntColumn get returnedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get consumedQuantity => integer().withDefault(const Constant(0))();
  IntColumn get leftQuantity => integer().withDefault(const Constant(0))();
  IntColumn get lostQuantity => integer().withDefault(const Constant(0))(); // Hilang dikonfirmasi (CORE-04)
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 16. Template Packing
@DataClassName('PackingTemplateEntry')
class PackingTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 17. Item Template Packing
@DataClassName('TemplateItemEntry')
class TemplateItems extends Table {
  TextColumn get id => text()();
  TextColumn get templateId => text().references(PackingTemplates, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemId => text().references(Items, #id)();
  IntColumn get plannedQuantity => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {templateId, itemId},
  ];
}

// 18. Pengaturan Aplikasi
@DataClassName('AppSettingEntry')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// 19. Manifest Keberangkatan Fisik (CORE-03)
@DataClassName('DepartureManifestEntry')
class DepartureManifests extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get departureNotes => text().nullable()(); // Pengecualian / catatan keberangkatan
  BoolColumn get isDepartedWithIssues => boolean().withDefault(const Constant(false))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get sourceLabel => text().withDefault(const Constant('departure_check'))(); // 'departure_check' | 'legacy_packing_record' | 'manual_correction'
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// 20. Rincian Barang dalam Manifest Keberangkatan (CORE-03)
@DataClassName('DepartureManifestItemEntry')
class DepartureManifestItems extends Table {
  TextColumn get id => text()();
  TextColumn get manifestId => text().references(DepartureManifests, #id, onDelete: KeyAction.cascade)();
  TextColumn get tripItemId => text().nullable()(); // Nullable agar pengeditan live trip item tidak cascade wipe snapshot historis
  TextColumn get itemId => text().nullable()(); // Nullable agar arsip/hapus master item tidak merusak snapshot
  TextColumn get itemNameSnapshot => text()();
  TextColumn get itemUnitSnapshot => text().withDefault(const Constant('buah'))();
  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();
  TextColumn get storageLocationSnapshot => text().nullable()();
  IntColumn get plannedQuantity => integer().withDefault(const Constant(1))();
  IntColumn get carriedQuantity => integer().withDefault(const Constant(0))(); // Jumlah fisik yang dikonfirmasi benar-benar berangkat
  IntColumn get deficiencyQuantity => integer().withDefault(const Constant(0))(); // planned - carried saat berangkat dengan catatan
  TextColumn get allocationsSnapshot => text().nullable()(); // JSON ringkasan alokasi wadah keberangkatan
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

