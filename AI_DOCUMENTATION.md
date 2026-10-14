# DOKUMENTASI SISTEM & SPESIFIKASI PRODUK: SIAPKAN TAS

Dokumen ini disusun secara terstruktur, eksplisit, dan komprehensif agar dapat dibaca, dipahami, dan dijadikan acuan konteks teknis maupun produk oleh sistem AI lain, LLM, atau pengembang perangkat lunak.

---

## Ringkasan Eksekutif & Identitas Proyek

| Parameter | Spesifikasi |
| :--- | :--- |
| **Nama Aplikasi** | **Siapkan Tas** (sebelumnya bernama kerja *Bawa*) |
| **Platform Target** | Android (minSdk: 26 / Android 8.0, targetSdk: 35 / Android 15, compileSdk: 36) |
| **Framework & Bahasa**| Flutter 3.27+ / Dart 3.6+ |
| **Arsitektur Kode** | Clean Architecture & Feature-First (Domain, Data, Presentation) |
| **Manajemen State** | Riverpod 2.x (StateNotifier / AsyncNotifier / StreamProvider) |
| **Database & Cache** | Drift (SQLite ORM) dengan isolasi 100% lokal (`app_database.dart`) |
| **Model Distribusi** | APK Mandiri Release teroptimasi (`--split-per-abi`, ukuran ~20–22 MB) |
| **Prinsip Dasar** | 100% Offline-First, Tanpa Akun, Tanpa Backend/Cloud, Privasi Mutlak |

---

## 1. Tujuan Aplikasi (Application Purpose & Core Mission)

### 1.1 Latar Belakang Masalah
1. **Lupa Kotak Penyimpanan**: Pengguna menyimpan barang di berbagai kotak fisik (misal: *Kotak Elektronik*, *Kotak Obat*, *Lemari Pakaian*). Saat memerlukan barang tertentu, pengguna sering kali harus membongkar banyak kotak fisik hanya untuk mencarinya.
2. **Kekacauan Antara Rencana dan Realitas Packing**: Daftar rencana bawaan sering tercampur dengan barang yang benar-benar telah dimasukkan ke dalam tas fisik.
3. **Perjalanan Berdekatan yang Berbenturan**: Beberapa perjalanan yang waktunya berdekatan menggunakan barang yang sama (misal: charger, jaket), menyebabkan kebingungan stok atau risiko barang tertinggal di kota sebelumnya.
4. **Jadwal & Tiket Tercecer**: Tiket perjalanan (PDF/gambar) dan jadwal agenda sering tersebar di berbagai aplikasi chat, email, dan galeri sehingga mudah terlewat.
5. **Barang Tertinggal Saat Pulang/Pindah Kota**: Ketika menginap di hotel atau berpindah kota, pengguna sering lupa barang apa saja yang dibawa dari rumah.

### 1.2 Misi Utama Produk
"Siapkan Tas" bertujuan membantu pengguna:
* Mengetahui seluruh inventaris barang pribadi yang dimiliki dan di kotak/lemari mana barang tersebut disimpan (dapat dilihat langsung tanpa membongkar kotak fisik).
* Merencanakan daftar bawaan untuk perjalanan (baik 1 tujuan maupun multi-kota).
* Melakukan proses packing ke dalam tas secara terorganisir dan terverifikasi secara fisik.
* Menyimpan jadwal kegiatan, tiket lokal (PDF/gambar), dan alarm pengingat tepat waktu tanpa membutuhkan koneksi internet.
* Memastikan seluruh barang yang dibawa kembali secara utuh saat pulang melalui fitur *Checklist Pulang* (*Returning Checkpoint*).

---

## 2. Model Mental & Aturan Domain (Core Mental Models)

