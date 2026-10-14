# PRD Bawa

## Aplikasi pribadi untuk barang, bawaan, dan perjalanan

| Informasi | Nilai |
| --- | --- |
| Versi dokumen | 1.0 |
| Tanggal | 10 Oktober 2026 |
| Platform utama | Android, dibuat menggunakan Flutter |
| Nama kerja | Bawa; dapat diganti tanpa mengubah kebutuhan produk |
| Pengguna | Satu orang, untuk pemakaian pribadi |
| Penyimpanan | Lokal, offline, tanpa akun |
| Pencadangan | Ekspor dan impor manual, termasuk foto dan tiket |
| Metode pembangunan | Dengan bantuan AI, dikerjakan per fase |
| Status | Spesifikasi siap menjadi pedoman implementasi bertahap |

## 1. Ringkasan produk

Bawa membantu pengguna mengetahui barang yang dimiliki, tempat barang disimpan, barang yang dipilih untuk suatu perjalanan, dan barang yang sudah dimasukkan ke tas. Pengguna dapat melihat isi kotak melalui aplikasi tanpa membongkar kotak fisik, menyiapkan perjalanan yang waktunya berdekatan, serta menyimpan jadwal dan tiket beserta pengingatnya.

**Kotak adalah penanda lokasi penyimpanan. Kotak tidak otomatis menjadi wadah yang ikut dibawa.** Tas perjalanan dicatat secara terpisah dan pengguna tetap boleh melakukan packing tanpa membuat daftar tas.

Contoh utama: charger tersimpan di Kotak Elektronik. Charger dipilih untuk perjalanan Bandung, tetapi belum dikemas. Setelah dimasukkan ke ransel, pengguna menandainya sebagai sudah dikemas dan, bila diperlukan, memilih Ransel Hitam sebagai tasnya. Kotak Elektronik tetap menjadi informasi lokasi simpan asal, bukan berarti kotaknya ikut ke Bandung.

Aplikasi harus ringan digunakan sehari-hari. Fitur yang lengkap ditempatkan di detail dan formulir lanjutan, sementara layar utama memprioritaskan perjalanan terdekat, barang yang belum dikemas, dan jadwal berikutnya.

## 2. Keputusan pengguna dan asumsi implementasi

### 2.1 Keputusan yang sudah ditetapkan

1. Aplikasi dibuat dengan Flutter untuk Android.
2. Digunakan secara pribadi, bukan aplikasi untuk banyak pengguna.
3. Semua fungsi utama bekerja offline tanpa akun.
4. Backup dilakukan melalui ekspor dan impor manual.
5. Kotak berfungsi sebagai lokasi/penanda penyimpanan untuk membantu memisahkan dan menemukan barang.
6. Barang yang dibawa menggunakan tas; pencatatan tas bersifat opsional.
7. Satu perjalanan bisa berisi satu kota atau beberapa kota.
8. Beberapa perjalanan dapat disiapkan sekaligus, termasuk yang waktunya berdekatan.
9. Barang dapat memiliki foto dan detail.
10. Jadwal, tiket, tanggal, jam, dan pengingat merupakan bagian dari produk.
11. UI modern, minimalis, sederhana, dan mengikuti karakter empat referensi visual pengguna.
12. AI mengerjakan aplikasi secara bertahap, bukan sekaligus dalam satu pekerjaan besar.

### 2.2 Default yang dapat langsung digunakan AI

| Hal | Default |
| --- | --- |
| Bahasa UI | Bahasa Indonesia |
| Format jam | 24 jam |
| Zona waktu awal | Zona waktu perangkat, disimpan sebagai zona IANA |
| Tema | Terang; dark mode ditunda sebagai fitur opsional |
| Warna aksen | Primary Orange: #FF5722, dengan latar netral terang |
| Jumlah pengguna | Satu profil lokal tanpa login |
| Jenis stok | Jumlah bulat dan satuan bebas, misalnya buah atau pasang |
| Backup versi awal | Satu arsip lengkap; impor menggantikan data, belum mendukung merge |
| Distribusi | APK release untuk instalasi pribadi |
| Penyedia layanan daring | Tidak ada backend, cloud sync, atau API AI di aplikasi |

Nama, warna aksen, dan ikon aplikasi adalah keputusan desain sementara. AI boleh menggantinya bila pengguna meminta. Jangan menganggap pengembangan dengan AI berarti aplikasi harus mempunyai chatbot atau fitur generatif.

## 3. Masalah, tujuan, dan batasan

### 3.1 Masalah yang diselesaikan

- Pengguna lupa kotak yang berisi barang tertentu dan harus membongkar beberapa kotak.
- Daftar barang yang diperlukan tercampur dengan barang yang benar-benar sudah masuk tas.
- Perjalanan yang berdekatan membutuhkan daftar berbeda, sementara beberapa barang dipakai kembali.
- Tiket dan jadwal tersebar sehingga tanggal, jam, atau persiapan mudah terlewat.
- Barang dapat tertinggal ketika berpindah kota atau pulang.

### 3.2 Tujuan produk

| Tujuan | Ukuran penerimaan |
| --- | --- |
| Menemukan lokasi penyimpanan | Dari pencarian, nama barang dan kotaknya terlihat tanpa membuka beberapa halaman |
| Packing dengan cepat | Menandai satu barang selesai dapat dilakukan langsung dari daftar bawaan |
| Membedakan rencana dan tindakan | Barang yang dipilih tidak otomatis dianggap sudah dikemas |
| Mendukung perjalanan fleksibel | Satu kota dan beberapa kota menggunakan model data yang sama |
| Informasi tersedia saat bepergian | Inventaris, foto, jadwal, dan lampiran tersimpan dapat dibuka dalam mode pesawat |
| Mengurangi barang tertinggal | Checklist pulang/perpindahan tersedia dari barang yang benar-benar dikemas |
| Menjaga data pribadi | Backup dapat dipulihkan lengkap pada instalasi baru |

Ukuran tersebut adalah target penerimaan, bukan klaim bahwa aplikasi sudah diuji atau dibuat.

### 3.3 Cakupan versi 1.0

Inventaris, lokasi penyimpanan, foto barang, perjalanan multi-kota, daftar bawaan, packing, tas opsional, pencarian, jadwal, tiket lokal, pengingat, checklist pulang, template, dan backup lengkap.

### 3.4 Di luar cakupan versi 1.0

Login, kolaborasi, berbagi perjalanan langsung antarorang, pembayaran, pemesanan tiket, integrasi maskapai, sinkronisasi cloud, GPS, prediksi cuaca, OCR tiket, pengenalan barang dengan AI, pemindaian barcode, nested box, pelacakan barang otomatis, inventaris komersial, dan anggaran perjalanan. Dark mode, widget, label QR kotak, serta kunci biometrik dapat masuk iterasi berikutnya setelah fungsi utama stabil.

## 4. Istilah dan model mental

| Istilah | Arti | Contoh |
| --- | --- | --- |
| Barang | Entri inventaris pribadi | Charger USB-C, kaus hitam |
| Lokasi simpan | Tempat asal/rujukan penyimpanan yang dicatat pengguna | Kotak Elektronik, Lemari, Laci Meja |
| Kotak | Salah satu jenis lokasi simpan | Kotak A di bawah meja |
| Perjalanan | Kelompok persiapan dan jadwal yang berdiri sendiri | Bandung akhir pekan |
| Tujuan | Kota atau tempat singgah di dalam perjalanan | Bandung, Jakarta |
| Bawaan | Barang yang dipilih untuk perjalanan dengan jumlah tertentu | Membawa 1 dari 2 charger |
| Tas | Wadah perjalanan opsional | Ransel Hitam |
| Dikemas | Pengguna sudah mengonfirmasi barang masuk bawaan | Charger 1/1 selesai |
| Jadwal | Kegiatan dengan tanggal, jam bila diketahui, dan lokasi | Berangkat, check-in hotel |
| Tiket | Catatan tiket atau reservasi beserta lampiran | PDF tiket kereta |
| Checkpoint | Saat pengecekan ulang sebelum pindah kota atau pulang | Sebelum pulang dari Jakarta |

### 4.1 Tiga informasi yang wajib dipisahkan

1. **Lokasi simpan asal:** tempat mencari barang sebelum packing.
2. **Keputusan per perjalanan:** dibawa, tidak dibawa, atau belum diputuskan.
3. **Jumlah yang sudah dikemas:** tindakan aktual yang dicatat pengguna untuk perjalanan tersebut.

Status perjalanan tidak boleh menjadi status global barang. Satu charger boleh direncanakan untuk perjalanan A dan B, tetapi packing untuk A tidak menyelesaikan packing untuk B.

### 4.2 Batas ketepatan lokasi

Aplikasi hanya mengetahui informasi yang dimasukkan pengguna. Label Kotak Elektronik berarti lokasi simpan asal/rujukan, bukan pelacakan posisi real-time. Setelah packing, tampilkan misalnya “Asal: Kotak Elektronik” dan “Dikemas: Ransel Hitam, perjalanan Bandung”. Bila tas tidak dicatat, cukup tampilkan “Sudah dikemas”.

Memindahkan barang secara fisik tidak bisa dideteksi aplikasi. Perubahan lokasi simpan dilakukan manual. Jangan otomatis mengembalikan lokasi barang ketika perjalanan selesai.

