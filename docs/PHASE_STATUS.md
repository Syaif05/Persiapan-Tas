# Status Implementasi Fase Proyek Bawa
Dokumen: `docs/PHASE_STATUS.md`
Terakhir Diperbarui: 10 Oktober 2026
Fase Aktif: **Fase 6 — Checklist Pulang dan Template (SELESAI)**

---

## 1. Ikhtisar Status Fase

| Fase | Nama Fase | Status | Keterangan & Prasyarat |
| --- | --- | --- | --- |
| **Fase 0** | **Fondasi keputusan dan rencana** | **SELESAI** | Ambigu teknis diselesaikan, toolchain diperiksa, schema difinalisasi, 3 dokumen docs/ dibuat. |
| **Fase 1** | **Sistem desain dan prototipe Flutter** | **SELESAI** | Design system token, 4 tab navigasi, widget inti, prototipe layar interaktif dengan fixture berlabel, uji aksesibilitas 360dp & font scale 1.5x (6/6 tes lolos, 0 isu analisis). |
| **Fase 2** | **Database, inventaris, lokasi, dan media** | **SELESAI** | 18 tabel Drift SQLite (ADR-08), Asset sandbox SHA-256 (ADR-05), Repository & Stream Provider (INV-01..09), UI terintegrasi database nyata (17/17 tes lolos, 0 isu analisis). |
| **Fase 3** | **Perjalanan, tujuan, dan packing** | **SELESAI** | Repositori & Stream Trips, Multi-kota/Stop (TRP-01..06), Duplikasi perjalanan dengan reset packing (TRP-07), Pemilihan inventaris non-duplikasi stok (PCK-01..03), Status packing parsial & centang cepat/undo (PCK-04..07), Tas perjalanan opsional (PCK-08), Deteksi konflik tanggal overlap (PCK-09), Pemeriksaan pra-berangkat (PCK-11..12), UI terintegrasi database nyata (30/30 tes lolos, 0 isu analisis). |
| **Fase 4** | **Agenda dan tiket offline** | **SELESAI** | Repositori & Stream Schedules (`SCH-01`..`04`, `SCH-12`), Timezone IANA & UTC instant derivation (`AT-11`), Pelestarian jadwal tanggal saja tanpa midnight mutation (`AT-10`), Repositori Tiket & Tiket tanpa jadwal (`SCH-05`, `SCH-07`), Lampiran PDF & Foto sandbox SHA-256 resolusi penuh (`SCH-06`, `AT-09`), Integrasi UI Agenda, Detail Tiket, Form Jadwal & Form Tiket (38/38 tes lolos, 0 isu analisis). |
| **Fase 5** | **Pengingat Android** | **SELESAI** | Plugin notifikasi lokal (`flutter_local_notifications`), pengelolaan izin runtime (`POST_NOTIFICATIONS`) & exact alarm (`SCHEDULE_EXACT_ALARM`), pengingat majemuk dengan ID unik deterministik, pembatalan & penjadwalan ulang saat edit/delete jadwal tanpa alarm duplikat, navigasi cold-start tap, dan rekonsiliasi boot (46/46 tes lolos, 0 isu analisis). |
| **Fase 6** | **Checklist pulang dan template** | **SELESAI** | Checkpoint snapshot hanya barang terkemas (`RET-01`..`02`), 3 kategori konfirmasi (kembali, habis, ditinggal) dengan status jujur `closed_with_unconfirmed` (`RET-03`, `RET-05`, `AT-17`), stok master tidak berubah (`RET-04`), pembuatan & penerapan template reusable dengan reset packing ke 0 tanpa duplikasi stok (`TPL-01`..`03`, `AT-18`), UI Checkpoint interaktif & aksi template (55/55 tes lolos, 0 isu analisis). |
| **Fase 7** | **Backup, restore, dan pengaturan** | **MENUNGGU INSTRUKSI** | Menunggu konfirmasi pengguna sebelum memulai implementasi arsip ZIP portabel, checksum SHA-256, atomic restore & rollback (BAK-01..07, SET-01..02). |
| **Fase 8** | **Penyempurnaan dan APK pribadi** | Menunggu | Bergantung pada seluruh fase inti (hardening, polishing, build APK release). |

---

## 2. Rincian Pengerjaan Fase 0

### Tujuan Fase 0
Menyelesaikan seluruh ambiguitas teknis, aturan perhitungan kuantitas, pemisahan entitas inti (kotak vs tas vs status perjalanan), verifikasi toolchain aktual, pemilihan dependensi berlisensi aman, penetapan target Android SDK, finalisasi schema, serta penyusunan dokumen arsitektur dan rencana pengujian sebelum penulisan kode aplikasi.

### Checklist Pekerjaan Fase 0

- [x] **Pemisahan Konseptual Kotak, Tas, dan Status Packing**:
  - Lokasi simpan fisik (`StorageLocation`) dicatat sebagai rujukan asal barang dan TIDAK otomatis menjadi barang/wadah yang ikut dibawa.
  - Tas perjalanan (`TripBag`) opsional per perjalanan, independen, dan pengguna tidak diwajibkan membuat tas untuk menyelesaikan packing.
  - Status packing (`TripItem`) melekat pada perjalanan tertentu, tidak menjadi status global barang. Packing perjalanan A tidak memengaruhi perjalanan B.
  - Tiga informasi dipisahkan dengan tegas: (1) Lokasi simpan asal, (2) Keputusan dibawa/tidak dibawa, (3) Jumlah yang dikemas.
- [x] **Pemeriksaan Toolchain & Lingkungan**:
  - Flutter 3.44.8 (channel stable), Dart 3.12.2.
  - OS Host: Windows 11.
  - Android SDK 37.0.0 (`C:\Users\syaif\AppData\Local\Android\sdk`), platforms 33 s/d 37.0, build-tools 34.0.0 s/d 37.0.0.
  - Emulator: `Pixel_10` AVD terkonfigurasi.
  - Android Studio: Terpasang di `C:\Program Files\Android\Android Studio`.
  - *Catatan keterbatasan*: `cmdline-tools` belum terpasang di SDK folder CLI, lisensi CLI belum diterima via command-line (akan diatur sebelum build Android Fase 8).
