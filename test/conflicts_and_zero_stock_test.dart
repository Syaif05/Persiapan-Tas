import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/checkpoints_repository.dart';
import 'package:bawa/data/repositories/trip_departure_repository.dart';

void main() {
  late AppDatabase db;
  late InventoryRepository inventoryRepo;
  late TripsRepository tripsRepo;
  late TripPackingRepository packingRepo;
  late CheckpointsRepository checkpointsRepo;
  late TripDepartureRepository departureRepo;

  setUp(() {
    db = AppDatabase.inMemory();
    inventoryRepo = InventoryRepository(db);
    tripsRepo = TripsRepository(db);
    packingRepo = TripPackingRepository(db);
    checkpointsRepo = CheckpointsRepository(db);
    departureRepo = TripDepartureRepository(db, packingRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('Tahap 6: QA-28 .. QA-35 Konflik Simultan & Stok Master Nol', () {
    test('QA-28: Stok obat disesuaikan ke nol setelah persetujuan (riwayat tetap, rencana baru positif ditolak)', () async {
      // 1. Buat barang obat dengan stok 2
      final med = await inventoryRepo.createItem(
        name: 'Paracetamol 500mg',
        quantity: 2,
        unit: 'strip',
      );
      expect(med.item.quantity, 2);

      // 2. Buat perjalanan & bawa 2 strip
      final tripId = await tripsRepo.createTrip(
        name: 'Perjalanan Bandung',
        startDate: '2026-10-10',
        endDate: '2026-10-12',
        stops: ['Bandung'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: med.item.id,
        plannedQuantity: 2,
      );
      final tripItem = await packingRepo.getTripItem(tripId, med.item.id);
      await packingRepo.packUnit(tripItem!.id, delta: 2);

      // Berangkatkan trip agar ada manifest
      await departureRepo.startTripAndCreateManifest(tripId: tripId);

      // 3. Buat checkpoint kepulangan: 2 strip habis diminum
      final cpId = await checkpointsRepo.createCheckpoint(tripId: tripId, title: 'Cek Pulang');
      final cpDetails = await checkpointsRepo.getCheckpointWithDetails(cpId);
      final entry = cpDetails!.entries.first;

      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 0,
        consumedQuantity: 2,
        leftQuantity: 0,
        lostQuantity: 0,
      );

      // 4. Periksa proposal penyesuaian stok
      final proposals = await checkpointsRepo.getStockAdjustmentProposals(cpId);
      expect(proposals.length, 1);
      expect(proposals.first.itemName, 'Paracetamol 500mg');
      expect(proposals.first.currentStock, 2);
      expect(proposals.first.totalReduction, 2);
      expect(proposals.first.proposedStock, 0);

      // 5. Terapkan penyesuaian stok dengan persetujuan pengguna
      await checkpointsRepo.applyStockAdjustments(proposals);
      await checkpointsRepo.closeCheckpoint(cpId);

      // 6. Verifikasi master stock sekarang 0 dan riwayat tetap ada
      final updatedMed = await inventoryRepo.getItemWithDetailsById(med.item.id);
      expect(updatedMed, isNotNull);
      expect(updatedMed!.item.quantity, 0);

      // 7. Rencana perjalanan baru dengan jumlah positif ditolak karena stok habis
      final trip2Id = await tripsRepo.createTrip(
        name: 'Perjalanan Jakarta',
        startDate: '2026-10-20',
        endDate: '2026-10-22',
        stops: ['Jakarta'],
      );

      expect(
        () => packingRepo.setPlannedItem(
          tripId: trip2Id,
          itemId: med.item.id,
          plannedQuantity: 1,
        ),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Stok barang "Paracetamol 500mg" saat ini 0'),
        )),
      );
    });

    test('QA-29: Turunkan stok di bawah rencana perjalanan lama (rencana dipertahankan & ditandai perlu ditinjau)', () async {
      // 1. Buat master barang stok 3
      final item = await inventoryRepo.createItem(
        name: 'Kabel HDMI',
        quantity: 3,
        unit: 'buah',
      );

      // 2. Rencanakan perjalanan dengan membawa 3 kabel
      final tripId = await tripsRepo.createTrip(
        name: 'Presentasi Proyek',
        startDate: '2026-11-01',
        endDate: '2026-11-03',
        stops: ['Surabaya'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripId,
        itemId: item.item.id,
        plannedQuantity: 3,
      );

      // 3. Stok master diturunkan menjadi 1 (misal 2 kabel rusak di rumah)
      await inventoryRepo.updateItem(
        id: item.item.id,
        name: 'Kabel HDMI',
        quantity: 1,
        unit: 'buah',
      );

      // 4. Verifikasi rencana perjalanan lama TIDAK dipotong diam-diam
      final tripItem = await packingRepo.getTripItem(tripId, item.item.id);
      expect(tripItem, isNotNull);
      expect(tripItem!.plannedQuantity, 3); // Rencana tetap 3

      // 5. Verifikasi checkItemConflict menandai perlunya tinjauan stok
      final conflict = await packingRepo.checkItemConflictResult(tripId, item.item.id, 3);
      expect(conflict, isNotNull);
      expect(conflict!.hasConflict, isTrue);
      expect(conflict.isUnderstockedReviewNeeded, isTrue);
      expect(conflict.deficiency, 2);
      expect(conflict.message, contains('Perlu ditinjau: Rencana membawa (3 buah) melebihi stok master terkini (1 buah, kurang 2)'));
    });

    test('QA-30: Dua perjalanan overlap melebihi stok (peringatan menampilkan tanggal dan kekurangan)', () async {
      // Stok inventaris = 2
      final item = await inventoryRepo.createItem(
        name: 'Power Bank 20000mAh',
        quantity: 2,
        unit: 'unit',
      );

      // Perjalanan 1: 2026-10-01 s/d 2026-10-05 butuh 2
      final trip1Id = await tripsRepo.createTrip(
        name: 'Trip A',
        startDate: '2026-10-01',
        endDate: '2026-10-05',
        stops: ['Kota A'],
      );
      await packingRepo.setPlannedItem(
        tripId: trip1Id,
        itemId: item.item.id,
        plannedQuantity: 2,
      );

      // Perjalanan 2: 2026-10-03 s/d 2026-10-07 butuh 1
      final trip2Id = await tripsRepo.createTrip(
        name: 'Trip B',
        startDate: '2026-10-03',
        endDate: '2026-10-07',
        stops: ['Kota B'],
      );
      await packingRepo.setPlannedItem(
        tripId: trip2Id,
        itemId: item.item.id,
        plannedQuantity: 1,
      );

      // Periksa dari sudut pandang Trip 2
      final result = await packingRepo.checkItemConflictResult(trip2Id, item.item.id, 1);
      expect(result, isNotNull);
      expect(result!.hasConflict, isTrue);
      expect(result.peakSimultaneousDemand, 3);
      expect(result.deficiency, 1);
      expect(result.conflictingDateRanges, contains('2026-10-03 s/d 2026-10-05'));
      expect(result.conflictingTripNames, contains('Trip A'));
      expect(result.message, contains('Potensi bentrok: Dibutuhkan puncak 3 unit (stok: 2, kurang 1) pada tanggal 2026-10-03 s/d 2026-10-05 bersama perjalanan "Trip A"'));
    });

    test('QA-31: Algoritma simultan (A panjang 1-10 butuh 1, B awal 1-3 butuh 1, C akhir 8-10 butuh 1; stok 2 -> TIDAK ada konflik palsu)', () async {
      // Stok = 2
      final item = await inventoryRepo.createItem(
        name: 'Tripod Kamera',
        quantity: 2,
        unit: 'buah',
      );

      // A: 2026-10-01 s/d 2026-10-10 butuh 1
      final tripAId = await tripsRepo.createTrip(
        name: 'Trip A',
        startDate: '2026-10-01',
        endDate: '2026-10-10',
        stops: ['A'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripAId,
        itemId: item.item.id,
        plannedQuantity: 1,
      );

      // B: 2026-10-01 s/d 2026-10-03 butuh 1
      final tripBId = await tripsRepo.createTrip(
        name: 'Trip B',
        startDate: '2026-10-01',
        endDate: '2026-10-03',
        stops: ['B'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripBId,
        itemId: item.item.id,
        plannedQuantity: 1,
      );

      // C: 2026-10-08 s/d 2026-10-10 butuh 1
      final tripCId = await tripsRepo.createTrip(
        name: 'Trip C',
        startDate: '2026-10-08',
        endDate: '2026-10-10',
        stops: ['C'],
      );
      await packingRepo.setPlannedItem(
        tripId: tripCId,
        itemId: item.item.id,
        plannedQuantity: 1,
      );

      // Cek dari sudut pandang Trip A: Permintaan puncak maksimum pada interval adalah 2 <= 2 stok.
      final resultA = await packingRepo.checkItemConflictResult(tripAId, item.item.id, 1);
      expect(resultA, isNotNull);
      expect(resultA!.hasConflict, isFalse, reason: 'Peak demand adalah 2, stok ada 2. Bukan konflik 3 unit!');
      expect(resultA.peakSimultaneousDemand, 2);
      expect(resultA.deficiency, 0);
    });

    test('QA-32: Tambah D (2-9 butuh 1) yang overlap B dan C -> konflik muncul hanya pada rentang permintaan berlebih', () async {
      // Stok = 2
      final item = await inventoryRepo.createItem(
        name: 'Lensa Tele',
        quantity: 2,
        unit: 'buah',
      );

      // A: 1-10 butuh 1
      final tripAId = await tripsRepo.createTrip(name: 'Trip A', startDate: '2026-10-01', endDate: '2026-10-10', stops: ['A']);
      await packingRepo.setPlannedItem(tripId: tripAId, itemId: item.item.id, plannedQuantity: 1);

      // B: 1-3 butuh 1
      final tripBId = await tripsRepo.createTrip(name: 'Trip B', startDate: '2026-10-01', endDate: '2026-10-03', stops: ['B']);
      await packingRepo.setPlannedItem(tripId: tripBId, itemId: item.item.id, plannedQuantity: 1);

      // C: 8-10 butuh 1
      final tripCId = await tripsRepo.createTrip(name: 'Trip C', startDate: '2026-10-08', endDate: '2026-10-10', stops: ['C']);
      await packingRepo.setPlannedItem(tripId: tripCId, itemId: item.item.id, plannedQuantity: 1);

      // D: 2-9 butuh 1
      final tripDId = await tripsRepo.createTrip(name: 'Trip D', startDate: '2026-10-02', endDate: '2026-10-09', stops: ['D']);
      await packingRepo.setPlannedItem(tripId: tripDId, itemId: item.item.id, plannedQuantity: 1);

      // Evaluasi dari sudut pandang Trip A:
      // Overlap berlebih (demand = 3 > 2) terjadi pada:
      // 2-3 (A+B+D = 3) dan 8-9 (A+C+D = 3)
      final resultA = await packingRepo.checkItemConflictResult(tripAId, item.item.id, 1);
      expect(resultA, isNotNull);
      expect(resultA!.hasConflict, isTrue);
      expect(resultA.peakSimultaneousDemand, 3);
      expect(resultA.deficiency, 1);
      expect(resultA.conflictingDateRanges, ['2026-10-02 s/d 2026-10-03', '2026-10-08 s/d 2026-10-09']);
      expect(resultA.conflictingTripNames, containsAll(['Trip B', 'Trip D', 'Trip C']));
    });

    test('QA-33: Tanggal akhir kosong menghasilkan ketidakpastian, bukan aman otomatis', () async {
      final item = await inventoryRepo.createItem(
        name: 'Jaket Gunung',
        quantity: 1,
        unit: 'buah',
      );

      // Trip 1 tanpa tanggal selesai (fleksibel)
      final trip1Id = await tripsRepo.createTrip(
        name: 'Eksplorasi Alam',
        startDate: '2026-10-05',
        endDate: null,
        stops: ['Gunung'],
      );
      await packingRepo.setPlannedItem(tripId: trip1Id, itemId: item.item.id, plannedQuantity: 1);

      // Trip 2 mulai 2026-10-07
      final trip2Id = await tripsRepo.createTrip(
        name: 'Pendakian Singkat',
        startDate: '2026-10-07',
        endDate: '2026-10-09',
        stops: ['Bukit'],
      );
      await packingRepo.setPlannedItem(tripId: trip2Id, itemId: item.item.id, plannedQuantity: 1);

      final result = await packingRepo.checkItemConflictResult(trip2Id, item.item.id, 1);
      expect(result, isNotNull);
      expect(result!.hasConflict, isTrue);
      expect(result.isUncertainDate, isTrue);
      expect(result.message, contains('Belum dapat memastikan ketersediaan'));
    });

    test('QA-34: Perjalanan berurutan tanpa overlap (tidak bentrok stok, tapi peringatan ketersediaan bila ada unit belum terkonfirmasi)', () async {
      final item = await inventoryRepo.createItem(
        name: 'Adaptor Colokan Universal',
        quantity: 1,
        unit: 'buah',
      );

      // Trip A: 2026-10-14 s/d 2026-10-16
      final tripAId = await tripsRepo.createTrip(
        name: 'Trip A (14-16)',
        startDate: '2026-10-14',
        endDate: '2026-10-16',
        stops: ['A'],
      );
      await packingRepo.setPlannedItem(tripId: tripAId, itemId: item.item.id, plannedQuantity: 1);
      final tripAItem = await packingRepo.getTripItem(tripAId, item.item.id);
      await packingRepo.packUnit(tripAItem!.id, delta: 1);
      await departureRepo.startTripAndCreateManifest(tripId: tripAId);

      // Trip B: 2026-10-17 s/d 2026-10-18 (berurutan tanpa overlap)
      final tripBId = await tripsRepo.createTrip(
        name: 'Trip B (17-18)',
        startDate: '2026-10-17',
        endDate: '2026-10-18',
        stops: ['B'],
      );
      await packingRepo.setPlannedItem(tripId: tripBId, itemId: item.item.id, plannedQuantity: 1);

      // Kasus 1: Trip A punya checkpoint dengan unconfirmed item
      final cpAId = await checkpointsRepo.createCheckpoint(tripId: tripAId, title: 'Cek Trip A');
      final cpA = await checkpointsRepo.getCheckpointWithDetails(cpAId);
      // Set returnedQuantity: 0 sehingga unconfirmed = 1
      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: cpA!.entries.first.id,
        returnedQuantity: 0,
        consumedQuantity: 0,
        leftQuantity: 0,
        lostQuantity: 0,
      );
      await checkpointsRepo.closeCheckpoint(cpAId);

      // Evaluasi Trip B: Deteksi barang belum terkonfirmasi dari Trip A
      final resultUnconfirmed = await packingRepo.checkItemConflictResult(tripBId, item.item.id, 1);
      expect(resultUnconfirmed, isNotNull);
      expect(resultUnconfirmed!.hasConflict, isTrue);
      expect(resultUnconfirmed.hasUnconfirmedFromPreviousTrip, isTrue);
      expect(resultUnconfirmed.message, contains('Ketersediaan belum dikonfirmasi: Masih ada 1 unit belum ditemukan pada pemeriksaan perjalanan sebelumnya ("Trip A (14-16)")'));

      // Kasus 2: Semua unit pada Trip A telah terkonfirmasi kembali
      final cpDetails = await checkpointsRepo.getCheckpointWithDetails(cpAId);
      final entry = cpDetails!.entries.first;
      await checkpointsRepo.updateReturnEntryQuantities(
        entryId: entry.id,
        returnedQuantity: 1,
        consumedQuantity: 0,
        leftQuantity: 0,
        lostQuantity: 0,
      );

      // Evaluasi ulang Trip B: Tidak ada konflik tanggal dan ketersediaan aman
      final resultClean = await packingRepo.checkItemConflictResult(tripBId, item.item.id, 1);
      expect(resultClean, isNotNull);
      expect(resultClean!.hasConflict, isFalse, reason: 'Interval berurutan 14-16 dan 17-18 tidak overlap dan barang sudah kembali');
    });

    test('QA-35: Batalkan perjalanan (permintaan stok aktif tidak tertinggal)', () async {
      final item = await inventoryRepo.createItem(
        name: 'Kacamata Renang',
        quantity: 1,
        unit: 'buah',
      );

      final trip1Id = await tripsRepo.createTrip(
        name: 'Trip 1',
        startDate: '2026-10-10',
        endDate: '2026-10-15',
        stops: ['Pantai'],
      );
      await packingRepo.setPlannedItem(tripId: trip1Id, itemId: item.item.id, plannedQuantity: 1);

      final trip2Id = await tripsRepo.createTrip(
        name: 'Trip 2',
        startDate: '2026-10-12',
        endDate: '2026-10-14',
        stops: ['Kolam'],
      );
      await packingRepo.setPlannedItem(tripId: trip2Id, itemId: item.item.id, plannedQuantity: 1);

      // Sebelum Trip 1 dibatalkan: bentrok karena stok 1 dipakai di 2 trip overlap
      final beforeCancel = await packingRepo.checkItemConflictResult(trip2Id, item.item.id, 1);
      expect(beforeCancel!.hasConflict, isTrue);

      // Batalkan Trip 1 (QA-35)
      await tripsRepo.updateTripStatus(trip1Id, 'cancelled');

      // Evaluasi ulang Trip 2: Trip 1 yang dibatalkan tidak lagi memesan stok
      final afterCancel = await packingRepo.checkItemConflictResult(trip2Id, item.item.id, 1);
      expect(afterCancel, isNotNull);
      expect(afterCancel!.hasConflict, isFalse, reason: 'Perjalanan dibatalkan tidak menjadi pemesan stok');
    });
  });
}