## 5. Alur penggunaan utama

### 5.1 Mulai menggunakan aplikasi

1. Pengguna membuka aplikasi dan langsung masuk ke Beranda.
2. Empty state menawarkan “Tambah barang” dan “Buat perjalanan”.
3. Pengguna membuat Kotak Elektronik, menambahkan keterangan “Rak bawah meja”, lalu foto kotak bila diperlukan.
4. Pengguna memasukkan barang: nama dan jumlah; foto, kategori, lokasi simpan, dan detail bersifat opsional.
5. Data tersimpan lokal dan tetap tersedia setelah aplikasi ditutup.

Tidak ada onboarding panjang, akun, atau permintaan semua izin saat pembukaan pertama.

### 5.2 Menyiapkan perjalanan

1. Buat perjalanan dengan nama, tanggal mulai, dan satu tujuan pertama.
2. Tambahkan tujuan lain bila diperlukan; tanggal akhir boleh belum diketahui.
3. Pilih barang dari inventaris atau tambah barang baru dari halaman perjalanan.
4. Tentukan jumlah yang dibawa dan, bila perlu, tandai barang lain sebagai tidak dibawa.
5. Gunakan filter “Belum dikemas”; lihat asal kotak setiap barang.
6. Setelah barang masuk tas, centang atau isi jumlah yang telah dikemas.
7. Catat tas secara opsional.
8. Buka pemeriksaan sebelum berangkat untuk melihat barang belum selesai dan jadwal berikutnya.

### 5.3 Menemukan barang tanpa membongkar kotak

1. Cari nama, kategori, atau nama kotak dari halaman Barang.
2. Hasil menunjukkan foto kecil, nama, jumlah inventaris, dan lokasi simpan asal.
3. Bila barang ada di daftar perjalanan aktif, tampilkan status packing dengan nama perjalanannya.
4. Detail barang memperlihatkan catatan dan perjalanan terkait.

### 5.4 Jadwal dan tiket

1. Tambah jadwal, misalnya “Kereta ke Bandung”, tanggal 18 Oktober pukul 07.30 WIB.
2. Lampirkan gambar atau PDF tiket, isi nomor pemesanan bila dibutuhkan.
3. Pilih pengingat, misalnya sehari sebelumnya dan dua jam sebelumnya.
4. Jadwal tampil pada agenda perjalanan dan agenda global.
5. Mengetuk notifikasi membuka jadwal yang sesuai, termasuk saat aplikasi sebelumnya tidak aktif.

### 5.5 Perjalanan berikutnya yang berdekatan

1. Duplikasi perjalanan atau gunakan template bawaan.
2. Nama dan tanggal disesuaikan; tujuan dan jadwal disalin hanya bila pengguna memilihnya.
3. Jumlah packing, checklist pulang, dan konfirmasi selesai direset.
4. Tiket dan pengingat lama tidak disalin secara default.
5. Barang tetap merujuk inventaris yang sama agar tidak membuat stok fiktif.

### 5.6 Mengecek sebelum pulang

1. Pengguna memilih “Cek sebelum pulang”.
2. Aplikasi membuat checklist dari jumlah yang tercatat sudah dikemas.
3. Pengguna memeriksa barang dan mencatat jumlah yang dibawa kembali.
4. Barang yang habis dipakai atau sengaja ditinggal memiliki pilihan terpisah.
5. Barang yang belum terkonfirmasi tetap terlihat; aplikasi tidak menyimpulkan semuanya aman.
6. Setelah sampai rumah, pengguna dapat memperbarui lokasi simpan asal secara manual.

## 6. Kebutuhan fungsional

Semua kebutuhan di bawah wajib selesai sebelum versi 1.0 dianggap siap, kecuali yang secara eksplisit bertanda opsional. ID dipakai pada rencana fase, pengujian, dan laporan AI.

### 6.1 Inventaris dan lokasi simpan

| ID | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| INV-01 | Tambah, baca, ubah, arsipkan barang | Nama wajib; jumlah bulat minimal 1; tersimpan setelah restart |
| INV-02 | Detail barang | Nama, jumlah, satuan, kategori, lokasi simpan, catatan, foto, dan penanda penting |
| INV-03 | Kelola lokasi simpan | Nama wajib; jenis kotak/lemari/laci/lainnya; foto dan keterangan opsional |
| INV-04 | Lihat isi lokasi | Daftar barang yang merujuk lokasi, dengan pencarian dan jumlah |
| INV-05 | Lokasi tidak wajib | Barang tanpa lokasi tetap bisa digunakan; tampilkan “Lokasi belum dicatat” |
| INV-06 | Foto barang | Kamera atau pemilih foto; satu foto utama dan hingga empat foto tambahan |
| INV-07 | Cari dan filter | Nama, kategori, lokasi; filter penting dan diarsipkan; urut nama atau terbaru |
| INV-08 | Riwayat tetap dapat dibaca | Mengarsipkan barang tidak merusak daftar bawaan lama |
| INV-09 | Nama yang mirip | Peringatan kemungkinan duplikat; pengguna tetap boleh menyimpan |

Ketentuan inventaris:

- Satu entri mewakili satu barang unik atau satu kelompok barang sejenis pada satu lokasi simpan.
- Bila kaus yang sama berada di dua kotak dan perlu dibedakan, buat dua entri atau pecah jumlah secara eksplisit. Versi 1.0 tidak memiliki stok terdistribusi per banyak lokasi dalam satu entri.
- Memecah jumlah harus berupa transaksi: jumlah asal berkurang dan entri baru dibuat bersama-sama. Fitur pemecahan otomatis boleh ditunda; pengguna tetap bisa membuat dan mengubah dua entri manual.
- Perubahan jumlah inventaris tidak diam-diam mengubah jumlah bawaan yang sudah dikemas. Jika jumlah baru lebih kecil dari rencana perjalanan aktif, tampilkan peringatan untuk ditinjau.
- Menghapus lokasi dengan barang terkait meminta pengguna memilih lokasi pengganti atau melepas lokasi. Barang tidak ikut terhapus.
- Barang yang sudah muncul pada perjalanan sebaiknya diarsipkan. Penghapusan permanen hanya tersedia jika tidak ada referensi; jangan memutus relasi secara diam-diam.

### 6.2 Perjalanan dan tujuan

| ID | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| TRP-01 | Banyak perjalanan | Dapat membuat beberapa perjalanan tanpa membatasi satu perjalanan aktif |
| TRP-02 | Data perjalanan | Nama, tanggal mulai, tanggal akhir opsional, catatan, dan status |
| TRP-03 | Satu atau beberapa tujuan | Minimal satu tujuan; urutan tujuan dapat diubah |
| TRP-04 | Tujuan berulang | Kota yang sama boleh muncul lagi, misalnya Bandung–Jakarta–Bandung |
| TRP-05 | Status perjalanan | Persiapan, berlangsung, selesai, dibatalkan; arsip adalah atribut terpisah |
| TRP-06 | Perjalanan berdekatan | Tampil terurut menurut tanggal; tidak mengubah data perjalanan lain |
| TRP-07 | Duplikasi | Barang dan jumlah rencana dapat disalin; status aktual direset |
| TRP-08 | Ringkasan kesiapan | Progres packing dan jumlah jadwal/tiket; jangan menyatakan tiket wajib untuk semua perjalanan |

Tanggal akhir harus sama atau setelah tanggal mulai. Nama tujuan dapat berupa kota, nama tempat, atau label bebas. Tanggal tiba/pergi per tujuan opsional; bila diisi, urutannya divalidasi. Jadwal di luar rentang perjalanan memberi peringatan dan menawarkan pembaruan rentang, bukan menghapus jadwal.

Status tidak berubah otomatis hanya karena tanggal sudah lewat. Aplikasi boleh menawarkan tindakan “Mulai perjalanan” atau “Selesaikan perjalanan”. Pembatalan dan penyelesaian membatalkan pengingat yang masih akan datang untuk perjalanan itu.

### 6.3 Daftar bawaan dan packing

| ID | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| PCK-01 | Pilih dari inventaris | Memilih barang tidak membuat salinan stok |
| PCK-02 | Keputusan bawaan | Dibawa, tidak dibawa, belum diputuskan; independen pada setiap perjalanan |
| PCK-03 | Jumlah dibawa | Untuk keputusan dibawa, jumlah rencana minimal 1 dan tidak melebihi jumlah inventaris saat dipilih |
| PCK-04 | Packing parsial | Jumlah dikemas 0 sampai jumlah rencana; status dihitung dari jumlah |
| PCK-05 | Centang cepat | Untuk satu unit, centang langsung; untuk beberapa unit tersedia “Tandai semua” dan pengisian jumlah |
| PCK-06 | Filter packing | Semua, belum dikemas, sebagian, selesai, tidak dibawa |
| PCK-07 | Asal kotak terlihat | Baris bawaan memperlihatkan lokasi simpan asal |
| PCK-08 | Tas opsional | Membuat tas dan memilihnya tidak wajib untuk menyelesaikan packing |
| PCK-09 | Peringatan konflik | Perencanaan barang yang sama pada perjalanan bertumpang tindih menunjukkan potensi bentrok |
| PCK-10 | Undo | Pembatalan centang tersedia lewat snackbar dan tersimpan dengan benar |
| PCK-11 | Barang penting | Dokumen/obat atau barang yang ditandai penting tetap terlihat saat belum selesai |
| PCK-12 | Pemeriksaan berangkat | Daftar sisa packing; tombol mulai perjalanan tetap tersedia setelah pengguna mengakui item yang belum selesai |

