import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';

void main() {
  late AppDatabase db;
  late TripPackingRepository packingRepo;
  late TripsRepository tripsRepo;
  late InventoryRepository inventoryRepo;

  setUp(() async {
    db = AppDatabase.inMemory();
    packingRepo = TripPackingRepository(db);
    tripsRepo = TripsRepository(db);
    inventoryRepo = InventoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('LOC-01: Model Alokasi Tas, Kantong, dan Pembagian Jumlah Barang', () {
    test('QA-09: Empat kaus dibagi dua tas berbeda dengan total alokasi konsisten', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Kaus Hitam',
        quantity: 10,
        unit: 'buah',
      );
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Jogja',
        startDate: '2026-11-20',
        stops: ['Yogyakarta'],
      );

      // Buat dua tas: Koper Kabin dan Ransel
      final koperId = await packingRepo.createTripBag(tripId, 'Koper Kabin');
      final ranselId = await packingRepo.createTripBag(tripId, 'Ransel Hitam');

      // Masukkan 4 kaus ke rencana dan kemas seluruh 4 unit
      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemRes.item.id,
        plannedQuantity: 4,
      );
      final tripItem = await packingRepo.getTripItem(tripId, itemRes.item.id);
      expect(tripItem, isNotNull);

      await packingRepo.packUnit(tripItem!.id, delta: 4);

      // Bagi alokasi: 2 di Koper Kabin, 2 di Ransel Hitam
      await packingRepo.setItemAllocations(
        tripItemId: tripItem.id,
        drafts: [
          AllocationDraft(
            targetType: 'bag',
            tripBagId: koperId,
            quantity: 2,
          ),
          AllocationDraft(
            targetType: 'bag',
            tripBagId: ranselId,
            quantity: 2,
          ),
        ],
      );

      // Verifikasi alokasi
      final allocations = await packingRepo.getItemAllocations(tripItem.id);
      expect(allocations.length, 2);
      expect(allocations.fold<int>(0, (sum, a) => sum + a.quantity), 4);
      expect(allocations.any((a) => a.bagName == 'Koper Kabin' && a.quantity == 2), isTrue);
      expect(allocations.any((a) => a.bagName == 'Ransel Hitam' && a.quantity == 2), isTrue);

      // Verifikasi bahwa master stok inventaris tetap tidak berubah
      final master = await (db.select(db.items)..where((i) => i.id.equals(itemRes.item.id))).getSingle();
      expect(master.quantity, 10);
    });

    test('QA-10: Pindah satu unit antartas dalam satu transaksi tanpa mengubah total fisik', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Kaus Putih',
        quantity: 5,
        unit: 'buah',
      );
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Malang',
        startDate: '2026-11-25',
        stops: ['Malang'],
      );

      final koperId = await packingRepo.createTripBag(tripId, 'Koper');
      final ranselId = await packingRepo.createTripBag(tripId, 'Ransel');

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemRes.item.id,
        plannedQuantity: 4,
      );
      final tripItem = await packingRepo.getTripItem(tripId, itemRes.item.id);

      await packingRepo.packUnit(tripItem!.id, delta: 4);

      // Awal: 2 di Koper, 2 di Ransel
      await packingRepo.setItemAllocations(
        tripItemId: tripItem.id,
        drafts: [
          AllocationDraft(targetType: 'bag', tripBagId: koperId, quantity: 2),
          AllocationDraft(targetType: 'bag', tripBagId: ranselId, quantity: 2),
        ],
      );

      var allocations = await packingRepo.getItemAllocations(tripItem.id);
      final koperAlloc = allocations.firstWhere((a) => a.tripBagId == koperId);

      // Pindahkan 1 unit dari Koper ke Ransel
      await packingRepo.moveAllocatedUnit(
        sourceAllocationId: koperAlloc.id,
        targetType: 'bag',
        targetBagId: ranselId,
        delta: 1,
      );

      // Verifikasi: Koper jadi 1, Ransel jadi 3, total tetap 4
      allocations = await packingRepo.getItemAllocations(tripItem.id);
      expect(allocations.length, 2);
      expect(allocations.firstWhere((a) => a.tripBagId == koperId).quantity, 1);
      expect(allocations.firstWhere((a) => a.tripBagId == ranselId).quantity, 3);
      expect(allocations.fold<int>(0, (sum, a) => sum + a.quantity), 4);

      // Verifikasi packedQuantity pada TripItems tetap 4
      final refreshedTripItem = await packingRepo.getTripItem(tripId, itemRes.item.id);
      expect(refreshedTripItem!.packedQuantity, 4);
    });

    test('QA-11: Alokasi pada badan (on_person) atau tanpa tas (unspecified) sah tanpa memalsukan tas bernama', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Dompet & KTP',
        quantity: 1,
        unit: 'buah',
      );
      final tripId = await tripsRepo.createTrip(
        name: 'Perjalanan Solo',
        startDate: '2026-11-28',
        stops: ['Solo'],
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemRes.item.id,
        plannedQuantity: 1,
      );
      final tripItem = await packingRepo.getTripItem(tripId, itemRes.item.id);

      // Kemas langsung ke badan (on_person)
      await packingRepo.packUnit(tripItem!.id, delta: 1, targetType: 'on_person');

      final allocations = await packingRepo.getItemAllocations(tripItem.id);
      expect(allocations.length, 1);
      expect(allocations.first.targetType, 'on_person');
      expect(allocations.first.tripBagId, isNull);
      expect(allocations.first.displayLocation, 'Dipakai di badan');

      // Validasi constraint: on_person tidak boleh diberi bagId
      await expectLater(
        packingRepo.setItemAllocations(
          tripItemId: tripItem.id,
          drafts: [
            const AllocationDraft(
              targetType: 'on_person',
              tripBagId: 'dummy-bag-id',
              quantity: 1,
            ),
          ],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('QA-12: Hapus tas dengan alokasi aktif menyelesaikan alokasi tanpa orphan data', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Jaket Parasut',
        quantity: 2,
        unit: 'buah',
      );
      final tripId = await tripsRepo.createTrip(
        name: 'Trip Bromo',
        startDate: '2026-12-05',
        stops: ['Bromo'],
      );

      final duffelBagId = await packingRepo.createTripBag(tripId, 'Duffel Bag');

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemRes.item.id,
        plannedQuantity: 2,
      );
      final tripItem = await packingRepo.getTripItem(tripId, itemRes.item.id);

      // Kemas 2 unit ke Duffel Bag
      await packingRepo.packUnit(tripItem!.id, delta: 2, tripBagId: duffelBagId);

      var allocations = await packingRepo.getItemAllocations(tripItem.id);
      expect(allocations.first.bagName, 'Duffel Bag');

      // Hapus tas dengan resolusi 'move_to_unspecified'
      await packingRepo.deleteTripBagSafely(duffelBagId, resolution: 'move_to_unspecified');

      // Verifikasi tas sudah terhapus
      final bags = await (db.select(db.tripBags)..where((b) => b.id.equals(duffelBagId))).get();
      expect(bags.isEmpty, isTrue);

      // Alokasi tidak menjadi orphan atau hilang, melainkan berpindah ke unspecified
      allocations = await packingRepo.getItemAllocations(tripItem.id);
      expect(allocations.length, 1);
      expect(allocations.first.targetType, 'unspecified');
      expect(allocations.first.tripBagId, isNull);
      expect(allocations.first.quantity, 2);
      expect(allocations.first.displayLocation, 'Lokasi tas belum dicatat');
    });

    test('Kompartemen tas: buat kantong depan dan alokasikan unit ke kompartemen', () async {
      final itemRes = await inventoryRepo.createItem(
        name: 'Paspor',
        quantity: 1,
        unit: 'buah',
      );
      final tripId = await tripsRepo.createTrip(
        name: 'Perjalanan Luar Negeri',
        startDate: '2026-12-10',
        stops: ['Kuala Lumpur'],
      );

      final bagId = await packingRepo.createTripBag(tripId, 'Ransel');
      final comp = await packingRepo.createBagCompartment(
        tripBagId: bagId,
        name: 'Kantong Depan',
      );

      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: itemRes.item.id,
        plannedQuantity: 1,
      );
      final tripItem = await packingRepo.getTripItem(tripId, itemRes.item.id);

      await packingRepo.packUnit(
        tripItem!.id,
        delta: 1,
        tripBagId: bagId,
        compartmentId: comp.id,
      );

      final allocations = await packingRepo.getItemAllocations(tripItem.id);
      expect(allocations.length, 1);
      expect(allocations.first.bagName, 'Ransel');
      expect(allocations.first.compartmentName, 'Kantong Depan');
      expect(allocations.first.displayLocation, 'Ransel → Kantong Depan');
    });
  });
}
