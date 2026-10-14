# Siapkan Tas

Aplikasi pribadi cerdas berbasis Flutter & Android untuk mengelola inventaris barang, kotak penyimpanan, daftar bawaan tas, perjalanan, jadwal agenda, tiket offline, dan checklist kepulangan tanpa koneksi internet (100% offline-first).

---

## 🤖 Dokumentasi Khusus AI & Pengembang

Untuk pemahaman komprehensif mengenai **tujuan aplikasi, model mental data, alur kerja, spesifikasi UI/UX, matriks fitur lengkap (INV, TRP, PCK, SCH, RET, TPL, BAK), skema database SQLite, kelebihan, serta batasan sistem**, silakan baca dokumen khusus AI berikut:

👉 **[AI_DOCUMENTATION.md](file:///d:/Pemrograman/Aplikasi/Aplikasi%20pribadi%20untuk%20barang/AI_DOCUMENTATION.md)**

---

## Ringkasan Fitur Utama
1. **Inventaris & Kotak Simpan**: Temukan barang dan cek isi kotak fisik di rumah tanpa membongkar kotak secara fisik.
2. **Tas & Bawaan (Cart UI)**: Antarmuka modern untuk merencanakan barang bawaan dan mencentang packing fisik secara instan.
3. **Perjalanan Fleksibel**: Mendukung perjalanan satu kota maupun multi-kota dengan deteksi konflik stok barang.
4. **Agenda & Tiket Offline**: Simpan tiket (PDF/gambar) dan jadwal kegiatan dengan alarm pengingat tepat waktu yang tahan reboot.
5. **Cek Sebelum Pulang**: Verifikasi barang kembali dengan formula akuntansi kepemilikan agar tidak ada barang tertinggal di hotel.
6. **Ekspor/Impor Mandiri**: Cadangkan seluruh database, foto, dan lampiran ke file arsip terpadu.

---

## Build & Rilis
Aplikasi dikompilasi teroptimasi menggunakan arsitektur split:
```bash
flutter build apk --split-per-abi --release
```
File APK rilis siap instal berada di:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (~22.1 MB)
