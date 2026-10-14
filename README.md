# Persiapan Tas (Bawa) 🎒📦

Aplikasi pribadi cerdas berbasis **Flutter (Android)** untuk manajemen inventaris rumah tangga, pengorganisasian kotak penyimpanan, perencanaan packing bawaan tas, jadwal agenda, tiket perjalanan offline, dan checklist kepulangan anti-ketinggalan.

> **100% Offline-First • Tanpa Login / Akun • Tanpa Cloud Tracker • Privasi Total**

---

## 🌟 Mengapa Persiapan Tas?

Sering kali kita mengalami masalah saat hendak bepergian:
- **Lupa kotak penyimpanan**: Charger atau obat tersimpan di kotak mana di rumah? Harus bongkar lemari/kardus satu per satu.
- **Rencana vs Tindakan tercampur**: Mencatat barang yang "ingin dibawa" dianggap sudah dimasukkan ke tas, sehingga ada barang penting yang tertinggal.
- **Perjalanan berdekatan**: Minggu ini ke Bandung, minggu depan ke Yogyakarta. Barang apa saja yang dipakai bergantian?
- **Barang tertinggal di hotel**: Saat check-out terburu-buru, barang kecil seperti adaptor atau pakaian dalam tertinggal.
- **Data boros ruang**: Saat perjalanan selesai bertumpuk, foto tiket dan lampiran lama memenuhi memori HP.

**Persiapan Tas** memecahkan masalah ini dengan model mental yang presisi dan arsitektur data yang kokoh.

---

## 💡 Konsep Inti & Model Mental

1. **Kotak Rumah $\neq$ Tas Perjalanan**:
   - **Kotak / Lemari / Laci** adalah lokasi penyimpanan rujukan asal di rumah Anda.
   - **Tas / Ransel / Koper** adalah wadah pembawa sementara untuk perjalanan tertentu.
   - Memasukkan charger ke Ransel Hitam tidak mengubah catatan bahwa lokasi simpan aslinya adalah "Kotak Elektronik Rak Bawah".
2. **Perjalanan Independen & Deteksi Konflik**:
   - Merencanakan barang pada Perjalanan A tidak otomatis menyelesaikan Perjalanan B.
   - Jika satu kamera direncanakan untuk 2 perjalanan yang rentang tanggalnya bertabrakan/beririsan, aplikasi akan memberi **peringatan konflik simultan**.
3. **Pemisahan Perjalanan Aktif & Menu Khusus Riwayat Selesai**:
   - Menu utama **Tas** hanya menampilkan perjalanan yang sedang aktif dipersiapkan / berlangsung agar tidak membingungkan pengguna saat memasukkan barang baru.
   - Perjalanan yang sudah berstatus **Selesai** ditempatkan rapi di menu khusus **Riwayat Perjalanan Selesai**.
4. **Hapus Bersih Media & Hemat Memori**:
   - Saat perjalanan selesai dihapus, aplikasi tidak hanya menghapus data tabel SQLite, melainkan **menghapus bersih seluruh file fisik foto tiket, boarding pass, dan lampiran dokumen dari memori perangkat**.
5. **Ekspor Teks Cerdas (Human & AI Friendly)**:
   - Salin seluruh daftar bawaan hanya dengan satu ketukan dalam format teks Markdown checklist (`[x]`, `[-]`, `[ ]`).
   - Sangat mudah dibaca manusia di aplikasi catatan (WhatsApp, Google Keep, Notion) maupun dianalisis langsung oleh AI LLM (Claude, ChatGPT, Gemini).

---

## 🚀 Fitur Unggulan

### 1. 📦 Inventaris & Kotak Penyimpanan
- Pencarian cerdas instan berdasarkan nama barang, kategori, atau nama kotak.
- Foto barang resolusi tinggi dengan kompresi hemat ruang.
- Label penanda penting (obat-obatan, dokumen penting, gadget).
- Mengetahui isi kotak tanpa membongkar kotak fisik di gudang/kamar.

### 2. 🧳 Perencanaan Tas & Bawaan (Cart UI)
- Pilihan keputusan: **Dibawa**, **Tidak Dibawa**, atau **Belum Diputuskan**.
- Kemas bertahap (packing parsial, misal: 2 dari 3 baju sudah masuk tas).
- Pemilihan kompartemen/tas perjalanan opsional (Koper Utama, Ransel, Waistbag).
- Filter status: *Semua*, *Belum Dikemas*, *Sebagian*, *Selesai*.
- Urutkan bawaan berdasarkan lokasi kotak asal untuk rute packing tercepat di rumah.
- Fitur **Undo** instan jika salah mencentang.

### 3. 📋 Ekspor & Salin Teks Bawaan (AI & Manusia)
- Tombol **Salin Teks** sekali sentuh pada halaman persiapan.
- Format Markdown terstruktur rapi:
  ```markdown
  # 🎒 DAFTAR BAWAAN: Liburan Akhir Tahun - Bandung
  📅 Tanggal : 18 Okt 2026 s/d 20 Okt 2026
  📊 Status  : 4/5 Barang Siap (80%)

  ## 🚨 BARANG SANGAT PENTING (Wajib Ada!)
  - [x] Paspor & Dompet (1 buah) ➔ [Tas Selempang]
  - [ ] Obat Asma (1 paket) ➔ [Ransel Depan] (Asal: Laci Obat)

  ## 📦 DAFTAR SEMUA BAWAAN
  - [x] Charger USB-C 65W (1 buah) ➔ [Ransel] (Asal: Kotak Elektronik)
  - [x] Kaus Hitam Polos (3 buah) ➔ [Koper Utama] (Asal: Lemari Pakaian)
  - [ ] Jaket Parasut (1 buah) ➔ [Belum ada wadah] (Asal: Gantungan)
  ```