- [x] **Pemilihan Versi Dependensi & Lisensi**:
  - Semua dependensi yang dipilih menggunakan lisensi permisif (MIT, BSD-3-Clause, Apache-2.0). Bebas copyleft.
  - Daftar dependensi di-pin dan didokumentasikan di `docs/DECISIONS.md`.
  - Tidak ada backend, cloud sync, analytics, atau API AI yang dimasukkan ke dalam arsitektur aplikasi.
- [x] **Finalisasi Skema Database & Relasi (Drift/SQLite)**:
  - 18 tabel relasional tervalidasi dengan foreign key cascading yang tepat.
  - UUID v4 sebagai primary key stabil (menghindari ID clash saat backup-restore).
  - Penanganan snapshot nama & lokasi pada `TripItem` dan `ReturnEntry` agar riwayat perjalanan lama tidak rusak saat inventaris diubah.
- [x] **Aturan Kuantitas, Progres, dan Konflik**:
  - Status packing diturunkan secara deterministik dari `packed_quantity` dan `planned_quantity`.
  - Rumus progres: baris barang selesai / baris barang dipilih dibawa.
  - State kosong: `"Belum ada daftar bawaan"` (bukan `"100% siap"`).
  - Deteksi konflik hanya untuk rentang tanggal yang beririsan (overlap).
- [x] **Strategi Media, Dokumen, Notifikasi, dan Backup**:
  - Sandboxed app-private storage dengan path relatif.
  - Gambar tiket dipertahankan resolusi aslinya agar QR/barcode tetap terbaca.
  - Jadwal tanggal saja (`is_date_only`) tidak diubah ke jam 00.00.
  - Notifikasi exact vs inexact alarm dengan status UI yang jujur.
  - Backup ZIP dengan validasi path traversal, SHA-256 checksum, dan jurnal pemulihan (rollback recovery).
- [x] **Dokumen Rencana**:
  - `docs/DECISIONS.md` telah dibuat.
  - `docs/PHASE_STATUS.md` telah dibuat.
  - `docs/TEST_PLAN.md` telah dibuat.

---

## 3. Rincian Pengerjaan Fase 1 — Sistem Desain dan Prototipe Flutter

### Tujuan Fase 1
Membangun fondasi antarmuka Flutter modern, minimalis, dan responsif sesuai pedoman PRD Seksi 7 dan 10, mencakup token desain visual, komponen UI inti yang dapat digunakan kembali, kerangka navigasi 4 tab, prototipe seluruh layar utama menggunakan data fixture lokal yang berlabel jelas (`FixtureBadge`), interaktivitas packing cepat & undo, serta validasi formulir dan pengujian aksesibilitas layar sempit (360dp) dan pembesaran font (1.5x).

### Checklist Pekerjaan Fase 1

- [x] **Inisialisasi Proyek Flutter & Dependensi UI**:
  - Proyek Flutter diinisialisasi (`com.bawa.app`, nama `bawa`).
  - Dependensi runtime dipasang: `flutter_riverpod: ^3.4.3`, `go_router: ^17.5.0`, `intl`, `uuid`, `crypto`.
- [x] **Design System Token & Tema**:
  - `AppColors`: Primary Orange (`#FF5722`), netral terang (`#F8F9FA`), netral kartu (`#FFFFFF`), borders (`#E0E0E0`), status semantic (success `#2E7D32`, warning `#ED6C02`, danger `#D32F2F`).
  - `AppSpacing`: Skala 4px terstandarisasi (`xs: 4`, `sm: 8`, `md: 12`, `base: 16`, `lg: 20`, `xl: 24`, `xxl: 32`).
  - `AppTypography`: Skala tipografi modern menggunakan font sistem yang bersih dengan hirarki `headlineLarge`, `headlineMedium`, `titleLarge`, `itemTitle`, `body`, `metadata`.
  - `AppTheme`: Konfigurasi Material 3 light theme, AppBar bersih, Card bertaraf minimalis, InputDecoration terisi lembut tanpa garis kasar berlebih.
- [x] **Komponen UI Inti Reusable**:
  - `BawaAppBar`: AppBar terpadu dengan penanganan overflow adaptif (`FittedBox`) dan aksi kontekstual.
  - `BawaSearchField`: Input pencarian cepat dengan ikon pencari dan tombol bersihkan (clear).
  - `BawaFilterChip`: Filter horizontal interaktif dengan indikator visual status aktif/tidak aktif.
  - `BawaButton`: Tombol primer, sekunder, dan outline yang konsisten secara dimensi sentuh (min 48dp).
  - `BawaProgressBar`: Indikator progres packing dengan label persentase dan bar animasi halus.
  - `BawaEmptyState`: Tampilan informatif ketika daftar kosong sesuai PRD Seksi 7.4 (ikon, judul, deskripsi pemandu, dan tombol aksi).
  - `FixtureBadge`: Penanda visual oranye mencolok "PREVIEW FIXTURE" untuk memastikan kejujuran bahwa prototipe menggunakan data lokal dan belum tersambung ke database permanen.
- [x] **Navigasi 4 Tab & Rute Global**:
  - `createAppRouter`: Menggunakan `StatefulShellRoute.indexedStack` untuk persistensi status 4 tab utama:
    1. **Tab 1: Beranda** (`/home`) — Perjalanan terdekat, progres cepat, tombol aksi.
    2. **Tab 2: Barang** (`/inventory`) — Inventaris lengkap, pencarian real-time, filter kategori, detail lokasi (`/inventory/locations`), formulir tambah barang (`/inventory/new`).
    3. **Tab 3: Perjalanan** (`/trips`) — Daftar perjalanan (persiapan, berlangsung, selesai), buat perjalanan baru (`/trips/new`), detail perjalanan (`/trips/:id`), checklist pulang (`/trips/:id/checkpoint`), detail tiket (`/trips/:id/tickets/:ticketId`).
    4. **Tab 4: Agenda** (`/agenda`) — Jadwal kronologis terpadu, lampiran tiket offline, penanda zona waktu IANA.
    5. **Rute Global**: Pengaturan & Backup (`/settings`).
