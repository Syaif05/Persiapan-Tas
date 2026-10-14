# Keputusan Arsitektur dan Teknis (Architectural Decision Record)
Proyek: **Bawa — Aplikasi pribadi untuk barang, bawaan, dan perjalanan**
Dokumen: `docs/DECISIONS.md`
Status: **Final (Fase 0)**
Tanggal: 10 Oktober 2026

---

## 1. Ringkasan & Prinsip Utama Produk

Bawa adalah aplikasi Android personal (offline-first, zero-account, zero-backend, zero-telemetry) yang dibangun dengan Flutter untuk memecahkan masalah mendasar:
1. **Lupa lokasi penyimpanan barang** (menghindari bongkar-bongkar kotak fisik).
2. **Pencampuran antara rencana bawaan dengan tindakan fisik packing**.
3. **Persiapan perjalanan multi-kota dan perjalanan berdekatan** yang memakai ulang barang inventaris.
4. **Jadwal dan tiket offline** yang mudah terlewat tanpa pengingat lokal yang tepat.
5. **Pengecekan barang saat kembali pulang** agar barang tidak tertinggal.

---

## 2. ADR-01: Pemisahan Entitas Kotak (Lokasi Simpan) vs Tas (Wadah Perjalanan) vs Status Packing

### Konteks & Masalah
Dalam pengelolaan barang perjalanan, pengguna sering tertukar antara:
- Di mana barang disimpan sehari-hari di rumah.
- Apa yang direncanakan untuk dibawa pada suatu perjalanan.
- Tas apa yang dipakai untuk membawa barang tersebut.
- Apakah barang fisik sudah benar-benar masuk ke dalam tas.

Jika status packing dilekatkan pada data global barang, maka:
- Perencanaan perjalanan kedua (misal Jakarta) akan langsung menganggap barang sudah dikemas jika perjalanan pertama (misal Bandung) sudah mengemasnya.
- Menandai barang dibawa seolah memindahkan lokasi penyimpanan permanen barang.

### Keputusan
1. **Kotak (`StorageLocation`)**: Merupakan penanda lokasi penyimpanan fisik asal / rujukan permanen (contoh: "Kotak Elektronik di rak bawah meja", "Lemari Utama"). Kotak **TIDAK** otomatis menjadi wadah yang ikut dibawa.
2. **Tas (`TripBag`)**: Wadah perjalanan yang opsional dan terikat spesifik pada satu entitas `Trip` (contoh: "Ransel Hitam", "Koper Kabin").
   - Pengguna **TIDAK DIWAJIBKAN** membuat tas untuk menyelesaikan packing.
   - Satu baris bawaan (`TripItem`) dapat memilih satu tas opsional.
3. **Status Packing (`TripItem`)**: Bersifat lokal dan terisolasi per perjalanan.
   - Terdiri dari 3 informasi yang berdiri sendiri:
     - **Lokasi simpan asal**: Didapat dari relasi `Item.storage_location_id` (dengan snapshot nama saat dipilih).
     - **Keputusan per perjalanan**: `decision` (`carried` [dibawa], `not_carried` [tidak dibawa], `undecided` [belum diputuskan]).
     - **Tindakan aktual packing**: `packed_quantity` (0 s/d `planned_quantity`).
4. **Independensi Perjalanan**:
   - Barang yang sama (contoh: Charger USB-C) dapat direncanakan di Perjalanan A dan Perjalanan B.
   - Menyelesaikan packing di Perjalanan A sama sekali **tidak** mengubah status packing di Perjalanan B.
   - `packed_quantity` **tidak pernah** mengurangi stok master `Item.quantity`. Packing adalah penandaan fisik masuk tas, bukan transaksi konsumsi/penjualan.

---

## 3. ADR-02: Aturan Perhitungan Kuantitas (Quantity), Status, dan Deteksi Konflik