AI yang memproses basis data atau kode aplikasi ini **WAJIB** memahami tiga pemisahan informasi berikut:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. LOKASI SIMPAN ASAL (Storage Location / Box)              │
│    - Rujukan fisik tempat barang disimpan di rumah.          │
│    - KOTAK TIDAK OTOMATIS IKUT KE PERJALANAN.               │
└──────────────────────────────┬──────────────────────────────┘
                               │ Digunakan untuk mencari barang
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. KEPUTUSAN PERJALANAN (Trip Decision)                     │
│    - Status: Dibawa (planned), Tidak Dibawa, Belum Diputuskan│
│    - Menentukan planned_quantity (minimal 1 unit).           │
└──────────────────────────────┬──────────────────────────────┘
                               │ Dilakukan tindakan packing fisik
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. TINDAKAN AKTUAL PACKING (Packed Action)                  │
│    - Status: packed_quantity (0 .. planned_quantity)        │
│    - Wadah perjalanan: Tas (Ransel, Koper) - OPSI OPSIONAL. │
│    - TIDAK MENGURANGI STOK INVENTARIS GUDANG.               │
└─────────────────────────────────────────────────────────────┘
```

### 2.1 Ketentuan Khusus yang Tidak Boleh Dilanggar
1. **Kotak vs Tas**:
   * **Kotak / Tempat Simpan** = Penanda lokasi penyimpanan rumah (contoh: *Kotak Kabel Bawah Meja*).
   * **Tas** = Wadah fisik yang dibawa bepergian (contoh: *Ransel Hitam*, *Koper Kabin*). Mencatat tas bersifat opsional; packing tetap sah tanpa tas.
2. **Packing Bukan Transaksi Penjualan**:
   * Mengemas barang ke tas (`packed_quantity`) **TIDAK** mengurangi stok inventaris global barang. Stok inventaris hanya berkurang jika pengguna secara eksplisit mengedit data barang di inventaris.
3. **Status Perjalanan Independen**:
   * Status packing pada Perjalanan A tidak mempengaruhi status barang di Perjalanan B. Barang yang sama dapat direncanakan untuk beberapa perjalanan sekaligus.
4. **Deteksi Konflik Beririsan (Overlap Conflict)**:
   * Potensi konflik terjadi jika jumlah rencana barang pada dua atau lebih perjalanan yang **rentang tanggalnya bertumpang tindih (overlap)** melebihi stok inventaris yang dimiliki. Jika tanggal perjalanan berurutan (tidak tumpang tindih), sistem tidak menganggapnya konflik.

---

## 3. Alur Penggunaan Aplikasi (User Workflows)

### 3.1 Alur 1: Pencatatan Inventaris & Lokasi Simpan
1. Pengguna membuka tab **Tas** atau **Beranda**, lalu memilih opsi tambah lokasi simpan (misal: "Kotak Elektronik", keterangan: "Rak lemari bawah").
2. Pengguna menambah barang baru (Nama: "Charger 65W", Stok: 2, Satuan: "buah", Lokasi: "Kotak Elektronik", Foto: opsional hingga 5 foto).
3. Jika saat input barang pengguna sudah memiliki rencana perjalanan aktif, pengguna dapat langsung memilih dropdown **"Masukkan ke Tas Perjalanan"** agar barang langsung terdaftar ke perjalanan tersebut.

### 3.2 Alur 2: Menyiapkan Perjalanan & Menentukan Bawaan
1. Pengguna membuka tab **Perjalanan**, menekan **"Tambah Perjalanan"**, mengisi nama (misal: "Liburan Bali"), tanggal mulai, dan daftar destinasi (misal: "Denpasar", "Ubud").
2. Dari detail perjalanan atau dari filter tab **Tas**, pengguna memilih barang-barang dari inventaris yang akan dibawa, lalu menentukan jumlah rencana (`planned_quantity`).
3. Sistem memvalidasi agar `planned_quantity` tidak melebihi stok inventaris saat pemilihan.

### 3.3 Alur 3: Packing Fisik Barang ke Tas
1. Pengguna memfilter daftar dengan opsi **"Belum Dikemas"**.
2. Di setiap baris barang, tertera asal kotak simpan (misal: `Asal: Kotak Elektronik`), sehingga pengguna tahu kotak mana yang harus dibuka di rumah.
3. Setelah barang fisik dimasukkan ke tas, pengguna menekan tombol status pil `[ ⚪ Kemas ]` yang langsung berubah menjadi `[ 🟢 Siap ]` secara instan (*silent feedback* tanpa popup mengganggu).
4. Pengguna dapat mengaitkan tas perjalanan (misal: *Ransel Hitam*) secara opsional.

### 3.4 Alur 4: Agenda, Tiket Offline, dan Pengingat
1. Pada tab **Agenda**, pengguna mencatat jadwal (transportasi, check-in, rapat) lengkap dengan tanggal, jam (format 24 jam), zona waktu IANA (`Asia/Jakarta`), dan opsi lampiran tiket (PDF atau gambar hingga 20 MB).
2. Tiket dan dokumen disalin ke direktori aman internal aplikasi agar dapat dibuka 100% offline saat mode pesawat.
3. Pengguna mengatur pengingat alarm (misal: 2 jam sebelum jadwal). Alarm dijadwalkan ke sistem Android via `AlarmManager` presisi.

### 3.5 Alur 5: Checklist Pulang (Returning Checkpoint)
1. Sebelum meninggalkan hotel atau kembali pulang ke rumah, pengguna membuka fitur **"Cek Sebelum Pulang"**.
2. Aplikasi mengunci snapshot dari seluruh barang yang tercatat berstatus `packed_quantity > 0`.
3. Pengguna memverifikasi kondisi fisik barang dengan rumus akuntansi kepemilikan:
   $$\text{Confirmed} = \text{Returned} + \text{Consumed} + \text{Intentionally Left}$$
   $$\text{Unconfirmed} = \text{Expected} - \text{Confirmed}$$
4. Jika masih ada sisa $\text{Unconfirmed} > 0$, barang tersebut ditandai belum terkonfirmasi (potensi tertinggal), sehingga pengguna dapat mencarinya sebelum checkout hotel.

---

## 4. Desain UI/UX & Desain Sistem

### 4.1 Prinsip Desain
* **Modern & Minimalis**: Mengacu pada estetika e-commerce modern / *shopping bag checkout*, fokus pada kejelasan data tanpa ornamen berlebih.
* **Non-Intrusif & Cepat**: Checklist packing bekerja instan tanpa jeda modal dialog. Snackbar notifikasi dibatasi maksimal 1.5 detik dengan `clearSnackBars()` otomatis agar tidak menumpuk.
* **Bebas Masalah Overflow**: Seluruh komponen kartu dan baris teks dibungkus `Expanded`/`Flexible` dengan proteksi elipsis untuk menjamin rendering bebas error pada layar sempit (360dp) maupun skala font besar (1.5x).

### 4.2 Skema Warna & Token Desain
* **Warna Utama (Primary Orange)**: `#FF5722` (Energetik, hangat, fokus perjalanan).
* **Warna Sekunder / Lembut**:
  * `Primary Soft`: `#FBE9E7`
  * `Primary Dark`: `#D84315`
  * `Surface`: `#FFFFFF`
  * `Background`: `#F8F9FA`
  * `Border`: `#E0E0E0`
  * `Success Green`: `#4CAF50` (Aksen status barang Siap)
  * `Error Red`: `#E53935`