- [x] **Interaktivitas Prototipe State (`PrototypeNotifier`)**:
  - Menggunakan Riverpod `Notifier` & `NotifierProvider` generasi terbaru (kompatibel penuh Riverpod 3).
  - Centang packing cepat (1 unit langsung centang, banyak unit dengan modal dialog).
  - Fitur SnackBar Undo pembatalan packing yang responsif.
  - Toggle Empty State di AppBar Beranda untuk menguji dan memperlihatkan tampilan kosong di semua tab.
- [x] **Aksesibilitas & Validasi Form**:
  - Seluruh komponen judul dan baris data mengantisipasi layar sempit (lebar 360dp) dan skala teks besar (1.5x) tanpa RenderFlex overflow.
  - Dropdown input dilengkapi `isExpanded: true` dan pemotongan teks rapi (`overflow: TextOverflow.ellipsis`).
  - Validasi ketat pada `ItemFormScreen` (nama wajib diisi, jumlah stok bulat minimal 1).
- [x] **Pengujian & Analisis Kode**:
  - `flutter analyze`: **0 issues found**.
  - `flutter test`: **6/6 tests passed** (smoke test, 360dp & 1.5x font scale accessibility, tab switching, packing toggle & undo, empty state toggle, form validation).

---

## 4. Rincian Pengerjaan Fase 2 — Database, Inventaris, Lokasi, dan Media

### Tujuan Fase 2
Mengimplementasikan seluruh lapisan persistensi data lokal menggunakan Drift SQLite (18 tabel relasional dari ADR-08), AssetStorageService tersandbox di direktori privat aplikasi dengan validasi checksum SHA-256 (ADR-05), Repository pattern untuk Inventaris (`INV-01`, `INV-02`), Lokasi Simpan (`INV-03`, `INV-04`), Lokasi Opsional (`INV-05`), Foto Item sandboxing (`INV-06`), Pencarian & Filter reaktif (`INV-07`), Arsip aman & Proteksi Hapus (`INV-08`), Peringatan Duplikat (`INV-09`), serta menghubungkan layar UI Barang, Detail Lokasi, Detail Barang, dan Formulir Barang ke data SQLite nyata tanpa fixture statis.

### Checklist Pekerjaan Fase 2

- [x] **Skema Database Relasional Drift (ADR-08)**:
  - 18 tabel relasional Drift terdefinisi lengkap di `lib/data/database/tables.dart`.
  - `AppDatabase` diinisialisasi di `lib/data/database/app_database.dart` dengan schema v1.
  - Menjalankan `PRAGMA foreign_keys = ON;` pada setiap koneksi.
  - Background isolate via `NativeDatabase.createInBackground` untuk performa UI 60fps tanpa freeze saat query berat.
  - Konstruktor `AppDatabase.inMemory()` untuk pengujian unit & integrasi terisolasi.
  - Seeding data awal: 7 kategori default & 2 lokasi simpan default (`Kotak Elektronik` & `Lemari Pakaian`).
  - Kode ter-generate bersih tanpa peringatan via `build_runner`.
- [x] **Asset Storage Service & Media Sandboxing (ADR-05 & AT-08)**:
  - `AssetStorageService` di `lib/data/services/asset_storage_service.dart`.
  - Salinan file gambar asli ke direktori privat `app_data/assets/` menggunakan nama UUID v4 unik.
  - Penghitungan dan validasi integritas checksum SHA-256.
  - Validasi batas ukuran file (maksimal 20 MB per file sesuai PRD Seksi 6.4).
  - Penyimpanan path relatif di database (`assets/<uuid>.<ext>`) untuk portabilitas backup-restore.
  - Penanganan pembatalan pemilihan gambar (`image_picker` cancel) tanpa error maupun file sampah.
- [x] **Repositori & Manajemen Data Terisolasi**:
  - `CategoriesRepository`: Pengambilan daftar kategori bawaan.
  - `LocationsRepository`: CRUD lokasi simpan, hitung jumlah item aktif per lokasi, penghapusan aman dengan opsi migrasi atau pelepasan lokasi item (item tidak terhapus).
  - `InventoryRepository`:
    - CRUD barang dengan validasi nama wajib dan kuantitas bulat minimal 1 (`INV-01`, `INV-02`).
    - Pendukung lokasi opsional (`INV-05`, menampilkan label "Lokasi belum dicatat").
    - Relasi foto item hingga 5 foto (1 utama, 4 tambahan) dengan urutan display_order (`INV-06`).
    - Deteksi nama mirip/duplikat dengan peringatan non-blocking (`INV-09`).
    - Pengarsipan barang (`is_archived = true`) tanpa merusak relasi bawaan (`INV-08`).
    - Penolakan penghapusan permanen barang jika telah terikat pada perjalanan aktif (`INV-08`).
    - Query stream reaktif gabungan (join Items, Categories, StorageLocations, ItemPhotos, Assets) dengan filter pencarian nama/kategori/lokasi/arsip (`INV-07`).
- [x] **Integrasi UI Nyata & Riverpod Stream**:
  - `database_providers.dart`: Menyediakan provider singleton database, service, repositori, dan stream query reaktif terfilter.
  - `InventoryScreen`: Menampilkan stream item nyata, thumbnail dari file sandbox, filter chip interaktif, pencarian instan, dan aksi "Muat Contoh Barang" jika database masih kosong.
  - `ItemDetailScreen`: Menampilkan detail lengkap, galeri carousel foto dari file sandbox lokal, tombol toggle arsip aman, dan konfirmasi hapus berpelindung.
  - `ItemFormScreen`: Mode buat & edit, integrasi `image_picker` (kamera & galeri), banner peringatan duplikat nama, dropdown kategori & lokasi dinamis, serta validasi kuantitas bulat >= 1.
  - `LocationDetailScreen`: Menampilkan daftar lokasi dan daftar barang yang tersimpan di dalamnya tanpa membongkar kotak fisik (`INV-04`), dialog tambah lokasi, serta dialog hapus lokasi aman dengan migrasi/pelepasan lokasi.
  - Rute router terkonfigurasi untuk detail barang (`/inventory/items/:itemId`), edit barang (`/inventory/edit/:itemId`), dan parameter `locationId` pada pembuatan barang.