Aturan perhitungan:

- `belum_dikemas`: packed_quantity = 0.
- `sebagian`: 0 < packed_quantity < planned_quantity.
- `selesai`: packed_quantity = planned_quantity.
- Keputusan tidak dibawa memiliki planned_quantity = 0 dan packed_quantity = 0.
- Barang yang belum dipilih tampil sebagai belum diputuskan pada pemilih inventaris. Jangan otomatis membuat baris perjalanan untuk seluruh inventaris.
- Progres utama adalah jumlah **baris barang selesai / baris barang yang dipilih dibawa**. Teks sekunder dapat menunjukkan jumlah unit selesai. Jangan mencampur dua rumus.
- Bila belum ada barang yang dipilih dibawa, tampilkan “Belum ada daftar bawaan”, bukan “100% siap”.
- Bila pengguna mengubah keputusan menjadi tidak dibawa pada barang yang sudah dikemas, minta konfirmasi untuk mereset packing. Perubahan catatan bukan berarti barang fisik otomatis keluar dari tas.
- Mengurangi jumlah rencana di bawah jumlah yang sudah dikemas membutuhkan koreksi eksplisit.
- Packed_quantity tidak mengurangi jumlah inventaris; packing bukan transaksi penjualan atau pemakaian barang.

Potensi konflik dihitung dari jumlah rencana pada perjalanan dengan rentang tanggal yang beririsan, dibandingkan jumlah inventaris. Jangan menjumlahkan kebutuhan perjalanan yang berurutan tanpa overlap. Bila tanggal akhir belum diketahui, tampilkan ketidakpastian, bukan konflik pasti. Peringatan tidak menghalangi perencanaan; pengguna mungkin akan menggunakan barang secara bergantian.

Versi 1.0 mendukung satu tas per baris bawaan. Bila satu jenis barang dibagi ke banyak tas, pengguna dapat menulis pembagian pada catatan. Jangan menambah sistem alokasi stok multi-tas pada fase awal.

### 6.4 Jadwal, tiket, dan pengingat

| ID | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| SCH-01 | Kelola jadwal | Judul, jenis, tanggal, jam opsional, lokasi, catatan, perjalanan, dan tujuan opsional |
| SCH-02 | Jenis jadwal | Transportasi, check-in/out, kegiatan, persiapan, lainnya |
| SCH-03 | Agenda | Tampilan daftar kronologis utama; kalender bulanan sebagai pilihan |
| SCH-04 | Zona waktu | Zona jadwal tersimpan dan terlihat saat berbeda dari zona perangkat |
| SCH-05 | Tiket/reservasi | Judul, penyedia, kode pemesanan opsional, catatan, jadwal terkait opsional |
| SCH-06 | Lampiran lokal | Gambar dan PDF disalin ke penyimpanan aplikasi dan bisa dibuka offline |
| SCH-07 | Tiket tanpa jadwal | Dapat disimpan lebih dahulu dan dikaitkan kemudian |
| SCH-08 | Pengingat lokal | Beberapa pengingat per jadwal: preset atau waktu khusus |
| SCH-09 | Izin dan status | Status aktif, izin diperlukan, perkiraan waktu, atau nonaktif terlihat jelas |
| SCH-10 | Pembaruan pengingat | Mengedit, membatalkan, dan menghapus jadwal memperbarui alarm terkait |
| SCH-11 | Navigasi notifikasi | Membuka jadwal yang benar saat aplikasi terbuka maupun cold start |
| SCH-12 | Batas tanggal/jam | Tanggal saja tidak diperlakukan sebagai jam 00.00 tanpa keputusan pengguna |

Tanggal dan waktu:

- Jadwal dengan jam menyimpan waktu lokal yang dipilih, zona IANA, dan hasil konversi instant UTC.
- Perubahan zona perangkat tidak menggeser waktu acara secara diam-diam. Pengguna dapat memilih zona baru saat mengedit acara.
- Jadwal lintas zona memiliki waktu mulai dan selesai dengan zona masing-masing bila keduanya diisi. Validasi urutan menggunakan instant UTC.
- Jadwal tanpa jam disimpan sebagai tanggal lokal, bukan timestamp tengah malam. Pengingatnya membutuhkan waktu eksplisit, misalnya pukul 09.00 pada tanggal yang dipilih.
- Default preset pengingat tersedia tetapi tidak otomatis aktif untuk setiap jadwal. Pengguna memilih pengingat ketika membuat atau mengedit jadwal.
- Pengingat yang sudah lewat tidak dijadwalkan ulang sebagai notifikasi baru. Tampilkan sebagai lewat/terlewat dalam aplikasi.
- Agenda menampilkan jam 24 jam dan penanda zona, misalnya 07.30 WIB; gunakan zona IANA sebagai data, bukan teks singkatan sebagai kunci.

Ketentuan tiket:

- Lampiran bukan bukti validasi tiket; aplikasi tidak memeriksa kode pemesanan ke penyedia.
- Gambar tiket asli harus dipertahankan agar QR/barcode tidak rusak. Thumbnail boleh diperkecil, sumber tetap tersedia untuk zoom.
- Buka PDF dengan viewer lokal yang kompatibel; bila belum tersedia, gunakan aplikasi eksternal melalui URI aman. Jangan menjanjikan preview internal sebelum plugin dibuktikan.
- Maksimal 20 MB per lampiran pada versi awal; tampilkan ukuran dan pesan penolakan yang jelas.
- Pengguna boleh menyimpan URL sebagai catatan, tetapi akses URL membutuhkan internet dan tidak termasuk jaminan offline.
- Tidak membuat QR/barcode dekoratif yang menyerupai tiket nyata.

Ketentuan notifikasi Android:

- Gunakan notifikasi lokal terjadwal; tidak memerlukan push server.
- Minta izin notifikasi dalam konteks saat pengguna mengaktifkan pengingat.
- Untuk acara yang membutuhkan ketepatan waktu, sediakan mode tepat waktu dengan pemeriksaan akses exact alarm. Bila akses tidak tersedia, tawarkan pengingat perkiraan dan tampilkan statusnya.
- Gunakan SCHEDULE_EXACT_ALARM untuk akses yang diberikan pengguna bila memang diperlukan. Jangan mengandalkan USE_EXACT_ALARM tanpa mengevaluasi kesesuaian penggunaan.
- Pengingat persiapan biasa boleh menggunakan alarm tidak presisi untuk mengurangi beban baterai.
- Jadwal ulang setelah reboot, pembaruan aplikasi, restore, perubahan jam/zona yang relevan, serta perubahan izin; hindari alarm ganda.
- Simpan ID notifikasi unik dengan pemetaan ke reminder. UUID tidak boleh dipotong menjadi integer tanpa mekanisme penanganan bentrok.
- Force-stop, perangkat mati, izin ditolak, dan pembatasan perangkat dapat menghalangi pengiriman. UI harus menjelaskan keterbatasan saat relevan; jangan menjamin notifikasi selalu tepat waktu.
- Teks lock screen default tidak memuat kode pemesanan atau isi tiket. Tidak diperlukan foreground service permanen.

### 6.5 Checklist pulang dan template

| ID | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| RET-01 | Buat checkpoint | Default sebelum pulang; checkpoint perpindahan kota opsional |
| RET-02 | Dasar checklist | Snapshot jumlah yang benar-benar dikemas saat checkpoint dibuat |
| RET-03 | Konfirmasi jumlah | Dibawa kembali, habis dipakai, sengaja ditinggal; sisa belum terkonfirmasi terlihat |
| RET-04 | Tidak mengubah stok otomatis | Penandaan checklist tidak langsung mengurangi inventaris |
| RET-05 | Tutup dengan catatan | Pengguna dapat menutup checkpoint dengan item belum selesai setelah konfirmasi; statusnya bukan lengkap |
| TPL-01 | Template bawaan | Nama template, barang, jumlah, dan catatan packing |
| TPL-02 | Terapkan template | Membuat rencana baru dengan packed_quantity = 0 |
| TPL-03 | Item tidak tersedia | Barang diarsipkan atau jumlah kurang muncul sebagai peringatan, tidak digandakan sebagai stok |

Untuk setiap entri checkpoint: `confirmed = returned + consumed + intentionally_left`, dengan semua nilai nonnegatif dan confirmed tidak melebihi expected_quantity. `unconfirmed = expected_quantity - confirmed`. Jika unconfirmed masih ada, tampilkan “Belum terkonfirmasi”; pengguna dapat mencatat dugaan hilang pada catatan, tetapi jangan otomatis menandainya selesai.

Snapshot checkpoint tidak berubah ketika daftar packing diedit. Tawarkan sinkronisasi ulang secara eksplisit, tampilkan perubahan, dan jangan mereset konfirmasi yang sudah ada tanpa keputusan pengguna. Checkpoint berikutnya dapat dibuat dari jumlah yang diketahui masih ikut dibawa berdasarkan checkpoint sebelumnya; bila belum jelas, minta pengguna meninjau daftar awalnya.