### Keputusan Status Bawaan (`TripItem`)
- `planned_quantity`: Jumlah yang direncanakan dibawa untuk perjalanan tersebut. Wajib bulat minimal 1 jika keputusan `carried`. Tidak boleh melebihi `Item.quantity` saat dipilih.
- `packed_quantity`: Jumlah unit yang sudah dimasukkan ke tas (`0 <= packed_quantity <= planned_quantity`).
- **Status packing diturunkan secara deterministik**:
  - `belum_dikemas`: `packed_quantity == 0` dan `planned_quantity > 0`.
  - `sebagian`: `0 < packed_quantity < planned_quantity`.
  - `selesai`: `packed_quantity == planned_quantity` dan `planned_quantity > 0`.
  - `tidak_dibawa`: `decision == not_carried` (`planned_quantity = 0`, `packed_quantity = 0`).
  - `belum_diputuskan`: Barang ada di inventaris tetapi belum dimasukkan ke daftar perjalanan (`TripItem` belum dibuat untuk item tersebut).

### Progres Kesiapan Perjalanan
- **Rumus Progres Utama**: `(Jumlah baris TripItem berstatus 'selesai') / (Jumlah baris TripItem berkeputusan 'dibawa')`.
- Jika belum ada barang yang dipilih dibawa (`baris dibawa == 0`): Tampilkan `"Belum ada daftar bawaan"`, **BUKAN** `"100% siap"`.
- Progres sekunder (teks pendukung): Menampilkan total unit (misal `"12 dari 15 barang dikemas"`). Dua rumus ini tidak boleh dicampuradukkan.

### Penanganan Perubahan dan Validasi
- **Mengubah keputusan menjadi 'tidak dibawa' pada item yang sudah dikemas**: Aplikasi wajib memunculkan dialog konfirmasi untuk mereset `packed_quantity` ke 0.
- **Mengurangi `planned_quantity` di bawah `packed_quantity`**: Ditolak atau meminta koreksi `packed_quantity` terlebih dahulu.
- **Undo centang**: Menyediakan feedback instan (Snackbar dengan aksi Undo) dan menyimpan perubahan secara persisten.

### Deteksi Konflik Perjalanan Bertumpang Tindih (Overlap)
- Konflik terjadi jika dua perjalanan memiliki rentang tanggal yang beririsan (`start_date` s/d `end_date`), dan total `planned_quantity` barang pada perjalanan-perjalanan tersebut melebihi total `Item.quantity` di inventaris.
- Jika perjalanan berurutan tanpa irisan tanggal: **TIDAK** dihitung konflik karena barang dapat digunakan kembali.
- Jika salah satu perjalanan belum memiliki `end_date`: Tampilkan peringatan potensi ketidakpastian rentang waktu, bukan konflik mutlak.
- Peringatan konflik bersifat informatif dan **tidak memblokir** pengguna menyimpan rencana.

---

## 4. ADR-03: Flutter Toolchain & Target Platform

### Hasil Pemeriksaan Lingkungan Lokal (Verifikasi Nyata)
- **OS**: Windows 11 (build 26300.9550).
- **Flutter SDK**: 3.44.8 (channel stable).
- **Dart SDK**: 3.12.2.
- **Java**: Java SE 26.0.1 terpasang; Android Studio JBR terinstal di `C:\Program Files\Android\Android Studio\jbr`.
- **Android SDK**: Terpasang di `C:\Users\syaif\AppData\Local\Android\sdk`.
  - Platform terpasang: `android-33`, `android-34`, `android-35`, `android-36`, `android-36.1`, `android-37.0`.
  - Build-tools terpasang: `34.0.0` s/d `37.0.0`.
  - AVD Emulator: `Pixel_10`.
- **Catatan & Keterbatasan Toolchain Saat Ini**:
  - `cmdline-tools` Android belum terpasang di SDK folder, sehingga perintah CLI `flutter doctor --android-licenses` belum dapat dieksekusi dari command-line. Hal ini dicatat sebagai prasyarat instalasi di Android Studio SDK Manager sebelum build release APK di Fase 8.
  - Perangkat aktif saat ini: Windows desktop, Chrome, Edge. AVD `Pixel_10` dapat dijalankan untuk pengujian Android.