- [x] **Pengujian & Analisis Kode**:
  - `flutter analyze`: **0 issues found**.
  - `flutter test`: **17/17 tests passed** di seluruh suite:
    - `test/asset_storage_test.dart` (1 tes: sandbox copying, sha256, isolation).
    - `test/database_test.dart` (2 tes: default seeding, foreign key cascade).
    - `test/inventory_repository_test.dart` (8 tes: INV-01 s/d INV-09, safe location deletion).
    - `test/features_test.dart` (3 tes: packing rapid check & undo, empty state, form validation).
    - `test/widget_test.dart` (3 tes: smoke, navigation, 360dp & 1.5x font scale accessibility).

---

## 5. Rincian Pengerjaan Fase 3 — Perjalanan, Tujuan, dan Packing

### Tujuan Fase 3
Mengimplementasikan model data dan repositori perjalanan multi-kota (`TRP-01` s/d `TRP-08`), penanganan daftar bawaan independen per perjalanan (`PCK-01` s/d `PCK-03`), status packing parsial deterministik (`PCK-04`), centang cepat & undo (`PCK-05`, `PCK-10`), filter packing (`PCK-06`), lokasi simpan asal terlihat (`PCK-07`), tas perjalanan opsional (`PCK-08`), deteksi potensi konflik tanggal overlap (`PCK-09`), barang penting (`PCK-11`), dialog pemeriksaan sebelum berangkat (`PCK-12`), serta menghubungkan layar Perjalanan (`TripsScreen`), Detail Perjalanan (`TripDetailScreen`), Formulir Perjalanan (`TripFormScreen`), Beranda (`HomeScreen`), dan Pemilih Barang (`TripItemPickerSheet`) ke SQLite nyata.

### Checklist Pekerjaan Fase 3

- [x] **Repositori & Logika Domain Perjalanan (`TripsRepository`)**:
  - `TRP-01`: Multi-perjalanan independen tanpa batasan satu perjalanan aktif.
  - `TRP-02`: CRUD metadata perjalanan (nama, tanggal mulai, tanggal akhir opsional, catatan, status, arsip).
  - `TRP-03` & `TRP-04`: Penanganan perhentian multi-kota (`TripStops`), urutan berurutan, dan dukungan kota berulang (contoh: Bandung -> Jakarta -> Bandung, `AT-06`).
  - `TRP-05`: Status perjalanan (`planning`, `ongoing`, `completed`, `cancelled`) dan pemisahan atribut arsip (`is_archived`).
  - `TRP-06`: Pengurutan kronologis perjalanan berdasarkan tanggal mulai terdekat.
  - `TRP-07`: Duplikasi perjalanan lengkap dengan penyalinan barang dan kuantitas rencana, serta **reset kuantitas packing ke 0** (`AT-18`).
  - `TRP-08`: Perhitungan kesiapan ringkasan perjalanan (`TripSummary`) dengan formula ketat: `completedLines / totalCarriedLines`, menampilkan status "Belum ada daftar bawaan" jika tidak ada item bawaan (`AT-05`).
- [x] **Repositori & Logika Packing (`TripPackingRepository`)**:
  - `PCK-01`: Pemilihan item dari inventaris tanpa membuat salinan stok di tabel `Items` (`AT-01`).
  - `PCK-02`: Keputusan bawaan independen per perjalanan (`is_carried = true/false`, `AT-02`).
  - `PCK-03`: Kuantitas rencana dibatasi `1 <= planned <= inventoryQuantity`.
  - `PCK-04`: Status packing deterministik (`belum_dikemas`, `sebagian`, `selesai`) diturunkan dari `packed_quantity` dan `planned_quantity` (`AT-03`).
  - `PCK-05` & `PCK-10`: Centang packing cepat (1 unit langsung centang penuh, modal kuantitas untuk multi-unit) dan dukungan pembatalan responsif via SnackBar Undo.
  - `PCK-06`: Filter daftar bawaan: `Semua`, `Belum dikemas`, `Sebagian`, `Selesai`, `Tidak dibawa`.
  - `PCK-07`: Lokasi simpan asal/rujukan tersnapshot dan terlihat jelas pada kartu item bawaan.
  - `PCK-08`: Tas perjalanan (`TripBags`) opsional per perjalanan, independen, dan pengguna dapat menyelesaikan packing tanpa membuat tas (`AT-07`).
  - `PCK-09`: Deteksi potensi konflik inventaris hanya dihitung saat tanggal perjalanan beririsan (overlap) dengan perjalanan aktif lainnya.
  - `PCK-11`: Barang penting (obat/dokumen) diberi penanda visual bintang khusus dan selalu terdeteksi pada filter item belum dikemas.
  - `PCK-12`: Dialog pemeriksaan pra-berangkat ("Cek Sebelum Berangkat") yang merinci sisa item belum dikemas dan meminta konfirmasi sebelum beralih ke status `ongoing`.
  - Reset konfirmasi saat barang yang sudah dikemas diubah menjadi tidak dibawa (`AT-04`).
- [x] **Integrasi Antarmuka Pengguna & Stream Reaktif**:
  - `database_providers.dart`: Penyediaan `tripsRepositoryProvider`, `tripPackingRepositoryProvider`, `tripsStreamProvider`, `tripDetailStreamProvider`, `upcomingTripStreamProvider`, `tripItemsStreamProvider`, `tripBagsStreamProvider`.
  - `TripsScreen`: Menampilkan stream perjalanan nyata untuk tab "Persiapan", "Berlangsung", dan "Selesai", live progress bar, aksi duplikasi & hapus perjalanan, serta empty state informatif.
  - `TripFormScreen`: Formulir buat & ubah perjalanan, date picker validasi urutan tanggal, editor dinamis multi-stop kota/tujuan, tombol simpan reaktif.
  - `TripDetailScreen`: Menampilkan detail perjalanan terintegrasi SQLite nyata, badge status, daftar tujuan berurut, manajemen tas opsional, banner peringatan konflik, filter chip packing, centang cepat & undo snackbar, tombol modal pra-berangkat, aksi duplikasi, dan transisi status.
  - `TripItemPickerSheet`: Modal pemilih barang dari inventaris dengan filter kategori/pencarian, penyesuaian kuantitas rencana, deteksi konflik stok overlap, dan simpan bawaan.
  - `HomeScreen`: Integrasi kartu perjalanan terdekat aktif nyata dari SQLite, persentase progres, preview barang belum dikemas, serta penghitungan total inventaris dan kotak fisik yang akurat.
  - `app_router.dart`: Penambahan rute edit perjalanan (`/trips/edit/:tripId`).