* **Tipografi**: Menggunakan penataan tipe skala modern Material 3 dengan kontras teks tinggi (`#212121` untuk teks utama, `#757575` untuk teks sekunder).
* **Radius Sudut**:
  * Card: `12.0dp`
  * Input / Button: `8.0dp`
  * Status Pill: `20.0dp` (Kapsul penuh)

### 4.3 Anatomi 4 Tab Navigasi Utama
1. **Tab 1: Beranda (`/home`)**:
   * Header brand dengan logo resmi "Siapkan Tas".
   * Ringkasan statistik cepat: Perjalanan aktif terdekat, total barang belum dikemas, dan jadwal agenda mendatang.
   * Kartu perjalanan aktif dengan bilah progres packing interaktif.
2. **Tab 2: Tas (`/inventory`)**:
   * Header pemilih perjalanan aktif (*Dropdown Perjalanan*).
   * Mode Tas Perjalanan: Menampilkan barang-barang yang direncanakan untuk perjalanan yang dipilih dalam format kartu belanja rapi (thumbnail 54x54, nama, lokasi asal, tombol pil status `Kemas`/`Siap`, tombol hapus langsung, dan menu 3-titik untuk opsi salin ke trip lain).
   * Mode Semua Inventaris (Katalog Gudang): Menampilkan seluruh stok barang yang tersimpan di rumah beserta filter kategori dan lokasi kotak.