### Penetapan Target SDK Android
- **Minimum SDK**: `minSdkVersion = 26` (Android 8.0 Oreo).
  - *Alasan*: Android 8.0 adalah batas minimal fitur modern Android yang stabil (Notification Channels wajib, API `java.time` native, storage permissions modern, serta mencakup >95% perangkat Android di pasar).
- **Target SDK**: `targetSdkVersion = 34` (Android 14) atau `35` (Android 15).
- **Compile SDK**: `compileSdkVersion = 35`.

---

## 5. ADR-04: Pemilihan Dependensi dan Evaluasi Lisensi

Seluruh paket pihak ketiga dipilih dengan kriteria:
1. Lisensi open source sangat permisif (MIT, BSD-3-Clause, Apache-2.0). **Tidak ada dependensi Copyleft (GPL/AGPL)**.
2. Tidak memerlukan server, cloud, atau analitik eksternal.
3. Stabil dan kompatibel dengan Flutter 3.44.8 dan Dart 3.12.x.

| Kategori | Paket & Versi Target | Lisensi | Alasan Pemilihan & Ketentuan |
| --- | --- | --- | --- |
| **State Management** | `flutter_riverpod: ^2.6.1` | MIT | State management deklaratif, isolasi state mudah diuji unit tanpa Flutter UI context, aman dari memory leak. |
| **Database & ORM** | `drift: ^2.24.2`<br>`sqlite3_flutter_libs: ^0.5.28`<br>`path: ^1.9.1`<br>`drift_dev: ^2.24.2` *(dev)* | MIT | Type-safe SQLite persistence, dukungan skema migrasi terstruktur, foreign key support, transaksi ACID lokal. |
| **Routing** | `go_router: ^14.8.1` | BSD-3-Clause | Declarative routing resmi, navigasi bertingkat, penanganan deep-link dari payload notifikasi lokal cold-start. |
| **Penyimpanan Lokal** | `path_provider: ^2.1.5` | BSD-3-Clause | Mendapatkan folder sandboxed app-private (`getApplicationDocumentsDirectory`) secara konsisten. |
| **Media & Foto** | `image_picker: ^1.1.2` | BSD-3-Clause | Menggunakan sistem Photo Picker modern Android (tidak memerlukan izin `READ_MEDIA_IMAGES` luas). |
| **Dokumen & Picker** | `file_picker: ^8.1.7` | MIT | Dukungan Android Storage Access Framework (SAF) untuk memilih file PDF tiket dan lokasi arsip ZIP backup. |
| **Notifikasi Lokal** | `flutter_local_notifications: ^18.0.1` | BSD-3-Clause | Pengelolaan jadwal alarm dan notifikasi lokal Android dengan dukungan Notification Channel & exact alarms. |
| **Zona Waktu** | `timezone: ^0.9.4`<br>`flutter_timezone: ^3.0.1` | BSD-2-Clause / Apache-2.0 | `flutter_timezone` membaca timezone IANA asli dari perangkat Android; `timezone` menangani konversi jam lokal & UTC. |
| **Format Tanggal** | `intl: ^0.20.2` | BSD-3-Clause | Standarisasi jam format 24-jam dan lokalisasi tanggal Bahasa Indonesia (`id_ID`). |
| **ID & Hashing** | `uuid: ^4.5.1`<br>`crypto: ^3.0.6` | MIT / BSD-3-Clause | UUID v4 untuk identitas unik stabil; SHA-256 untuk verifikasi integritas backup dan asset lampiran. |
| **Backup Archive** | `archive: ^4.0.2` | Apache-2.0 | Ekstraksi dan pembuatan file ZIP lokal murni di Dart tanpa ketergantungan utility OS eksternal. |
| **Buka Lampiran** | `open_filex: ^4.5.0` | MIT | Membuka PDF atau file tiket via sistem Android `FileProvider` (Intent aman) ke viewer lokal terpasang. |

---