### 6.6 Backup dan pengaturan

| ID | Kebutuhan | Kriteria penerimaan |
| --- | --- | --- |
| BAK-01 | Ekspor lengkap | Seluruh data, foto asli, tiket, dan pengaturan portabel masuk satu arsip |
| BAK-02 | Pilih tujuan simpan | Menggunakan pemilih dokumen Android; keberhasilan berarti file benar-benar selesai ditulis |
| BAK-03 | Impor dengan preview | Menampilkan tanggal backup, jumlah barang/perjalanan/lampiran, dan peringatan penggantian data |
| BAK-04 | Validasi sebelum restore | Format, versi, relasi, checksum, ukuran, dan path diperiksa sebelum data aktif disentuh |
| BAK-05 | Restore aman | Gagal impor tidak mengubah data aktif; tersedia rollback saat proses terganggu |
| BAK-06 | Jadwal ulang reminder | Restore memeriksa izin perangkat baru dan membangun kembali pengingat yang masih akan datang |
| BAK-07 | Status backup | Tanggal ekspor terakhir dan indikasi ada perubahan setelah backup |
| SET-01 | Pengaturan dasar | Bahasa awal Indonesia, jam 24 jam, pengingat, ukuran penyimpanan, backup, info aplikasi |
| SET-02 | Hapus semua data | Konfirmasi khusus dan anjuran backup; tidak dapat terpicu dari tombol biasa |

Impor versi 1.0 menggunakan mode **ganti seluruh data**, bukan gabung. Preview harus mengatakan ini dengan jelas. Backup internal sementara untuk rollback bukan pengganti backup eksternal pengguna.

## 7. Arsitektur informasi dan layar

### 7.1 Navigasi global

Empat tab: **Beranda · Barang · Perjalanan · Agenda**. Pengaturan dibuka melalui ikon di header Beranda. Kotak/lokasi simpan menjadi subhalaman Barang; tiket menjadi tab detail perjalanan. Hindari membuat enam atau tujuh tab utama.

### 7.2 Navigasi di dalam perjalanan

Empat bagian: **Ringkasan · Bawaan · Jadwal · Tiket**. Kelola tujuan, tas, template, serta cek pulang melalui tindakan kontekstual. Header selalu menunjukkan nama perjalanan agar pengguna tidak mengubah perjalanan lain tanpa sadar.

| Layar | Konten prioritas | Tindakan utama |
| --- | --- | --- |
| Beranda | Perjalanan terdekat/berlangsung, sisa packing, jadwal berikutnya | Lanjutkan persiapan |
| Barang | Search, filter lokasi/kategori, daftar dengan thumbnail | Tambah barang |
| Detail barang | Foto, jumlah, asal simpan, catatan, perjalanan terkait | Ubah barang |
| Lokasi simpan | Kotak/lemari/laci, jumlah entri barang | Tambah lokasi |
| Detail lokasi | Foto/keterangan lokasi dan isi | Tambah barang di sini |
| Daftar perjalanan | Berlangsung, berikutnya, riwayat | Buat perjalanan |
| Ringkasan perjalanan | Tujuan berurutan, tanggal, kesiapan, jadwal terdekat | Lanjutkan packing |
| Bawaan | Filter status, asal simpan, jumlah, checkbox | Pilih barang |
| Detail packing | Jumlah rencana/dikemas, tas opsional, catatan | Simpan perubahan |
| Jadwal perjalanan | Timeline menurut tanggal | Tambah jadwal |
| Tiket | Daftar reservasi, judul, waktu, preview | Tambah tiket |
| Detail tiket | Data reservasi dan lampiran yang dapat di-zoom | Buka lampiran |
| Agenda global | Jadwal semua perjalanan, filter, kalender pilihan | Buka jadwal |
| Checkpoint | Barang yang harus dikonfirmasi, sisa jumlah | Konfirmasi barang |
| Template | Template packing yang dapat dipakai ulang | Gunakan template |
| Backup | Ekspor, impor, ekspor terakhir, perubahan terbaru | Ekspor backup |

Aturan Beranda: bila beberapa perjalanan berlangsung, tampilkan daftar ringkas dan pilihan konteks. Bila tidak ada yang berlangsung, prioritaskan perjalanan persiapan dengan tanggal terdekat. Perjalanan selesai tidak otomatis menjadi kartu utama. Pengguna boleh menyematkan perjalanan secara manual.

### 7.3 Keadaan layar

Setiap layar mendukung keadaan kosong, loading lokal singkat, data tersedia, kesalahan yang dapat dipulihkan, dan input tidak valid. Tambahkan keadaan lampiran hilang, penyimpanan penuh, izin ditolak, serta item diarsipkan ketika relevan.

Contoh teks UI:

- “Belum ada barang. Catat barang pertama dan tempat menyimpannya.”
- “3 barang belum dikemas.”
- “Asal: Kotak Elektronik.”
- “Sudah dikemas · Ransel Hitam.”
- “Lokasi belum dicatat.”
- “Pengingat tersimpan, tetapi izin notifikasi belum aktif.”
- “Lampiran tidak ditemukan. Kamu bisa menambahkannya kembali.”
- “Backup ini akan mengganti seluruh data di aplikasi.”

## 8. Arah UI dan sistem desain

### 8.1 Pembacaan empat referensi pengguna

| Referensi | Karakter yang dipakai | Adaptasi pada Bawa |
| --- | --- | --- |
| image(20261010-084127).png | Daftar ringkas, thumbnail, latar putih, CTA kuat | Daftar packing dengan foto, jumlah, dan tombol tindakan yang jelas |
| image(20261010-084137).png | Hierarki judul, search lapang, foto sudut membulat | Halaman inventaris yang terasa bersih dan mudah dipindai |
| image(20261010-084200).png | Kalender, tanggal/jam menonjol, navigasi bawah, aksen biru | Agenda dan detail jadwal dengan informasi waktu yang kuat |
| image(20261010-084210).png | Struktur kartu tiket dan identitas kegiatan | Tiket/reservasi sederhana dengan jadwal dan lampiran nyata |

Referensi digunakan untuk karakter visual, bukan disalin sebagai aplikasi makanan, galeri desain, atau dompet. Dokumen tetap dapat digunakan tanpa gambar tertanam. Jika AI pelaksana tidak menerima empat file asli, ia harus mengikuti deskripsi tabel ini dan meminta referensi hanya bila diperlukan untuk penyamaan visual yang lebih tepat.

### 8.2 Prinsip visual

- Latar terang netral, tipografi tegas, foto sebagai petunjuk barang, satu aksen utama.
- Ruang kosong membantu membaca; jangan membungkus setiap informasi dalam kartu besar.
- Daftar barang lebih diutamakan daripada grid untuk pekerjaan packing. Grid opsional untuk melihat lokasi simpan.
- Kartu tiket dapat memakai pembatas putus-putus yang halus, tanpa dekorasi boarding pass berlebihan.
- Bayangan sangat tipis hanya pada elemen yang memerlukan pemisahan. Hindari neumorphism yang mengurangi kontras.
- Tidak menggunakan gradient besar, glassmorphism, ilustrasi AI dekoratif, emoji di setiap judul, angka statistik yang tidak berguna, atau greeting hero yang mengambil setengah layar.
- Informasi paling penting: nama barang, asal kotak, jumlah, status, tanggal, jam. Dekorasi mengikuti informasi tersebut.

### 8.3 Design tokens awal

| Token | Nilai awal |
| --- | --- |
| Background | #F7F8FA |
| Surface | #FFFFFF |
| Teks utama | #171A20 |
| Teks sekunder | #5E6673 |
| Border | #E5E8EE |
| Primary | #465DDB |
| Primary soft | #EEF1FF |
| Success | #22734B |
| Warning | #8C5D14 |
| Error | #B42318 |
| Spacing | 4, 8, 12, 16, 20, 24, 32 |
| Radius input/baris foto | 10–12 dp |
| Radius kartu/sheet | 16–20 dp |
| Tombol utama | Tinggi minimal 48 dp |
| Target sentuh | Minimal 48 × 48 dp, termasuk checkbox dan ikon |
| Foto daftar | Sekitar 52–60 dp persegi |
| Font | Inter dibundel lokal beserta lisensi; fallback font sistem |
| Judul layar | 24–28 sp, semibold |
| Judul bagian | 18–20 sp, semibold |
| Body | 14–16 sp |
| Metadata | 12–13 sp, tidak digunakan untuk informasi utama |
| Motion | 150–220 ms, singkat dan fungsional |

Nilai warna merupakan rancangan awal. AI wajib memeriksa kontras nyata, minimal 4.5:1 untuk teks normal. Status memakai teks/ikon selain warna. Teks putih di atas primary harus diuji, bukan diasumsikan.

### 8.4 Komponen wajib konsisten

Header, search field, filter chip, baris barang, checkbox packing, kartu perjalanan ringkas, progress bar, baris jadwal, kartu tiket, field tanggal/jam, bottom sheet, dialog konfirmasi, snackbar undo, dan empty state.