3. **Tab 3: Perjalanan (`/trips`)**:
   * Daftar seluruh perjalanan (Persiapan, Berlangsung, Selesai, Dibatalkan).
   * Fitur duplikasi perjalanan dan penerapan template packing.
4. **Tab 4: Agenda (`/agenda`)**:
   * Daftar kronologis kegiatan perjalanan dan agenda global.
   * Dukungan tampilan kalender bulanan dengan penanda titik jadwal.
   * Akses detail tiket dan pengingat alarm Android.

---

## 5. Fitur-Fitur Lengkap Aplikasi

### 5.1 Modul Inventaris & Lokasi Simpan (INV)
* **INV-01**: Tambah, baca, ubah, dan arsipkan barang inventaris dengan nama wajib dan jumlah bulat minimal 1.
* **INV-02**: Rincian barang mencakup nama, jumlah stok, satuan bebas (buah, pasang, set), kategori, lokasi simpan, catatan, foto, dan penanda barang penting (*important*).
* **INV-03**: Manajemen lokasi simpan (Kotak, Lemari, Laci, Rak) lengkap dengan nama, jenis, deskripsi, dan foto rujukan kotak.
* **INV-04**: Tampilan "Lihat Isi Kotak" untuk melihat seluruh barang di dalam kotak tertentu secara digital tanpa membongkar kotak fisik.
* **INV-05**: Dukungan barang tanpa lokasi (menampilkan label ramah *"Lokasi belum dicatat"*).
* **INV-06**: Galeri foto barang lokal (1 foto utama + hingga 4 foto tambahan) dengan fitur *Full Screen Image Viewer* (zoom, pan, pratinjau penuh).
* **INV-07**: Pencarian instan dan filter multi-dimensi (nama, kategori, kotak, barang penting, terarsip).
* **INV-08**: Pengarsipan barang aman; mengarsipkan barang tidak merusak riwayat perjalanan lama.
* **INV-09**: Deteksi duplikasi nama barang secara real-time saat pengetikan untuk mencegah entri ganda.

### 5.2 Modul Perjalanan & Destinasi (TRP)
* **TRP-01**: Manajemen banyak perjalanan tanpa batasan; beberapa perjalanan dapat aktif dan disiapkan secara bersamaan.
* **TRP-02**: Entri perjalanan dengan nama, tanggal mulai, tanggal akhir (opsional/fleksibel), catatan, dan status.
* **TRP-03**: Dukungan perjalanan satu kota maupun multi-kota dengan urutan destinasi yang dapat disesuaikan.
* **TRP-04**: Destinasi berulang diizinkan (contoh: Jakarta $\rightarrow$ Bandung $\rightarrow$ Jakarta).
* **TRP-05**: Status siklus hidup perjalanan: *Persiapan*, *Berlangsung*, *Selesai*, *Dibatalkan*, serta atribut pengarsipan terpisah.
* **TRP-06**: Penataan urutan kronologis perjalanan otomatis berdasarkan tanggal terdekat.
* **TRP-07**: Duplikasi perjalanan untuk persiapan perjalanan rutin dengan reset status packing aktual.
* **TRP-08**: Ringkasan kesiapan perjalanan (rasio barang terkemas dan jumlah agenda).