## 6. ADR-05: Strategi Penyimpanan File, Foto, dan Lampiran Tiket

### Masalah
Jika aplikasi hanya menyimpan URI picker atau path absolut galeri:
1. Ketika pengguna memindahkan atau menghapus foto di galeri luar, foto di aplikasi menjadi hilang/corrupt.
2. Ketika backup diekspor-diimpor ke perangkat baru, path absolut perangkat lama menjadi invalid.
3. Gambar resolusi penuh kamera (10–50 MB) jika di-decode langsung pada daftar barang akan menyebabkan UI jank atau OOM (Out Of Memory).

### Keputusan Teknis
1. **Penyimpanan Terisolasi (App-Private Sandbox)**:
   - File sementara dari picker/kamera langsung disalin ke folder `app_data/assets/` dengan nama unik `<uuid>.<ext>`.
   - Database hanya menyimpan **path relatif** (contoh: `assets/9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d.jpg`).
   - Sumber asli di galeri boleh dihapus pengguna tanpa memengaruhi salinan di aplikasi.
2. **Spesifikasi Kompresi & Thumbnail**:
   - Foto barang: kompresi sisi terpanjang maksimal 1600 px (kualitas JPEG ~85%).
   - Thumbnail foto barang: dihasilkan saat impor dengan ukuran ~200 px persegi untuk rendering mulus di daftar inventaris.
   - **Pengecualian Kritis untuk Tiket**: Gambar tiket/boarding pass **TIDAK BOLEH dikompresi berlebihan** agar QR code / Barcode tetap tajam dan dapat dipindai saat di-zoom. File asli tiket dipertahankan.
3. **Batas Ukuran**: Maksimal 20 MB per file lampiran. Validasi ukuran dijalankan sebelum file disimpan.
4. **Penanganan Lampiran Hilang**: Jika file terhapus secara anomali, UI menampilkan placeholder yang jelas dan tombol aksi untuk mengganti lampiran, tanpa menyebabkan crash.

---

## 7. ADR-06: Strategi Penjadwalan & Pengingat Android (Local Notifications)

### Penanganan Waktu Jadwal
- **Jadwal dengan Jam**:
  - Menyimpan: `local_date`, `local_start`, `start_zone` (nama zona IANA, contoh `Asia/Jakarta`), dan `start_utc` (instant UTC terhitung).
  - Jika zona perangkat berubah saat bepergian: instant UTC tetap stabil, UI menampilkan label zona terkait (contoh: `07.30 WIB`).
- **Jadwal Tanpa Jam (`is_date_only = true`)**:
  - Disimpan sebagai tanggal lokal murni.
  - **DILARANG DIUBAH MENJADI JAM 00.00 SECARA OTOMATIS**.
  - Pengingat untuk jadwal tanggal saja mewajibkan jam eksplisit (default yang disarankan: jam 09.00 pada tanggal tersebut).

### Pengelolaan Izin & Alarm Android
1. **Izin Notifikasi (`POST_NOTIFICATIONS` - Android 13+)**:
   - Diminta secara kontekstual hanya saat pengguna pertama kali menyalakan pengingat.
   - Jika ditolak: jadwal tetap tersimpan, UI secara jujur menampilkan status `"Izin notifikasi belum aktif"`.
2. **Ketepatan Alarm (Exact vs Inexact)**:
   - Pengingat kritis menggunakan `SCHEDULE_EXACT_ALARM` jika izin tersedia di pengaturan sistem.
   - Jika izin exact alarm tidak tersedia: otomatis fallback ke inexact alarm dengan status UI `"Pengingat perkiraan waktu"`.
   - Tidak menggunakan `USE_EXACT_ALARM` tanpa evaluasi kebijakan.
3. **Siklus Hidup & Penjadwalan Ulang**:
   - Mendaftarkan BroadcastReceiver untuk `ACTION_BOOT_COMPLETED`, `ACTION_TIMEZONE_CHANGED`, dan `ACTION_MY_PACKAGE_REPLACED`.
   - Mengedit/menghapus jadwal otomatis membatalkan alarm lama dan membuat alarm baru dengan mapping notification ID unik berbasis hash integer stabil dari UUID reminder.