- [x] **Pengujian & Analisis Kode**:
  - `flutter analyze`: **0 issues found** (tidak ada warning atau error).
  - `flutter test`: **30/30 tests passed** di seluruh suite:
    - `test/trips_and_packing_test.dart` (13 tes: TRP-01 s/d TRP-08, PCK-01 s/d PCK-12, AT-01 s/d AT-07, AT-18).
    - `test/inventory_repository_test.dart` (8 tes: INV-01 s/d INV-09).
    - `test/features_test.dart` (3 tes: packing rapid check & undo snackbar, empty state, form validation).
    - `test/widget_test.dart` (3 tes: smoke, navigation, 360dp & 1.5x font scale accessibility).
    - `test/database_test.dart` (2 tes: default seeding, foreign key cascade).
    - `test/asset_storage_test.dart` (1 tes: sandbox copying, sha256 checksum).

---

## 6. Rincian Pengerjaan Fase 4 — Agenda dan Tiket Offline

### Tujuan Fase 4
Mengimplementasikan repositori agenda/jadwal kegiatan (`SCH-01`, `SCH-02`, `SCH-03`, `SCH-12`), penanganan zona waktu IANA yang tepat (WIB, WITA, WIT, UTC) dengan konversi instan UTC (`SCH-04`, `AT-11`), pelestarian jadwal bertanggal saja tanpa mutasi tengah malam (`AT-10`), repositori tiket/reservasi offline (`SCH-05`), relasi tiket mandiri/tanpa jadwal (`SCH-07`), penyimpanan lampiran PDF dan gambar resolusi penuh (anti-kompresi perusak barcode/QR) di sandbox lokal dengan hash SHA-256 (`SCH-06`, `AT-09`), pembukaan berkas offline via `open_filex`, serta pengintegrasian antarmuka pengguna `AgendaScreen`, `TicketDetailScreen`, `ScheduleFormScreen`, `TicketFormScreen`, dan Tab Jadwal & Tiket pada `TripDetailScreen`.

### Checklist Pekerjaan Fase 4

- [x] **Utilitas Waktu & Zona Waktu (`AppDateTimeUtils`)**:
  - `SCH-04`: Registrasi zona waktu IANA standar Indonesia (WIB - `Asia/Jakarta`, WITA - `Asia/Makassar`, WIT - `Asia/Jayapura`) dan UTC.
  - `AT-11`: Konversi waktu lokal ke instan UTC stabil (`computeUtcInstant`) tanpa bergeser saat perangkat berpindah zona.
  - `SCH-12` & `AT-10`: Jadwal bertanggal saja (`isDateOnly = true`) tidak menghasilkan jam 00:00 midnight (`startUtc = null`, `localStart = null`). Format teks menampilkan "Sepanjang hari".
  - Validasi rentang tanggal jadwal terhadap rentang tanggal perjalanan (`isDateWithinTripRange`).
- [x] **Repositori Jadwal & Agenda (`SchedulesRepository`)**:
  - `SCH-01`: CRUD jadwal kegiatan lengkap dengan validasi judul wajib, kueri tripId, tanggal lokal, jam mulai/selesai, zona waktu, lokasi teks, dan catatan.
  - `SCH-02`: Kategori jenis kegiatan (`transport`, `lodging`, `activity`, `preparation`, `other`).
  - `SCH-03`: Kueri stream kronologis global terurut berdasarkan tanggal terdekat, jam mulai, dan status perjalanan aktif (`watchGlobalAgenda`).
  - Validasi urutan waktu: jam selesai tidak boleh lebih awal dari jam mulai (`ArgumentError`).
  - Penghapusan jadwal melepas tautan tiket terkait secara aman tanpa menghapus tiket (`scheduleEventId = null`).
- [x] **Repositori Tiket Offline & Lampiran Sandbox (`TicketsRepository`)**:
  - `SCH-05`: CRUD tiket/reservasi (judul, penyedia/provider, kode booking/reservasi prominen, catatan, tripId, scheduleEventId).
  - `SCH-07`: Tiket dapat disimpan tanpa jadwal dan dapat dikaitkan kemudian ke jadwal perjalanan.
  - `SCH-06` & `AT-09`: Penyimpanan berkas lampiran PDF dan gambar tiket ke folder sandbox `app_data/assets/` dengan verifikasi batas ukuran (maks 20 MB) dan hash SHA-256.
  - Resolusi gambar tiket asli dipertahankan secara utuh tanpa kompresi agresif agar QR code dan barcode boarding pass tetap tajam dan dapat dipindai saat di-zoom.
  - Integrasi pembuka berkas lokal offline via `open_filex` dan zoomable preview in-app via `InteractiveViewer`.
  - Penghapusan tiket melakukan cascade dan membersihkan berkas fisik asset dari disk sandbox tanpa meninggalkan berkas yatim (orphan files).