### 5.3 Modul Bawaan & Packing (PCK)
* **PCK-01**: Memilih barang dari inventaris langsung ke perjalanan tanpa menduplikasi data master barang.
* **PCK-02**: Keputusan bawaan per perjalanan: Dibawa, Tidak Dibawa, atau Belum Diputuskan.
* **PCK-03**: Penentuan jumlah rencana (`planned_quantity`) yang divalidasi terhadap stok fisik inventaris.
* **PCK-04**: Dukungan packing bertahap (`packed_quantity` dari 0 hingga `planned_quantity`).
* **PCK-05**: Quick checklist interaktif: sekali tekan langsung selesai untuk 1 unit, atau kontrol jumlah untuk multi-unit.
* **PCK-06**: Filter status packing: *Semua*, *Belum Dikemas*, *Sebagian*, *Selesai*, *Tidak Dibawa*.
* **PCK-07**: Keterangan lokasi kotak asal selalu terlihat jelas pada setiap kartu barang di daftar bawaan.
* **PCK-08**: Wadah perjalanan (*Tas*) opsional; pengguna bebas membuat daftar tas atau langsung melakukan packing tanpa tas.
* **PCK-09**: Peringatan konflik otomatis jika barang yang sama direncanakan melebihi stok pada perjalanan dengan rentang waktu yang bertumpang tindih.
* **PCK-10**: Fitur duplikasi / salin item langsung dari satu perjalanan ke perjalanan lain.
* **PCK-11**: Sorotan khusus untuk barang penting (dokumen identitas, obat-obatan, barang berharga).
* **PCK-12**: Layar *Pemeriksaan Sebelum Berangkat* untuk memvalidasi sisa barang yang belum masuk tas sebelum perjalanan dimulai.

### 5.4 Modul Agenda, Tiket & Notifikasi (SCH)
* **SCH-01**: Manajemen jadwal kegiatan: judul, kategori kegiatan, tanggal, jam mulai & selesai (opsional), lokasi, catatan, serta relasi ke perjalanan dan destinasi tertentu.
* **SCH-02**: Kategori kegiatan terstruktur: *Transportasi*, *Check-in/Check-out*, *Kegiatan*, *Persiapan*, *Lainnya*.
* **SCH-03**: Tampilan agenda ganda: daftar kronologis per tanggal dan kalender bulanan interaktif.
* **SCH-04**: Penyimpanan zona waktu berbasis standar IANA (`Asia/Jakarta`, `Asia/Makassar`, `Asia/Jayapura`) dengan konversi UTC otomatis dan penanda jam 24 jam.
* **SCH-05**: Penyimpanan tiket/reservasi mandiri dengan nomor booking, nama provider, dan catatan.
* **SCH-06**: Lampiran tiket lokal (PDF & gambar) yang disalin ke penyimpanan terisolasi aplikasi, dapat dibuka kapan saja tanpa koneksi internet.
* **SCH-07**: Dukungan tiket independen (dapat disimpan terlebih dahulu sebelum jadwal kegiatan dibuat).
* **SCH-08**: Sistem pengingat lokal ganda: preset (15 menit, 1 jam, 1 hari sebelumnya) atau waktu khusus.
* **SCH-09**: Dukungan alarm Android presisi (`SCHEDULE_EXACT_ALARM`) dan alarm perkiraan ramah baterai.
* **SCH-10**: Pembaruan alarm otomatis saat jadwal diedit, dibatalkan, atau dihapus.
* **SCH-11**: Rekonsiliasi alarm otomatis saat perangkat Android selesai dinyalakan ulang (*device reboot*) atau saat aplikasi dibuka kembali.
* **SCH-12**: Dukungan jadwal "Hanya Tanggal (Tanpa Jam)" tanpa memaksa jam menjadi 00:00.

### 5.5 Modul Checklist Pulang & Template (RET & TPL)
* **RET-01**: Pembuatan checkpoint kepulangan (default) atau checkpoint saat berpindah antar-kota.
* **RET-02**: Penguncian otomatis (*snapshot*) dari barang yang berstatus sudah dikemas pada perjalanan tersebut.
* **RET-03**: Konfirmasi tiga status kepulangan: *Dibawa Kembali*, *Habis Dipakai*, atau *Sengaja Ditinggal*.
* **RET-04**: Verifikasi kepulangan tidak merusak atau mengurangi stok master inventaris secara diam-diam.
* **RET-05**: Penutupan checkpoint dengan catatan evaluasi barang hilang/tertinggal.
* **TPL-01**: Template packing bawaan untuk tipe perjalanan populer (misal: *Liburan Singkat Akhir Pekan*, *Perjalanan Bisnis*).
* **TPL-02**: Penerapan template ke perjalanan baru secara instan dengan reset status packing ke 0.
* **TPL-03**: Penanganan item template yang stoknya kurang atau sedang diarsipkan dengan peringatan informatif.