4. **Navigasi Notifikasi**:
   - Payload notifikasi membawa `event_id` dan `trip_id`.
   - Baik aplikasi sedang berjalan di background maupun cold-start, tap pada notifikasi mengarahkan pengguna langsung ke detail jadwal yang bersangkutan via `go_router`.

---

## 8. ADR-07: Strategi Ekspor dan Impor Backup

### Format Arsip
Format: file ZIP tunggal bernama `Bawa_Backup_YYYYMMDD_HHmm.zip`.
Isi arsip:
```text
manifest.json
data.json
assets/
  <asset_uuid_1>.jpg
  <asset_uuid_2>.pdf
```

### Keamanan & Validasi Impor
1. **Pencegahan Path Traversal**: Setiap entri file di dalam ZIP diperiksa sebelum diekstrak. File dengan nama yang mengandung `..`, karakter path absolut, atau symlink akan langsung ditolak.
2. **Batas Proteksi Ukuran**:
   - Maksimal ukuran file ZIP: 512 MB.
   - Maksimal total hasil ekstraksi: 1 GB.
   - Maksimal ukuran per file lampiran: 20 MB.
   - Maksimal jumlah entitas: 10.000 baris.
3. **Verifikasi Integritas**: Membandingkan checksum SHA-256 setiap asset dengan yang tercatat di `manifest.json`.
4. **Mode Penggantian Penuh (Replace All)**: Impor versi 1.0 menggantikan seluruh data lokal, bukan penggabungan (merge). UI preview wajib menampilkan rincian data cadangan dan dialog konfirmasi bahaya sebelum eksekusi.
5. **Atomic Restore & Jurnal Pemulihan**:
   - Ekstraksi dilakukan ke direktori staging sementara.
   - Database dan filesystem asset diganti dalam transaksi terkontrol dengan file penanda jurnal (`restore_journal.json`).
   - Jika aplikasi mati/force-close saat restore, startup berikutnya membaca jurnal dan melakukan rollback ke snapshot sebelumnya.
6. **Pasca Restore**: Jadwal pengingat lama dibatalkan dan dijadwalkan ulang untuk reminder masa depan sesuai izin perangkat saat ini.

---

## 9. ADR-08: Skema Database Relasional Lengkap (Drift / SQLite)

### Konvensi
- UUID v4 (`TEXT`) sebagai Primary Key stabil pada semua entitas.
- Timestamps teknis (`created_at`, `updated_at`, `archived_at`) disimpan dalam ISO-8601 UTC string atau integer epoch milliseconds.
- Enforcing Foreign Keys (`PRAGMA foreign_keys = ON;`).

### Daftar Tabel
1. `storage_locations`:
   - `id` (TEXT PK), `name` (TEXT NOT NULL), `type` (TEXT NOT NULL - 'box'|'wardrobe'|'drawer'|'other'), `description` (TEXT), `photo_asset_id` (TEXT FK assets), `archived_at` (TEXT).
2. `categories`:
   - `id` (TEXT PK), `name` (TEXT NOT NULL UNIQUE), `sort_order` (INTEGER NOT NULL DEFAULT 0).
3. `items`:
   - `id` (TEXT PK), `name` (TEXT NOT NULL), `quantity` (INTEGER NOT NULL DEFAULT 1), `unit` (TEXT NOT NULL DEFAULT 'buah'), `category_id` (TEXT FK categories), `storage_location_id` (TEXT FK storage_locations), `notes` (TEXT), `is_important` (INTEGER NOT NULL DEFAULT 0), `archived_at` (TEXT), `created_at` (TEXT NOT NULL), `updated_at` (TEXT NOT NULL).
4. `item_photos`:
   - `id` (TEXT PK), `item_id` (TEXT NOT NULL FK items ON DELETE CASCADE), `asset_id` (TEXT NOT NULL FK assets), `sort_order` (INTEGER NOT NULL DEFAULT 0).
