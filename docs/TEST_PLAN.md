# Rencana Pengujian Aplikasi Bawa (Test Plan)
Dokumen: `docs/TEST_PLAN.md`
Status: **Final (Fase 0)**
Tanggal: 10 Oktober 2026

---

## 1. Pendekatan dan Piramida Pengujian

Pengujian pada Bawa dirancang untuk menjamin kualitas tinggi secara bertahap dan dapat diverifikasi secara otomatis maupun manual.

```text
        /  Integration Tests  \        <- AT-20 s/d AT-26 (SAF, Alarm, Restore, Device)
       /     Widget Tests      \       <- Formulir, Checkbox Packing, Error State, Font 1.5
      /   Data / Drift Tests    \      <- Schema SQLite, Migrasi, Foreign Keys, Snapshot
     /     Domain Unit Tests     \     <- Quantity Rules, Progress, Date Overlap, Checkpoint
```

1. **Domain Unit Tests**: Menguji logika murni tanpa ketergantungan Flutter UI:
   - Aturan kuantitas bawaan dan status packing.
   - Perhitungan progres perjalanan (baris vs unit).
   - Deteksi konflik irisan rentang tanggal perjalanan.
   - Perhitungan formula checkpoint (`confirmed` vs `unconfirmed`).
   - Validasi struktur JSON manifest, sanitasi path traversal, dan SHA-256 hash.
2. **Database & Data Layer Tests**: Menguji repository dan Drift database (menggunakan in-memory SQLite):
   - Integritas relasi foreign key dan on delete cascade.
   - Pembuatan dan pemeliharaan snapshot nama dan lokasi asal pada `TripItem`.
   - Transaksi pemecahan stok dan pengarsipan barang tanpa merusak riwayat perjalanan.
3. **Widget Tests**: Menguji komponen antarmuka pengguna:
   - Respon interaksi packing cepat dan pembatalan (Undo via Snackbar).
   - Dialog konfirmasi saat mengubah status item yang sudah dikemas menjadi 'tidak dibawa'.
   - Aksesibilitas: layar sempit (lebar 360 dp) dan font scale 1.5 (tidak terjadi layout overflow).
   - Tampilan empty state yang ramah dan informatif.
4. **Integration & Device Tests**: Menguji fungsionalitas Android:
   - Penjadwalan alarm dan notifikasi lokal.
   - Lifecycle camera/picker dan isolasi penyimpanan app-private.
   - Siklus ekspor dan restore file ZIP secara atomik.

---

## 2. Matriks Pengujian Penerimaan (Acceptance Test AT-01 s/d AT-26)