Tombol tambah mengikuti konteks layar; jangan menempatkan tombol tambah global tanpa menunjukkan objek yang akan dibuat. Formulir pendek menggunakan sheet, formulir dengan foto/lampiran dan banyak field menggunakan halaman penuh. Back pada formulir yang berubah menawarkan simpan atau buang perubahan.

### 8.5 Aksesibilitas dan adaptasi Android

- Safe area dan edge-to-edge tidak menutupi konten dengan status/navigation bar.
- Tombol back Android mengikuti urutan navigasi; tidak menutup aplikasi ketika sheet masih terbuka.
- UI diperiksa pada lebar 360 dp dan font scale 1.0–1.5.
- Nama barang/tujuan panjang tidak merusak checkbox atau jam; detail lengkap tersedia.
- Screen reader membaca nama barang, jumlah, lokasi, dan status checkbox.
- Keyboard tidak menutup tombol simpan; field jumlah menggunakan input numerik dengan validasi.
- Animasi menghormati preferensi reduced motion yang tersedia.

## 9. Model data

Gunakan SQLite sebagai sumber kebenaran lokal. UUID dipakai sebagai identitas stabil; tanggal teknis created_at/updated_at disimpan dalam UTC. Relasi menggunakan foreign key dan indeks yang sesuai. Nama tidak menjadi primary key.

| Entitas | Field inti | Catatan |
| --- | --- | --- |
| StorageLocation | id, name, type, description, photo_asset_id, archived_at | Lokasi simpan, tidak wajib ikut perjalanan |
| Category | id, name, sort_order | Kategori sederhana, tanpa hierarki |
| Item | id, name, quantity, unit, category_id, storage_location_id, notes, is_important, archived_at, created_at, updated_at | Satu lokasi simpan asal per entri |
| ItemPhoto | id, item_id, asset_id, sort_order | Relasi foto; foto utama memiliki urutan pertama |
| Asset | id, relative_path, mime_type, size_bytes, sha256, original_name, kind | Foto/tiket disimpan sebagai file, bukan base64 di tabel |
| Trip | id, name, start_date, end_date, date_zone_id, status, is_archived, is_pinned, notes | end_date dapat null |
| TripStop | id, trip_id, label, sort_order, arrival_local, arrival_zone, departure_local, departure_zone | Label kota boleh berulang |
| TripBag | id, trip_id, name, description | Opsional dan khusus perjalanan |
| TripItem | id, trip_id, item_id, decision, planned_quantity, packed_quantity, trip_bag_id, notes, name_snapshot, source_label_snapshot, updated_at | Unique(trip_id, item_id); status packing diturunkan dari jumlah |
| ScheduleEvent | id, trip_id, trip_stop_id, title, type, is_date_only, local_date, local_start, start_zone, start_utc, local_end, end_zone, end_utc, location_text, notes, status | Field waktu nullable untuk acara tanggal saja |
| Ticket | id, trip_id, schedule_event_id, title, provider, booking_code, notes | Relasi jadwal opsional; harus dari perjalanan yang sama |
| TicketAttachment | id, ticket_id, asset_id, sort_order | Beberapa lampiran per tiket |
| Reminder | id, schedule_event_id, trigger_utc, notification_id, precision_preference, scheduling_state, enabled | Status tersimpan bukan bukti notifikasi sudah dibaca |
| ReturnCheckpoint | id, trip_id, trip_stop_id, title, created_at, closed_at, close_state | close_state: lengkap atau ditutup_dengan_sisa |
| ReturnEntry | id, checkpoint_id, trip_item_id, name_snapshot, expected_quantity, returned_quantity, consumed_quantity, left_quantity, notes | Snapshot checklist dan jumlah terkonfirmasi |
| PackingTemplate | id, name, notes, created_at, updated_at | Tidak menyimpan tiket aktif |
| TemplateItem | id, template_id, item_id, planned_quantity, notes | Unique(template_id, item_id) |
| AppSettings | key, value | Tema awal, format jam, backup terakhir, revision data |

Ketentuan relasi dan riwayat:

- TripItem yang aktif menampilkan nama dan lokasi asal dari Item terbaru. Snapshot menyimpan konteks saat dipilih dan diperbarui ketika pengguna meninjau ulang barang untuk perjalanan tersebut.
- Ketika perjalanan selesai/dibatalkan, freeze snapshot yang dipakai riwayat. Perubahan nama/kotak pada inventaris tidak mengubah tampilan historis.
- Item diarsipkan tetap dapat dibaca oleh perjalanan dan template lama, tetapi tidak tampil sebagai pilihan normal.
- Menghapus Trip menghapus data turunan perjalanan setelah konfirmasi, tetapi tidak menghapus Item dan StorageLocation.
- Menghapus ScheduleEvent melepas relasi Ticket, membatalkan Reminder, dan mempertahankan tiket. Menghapus TripStop menawarkan pelepasan relasi jadwal, bukan penghapusan jadwal tersembunyi.
- Asset dihapus hanya jika tidak ada referensi lagi. Cache thumbnail dapat dibangun ulang dan tidak wajib masuk backup.
- Setiap edit yang memengaruhi backup menaikkan data_revision. last_export_revision menunjukkan apakah ada perubahan setelah ekspor terakhir.
- Schema database dan schema backup memiliki versi terpisah. Setiap perubahan schema harus memiliki migrasi; jangan menghapus database agar migrasi terlihat berhasil.

## 10. Arsitektur dan rekomendasi teknologi

### 10.1 Struktur aplikasi

Gunakan organisasi per fitur dengan pemisahan UI, state/controller, repository, dan penyimpanan. Logika jumlah, konflik perjalanan, progres, checkpoint, dan validasi backup dipisahkan menjadi fungsi/service yang dapat diuji tanpa widget.

```text
lib/
  app/                 bootstrap, router, theme, navigation
  core/                database, assets, errors, time, shared widgets
  features/
    inventory/         barang dan lokasi simpan
    trips/             perjalanan dan tujuan
    packing/           pilihan bawaan dan packing
    agenda/            jadwal dan tampilan kalender
    tickets/           tiket dan lampiran
    reminders/         pengingat lokal
    return_check/      checkpoint pulang/perpindahan
    templates/         template bawaan
    backup/            ekspor, validasi, restore
    settings/          preferensi lokal
test/
integration_test/
docs/                  keputusan, kemajuan fase, panduan uji
```

Struktur ini adalah pedoman, bukan kewajiban membuat semua folder sebelum ada isinya. Tidak diperlukan microservice, server, event bus besar, atau banyak lapisan abstraksi untuk operasi sederhana.

### 10.2 Stack yang direkomendasikan

| Kebutuhan | Pilihan | Ketentuan |
| --- | --- | --- |
| UI dan bahasa | Flutter stable + Dart yang kompatibel | Catat versi toolchain aktual; jangan mengarang versi |
| Database | SQLite melalui Drift | Typed query, transaksi, dan strategi migrasi |
| State management | Riverpod | Satu pendekatan state utama; jangan campur banyak framework |
| Routing | go_router | Mendukung deep link internal notifikasi dan back stack |
| Kamera/pemilih foto | image_picker atau API picker yang kompatibel | Uji lifecycle, canceled selection, dan pemulihan hasil pada Android |
| File app-private | path_provider | Simpan path relatif, bukan path absolut perangkat lama |
| Pemilih dokumen | file_selector atau integrasi Storage Access Framework | Harus terbukti dapat membaca/menulis URI Android pada perangkat target |
| Notifikasi | flutter_local_notifications | Ikuti setup Android dan pemeriksaan izin versi yang dipakai |
| Zona waktu | timezone dan cara membaca zona perangkat yang kompatibel | Jangan mengasumsikan package timezone sendiri membaca zona perangkat |
| Backup | archive + JSON manifest + SHA-256 | Streaming/isolate untuk kerja berat; batas ukuran dan path aman |
| Format tanggal | intl | Label Indonesia dan jam 24 jam |
| Identitas | uuid | ID stabil untuk relasi dan restore |
| PDF | Viewer lokal yang lisensinya cocok atau pembuka eksternal | Pilih setelah spike pembukaan offline dan keamanan URI |
| Pengujian | flutter_test dan integration_test | Fokus pada domain penting dan alur nyata |

Pilihan di atas merupakan rekomendasi proyek, bukan klaim semua paket cocok pada semua versi Android. Pada Fase 0, AI harus memeriksa dokumentasi resmi, lisensi, minSdk, compileSdk, targetSdk, kebutuhan native build, serta kompatibilitas paket. Gunakan versi stabil yang kompatibel, pin hasil resolusi dalam pubspec.lock, dan simpan keputusan di docs/DECISIONS.md. Jangan mengganti stack saat proyek berjalan tanpa alasan teknis yang tertulis.

Target awal produk: Android 8/API 26 ke atas, hanya bila toolchain dan dependensi yang dipilih mendukung. Jika suatu dependensi membutuhkan versi lebih tinggi, tentukan minimum aktual pada Fase 0 dan catat dampaknya. Target/compile SDK mengikuti toolchain yang diverifikasi saat implementasi; dokumen ini tidak mengunci nomor yang mungkin cepat berubah.

### 10.3 Kebijakan offline dan privasi