5. `assets`:
   - `id` (TEXT PK), `relative_path` (TEXT NOT NULL), `mime_type` (TEXT NOT NULL), `size_bytes` (INTEGER NOT NULL), `sha256` (TEXT NOT NULL), `original_name` (TEXT NOT NULL), `kind` (TEXT NOT NULL - 'item_photo'|'ticket_attachment'|'location_photo').
6. `trips`:
   - `id` (TEXT PK), `name` (TEXT NOT NULL), `start_date` (TEXT NOT NULL), `end_date` (TEXT), `date_zone_id` (TEXT NOT NULL), `status` (TEXT NOT NULL DEFAULT 'planning' - 'planning'|'ongoing'|'completed'|'cancelled'), `is_archived` (INTEGER NOT NULL DEFAULT 0), `is_pinned` (INTEGER NOT NULL DEFAULT 0), `notes` (TEXT), `created_at` (TEXT NOT NULL), `updated_at` (TEXT NOT NULL).
7. `trip_stops`:
   - `id` (TEXT PK), `trip_id` (TEXT NOT NULL FK trips ON DELETE CASCADE), `label` (TEXT NOT NULL), `sort_order` (INTEGER NOT NULL DEFAULT 0), `arrival_local` (TEXT), `arrival_zone` (TEXT), `departure_local` (TEXT), `departure_zone` (TEXT).
8. `trip_bags`:
   - `id` (TEXT PK), `trip_id` (TEXT NOT NULL FK trips ON DELETE CASCADE), `name` (TEXT NOT NULL), `description` (TEXT).
9. `trip_items`:
   - `id` (TEXT PK), `trip_id` (TEXT NOT NULL FK trips ON DELETE CASCADE), `item_id` (TEXT NOT NULL FK items), `decision` (TEXT NOT NULL DEFAULT 'carried' - 'carried'|'not_carried'), `planned_quantity` (INTEGER NOT NULL DEFAULT 1), `packed_quantity` (INTEGER NOT NULL DEFAULT 0), `trip_bag_id` (TEXT FK trip_bags), `notes` (TEXT), `name_snapshot` (TEXT NOT NULL), `source_label_snapshot` (TEXT), `updated_at` (TEXT NOT NULL), UNIQUE(`trip_id`, `item_id`).
10. `schedule_events`:
    - `id` (TEXT PK), `trip_id` (TEXT NOT NULL FK trips ON DELETE CASCADE), `trip_stop_id` (TEXT FK trip_stops), `title` (TEXT NOT NULL), `type` (TEXT NOT NULL - 'transport'|'lodging'|'activity'|'preparation'|'other'), `is_date_only` (INTEGER NOT NULL DEFAULT 0), `local_date` (TEXT NOT NULL), `local_start` (TEXT), `start_zone` (TEXT), `start_utc` (TEXT), `local_end` (TEXT), `end_zone` (TEXT), `end_utc` (TEXT), `location_text` (TEXT), `notes` (TEXT), `status` (TEXT NOT NULL DEFAULT 'planned').
11. `tickets`:
    - `id` (TEXT PK), `trip_id` (TEXT NOT NULL FK trips ON DELETE CASCADE), `schedule_event_id` (TEXT FK schedule_events), `title` (TEXT NOT NULL), `provider` (TEXT), `booking_code` (TEXT), `notes` (TEXT).
12. `ticket_attachments`:
    - `id` (TEXT PK), `ticket_id` (TEXT NOT NULL FK tickets ON DELETE CASCADE), `asset_id` (TEXT NOT NULL FK assets), `sort_order` (INTEGER NOT NULL DEFAULT 0).