### 4. 🧭 Multi-Destinasi & Jadwal Agenda Offline
- Mendukung perjalanan satu tujuan atau multi-kota berantai (contoh: Jakarta ➔ Bandung ➔ Yogyakarta ➔ Jakarta).
- Agenda kronologis lengkap: keberangkatan transportasi, check-in hotel, wisata, dan kepulangan.
- Dukungan zona waktu (WIB, WITA, WIT, atau zona internasional IANA).
- Pengingat notifikasi lokal tepat waktu (Exact Alarm Android) yang tetap aktif setelah perangkat di-reboot.

### 5. 🎟️ Tiket & Dokumen Lokal
- Simpan e-tiket pesawat, kereta, hotel, voucher wisata secara offline (PDF & Foto Gambar).
- Zoom penuh untuk mempermudah petugas scan barcode / QR code tiket.
- Lampiran tersimpan mandiri di direktori aman internal aplikasi tanpa dependensi cloud.

### 6. 🔄 Cek Sebelum Pulang (Anti-Ketinggalan)
- Membuat snapshot otomatis dari barang yang tercatat dibawa.
- Formula verifikasi kepulangan:
  $$\text{Dikonfirmasi} = \text{Dibawa Pulang} + \text{Habis Dipakai} + \text{Sengaja Ditinggal}$$
- Barang yang belum diverifikasi tetap berstatus `Belum Terkonfirmasi` dan ditandai merah agar tidak tertinggal di penginapan.

### 7. 💾 Cadangan & Pemulihan Mandiri (Backup & Restore)
- Ekspor seluruh database, foto barang, tiket, dan metadata ke dalam **1 file arsip ZIP utuh**.
- Validasi checksum dan preview sebelum impor data agar terhindar dari file rusak.
- Restore bersih tanpa meninggalkan data yatim (*orphan files*).

---

## 🛠️ Arsitektur & Teknologi

Aplikasi dibangun dengan arsitektur bersih (*Clean Architecture* & *Feature-First*):

```
lib/
├── core/                  # Konstanta tema, utilitas format teks, database, notifikasi
│   ├── database/          # Drift / SQLite table schema & DAOs
│   ├── theme/             # Palet warna modern (Vibrant Orange & Netral)
│   └── utils/             # TripTextFormatter, date helpers, file storage
├── data/                  # Implementasi repository, providers, & local storage
│   ├── providers/         # Riverpod StateNotifier & Provider DI
│   └── repositories/      # Items, Trips, Tickets, Schedules, Backup repo
└── features/              # UI & Presentasi (Feature-Driven)
    ├── inventory/         # Manajemen barang, kotak simpan, & Cart bawaan
    ├── trips/             # Detail perjalanan, multi-destinasi, checklist, agenda
    ├── schedules/         # Kalender & agenda perjalanan
    ├── tickets/           # Viewer tiket lokal & lampiran
    └── settings/          # Pengaturan, backup, restore, & info aplikasi
```

### Tech Stack
- **Framework**: Flutter 3.x / Dart 3.x
- **Database Lokal**: SQLite via [Drift](https://drift.simonbinder.eu/) (Typed SQL, reactive queries)
- **State Management**: [Flutter Riverpod](https://riverpod.dev/)
- **Notifikasi**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) (Exact Alarms & Boot Receiver)
- **File & Media**: `image_picker`, `file_picker`, `path_provider`, `archive` (ZIP backup)

---

## 💻 Panduan Pengembang (Developer Guide)

### Prasyarat
- **Flutter SDK**: `>= 3.24.0`
- **Dart SDK**: `>= 3.5.0`
- **Android SDK**: API Level 34 (Android 14) / Minimal API 21 (Android 5.0 Lollipop)
- **Java JDK**: 17

### 1. Kloning Repositori
```bash
git clone https://github.com/Syaif05/Persiapan-Tas.git
cd Persiapan-Tas
```

### 2. Pasang Dependensi
```bash
flutter pub get
```

### 3. Generate Kode (Drift & Mappers)
Jika mengubah skema database pada `lib/core/database/`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Jalankan Analisis Kode & Pengujian
Pastikan tidak ada issue linting dan seluruh unit/widget test lulus 100%:
```bash
flutter analyze
flutter test
```

### 5. Jalankan Aplikasi di Perangkat / Emulator
```bash
flutter run
```

---

## 📦 Panduan Kompilasi & Build Rilis (APK)

### Build APK Lengkap (Universal):
```bash
flutter build apk --release
```
Hasil file APK berada di:
`build/app/outputs/flutter-apk/app-release.apk`

### Build APK Teroptimasi (Split per ABI - Direkomendasikan):
Untuk ukuran file yang jauh lebih ringkas (~20-22 MB per arsitektur):
```bash
flutter build apk --split-per-abi --release
```
File APK untuk sebagian besar HP Android modern:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

---

## 📄 Lisensi & Kontribusi

Proyek ini dikembangkan untuk kebutuhan pribadi dengan standar kualitas tinggi, stabilitas offline teruji, dan desain modern. Kontribusi, laporan bug, serta saran fitur melalui Issue & Pull Request sangat disambut dengan baik!

Dibuat dengan ❤️ untuk perjalanan yang tenang, teratur, dan bebas barang tertinggal.