- [x] **Integrasi Antarmuka Pengguna & Stream Reaktif**:
  - `database_providers.dart`: Penambahan `schedulesRepositoryProvider`, `ticketsRepositoryProvider`, `tripSchedulesStreamProvider`, `globalAgendaStreamProvider`, `tripTicketsStreamProvider`, `ticketDetailStreamProvider`.
  - `AgendaScreen`: Mengganti fixture prototipe dengan stream SQLite nyata; daftar kronologis terkelompok berdasarkan tanggal; tampilan kalender interaktif bulanan dengan penanda titik tanggal acara dan filter tanggal; FAB tambah jadwal dengan pemilih perjalanan aktif.
  - `TripDetailScreen`: Mengganti placeholder Tab 3 (Jadwal) dan Tab 4 (Tiket) dengan stream SQLite nyata, kartu acara terstruktur dengan penanda zona waktu, kartu tiket dengan kode booking prominen, tombol aksi buat/edit/hapus.
  - `ScheduleFormScreen`: Formulir buat & ubah jadwal, segmented type chip, date picker dengan banner peringatan jika di luar rentang tanggal perjalanan, switch tanggal saja, time picker jam mulai & selesai, dropdown zona waktu IANA, dan pemilih tujuan kota perhentian perjalanan.
  - `TicketFormScreen`: Formulir buat & ubah tiket, picker dokumen PDF & foto, staging berkas baru, dropdown tautan jadwal, textfield kode booking kapital.
  - `TicketDetailScreen`: Menampilkan detail tiket SQLite nyata, tombol salin kode booking ke clipboard, daftar lampiran PDF dan gambar, tombol buka berkas di viewer aplikasi eksternal, dan modal full-screen zoomable preview untuk scan barcode/QR.
  - `HomeScreen`: Memperbarui Seksi 2 "Jadwal Berikutnya" agar menampilkan jadwal terdekat riil dari SQLite dengan penanda zona waktu IANA.
  - `app_router.dart`: Pendaftaran rute `/trips/:tripId/schedules/new`, `/trips/:tripId/schedules/edit/:scheduleId`, `/trips/:tripId/tickets/new`, `/trips/:tripId/tickets/edit/:ticketId`.
- [x] **Pengujian & Analisis Kode**:
  - `flutter analyze`: **0 issues found** (tidak ada warning atau error).
  - `flutter test`: **38/38 tests passed** di seluruh suite:
    - `test/schedules_and_tickets_test.dart` (8 tes: SCH-01 s/d SCH-07, SCH-12, AT-09, AT-10, AT-11).
    - `test/trips_and_packing_test.dart` (13 tes: TRP-01 s/d TRP-08, PCK-01 s/d PCK-12).
    - `test/inventory_repository_test.dart` (8 tes: INV-01 s/d INV-09).
    - `test/features_test.dart` (3 tes: packing check & undo snackbar, empty state, form validation).
    - `test/widget_test.dart` (3 tes: smoke, navigation, 360dp & 1.5x font scale accessibility).
    - `test/database_test.dart` (2 tes: default seeding, foreign key cascade).
    - `test/asset_storage_test.dart` (1 tes: sandbox copying, sha256 checksum).

---

## 7. Rincian Pengerjaan Fase 5 — Pengingat Android

### Tujuan Fase 5
Mengintegrasikan plugin notifikasi lokal Android (`flutter_local_notifications`), pengelolaan izin runtime Android 13+ (`POST_NOTIFICATIONS`) dan izin exact alarm Android 12+ (`SCHEDULE_EXACT_ALARM`) dengan fallback transparan ke perkiraan waktu (`approximate`), dukungan pengingat majemuk (*multiple reminders*) per jadwal kegiatan (`SCH-08`) dengan ID notifikasi integer 31-bit positif unik bebas collision, pembatalan dan penjadwalan ulang alarm otomatis saat jadwal diedit atau dihapus tanpa meninggalkan alarm duplikat (`SCH-10`, `AT-14`), penanganan navigasi tap notifikasi saat aplikasi berjalan maupun cold-start (`SCH-11`, `AT-16`), perlindungan privasi teks notifikasi lock screen, rekonsiliasi alarm setelah boot/start perangkat (`AT-15`), serta integrasi UI indikator status pengingat pada `ScheduleFormScreen`, `TripDetailScreen`, `AgendaScreen`, dan `SettingsScreen`.

### Checklist Pekerjaan Fase 5

- [x] **Service Notifikasi Lokal & Timezone (`NotificationService`)**:
  - Konfigurasi kanal notifikasi Android: `bawa_schedule_reminders`, nama `"Pengingat Jadwal & Perjalanan"`, `Importance.high`, `Priority.high`, getar aktif, dan `NotificationVisibility.private` (mencegah kebocoran data tiket ke lock screen).
  - Inisialisasi timezone IANA via package `timezone` (`tz.initializeTimeZones()`).
  - Pemilihan waktu instan UTC deterministik (`tz.TZDateTime.from(scheduledUtc, tz.UTC)`).
  - Pengelolaan izin runtime: `requestNotificationsPermission()` (Android 13+) dan pemeriksaan `areNotificationsEnabled()`.
  - Pengelolaan exact alarm: `requestExactAlarmsPermission()` (Android 12+) dengan fallback `AndroidScheduleMode.inexactAllowWhileIdle` saat izin exact alarm tidak tersedia (`AT-13`).
  - Penanganan payload JSON `NotificationPayloadData(tripId, scheduleEventId, reminderId)` untuk navigasi reaktif dan deteksi cold-start via `getNotificationAppLaunchDetails()` (`SCH-11`, `AT-16`).
- [x] **Repositori Pengingat & SQLite (`RemindersRepository`)**:
  - `SCH-08`: Pengingat majemuk per jadwal kegiatan dengan preset waktu (tepat saat acara, 15 mnt, 30 mnt, 1 jam, 2 jam, 1 hari sebelum) serta waktu kustom.
  - `SCH-12`: Jadwal tanggal saja (`isDateOnly = true`) mewajibkan waktu eksplisit (default 09:00 WIB/lokal), tidak diubah menjadi midnight timestamp.
  - Pembangkit ID notifikasi integer 31-bit unik positif yang deterministik dan diverifikasi terhadap seluruh ID aktif di tabel `reminders` database SQLite.
  - `SCH-09` & `AT-12`: Pengelolaan status scheduling yang jujur:
    - `'active'`: Alarm presisi dijadwalkan tepat waktu.
    - `'approximate'`: Fallback perkiraan waktu saat izin exact alarm tidak tersedia.
    - `'permission_required'`: Izin notifikasi ditolak oleh pengguna/sistem; jadwal tetap tersimpan aman.
    - `'missed'`: Waktu trigger sudah berada di masa lalu saat disimpan atau saat perangkat dinyalakan kembali.
    - `'disabled'`: Dinonaktifkan manual oleh pengguna.
  - `SCH-10` & `AT-14`: Mengedit jadwal membatalkan seluruh alarm lama di sistem OS dan menjadwalkan alarm baru tanpa menyisakan alarm duplikat di OS maupun tabel database.
  - Menghapus jadwal (`deleteSchedule`) otomatis membatalkan seluruh alarm terkait di OS sebelum baris dihapus dari database.
  - `AT-15`: Rekonsiliasi startup/boot (`reconcileAllReminders`) memeriksa seluruh pengingat aktif, menandai pengingat lampau sebagai `'missed'`, dan menjadwalkan ulang pengingat mendatang sesuai status izin saat ini.