13. `reminders`:
    - `id` (TEXT PK), `schedule_event_id` (TEXT NOT NULL FK schedule_events ON DELETE CASCADE), `trigger_utc` (TEXT NOT NULL), `notification_id` (INTEGER NOT NULL UNIQUE), `precision_preference` (TEXT NOT NULL DEFAULT 'exact' - 'exact'|'inexact'), `scheduling_state` (TEXT NOT NULL DEFAULT 'active' - 'active'|'pending_permission'|'dismissed'), `enabled` (INTEGER NOT NULL DEFAULT 1).
14. `return_checkpoints`:
    - `id` (TEXT PK), `trip_id` (TEXT NOT NULL FK trips ON DELETE CASCADE), `trip_stop_id` (TEXT FK trip_stops), `title` (TEXT NOT NULL), `created_at` (TEXT NOT NULL), `closed_at` (TEXT), `close_state` (TEXT NOT NULL DEFAULT 'open' - 'open'|'completed'|'closed_with_unconfirmed').
15. `return_entries`:
    - `id` (TEXT PK), `checkpoint_id` (TEXT NOT NULL FK return_checkpoints ON DELETE CASCADE), `trip_item_id` (TEXT NOT NULL FK trip_items), `name_snapshot` (TEXT NOT NULL), `expected_quantity` (INTEGER NOT NULL), `returned_quantity` (INTEGER NOT NULL DEFAULT 0), `consumed_quantity` (INTEGER NOT NULL DEFAULT 0), `left_quantity` (INTEGER NOT NULL DEFAULT 0), `notes` (TEXT).
16. `packing_templates`:
    - `id` (TEXT PK), `name` (TEXT NOT NULL), `notes` (TEXT), `created_at` (TEXT NOT NULL), `updated_at` (TEXT NOT NULL).
17. `template_items`:
    - `id` (TEXT PK), `template_id` (TEXT NOT NULL FK packing_templates ON DELETE CASCADE), `item_id` (TEXT NOT NULL FK items), `planned_quantity` (INTEGER NOT NULL DEFAULT 1), `notes` (TEXT), UNIQUE(`template_id`, `item_id`).
18. `app_settings`:
    - `key` (TEXT PK), `value` (TEXT NOT NULL).

---

## 10. ADR-09: Arsitektur Navigasi dan Hierarki Layar

### Tab Utama Global (4 Tab)
1. **Beranda (`/home`)**:
   - Kartu perjalanan terdekat / yang sedang berlangsung.
   - Ringkasan sisa packing dan checklist cepat.
   - Jadwal berikutnya dalam 24-48 jam ke depan.
   - Ikon pengaturan di pojok kanan atas menuju `/settings`.
2. **Barang (`/inventory`)**:
   - Pencarian cepat nama barang, lokasi, atau kategori.
   - Filter chip: Kategori, Lokasi Simpan, Penanda Penting.
   - Daftar barang dengan thumbnail foto, jumlah, dan nama kotak asal.
   - Akses ke Subhalaman Lokasi Simpan (`/inventory/locations`).
3. **Perjalanan (`/trips`)**:
   - Tab segmen: Berlangsung, Persiapan, Riwayat (Selesai/Batal).
   - Kartu perjalanan dengan tujuan berurutan, tanggal, dan progress ringkas.
4. **Agenda (`/agenda`)**:
   - Tampilan agenda global kronologis seluruh perjalanan.
   - Pilihan toggle tampilan kalender bulanan.

### Navigasi di Dalam Perjalanan (`/trips/:id`)
Diatur dalam 4 bagian/tab sub-konteks:
1. **Ringkasan**: Tujuan berurutan (`TripStop`), tanggal, status, kesiapan packing, tombol periksa sebelum berangkat.
2. **Bawaan**: Daftar `TripItem`, filter (Semua, Belum dikemas, Sebagian, Selesai, Tidak dibawa), centang cepat, asal kotak, tas opsional.
3. **Jadwal**: Timeline kegiatan & transportasi yang terkait perjalanan ini.
4. **Tiket**: Daftar reservasi tiket dan lampirannya.
5. **Aksi Kontekstual Menu**: Cek sebelum pulang (Checkpoint), Duplikasi perjalanan, Kelola tas, Simpan sebagai template.