### 5.6 Modul Cadangan & Pengaturan (BAK)
* **BAK-01**: Ekspor cadangan penuh (*Full Backup*) yang membungkus database SQLite, seluruh foto barang asli, dan lampiran tiket ke dalam satu file arsip zip terpadu.
* **BAK-02**: Penyimpanan file ekspor langsung ke penyimpanan lokal perangkat via Android Storage Access Framework (SAF).
* **BAK-03**: Pratinjau info cadangan sebelum pemulihan (tanggal backup, jumlah barang, perjalanan, dan lampiran).
* **BAK-04**: Validasi integritas dan versi skema cadangan sebelum proses restore dieksekusi.
* **BAK-05**: Pemulihan aman (*Atomic Restore*) dengan mekanisme rollback jika proses impor terinterupsi.
* **BAK-06**: Penjadwalan ulang seluruh alarm pengingat aktif di perangkat baru setelah pemulihan selesai.
* **BAK-07**: Riwayat pencatatan tanggal backup terakhir di halaman Pengaturan.

---

## 6. Arsitektur Teknis & Struktur Database

### 6.1 Diagram Skema Relasi Database (Drift SQLite)

```
┌─────────────────┐       ┌──────────────────────┐       ┌─────────────────┐
│ StorageLocations│       │      Categories      │       │     Assets      │
├─────────────────┤       ├──────────────────────┤       ├─────────────────┤
│ id (PK)         │       │ id (PK)              │       │ id (PK)         │
│ name            │       │ name                 │       │ filePath        │
│ type (box/etc)  │       │ icon, color          │       │ mimeType, size  │
└────────┬────────┘       └──────────┬───────────┘       └────────┬────────┘
         │                           │                            │
         │ 1:N                       │ 1:N                        │ 1:N
         ▼                           ▼                            ▼
┌────────────────────────────────────────────────────────┐  ┌─────────────┐
│                         Items                          │  │ ItemPhotos  │
├────────────────────────────────────────────────────────┤  ├─────────────┤
│ id (PK), name, quantity, unit, isImportant, isArchived │◄─┤ itemId (FK) │
│ storageLocationId (FK), categoryId (FK), notes         │  │ assetId(FK) │
└──────────────────────────┬─────────────────────────────┘  └─────────────┘
                           │ 1:N
                           ▼
┌─────────────────┐       ┌──────────────────────────────┐
│      Trips      │       │          TripItems           │
├─────────────────┤       ├──────────────────────────────┤
│ id (PK)         │◄──────┤ tripId (FK)                  │
│ name            │       │ itemId (FK)                  │
│ startDate       │       │ decision (carried/not_carried│
│ endDate         │       │ plannedQuantity              │
│ status          │       │ packedQuantity               │
│ isArchived      │       │ bagId (FK, nullable)         │
└────────┬────────┘       └──────────────┬───────────────┘
         │ 1:N                           │ N:1
         ├───────────────────────────────┼────────────────────────┐
         │                               ▼                        │
         │                        ┌─────────────┐                 │
         │                        │    Bags     │                 │
         │                        ├─────────────┤                 │
         │                        │ id (PK)     │                 │
         │                        │ tripId (FK) │                 │
         │                        │ name, color │                 │
         │                        └─────────────┘                 │
         │ 1:N                                                    │
         ├───────────────────────┬────────────────────────┐       │
         ▼                       ▼                        ▼       ▼
┌─────────────────┐     ┌─────────────────┐     ┌───────────────────┐
│    TripStops    │     │ ScheduleEvents  │     │    Checkpoints    │
├─────────────────┤     ├─────────────────┤     ├───────────────────┤
│ id (PK)         │     │ id (PK)         │     │ id (PK)           │
│ tripId (FK)     │     │ tripId (FK)     │     │ tripId (FK)       │
│ name, sequence  │     │ title, category │     │ title, type, date │
└─────────────────┘     │ localDate, time │     └─────────┬─────────┘
                        │ zoneId, instant │               │ 1:N
                        └────────┬────────┘               ▼
                                 │ 1:N          ┌───────────────────┐
                                 ▼              │  CheckpointItems  │
                        ┌─────────────────┐     ├───────────────────┤
                        │    Reminders    │     │ id (PK)           │
                        ├─────────────────┤     │ checkpointId (FK) │
                        │ id (PK)         │     │ tripItemId (FK)   │
                        │ scheduleId (FK) │     │ expectedQuantity  │
                        │ type, targetTime│     │ returnedQuantity  │
                        │ androidAlarmId  │     │ consumedQuantity  │
                        └─────────────────┘     │ leftQuantity      │
                                                └───────────────────┘
```