- [x] **Integrasi Antarmuka Pengguna & Stream Reaktif**:
  - `database_providers.dart`: Penambahan `notificationServiceProvider`, `remindersRepositoryProvider`, `scheduleRemindersStreamProvider`, dan `notificationPermissionStatusProvider`.
  - `main.dart`: Inisialisasi `NotificationService` saat startup aplikasi, registrasi handler tap notifikasi ke router, pemrosesan cold start payload, dan rekonsiliasi pengingat di latar belakang.
  - `ScheduleFormScreen`: Penambahan Seksi 7 "Pengingat & Alarm", banner status izin notifikasi dengan tombol aksi berikan izin, daftar pengingat aktif dengan tombol hapus, modal pemilih preset & kustom waktu, serta catatan edukatif mengenai pembatasan baterai vendor OEM.
  - `TripDetailScreen` (Tab 3: Jadwal): Penambahan badge status pengingat pada kartu jadwal (aktif, perkiraan, atau izin diperlukan) dengan icon lonceng.
  - `AgendaScreen`: Penambahan badge status pengingat interaktif pada kartu agenda global.
  - `SettingsScreen`: Penambahan panel "Pengingat & Alarm Android" yang menampilkan status izin notifikasi sistem, status exact alarm, tombol sinkronisasi ulang pengingat, dan panduan mitigasi optimasi baterai OEM.
- [x] **Pengujian & Analisis Kode**:
  - `flutter analyze`: **0 issues found** (tidak ada warning atau error di seluruh codebase).
  - `flutter test`: **46/46 tests passed** di seluruh suite:
    - `test/reminders_and_notifications_test.dart` (8 tes: SCH-08 s/d SCH-11, SCH-12, AT-12 s/d AT-16).
    - `test/schedules_and_tickets_test.dart` (8 tes: SCH-01 s/d SCH-07, SCH-12, AT-09, AT-10, AT-11).
    - `test/trips_and_packing_test.dart` (13 tes: TRP-01 s/d TRP-08, PCK-01 s/d PCK-12).
    - `test/inventory_repository_test.dart` (8 tes: INV-01 s/d INV-09).
    - `test/features_test.dart` (3 tes: packing check & undo snackbar, empty state, form validation).
    - `test/widget_test.dart` (3 tes: smoke, navigation, 360dp & 1.5x font scale accessibility).
    - `test/database_test.dart` (2 tes: default seeding, foreign key cascade).
    - `test/asset_storage_test.dart` (1 tes: sandbox copying, sha256 checksum).

---

## 8. Rincian Pengerjaan Fase 6 — Checklist Pulang dan Template

### Tujuan Fase 6
Mengimplementasikan alur verifikasi barang kepulangan/perpindahan perhentian (`RET-01` s/d `RET-05`, `AT-17`) dan sistem template packing bawaan yang reusable (`TPL-01` s/d `TPL-03`, `AT-18`) secara offline-first menggunakan SQLite, dengan integritas data yang jujur (tidak ada kesimpulan otomatis aman), perhitungan kuantitas terisolasi tanpa merusak stok inventaris master, dan integrasi penuh pada antarmuka pengguna.

### Checklist Pekerjaan Fase 6

- [x] **Repositori Checkpoints Pulang (`CheckpointsRepository`)**:
  - `createCheckpoint`: Mengambil snapshot HANYA dari barang yang berstatus dibawa (`decision == 'carried'`) dan benar-benar sudah dikemas (`packed_quantity > 0`) pada perjalanan terkait (`RET-01`, `RET-02`).
  - `updateReturnEntryQuantities`: Memfasilitasi 3 kategori konfirmasi pengembalian (`returned_quantity` [dibawa kembali], `consumed_quantity` [habis dipakai], `left_quantity` [sengaja ditinggal]) dengan validasi constraint ketat: `confirmed = returned + consumed + left <= expected_quantity` dan semua kuantitas non-negatif (`RET-03`, `AT-17`).
  - Perhitungan sisa belum terkonfirmasi: `unconfirmed = expected_quantity - confirmed`.
  - Isolasi stok inventaris: Konfirmasi checkpoint TIDAK mengubah atau mengurangi stok master di tabel `Items` (`RET-04`, `AT-17`).
  - Penutupan checkpoint jujur (`closeCheckpoint`): Jika masih ada unit belum terkonfirmasi (`unconfirmed > 0`), checkpoint dicatat sebagai `closed_with_unconfirmed` (BUKAN `completed`/selesai), dengan timestamp `closed_at` (`RET-05`, `AT-17`). Hanya jika seluruh unit terkonfirmasi lengkap (`unconfirmed == 0`), status dicatat `completed`.
- [x] **Repositori Template Packing (`TemplatesRepository`)**:
  - `createTemplate`: Membuat template baru dengan nama, catatan opsional, dan daftar item serta kuantitas rencana (`TPL-01`).
  - `createTemplateFromTrip`: Mengonversi seluruh barang yang dibawa pada perjalanan aktif menjadi template packing reusable (`TPL-01`, `AT-18`).
  - `applyTemplateToTrip`: Menerapkan template ke suatu perjalanan dengan aturan:
    1. `packed_quantity` SELALU direset ke 0 pada perjalanan target (`TPL-02`, `AT-18`).
    2. TIDAK menduplikasi atau membuat baris barang baru di tabel master `Items` (`AT-18`).
    3. Mengembalikan peringatan (`warnings`) jika ada barang template yang sedang diarsipkan di inventaris (`archived_at != null`) atau jika stok inventaris master lebih sedikit daripada kebutuhan template (`TPL-03`, `AT-18`). Kuantitas rencana dibatasi maksimal sebanyak stok inventaris yang tersedia.