| ID Uji | Skenario Pengujian | Hasil yang Diharapkan | Jenis Uji |
| --- | --- | --- | --- |
| **AT-01** | Charger pada Kotak Elektronik dipilih untuk perjalanan Bandung | Label asal kotak terlihat ("Asal: Kotak Elektronik"); status packing awal adalah "Belum dikemas". | Unit + Widget |
| **AT-02** | Charger dikemas pada perjalanan Bandung, dan juga direncanakan untuk perjalanan Jakarta | Perjalanan Bandung berstatus selesai (1/1); perjalanan Jakarta tetap berstatus belum dikemas (0/1). Independensi perjalanan terbukti. | Unit + Integration |
| **AT-03** | 5 kaus direncanakan, 3 unit dikemas | Status item adalah "Sebagian"; baris barang belum dihitung selesai pada progres utama perjalanan. | Unit + Widget |
| **AT-04** | Mengubah barang yang sudah dikemas menjadi 'tidak dibawa' | Muncul dialog konfirmasi reset packing; packing tidak berubah secara diam-diam. Jika dikonfirmasi, `packed_quantity` direset ke 0. | Widget Test |
| **AT-05** | Perjalanan baru tanpa barang bawaan | Indikator progres menampilkan teks "Belum ada daftar bawaan", BUKAN "100% siap". | Widget Test |
| **AT-06** | Bandung – Jakarta – Bandung dalam satu perjalanan | Tujuan berulang tersimpan sebagai entitas `TripStop` berbeda dengan ID unik dan urutan (`sort_order`) yang benar. | Data Test |
| **AT-07** | Melakukan packing tanpa membuat atau memilih tas perjalanan | Seluruh fungsi centang packing, perhitungan progres, dan ringkasan dapat diselesaikan 100% tanpa hambatan. | Widget Test |
| **AT-08** | Hapus foto sumber dari galeri perangkat luar lalu buka aplikasi kembali | Foto di dalam aplikasi tetap utuh dan tampil sempurna karena telah disalin ke app-private storage. | Integration Test |
| **AT-09** | Lampirkan PDF dan foto tiket lalu aktifkan Mode Pesawat (Airplane Mode) | Dokumen tiket dapat dibuka offline; foto tiket mempertahankan resolusi asli sehingga QR code / barcode dapat di-zoom dengan jelas. | Device Test |
| **AT-10** | Jadwal hanya berisi tanggal tanpa jam | Jadwal disimpan sebagai tanggal lokal murni; sistem TIDAK mengubahnya menjadi jam 00.00 malam. | Unit + Data |
| **AT-11** | Acara pukul 07.30 WIB; zona waktu perangkat diubah | Instant waktu acara UTC tetap stabil; UI menampilkan jam lokal dengan penanda zona yang relevan. | Unit Test |
| **AT-12** | Izin notifikasi Android ditolak oleh pengguna | Jadwal tetap tersimpan tanpa crash; UI secara transparan menampilkan status "Izin notifikasi belum aktif". | Widget + Integration |
| **AT-13** | Akses exact alarm tidak tersedia pada perangkat | Aplikasi tidak mengalami crash; sistem otomatis fallback ke inexact alarm dan menampilkan label "Pengingat perkiraan waktu". | Integration Test |
| **AT-14** | Edit waktu jadwal yang memiliki 2 reminder aktif | Reminder lama dibatalkan; 2 reminder baru dijadwalkan ulang dengan ID unik tanpa ada duplikasi alarm. | Unit + Integration |
| **AT-15** | Perangkat reboot setelah menyetel pengingat masa depan | Broadcast receiver `BOOT_COMPLETED` memicu rekonsiliasi pengingat sesuai konfigurasi jadwal dan status izin. | Android Integration |
| **AT-16** | Ketuk notifikasi dari kondisi aplikasi mati (cold-start) | Aplikasi membuka langsung halaman detail jadwal atau tiket yang sesuai dengan payload notifikasi. | Integration Test |
| **AT-17** | 5 item dikemas; saat checkpoint pulang tercatat 3 kembali dan 1 habis | 1 unit terhitung sebagai sisa belum terkonfirmasi; checkpoint tidak dinyatakan lengkap otomatis. | Unit + Widget |
| **AT-18** | Duplikasi perjalanan atau menerapkan template packing | Stok inventaris master tidak bertambah fiktif; status packing aktual, checkpoint pulang, dan tiket aktif direset ke status baru. | Unit + Data |
| **AT-19** | Arsipkan barang master yang ada pada riwayat perjalanan lama | Riwayat perjalanan lama tetap terbaca jelas (menggunakan snapshot nama/lokasi); item yang diarsipkan tidak muncul di pilihan perjalanan baru. | Data Test |
| **AT-20** | Ekspor arsip backup ZIP lalu pulihkan (restore) ke instalasi baru / dataset kosong | Seluruh entitas (barang, lokasi, perjalanan, jadwal, tiket) dan file media pulih 100% identik; alarm masa depan dijadwalkan ulang. | Integration Test |
| **AT-21** | Impor arsip ZIP yang corrupt, memiliki path traversal (`../`), atau checksum beda | Impor ditolak dengan pesan error yang aman; database dan file aktif sama sekali tidak berubah. | Unit + Integration |
| **AT-22** | Aplikasi ditutup paksa (force-kill) di tengah proses restore | Saat startup berikutnya, penanda jurnal mendeteksi proses terputus dan memulihkan kondisi konsisten (rollback otomatis). | Integration Test |
| **AT-23** | Upgrade skema database lokal dengan data eksisting | Seluruh data barang, foto, jadwal, tiket, dan relasi tetap utuh melalui skrip migrasi Drift yang teruji. | Migration Test |
| **AT-24** | Ruang penyimpanan internal penuh saat menyalin media foto | Muncul pesan kesalahan yang jelas dan dapat dipahami; database tidak menyimpan referensi asset setengah jadi (orphan record). | Data Layer Test |
| **AT-25** | Tampilan pada layar lebar 360 dp dengan font scale 1.5 | Seluruh teks penting terbaca tanpa terpotong fatal; tombol dan checkbox tetap dapat disentuh (target sentuh minimal 48x48 dp). | Widget Test |
| **AT-26** | Seluruh alur utama dijalankan dalam Mode Pesawat | Tidak ada spinner loading yang menunggu jaringan internet; seluruh operasi lokal responsif seketika. | Device Test |