### 6.2 Struktur Direktori Proyek
```text
lib/
├── app/
│   └── navigation/
│       └── app_router.dart          # GoRouter dengan StatefulShellRoute 4 Tab
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          # Palet warna primer, netral, dan status
│   │   ├── app_spacing.dart         # Padding, margin, radius seragam
│   │   ├── app_theme.dart           # Konfigurasi ThemeData terang
│   │   └── app_typography.dart      # Gaya teks dan hierarki tipografi
│   ├── utils/
│   │   └── datetime_utils.dart      # Konversi zona IANA & format tanggal aman
│   └── widgets/
│       ├── bawa_app_bar.dart        # AppBar standar dengan subtitle
│       ├── bawa_button.dart         # Tombol interaktif seragam
│       ├── bawa_empty_state.dart    # Tampilan informatif saat data kosong
│       ├── bawa_filter_chip.dart    # Filter pil interaktif
│       ├── bawa_progress_bar.dart   # Bilah progres packing
│       ├── bawa_search_field.dart   # Kolom pencarian instan
│       └── full_screen_image_viewer.dart # Pratinjau gambar layar penuh
├── data/
│   ├── database/
│   │   ├── app_database.dart        # Instansiasi Drift SQLite
│   │   ├── app_database.g.dart      # Kode ter-generate Drift
│   │   ├── tables.dart              # Definisi 16 tabel relasional
│   │   └── connection/              # Koneksi SQLite native (Android/IO)
│   ├── providers/
│   │   └── database_providers.dart  # Riverpod StreamProviders & Repositories
│   ├── repositories/
│   │   ├── inventory_repository.dart
│   │   ├── locations_repository.dart
│   │   ├── trips_repository.dart
│   │   ├── trip_packing_repository.dart
│   │   ├── schedules_repository.dart
│   │   ├── reminders_repository.dart
│   │   ├── checkpoints_repository.dart
│   │   └── templates_repository.dart
│   └── services/
│       ├── asset_storage_service.dart # Manajemen file foto/tiket offline
│       └── notification_service.dart  # Integrasi alarm dan notifikasi Android
├── features/
│   ├── home/                        # Tab 1: Dashboard & Ringkasan Perjalanan
│   ├── inventory/                   # Tab 2: Halaman Tas, Item Form, Kotak Detail
│   ├── trips/                       # Tab 3: Daftar Perjalanan, Detail Packing, Checkpoint
│   ├── agenda/                      # Tab 4: Agenda, Kalender, Form Jadwal & Tiket
│   └── settings/                    # Layar Pengaturan, Backup, Restore
└── main.dart                        # Entry point aplikasi & inisialisasi lokal
```

---

## 7. Kelebihan Aplikasi (Key Strengths)

1. **Privasi Absolut & 100% Offline**:
   * Data tidak pernah dikirim ke internet, tidak memerlukan pendaftaran akun, dan tidak memiliki dependensi server cloud. Bebas dari kebocoran data pribadi.
2. **Menemukan Barang Tanpa Membongkar Kotak**:
   * Pengguna dapat memeriksa isi kotak penyimpanan fisik di rumah langsung dari layar HP dalam hitungan detik.
3. **Pemisahan Rencana vs Tindakan Fisik**:
   * Tidak ada asumsi bahwa barang yang dimasukkan ke daftar rencana otomatis sudah masuk tas. Packing membutuhkan konfirmasi centang fisik pengguna.