- [x] **Integrasi Antarmuka Pengguna (UI Screens)**:
  - `CheckpointScreen` (`lib/features/trips/checkpoint_screen.dart`):
    - Menggantikan prototipe state dengan reactive SQLite stream (`tripCheckpointsStreamProvider`).
    - State kosong informatif jika belum ada checkpoint dengan tombol "Buat Checkpoint Sekarang" (validasi minimal ada 1 barang dikemas).
    - Selector antar-checkpoint jika terdapat lebih dari satu snapshot.
    - Banner status checkpoint dengan warna semantik jujur (hijau jika lengkap, kuning peringatan jika ada sisa belum terkonfirmasi).
    - Kartu barang interaktif dengan 3 pengatur kuantitas (+/-) untuk Kembali, Habis, dan Ditinggal, tombol "Kembali Semua", dan dialog penambahan catatan (misal dugaan tertinggal di hotel).
    - Tombol penutupan checkpoint dengan dialog konfirmasi yang secara eksplisit memperingatkan jika terdapat sisa belum terkonfirmasi bahwa status akan dicatat sebagai "Ditutup dengan sisa", bukan selesai.
  - `TripDetailScreen` (`lib/features/trips/trip_detail_screen.dart`):
    - Tab 1 (Ringkasan): Menambahkan kartu "Cek Sebelum Pulang" dengan status snapshot terkini (Aktif/Selesai/Ditutup dg sisa) dan tombol cepat navigasi ke checkpoint.
    - Tab 2 (Bawaan): Menambahkan tombol "Terapkan Template" di action bar bawah dan menu popup "Simpan Bawaan sbg Template" serta "Terapkan Template" dengan modal sheet preview & dialog peringatan stok/arsip (`TPL-03`).
- [x] **Pengujian Otomatis & Analisis Kode**:
  - `test/checkpoints_and_templates_test.dart`: 9 tes spesifik memverifikasi `RET-01` s/d `RET-05`, `TPL-01` s/d `TPL-03`, `AT-17`, dan `AT-18`.
  - `flutter analyze`: **0 issues found** (tidak ada warning atau error).
  - `flutter test`: **55/55 tests passed** di seluruh suite:
    - `test/checkpoints_and_templates_test.dart` (9 tes: RET-01..05, TPL-01..03, AT-17, AT-18).
    - `test/reminders_and_notifications_test.dart` (8 tes: SCH-08..11, SCH-12, AT-12..16).
    - `test/schedules_and_tickets_test.dart` (8 tes: SCH-01..07, SCH-12, AT-09..11).
    - `test/trips_and_packing_test.dart` (13 tes: TRP-01..08, PCK-01..12).
    - `test/inventory_repository_test.dart` (8 tes: INV-01..09).
    - `test/features_test.dart` (3 tes: packing check & undo snackbar, empty state, form validation).
    - `test/widget_test.dart` (3 tes: smoke, navigation, 360dp & 1.5x font scale accessibility).
    - `test/database_test.dart` (2 tes: default seeding, foreign key cascade).
    - `test/asset_storage_test.dart` (1 tes: sandbox copying, sha256 checksum).

---

## 9. Matriks Kebutuhan Fungsional & Kesiapan

| ID Kebutuhan | Deskripsi Singkat | Status Saat Ini | Fase Pelaksana |
| --- | --- | --- | --- |
| **INV-01 .. INV-09** | Manajemen Inventaris, Lokasi Simpan, Foto, Kategori | **SELESAI** (Persistensi SQLite & UI Nyata) | Fase 2 |
| **TRP-01 .. TRP-08** | Manajemen Perjalanan, Multi-Kota, Status, Duplikasi | **SELESAI** (Persistensi SQLite & UI Nyata) | Fase 3 |
| **PCK-01 .. PCK-12** | Daftar Bawaan, Packing Parsial, Centang, Tas Opsional, Konflik | **SELESAI** (Persistensi SQLite & UI Nyata) | Fase 3 |
| **SCH-01 .. SCH-07, SCH-12** | Jadwal, Timezone IANA, Tiket Offline, Lampiran | **SELESAI** (Persistensi SQLite & File Sandbox) | Fase 4 |
| **SCH-08 .. SCH-11** | Pengingat Lokal Android, Exact Alarm, Reschedule | **SELESAI** (Plugin Notifikasi, Alarm & SQLite) | Fase 5 |
| **RET-01 .. RET-05** | Checkpoint Pulang, Sisa Belum Terkonfirmasi | **SELESAI** (Snapshot SQLite, 3 Kategori, Status Jujur) | Fase 6 |
| **TPL-01 .. TPL-03** | Template Packing Reusable, Peringatan Stok | **SELESAI** (Reset Packed ke 0, Isolasi Stok, Warning) | Fase 6 |
| **BAK-01 .. BAK-07** | Ekspor-Impor Backup ZIP, Validasi, Rollback | Prototipe UI (Fase 1) | Fase 7 (Implementasi Arsip ZIP) |
| **SET-01 .. SET-02** | Pengaturan Aplikasi & Hapus Data Aman | **SELESAI** (Preferensi, Alarm & Reset Dialog) | Fase 5 & Fase 7 |

---

## 10. Handoff dan Langkah Selanjutnya

- **Fase 6 Telah Selesai**: Seluruh repositori checkpoint (`CheckpointsRepository`), repositori template (`TemplatesRepository`), integrasi UI layar pemeriksaan kepulangan (`CheckpointScreen`), penambahan aksi template di ringkasan dan daftar bawaan (`TripDetailScreen`), serta pengujian otomatis acceptance test (`AT-17`, `AT-18`) telah selesai diuji dan diverifikasi secara menyeluruh (analisis 0 masalah, 100% tes lolos: 55/55).
- **Kondisi Berhenti**: Sesuai instruksi pengguna dan aturan pengerjaan bertahap (PRD Seksi 2.1 & 15.3), AI **berhenti di Fase 6** dan melaporkan hasil kerja secara rinci.
- **Langkah Berikutnya**: Menunggu instruksi eksplisit dari pengguna sebelum memulai **Fase 7 — Backup, restore, dan pengaturan**.