- Tidak ada API, login, analytics, iklan, telemetry, atau backend.
- Font dan aset UI dibundel agar startup tidak membutuhkan internet.
- Release tidak meminta izin INTERNET bila semua dependensi mendukung kebutuhan offline tanpa izin tersebut. Periksa merged manifest aktual.
- Gunakan picker dengan akses terbatas; jangan meminta akses seluruh penyimpanan atau MANAGE_EXTERNAL_STORAGE untuk fitur dasar.
- Kamera, notifikasi, dan exact alarm hanya diminta saat dibutuhkan. Penolakan izin tidak memblokir inventaris atau perjalanan.
- Nonaktifkan cloud Auto Backup Android dan atur pengecualian ekstraksi data yang sesuai. Pada sebagian perangkat, allowBackup=false saja tidak cukup untuk membatasi transfer antarperangkat; kebijakan backup harus diuji dan didokumentasikan.
- File disimpan dalam sandbox aplikasi. Versi 1.0 tidak menjanjikan enkripsi database atau backup.
- Backup ekspor berisi data pribadi dalam format yang dapat dibaca; tampilkan keterangan ini di layar backup. Backup dengan kata sandi dapat menjadi fitur berikutnya menggunakan format enkripsi teruji, tanpa kriptografi buatan sendiri.
- Log teknis tidak berisi kode pemesanan, isi tiket, foto, atau path pribadi lengkap.
- APK pembaruan harus menggunakan application ID dan signing key yang sama agar dapat meng-upgrade aplikasi terpasang dengan data tetap tersedia.

## 11. Penyimpanan foto dan lampiran

1. Hasil kamera/picker segera disalin dari URI/path sementara ke direktori app-private dengan nama UUID.
2. Database menyimpan path relatif dan metadata asset.
3. Foto barang dapat dikompresi untuk pemakaian sehari-hari: target sisi panjang sekitar 1600 px dan kualitas yang masih dapat dibaca. Sediakan thumbnail terpisah.
4. Hindari decoding gambar resolusi penuh pada setiap baris daftar.
5. Orientasi foto harus benar; metadata lokasi foto dibuang saat memproses foto barang bila memungkinkan tanpa merusak gambar.
6. Lampiran tiket asli dipertahankan. Buat preview terpisah, bukan mengganti file sumber.
7. Operasi copy gagal atau storage penuh tidak boleh meninggalkan referensi database ke file yang belum selesai.
8. Jika proses terputus, pembersihan file staging dilakukan pada startup berikutnya tanpa menghapus asset yang masih dipakai.
9. Menghapus file sumber di galeri/Downloads tidak merusak salinan aplikasi.
10. Menampilkan asset yang hilang menggunakan placeholder dan tindakan perbaikan, tidak menyebabkan crash.

## 12. Spesifikasi ekspor dan impor backup

### 12.1 Format

Nama default: `Bawa_Backup_YYYYMMDD_HHmm.zip`. Ekstensi ZIP dipakai agar mudah dipindahkan dan dipahami pengguna.

```text
manifest.json
data.json
assets/<asset_uuid>.<extension>
```

Manifest minimal memuat `format`, `schema_version`, `app_version`, `created_at_utc`, `data_revision`, jumlah entitas, daftar asset dengan path relatif, ukuran, dan SHA-256. data.json memuat hasil ekspor logis dari semua entitas portabel. Tidak menyimpan URI picker atau path absolut perangkat.

SHA-256 digunakan untuk mendeteksi kerusakan file, bukan membuktikan backup berasal dari pihak tepercaya. Setiap konten impor tetap harus divalidasi.

### 12.2 Proses ekspor

1. Baca snapshot data yang konsisten. Selama snapshot dan daftar asset dikumpulkan, cegah perubahan terkait atau gunakan mekanisme snapshot yang setara.
2. Kumpulkan seluruh file sumber yang dirujuk; laporan kegagalan harus menyebut ada lampiran yang tidak tersedia, bukan mengklaim backup lengkap.
3. Buat manifest dan archive staging, lalu verifikasi hasilnya.
4. Salin arsip ke lokasi pilihan pengguna menggunakan picker Android.
5. Tandai ekspor berhasil hanya setelah penulisan tujuan selesai. Pembatalan picker bukan ekspor berhasil.
6. Simpan last_export_revision dari snapshot yang diekspor. Jika ada edit setelah snapshot, indikator perubahan tetap menyala.

### 12.3 Proses impor dan pemulihan

1. Salin arsip terpilih ke staging, jangan langsung mengekstrak ke folder asset aktif.
2. Tolak format asing, schema lebih baru yang belum didukung, relasi tidak valid, checksum berbeda, jumlah negatif, dan rentang packing/checkpoint yang tidak valid.
3. Validasi setiap path hasil normalisasi. Tolak path absolut, traversal `..`, symlink, nama/path duplikat, dan file di luar direktori staging.
4. Terapkan batas proteksi awal: arsip 512 MB, total ekstraksi 1 GB, file maksimal 20 MB untuk tiket/foto yang sesuai kebijakan, dan maksimal 10.000 entry. Validasi ukuran saat streaming, bukan hanya header archive. Batas dapat diperbesar melalui perubahan implementasi yang diuji, bukan bypass otomatis.
5. Tampilkan preview dan minta konfirmasi “Ganti data”. Ini adalah konfirmasi tindakan di produk karena data lama akan diganti.
6. Simpan rollback snapshot internal; cegah edit selama penggantian.
7. Gunakan penanda restore journal untuk mengoordinasikan database dan folder asset. Database transaction saja tidak mencakup filesystem.
8. Ganti data dan asset menggunakan staging tervalidasi; lakukan commit yang dapat dipulihkan bila aplikasi ditutup di tengah proses.
9. Pada startup, journal yang belum selesai memicu rollback atau penyelesaian terkontrol. Data aktif tidak boleh berisi campuran dua backup.
10. Setelah restore berhasil, bangun ulang thumbnail dan ID notifikasi perangkat; batalkan reminder lama dan jadwalkan reminder masa depan sesuai izin saat ini.
11. Izin Android, notification ID perangkat lama, cache, URI picker, signing key, dan path absolut tidak dipulihkan sebagai data portabel.

Impor backup yang sama dua kali tidak membuat data ganda karena seluruh dataset diganti. Migrasi backup schema lama harus teruji. Jangan mendukung format lama secara diam-diam bila migrator belum dibuat.

## 13. Kualitas, performa, dan ketahanan

| Area | Target versi 1.0 |
| --- | --- |
| Respons packing | Feedback visual langsung; persist cepat; revert dan tampilkan error bila save gagal |
| Search | Target hasil <300 ms untuk 2.000 entri pada perangkat uji, dengan debounce yang wajar |
| Data uji | 2.000 barang, 100 lokasi, 100 perjalanan, 1.000 jadwal, dan asset contoh terukur |
| Startup | Target cold start <3 detik pada perangkat uji; ukur pada build release |
| Daftar | Lazy rendering, thumbnail caching, dan query terindeks |
| Kerja berat | Ekspor, ekstraksi, hashing, dan pemrosesan gambar tidak membekukan UI |
| Ketahanan | Data konsisten saat proses ditutup, storage penuh, picker batal, atau impor gagal |
| Offline | Semua fitur inti dan file yang tersimpan dapat digunakan dalam mode pesawat |
| Pembaruan | Migrasi database mempertahankan barang, perjalanan, foto, dan tiket |
| Feedback | Tidak ada spinner permanen atau tombol yang menampilkan berhasil sebelum penyimpanan sukses |

Angka performa adalah target awal yang harus diukur, bukan alasan untuk membuat benchmark besar sebelum alur utama selesai. Catat perangkat, OS, ukuran dataset, dan hasil aktual dalam laporan pengujian.

## 14. Rencana implementasi bertahap oleh AI

### 14.1 Aturan pengerjaan

AI bekerja hanya pada fase yang disebutkan pengguna. Bila pengguna hanya menyerahkan PRD tanpa menyebut fase, mulai dari **Fase 0**, bukan membangun seluruh aplikasi. Tidak perlu meminta persetujuan untuk setiap perubahan kecil di dalam fase yang sudah diminta.

Setiap fase menghasilkan fungsi yang dapat diperiksa, catatan perubahan, validasi yang benar-benar dijalankan, keterbatasan yang masih ada, dan handoff untuk fase berikutnya. Jangan mengklaim pengujian perangkat fisik, build, atau notifikasi berhasil jika lingkungan tidak memungkinkan pelaksanaannya.

### Fase 0 — Fondasi keputusan dan rencana

**Tujuan:** menyelesaikan ambiguitas teknis sebelum coding besar.

Pekerjaan:

- Baca PRD dan catat perbedaan kotak, tas, dan status per perjalanan.
- Periksa Flutter/Android toolchain, kompatibilitas dan lisensi paket, serta strategi storage picker, PDF, notification, dan backup.
- Pilih versi dependency aktual dan dokumentasikan alasan.
- Finalisasi schema awal, relasi, aturan quantity, navigasi, dan daftar layar.
- Buat docs/DECISIONS.md, docs/PHASE_STATUS.md, docs/TEST_PLAN.md.
- Tetapkan minimum Android dan perangkat uji yang tersedia.