4. **Sangat Ringan & Efisien**:
   * Dibuat dengan arsitektur kompilasi terpisah per ABI (`--split-per-abi`), menghasilkan ukuran file unduhan hanya ~22 MB dengan pemangkasan font ikon sebesar 99%.
5. **Resilien Terhadap Reboot & Perubahan Waktu**:
   * Alarm pengingat direkonsiliasi otomatis setelah perangkat Android restart, dan penyimpanan zona waktu IANA menjaga jadwal tidak bergeser saat bepergian melintasi zona waktu (WIB/WITA/WIT).
6. **Desain UX Bersih & Tanpa Gangguan**:
   * Interaksi checklist cepat, tidak ada popup yang menggantung atau menutupi bilah navigasi, dan navigasi 4 tab yang intuitif.

---

## 8. Kekurangan & Batasan Produk (Limitations & Trade-offs)

1. **Satu Pengguna Lokal (Single-User Only)**:
   * Tidak mendukung kolaborasi banyak orang secara real-time atau sinkronisasi multi-perangkat via internet (sinkronisasi antar-perangkat hanya melalui ekspor-impor file backup manual).
2. **Tidak Melacak Posisi Barang Secara Real-Time (Tanpa Sensor/IoT)**:
   * Aplikasi tidak memiliki koneksi ke pelacak GPS, Bluetooth Beacon, atau Apple AirTag. Lokasi barang mencerminkan catatan terakhir yang dimasukkan oleh pengguna.
3. **Tidak Memiliki Fitur OCR Tiket Otomatis**:
   * Lampiran tiket (PDF/gambar) disimpan apa adanya sebagai dokumen offline. Aplikasi tidak membaca kode booking secara otomatis menggunakan pengenalan teks AI.
4. **Stok Inventaris Tidak Terdistribusi per Multi-Lokasi dalam Satu Entri**:
   * Satu entri barang terhubung ke satu lokasi kotak. Jika pengguna memiliki 5 kaus identik yang disimpan di dua kotak berbeda, pengguna harus membuat dua entri barang terpisah.
5. **Impor Backup Bersifat Menimpa (*Replace-All*)**:
   * Pemulihan data dari file backup akan menggantikan seluruh basis data aktif. Sistem belum mendukung penggabungan diferensial (*merge conflict resolution*).

---

## 9. Pedoman Pengembangan untuk Sistem AI & Pengembang

Saat memodifikasi atau memperluas kode pada repositori ini, AI **HARUS** mematuhi pedoman teknis berikut:

1. **Integritas Skema Database**:
   * Setiap perubahan kolom pada file `tables.dart` wajib menaikkan versi skema di `app_database.dart` dan menyertakan strategi migrasi yang aman. Jangan menghapus kolom foreign key tanpa mengevaluasi efek kaskade relasi.
2. **Pencegahan Error Overflow Layar**:
   * Hindari penggunaan widget horizontal yang tidak memiliki batasan lebar di dalam `Row` atau `ListTile`. Gunakan selalu `Expanded` atau `Flexible` dengan parameter `overflow: TextOverflow.ellipsis`.
3. **Pencegahan Tombol Tertutup Navigasi**:
   * Setiap form panjang yang menggunakan `SingleChildScrollView` wajib memiliki bantalan bawah (`SizedBox(height: 80)` atau padding aman) agar tombol aksi utama tidak tertutup oleh navigasi sistem Android atau bilah bawah.
4. **Penanganan Format Tanggal & Jam**:
   * Selalu gunakan helper aman [`AppDateTimeUtils.formatFullDate`](file:///d:/Pemrograman/Aplikasi/Aplikasi%20pribadi%20untuk%20barang/lib/core/utils/datetime_utils.dart) atau blok *try-catch* ketika memformat tanggal dengan lokal `id_ID` untuk mencegah `LocaleDataException`.
5. **Verifikasi Kualitas Wajib**:
   * Setiap sebelum menyelesaikan tugas, jalankan:
     ```bash
     flutter analyze
     flutter test
     ```
     Pastikan status `No issues found!` dan seluruh rangkaian pengujian lolos 100%.