---

## 3. Rincian Implementasi Tes Unit Logika Kritis (Domain Engine)

### 3.1 Aturan Status Packing (`PackingStatusEvaluator`)
```dart
enum PackingStatus { belumDikemas, sebagian, selesai, tidakDibawa }

PackingStatus calculateStatus({
  required String decision,
  required int plannedQuantity,
  required int packedQuantity,
}) {
  if (decision == 'not_carried') return PackingStatus.tidakDibawa;
  if (packedQuantity <= 0) return PackingStatus.belumDikemas;
  if (packedQuantity < plannedQuantity) return PackingStatus.sebagian;
  return PackingStatus.selesai;
}
```
**Kasus Uji**:
1. `planned: 2, packed: 0` -> `belumDikemas`.
2. `planned: 3, packed: 1` -> `sebagian`.
3. `planned: 3, packed: 3` -> `selesai`.
4. `decision: not_carried, planned: 0, packed: 0` -> `tidakDibawa`.

### 3.2 Aturan Progres Perjalanan (`TripProgressEvaluator`)
```dart
class TripProgress {
  final int completedLines;
  final int totalPlannedLines;
  final int completedUnits;
  final int totalPlannedUnits;

  bool get hasCarriedItems => totalPlannedLines > 0;
  double get lineProgressRatio => hasCarriedItems ? completedLines / totalPlannedLines : 0.0;
}
```
**Kasus Uji**:
1. `totalPlannedLines == 0` -> `hasCarriedItems == false`, pesan UI: `"Belum ada daftar bawaan"`.
2. 3 baris barang direncanakan: 2 baris selesai, 1 baris sebagian -> `completedLines = 2`, `lineProgressRatio = 2/3 (66.7%)`.

### 3.3 Logika Deteksi Konflik Perjalanan Bertumpang Tindih (`ConflictDetector`)
**Kriteria Overlap**:
Dua perjalanan A dan B mengalami overlap jika:
`!(A.endDate < B.startDate || A.startDate > B.endDate)`
Jika overlap terjadi, akumulasi kebutuhan item dibandingkan dengan `Item.quantity`.
**Kasus Uji**:
1. Trip A (10–12 Okt, butuh 2 charger), Trip B (11–15 Okt, butuh 1 charger). Total stok = 2.
   -> *Hasil*: Overlap terdeteksi. Kebutuhan = 3, stok = 2. **Peringatan potensi konflik 1 unit**.
2. Trip A (10–12 Okt, butuh 2 charger), Trip B (13–15 Okt, butuh 2 charger). Total stok = 2.
   -> *Hasil*: Tidak overlap. **Tidak ada konflik**.
3. Trip A (10–12 Okt), Trip B (mulai 11 Okt, `end_date = null`).
   -> *Hasil*: Tampilkan peringatan ketidakpastian rentang waktu.

### 3.4 Logika Checkpoint Pulang (`ReturnCheckpointEvaluator`)
```dart
int unconfirmedQuantity({
  required int expectedQuantity,
  required int returnedQuantity,
  required int consumedQuantity,
  required int leftQuantity,
}) {
  final confirmed = returnedQuantity + consumedQuantity + leftQuantity;
  return expectedQuantity - confirmed;
}
```
**Kasus Uji**:
1. `expected: 5, returned: 3, consumed: 1, left: 0` -> `confirmed: 4, unconfirmed: 1`. Checkpoint berstatus `closed_with_unconfirmed`.
2. `expected: 5, returned: 5, consumed: 0, left: 0` -> `confirmed: 5, unconfirmed: 0`. Checkpoint berstatus `completed`.

---

## 4. Rencana Lingkungan dan Eksekusi Pengujian

| Lapisan Uji | Cara Eksekusi | Lingkungan Saat Ini |
| --- | --- | --- |
| **Unit & Logic Tests** | `flutter test test/core/...` | Tersedia langsung di host Windows (Dart/Flutter VM). |
| **Drift DB Tests** | `flutter test test/data/...` | Menggunakan in-memory SQLite (`sqlite3` / `drift/native.dart`). |
| **Widget Tests** | `flutter test test/features/...` | Flutter Widget Tester lokal (simulasi resolusi dan font scale). |
| **Android Tests** | `flutter test integration_test/...` | Membutuhkan AVD Emulator (`Pixel_10`) yang dijalankan. |