**Selesai bila:** keputusan dapat diterapkan, dependensi kritis diketahui, dan tidak ada backend/login yang disisipkan. Hasil utama berupa dokumen rencana dan daftar pekerjaan; belum perlu membuat semua layar.

### Fase 1 — Sistem desain dan prototipe Flutter

**Dependensi:** Fase 0. **Tujuan:** menentukan kualitas UI sebelum fitur berkembang.

Pekerjaan:

- Buat proyek Flutter dan design tokens, navigasi empat tab, serta komponen inti.
- Buat layar contoh Beranda, Barang, detail lokasi, detail perjalanan, Bawaan, Agenda, dan Tiket.
- Gunakan fixture lokal berlabel untuk preview; tidak berpura-pura sebagai data pengguna tersimpan.
- Buat empty state dan formulir utama.
- Periksa ukuran layar kecil, teks panjang, font scale, contrast, dan back navigation.

**Selesai bila:** UI konsisten, alur dapat diklik, screenshot layar utama tersedia, dan build dasar berjalan. Tidak diperlukan layanan daring.

### Fase 2 — Database, inventaris, lokasi, dan media

**Dependensi:** Fase 1. **Cakupan:** INV-01 sampai INV-09.

Pekerjaan:

- Implementasi SQLite/Drift, migrasi awal, repository, dan assets service.
- CRUD barang/lokasi/kategori, archive, pencarian dan filter.
- Kamera/picker, salin foto permanen, thumbnail, penanganan canceled picker dan file hilang.
- Ganti fixture dengan data persisten pada layar terkait; fixture hanya berada di mode development/demo.

**Selesai bila:** barang dan foto tetap tersedia setelah restart dan mode pesawat, isi kotak dapat dilihat, dan sumber foto boleh dihapus tanpa merusak salinan aplikasi.

### Fase 3 — Perjalanan, tujuan, dan packing

**Dependensi:** Fase 2. **Cakupan:** TRP-01 sampai TRP-08; PCK-01 sampai PCK-12.

Pekerjaan:

- Perjalanan satu/multi-kota, urutan tujuan, tanggal, dan status.
- Pilih barang, tidak dibawa, jumlah rencana, packing parsial, centang cepat, dan undo.
- Tas opsional dan sumber kotak terlihat.
- Progres yang benar dan warning potensi konflik.
- Duplikasi dengan reset data aktual.

**Selesai bila:** perjalanan A dan B tidak saling mengubah status packing, kotak tidak dianggap tas, dan perjalanan tanpa daftar tidak dinyatakan siap.

### Fase 4 — Agenda dan tiket offline

**Dependensi:** Fase 3. **Cakupan:** SCH-01 sampai SCH-07 serta SCH-12.

Pekerjaan:

- Jadwal bertanggal/berjam, zona waktu, agenda global/per perjalanan, dan kalender pilihan.
- Tiket dengan atau tanpa relasi jadwal, import gambar/PDF, serta preview/zoom.
- Validasi rentang waktu dan keterkaitan perjalanan.

**Selesai bila:** tiket yang tersimpan dapat dibuka offline, gambar QR asli tidak rusak oleh thumbnail, dan jadwal tanggal saja tidak berubah menjadi tengah malam secara otomatis.

### Fase 5 — Pengingat Android

**Dependensi:** Fase 4. **Cakupan:** SCH-08 sampai SCH-11.

Pekerjaan:

- Local notification, runtime permission, pemeriksaan exact alarm, dan fallback yang terlihat.
- Pengingat majemuk dengan ID unik dan pembaruan saat jadwal berubah.
- Notifikasi menuju halaman yang benar saat cold start.
- Reschedule reboot/update dan rekonsiliasi izin.
- Tampilkan keterbatasan kondisi force-stop atau pembatasan perangkat secara kontekstual.

**Selesai bila:** ada hasil uji pengingat pada Android yang tersedia, pengeditan tidak meninggalkan notifikasi lama, dan UI tidak menyatakan pengingat aktif ketika izin tidak memungkinkan. Jika perangkat fisik belum tersedia, tulis “belum diverifikasi pada perangkat fisik” dan jadikan ini pekerjaan validasi wajib berikutnya.

### Fase 6 — Checklist pulang dan template

**Dependensi:** Fase 3; integrasi memakai hasil Fase 4–5. **Cakupan:** RET-01 sampai RET-05; TPL-01 sampai TPL-03.

Pekerjaan:

- Checkpoint berdasarkan packed quantity, jumlah terkonfirmasi, dan sisa belum terkonfirmasi.
- Checkpoint perpindahan kota opsional.
- Template dan penggunaan kembali rencana, tanpa menyalin status aktual/tiket lama.
- Pembaruan tampilan riwayat dan snapshot perjalanan.

**Selesai bila:** item tidak hilang dari checklist karena perubahan inventaris, checkpoint tidak menganggap barang belum terkonfirmasi aman, dan template tidak menggandakan stok.

### Fase 7 — Backup, restore, dan pengaturan

**Dependensi:** Fase 2–6. **Cakupan:** BAK-01 sampai BAK-07; SET-01 sampai SET-02.

Pekerjaan:

- Ekspor satu arsip dengan seluruh media, manifest, checksum, dan logical data.
- Pemilih tujuan simpan, status revision backup, import preview, validasi staging, journal, dan rollback.
- Restore pada dataset kosong/instalasi baru; rekonsiliasi reminder dan izin.
- Kebijakan Android Auto Backup dan data extraction rules.

**Selesai bila:** backup memulihkan barang, lokasi, packing, perjalanan, jadwal, tiket, foto, template, dan checkpoint. Arsip rusak atau terputus tidak merusak dataset aktif. Versi ini belum boleh dijadikan tempat satu-satunya untuk data pribadi sampai uji restore lulus.

### Fase 8 — Penyempurnaan dan APK pribadi

**Dependensi:** Semua fase inti. **Tujuan:** aplikasi siap dipakai sehari-hari.

Pekerjaan:

- Review visual terhadap empat referensi; rapikan layout, microcopy, tap target, dan kondisi layar.
- Jalankan uji domain, integration, migrasi, backup, notifikasi, mode pesawat, dan storage error yang relevan.
- Ukur performa build release pada dataset realistis.
- Periksa manifest release, dependency, izin, dan lisensi aset.
- Buat APK release, panduan instalasi, panduan backup, changelog, serta catatan signing untuk update berikutnya.
- Signing key dibuat dan disimpan oleh pemilik di tempat aman; jangan masuk source control atau log AI.

**Selesai bila:** Definition of Done terpenuhi. Jika build perangkat atau signing belum tersedia, hasil harus menyebut blocker aktual dan tidak mengklaim APK siap dipasang.

## 15. Cara mengendalikan pekerjaan AI

### 15.1 Instruksi induk yang dapat ditempel

```text
Gunakan PRD_Bawa_Flutter_Android.md sebagai spesifikasi produk.
Kerjakan hanya fase yang saya minta. Jika saya belum menyebut fase, mulai Fase 0.

Kotak adalah lokasi simpan asal. Tas perjalanan opsional dan entitasnya terpisah.
Lokasi asal, keputusan dibawa, dan jumlah dikemas harus terpisah.
Status packing melekat pada perjalanan, bukan barang global.
Aplikasi offline tanpa akun, backend, cloud sync, analytics, atau API AI.

Sebelum mengedit, periksa kondisi repository dan pekerjaan fase sebelumnya.
Jangan menimpa perubahan pengguna atau mengganti stack tanpa alasan tertulis.
Gunakan dokumentasi resmi untuk konfigurasi Flutter/Android dan paket.
Jangan mengarang API, versi, hasil build, hasil tes, atau kemampuan plugin.

Kerjakan bagian kecil yang dapat diverifikasi. Fixture hanya untuk preview/test.
Saat layar dihubungkan ke data, gunakan repository nyata, bukan data dummy tersembunyi.
Sertakan keadaan kosong, error, canceled action, dan persistensi yang sesuai.
Jangan menghapus database sebagai pengganti migrasi.
Jangan menambah fitur di luar fase agar terlihat lengkap.

Akhiri fase dengan ringkasan perubahan, validasi aktual, keterbatasan,
status acceptance criteria, dan langkah berikutnya. Perbarui PHASE_STATUS.md.
Berhenti setelah fase yang diminta selesai; jangan otomatis mengerjakan semua fase.
```

### 15.2 Prompt untuk menjalankan satu fase

```text
Baca PRD_Bawa_Flutter_Android.md dan catatan proyek yang sudah ada.
Kerjakan Fase [nomor dan nama] saja.
Pastikan prasyarat fase tersebut terpenuhi. Jika ada kekurangan kecil,
selesaikan yang diperlukan dan catat alasannya; jika ada blocker besar,
jelaskan bukti dan lanjutkan pekerjaan yang tidak bergantung pada blocker itu.

Implementasikan seluruh cakupan fase dan verifikasi acceptance criteria terkait.
Jalankan pemeriksaan yang tersedia dan tulis hasil aktualnya.
Perbarui docs/PHASE_STATUS.md, docs/DECISIONS.md bila ada keputusan baru,
dan docs/TEST_PLAN.md bila skenario uji berubah.
Laporkan apa yang sudah siap, apa yang belum diuji, dan handoff fase berikutnya.
```

### 15.3 Format handoff antar sesi AI

```text
Fase dan status:
Tujuan fase:
Fitur yang selesai dan ID kebutuhan:
File utama yang berubah:
Migrasi/schema saat ini:
Keputusan penting:
Perintah/pengujian yang dijalankan dan hasil:
Pengujian yang belum bisa dijalankan:
Masalah tersisa:
Cara menjalankan dan memeriksa hasil:
Pekerjaan fase berikutnya:
```

Simpan hasil yang dapat dibangun pada setiap fase, idealnya satu atau beberapa commit lokal yang jelas. Kemajuan tidak diukur dari banyaknya file, tetapi dari alur yang bekerja dan terverifikasi. “100% dengan bantuan AI” tetap membutuhkan pengguna untuk mencoba alur, menilai UI, dan menjaga signing key; bukan jaminan hasil tanpa review.

## 16. Skenario pengujian penerimaan

| ID uji | Skenario | Hasil yang diharapkan |
| --- | --- | --- |
| AT-01 | Charger pada Kotak Elektronik dipilih untuk Bandung | Asal kotak terlihat; status belum dikemas |
| AT-02 | Charger dikemas untuk Bandung, juga direncanakan untuk Jakarta | Bandung selesai; Jakarta tetap belum dikemas |
| AT-03 | 5 kaus direncanakan, 3 dikemas | Status sebagian; progres baris belum dianggap selesai |
| AT-04 | Mengubah barang dikemas menjadi tidak dibawa | Konfirmasi reset muncul; perubahan tidak diam-diam |
| AT-05 | Perjalanan tanpa barang | “Belum ada daftar bawaan”, bukan 100% |
| AT-06 | Bandung–Jakarta–Bandung dalam satu perjalanan | Tujuan berulang tersimpan dengan ID berbeda dan urutan benar |
| AT-07 | Packing tanpa membuat tas | Semua fungsi packing tetap bisa digunakan |
| AT-08 | Hapus foto sumber dari galeri lalu restart | Foto dalam aplikasi tetap tersedia |
| AT-09 | Lampirkan PDF dan gambar tiket lalu mode pesawat | File tersimpan dapat dibuka; original QR dapat diperbesar |
| AT-10 | Jadwal tanggal saja | Tidak dijadwalkan pukul 00.00 tanpa input pengguna |
| AT-11 | Acara 07.30 WIB, zona perangkat berubah | Instant acara tetap; UI menunjukkan zona yang relevan |
| AT-12 | Izin notifikasi ditolak | Jadwal tetap tersimpan; status izin diperlukan terlihat |
| AT-13 | Akses exact alarm tidak tersedia | Tidak crash; status fallback/tindakan izin jelas |
| AT-14 | Edit waktu jadwal dengan dua reminder | Reminder lama dibatalkan; dua reminder baru tidak ganda |
| AT-15 | Reboot setelah membuat reminder masa depan | Reminder direkonsiliasi sesuai konfigurasi dan izin |
| AT-16 | Ketuk notifikasi dari aplikasi yang belum berjalan | Membuka detail jadwal yang benar |
| AT-17 | Item 5 dikemas; checkpoint 3 kembali, 1 habis | Satu unit belum terkonfirmasi, checklist belum lengkap |
| AT-18 | Duplikasi perjalanan/template | Stok tidak bertambah; packing, checkpoint, dan tiket aktif tidak terbawa |
| AT-19 | Arsipkan barang pada perjalanan lama | Riwayat tetap terbaca; pilihan baru memberi warning bila perlu |
| AT-20 | Ekspor dan restore ke dataset kosong | Semua entitas dan asset sumber cocok; reminder diatur ulang |
| AT-21 | ZIP rusak, path traversal, checksum berbeda | Impor ditolak; data aktif tidak berubah |
| AT-22 | Tutup proses saat restore | Startup memulihkan dataset konsisten melalui journal |
| AT-23 | Upgrade schema database dengan data lama | Barang, foto, tiket, dan relasi tetap tersedia |
| AT-24 | Storage penuh/copy file gagal | Pesan jelas; tidak ada referensi asset setengah jadi |
| AT-25 | Lebar 360 dp, font scale 1.5, teks panjang | Informasi utama terbaca dan tindakan dapat disentuh |
| AT-26 | Semua alur utama dalam mode pesawat | Tidak ada spinner akibat menunggu jaringan |

Uji unit difokuskan pada quantity, progres, overlap tanggal, snapshot checkpoint, konversi zona, dan validasi backup. Widget test digunakan untuk interaksi penting seperti packing parsial dan error state. Integration test mencakup persistensi, perjalanan, lampiran, serta ekspor/restore. Pengiriman notifikasi, picker Android, reboot, dan pembaruan APK perlu validasi pada emulator/perangkat yang mendukung, dengan catatan keterbatasan jelas.

## 17. Definition of Done versi 1.0

- Semua ID kebutuhan wajib memiliki status selesai atau blocker yang membuat rilis belum siap.
- Inventaris, isi kotak, perjalanan, dan packing benar-benar memakai data lokal persisten.
- Kotak/lokasi asal tidak disamakan dengan tas bawaan.
- Packing antarperjalanan independen dan jumlah tidak melanggar aturan.
- Satu/multi-kota, tujuan berulang, dan perjalanan berdekatan berjalan.
- Foto dan lampiran tersimpan offline dan tidak bergantung pada file sementara.
- Jadwal memiliki tanggal/jam/zona yang benar dan status izin pengingat jujur.
- Checklist pulang tidak menyembunyikan barang yang belum terkonfirmasi.
- Backup lengkap berhasil dipulihkan; impor gagal tidak merusak data aktif.
- Migrasi dan update APK mempertahankan data.
- UI lolos pemeriksaan layar kecil, teks besar, kontras, dan back navigation.
- Tidak ada backend, login, analytics, atau izin storage luas yang tidak diperlukan.
- Tidak ada tombol palsu, placeholder fitur yang dianggap selesai, atau hasil uji yang dikarang.
- APK release dan panduan tersedia jika lingkungan build/signing memungkinkan; jika tidak, status rilis tetap belum selesai.

## 18. Risiko dan keputusan praktis

| Risiko | Penanganan |
| --- | --- |
| UI terlihat generik karena terlalu banyak kartu/dekorasi | Gunakan daftar fungsional, hierarchy kuat, foto nyata, dan design tokens konsisten |
| Pengguna mengira lokasi otomatis aktual | Label “Asal” dan konteks perjalanan; pembaruan lokasi manual |
| Banyak perjalanan mengacaukan status barang | Status dan jumlah aktual tersimpan pada TripItem |
| AI menambah kompleksitas untuk mengejar kelengkapan | Cakupan fase tegas dan fitur tambahan dipisahkan dari versi 1.0 |
| Notifikasi dibatasi Android/perangkat | Izin kontekstual, status tepat/perkiraan, reschedule, dan uji perangkat |
| File sementara hilang | Salin ke app-private storage sebelum dianggap berhasil |
| Backup kehilangan foto/tiket | Manifest semua asset, checksum, dan acceptance test restore lengkap |
| Restore terputus | Staging, journal, dan rollback database + filesystem |
| Update APK gagal atau kehilangan data | Application ID dan signing key stabil, migrasi teruji |
| Pengguna mengandalkan data sebelum backup stabil | Jangan menyebut versi siap dipakai harian sebelum uji restore selesai |

## 19. Referensi teknis untuk AI pelaksana

Dokumentasi berikut diperiksa pada 10 Oktober 2026. Gunakan kembali dokumentasi resmi versi toolchain/paket yang dipilih ketika implementasi, karena konfigurasi dapat berubah. Keputusan Riverpod, routing, struktur fitur, batas file, serta token UI merupakan rekomendasi proyek ini.

| Sumber primer | Relevansi |
| --- | --- |
| [Flutter: Guide to app architecture](https://docs.flutter.dev/app-architecture/guide) | Pemisahan tanggung jawab UI dan data, disesuaikan ukuran proyek |
| [Flutter: Persistent storage architecture, SQL](https://docs.flutter.dev/app-architecture/design-patterns/sql) | Data kompleks persisten pada perangkat |
| [Drift package](https://pub.dev/packages/drift) | Kandidat lapisan SQLite Flutter/Dart |
| [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) | Setup plugin, scheduled notifications, receiver, dan lifecycle |
| [Android: Schedule alarms](https://developer.android.com/develop/background-work/services/alarms) | Exact/inexact alarm, akses alarm, dan reboot |
| [Android: Notification runtime permission](https://developer.android.com/develop/ui/compose/notifications/notification-permission) | Izin POST_NOTIFICATIONS pada Android 13+ |
| [Android: Back up user data with Auto Backup](https://developer.android.com/identity/data/autobackup) | Pengaturan backup OS dan perbedaan cloud/device transfer |

## 20. Langkah awal yang disarankan

Serahkan PRD ini ke AI coding dan minta Fase 0 terlebih dahulu. Setelah keputusan teknis selesai, jalankan Fase 1 untuk menetapkan tampilan yang sesuai referensi. Lanjutkan satu fase per pekerjaan, dengan catatan kemajuan dan hasil validasi yang dapat diperiksa. Jangan menjadikan banyaknya fitur dalam satu respons AI sebagai tanda aplikasi sudah siap.
