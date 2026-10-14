# Rencana Perbaikan dan Peningkatan Aplikasi Siapkan Tas

Dokumen kerja untuk AI pengembang Flutter

| Informasi | Keterangan |
| --- | --- |
| Sumber analisis | `AI_DOCUMENTATION.md` yang diberikan pengguna |
| Tanggal penyusunan | 14 Oktober 2026 |
| Produk | Siapkan Tas, aplikasi Android untuk inventaris dan packing barang pribadi |
| Tujuan pembaruan | Mengurangi barang tertinggal dan membuat catatan keberadaan barang lebih mudah dipercaya tanpa membongkar tas |
| Cakupan penilaian | Analisis dokumentasi produk dan teknis; belum memeriksa repositori, APK, screenshot, atau perilaku aplikasi secara langsung |
| Bentuk hasil | Rekomendasi, aturan domain, spesifikasi interaksi, rancangan data, prioritas, skenario pengujian, dan instruksi implementasi |

## 1. Kesimpulan utama

Siapkan Tas sudah memiliki fondasi yang sesuai: inventaris, tempat simpan asal, perjalanan, jumlah rencana, packing bertahap, tas opsional, agenda offline, checklist pulang, template, dan backup. Pembaruan paling bernilai adalah memperkuat hubungan antara **catatan aplikasi dan tindakan fisik pengguna**.

Saat ini dokumentasi belum menjelaskan secara cukup rinci apa yang terjadi ketika barang yang sudah dicentang dikeluarkan untuk dipakai, dipindahkan ke tas lain, dibagi ke beberapa tas, dibeli selama perjalanan, atau hilang sebelum checkpoint berikutnya. Ini adalah celah spesifikasi yang perlu diperiksa di kode, bukan bukti bahwa implementasinya pasti salah.

Contoh sasaran hasil:

> Pengguna mencari “charger” dan melihat: “Direncanakan 1; sudah disiapkan 1; terakhir dicatat di Ransel Hitam → Kantong depan; dikonfirmasi hari ini 07.10.” Setelah charger dikeluarkan untuk digunakan, pengguna memilih “Sedang dipakai”. Aplikasi menandainya perlu dimasukkan kembali sebelum berangkat.

Informasi tersebut tetap merupakan catatan pengguna. Tanpa sensor, aplikasi tidak dapat memastikan bahwa barang benar-benar masih berada di tas. Foto, QR, dan waktu konfirmasi membantu pengguna memeriksa catatan; semuanya tidak membuktikan keberadaan barang secara otomatis.

Urutan pengembangan: perkuat integritas packing dan pemeriksaan keberangkatan, perbaiki lokasi barang dan checkpoint, lalu tambahkan kemudahan input. Jangan mendahulukan OCR, integrasi cloud, atau fitur dekoratif.

## 2. Cara membaca dan menggunakan dokumen ini

### 2.1 Kategori temuan

| Kategori | Arti | Tindakan AI pengembang |
| --- | --- | --- |
| Sudah terdokumentasi | Fitur disebut di dokumen sumber | Cari implementasi dan uji perilakunya; jangan membuat fitur yang sama dua kali |
| Perlu diperjelas | Aturan atau kasus batas belum dijelaskan | Tentukan kontrak perilaku, lalu sesuaikan kode jika perlu |
| Peningkatan baru | Kemampuan tambahan yang tidak terlihat di sumber | Implementasikan bertahap sesuai prioritas |
| Perlu verifikasi teknis | Klaim hanya dapat dibuktikan lewat kode atau perangkat | Laporkan bukti pemeriksaan dan hasil pengujian |

### 2.2 Prioritas

| Prioritas | Makna |
| --- | --- |
| P0 | Risiko salah menyatakan barang siap, merusak riwayat, kehilangan data, atau menghalangi alur inti. Selesaikan sebelum memperluas fitur |
| P1 | Peningkatan yang langsung memudahkan packing, pencarian, atau perjalanan berulang |
| P2 | Tambahan opsional setelah alur inti stabil |

Setiap bagian harus diterjemahkan menjadi tugas kecil dengan bukti selesai. P0 bukan perintah untuk menulis ulang seluruh aplikasi sekaligus.

## 3. Hal yang harus dipertahankan

1. Android dan Flutter tetap menjadi platform utama. Ikuti versi SDK serta dependency yang benar-benar digunakan repositori; jangan menaikkan semua versi hanya karena dokumentasi menyebut versi minimum.
2. Pemakaian pribadi, tanpa akun dan tanpa backend. Semua fungsi inti harus berjalan offline.
3. Drift/SQLite, Riverpod, dan GoRouter tetap dipakai bila implementasi yang ada layak. Tambahkan use case atau service pada batas tanggung jawab yang jelas.
4. Tempat simpan rumah berbeda dari tas perjalanan. Kotak rumah tidak otomatis dibawa.
5. Memilih barang ke daftar perjalanan hanya membuat rencana. Konfirmasi fisik diperlukan untuk mencatat packing.
6. Packing tidak otomatis mengurangi jumlah inventaris. Konsumsi, kehilangan, atau barang yang ditinggal boleh menghasilkan usulan penyesuaian stok, tetapi perubahan inventaris memerlukan tindakan eksplisit pengguna.
7. Tas tetap opsional. Barang dapat disiapkan tanpa mencatat nama tas.
8. Perjalanan memiliki rencana dan status sendiri. Perubahan packing satu perjalanan tidak mengubah packing perjalanan lain.
9. Snapshot perjalanan dan checkpoint lama harus tetap terbaca setelah barang master diedit atau diarsipkan.
10. Pertahankan identitas visual terang dan aksen oranye yang tercantum di sumber. Pembaruan ini tidak mengharuskan perubahan warna merek.

## 4. Audit dokumentasi saat ini

| Area dan rujukan sumber | Penilaian | Perbaikan yang disarankan | Prioritas |
| --- | --- | --- | --- |
| Packing dan rencana, §2, PCK-04/05 | Pemisahan sudah tepat; belum ada aturan pembatalan packing, barang dipakai, dan perubahan jumlah | Perjelas transisi, catat perubahan, invalidasi pemeriksaan terkait | P0 |
| Lokasi asal dan `bagId`, §6.1 | Satu barang perjalanan memiliki satu referensi tas | Alokasi jumlah per tas dan kantong, dengan fallback tanpa lokasi | P1 |
| Checklist sebelum berangkat, PCK-12 | Sudah disebut; syarat “siap” belum rinci | Ringkasan hambatan, barang penting, pemeriksaan versi terbaru | P0 |
| Snapshot checklist pulang, §3.5, RET-02 | Snapshot dari `packed_quantity` saja berpotensi kurang untuk perjalanan panjang | Manifest keberangkatan dan saldo barang antar-checkpoint | P0 |
| Checkpoint antar-kota, RET-01 | Sudah disebut; pengaruh konsumsi dan barang baru belum dijelaskan | Baseline per tahap, kuantitas hilang, penutupan belum lengkap | P0 |
| Konflik, §2.1, PCK-09 | Overlap sudah didefinisikan; tanggal akhir kosong dan tiga perjalanan belum diatur | Permintaan maksimum pada waktu yang sama, hasil “belum pasti” | P0 |
| Tab Tas, §4.3 | Inventaris rumah dan packing bercampur dalam satu tab | Mode eksplisit Inventaris/Bawaan dan konteks perjalanan konsisten | P1 |
| Tambah barang, §3.1 | Label “Masukkan ke Tas Perjalanan” bisa menyiratkan barang sudah dikemas | Ganti menjadi “Tambahkan ke daftar bawaan”; packing tetap tindakan terpisah | P0 |
| Hapus langsung, §4.3 | Berpotensi membuat catatan barang hilang dari daftar tanpa sengaja | Hapus dari rencana, undo, dan aturan untuk barang yang sudah dibawa | P0 |
| Snackbar 1,5 detik, §4.1 | Cocok untuk informasi kecil; terlalu pendek untuk undo | Pisahkan informasi singkat dari aksi pemulihan | P1 |
| Overflow dan padding 80, §9 | Solusi umum belum menjamin nama terbaca dan tombol aman pada semua inset | Tata letak adaptif, SafeArea, keyboard, dan area aksi yang terukur | P0 |
| Alarm, SCH-09/11 | Presisi dan rekonsiliasi sudah disebut | Status izin, fallback, kegagalan, dan pengujian perangkat nyata | P0 |
| Backup, BAK-01/05 | Backup penuh dan rollback sudah disebut | Snapshot SQLite konsisten, aset ikut konsisten, restore tahan crash | P0 |
| “Privasi mutlak”, §7 | Offline membantu privasi; klaim absolut terlalu luas | Audit izin, Android Auto Backup, dependency, dan ekspor data | P0 |
| Clean Architecture, identitas vs §6.2 | Struktur contoh masih memusatkan repository dalam `data/` | Audit dependensi nyata; refactor terbatas pada kebutuhan perubahan | P1 |
| Ukuran APK 20–22 MB, §7 | Merupakan klaim yang perlu diukur pada build tertentu | Catat ABI, mode release, versi build, dan ukuran aktual | P2 |

## 5. Model domain yang perlu diperjelas

### 5.1 Pisahkan lima jenis informasi

| Informasi | Contoh | Aturan |
| --- | --- | --- |
| Inventaris | Memiliki dua charger | Jumlah kepemilikan yang diedit eksplisit |
| Lokasi asal | Kotak Elektronik, rak bawah | Referensi lokasi rumah; bukan posisi barang saat bepergian |
| Rencana | Membawa satu charger ke Bandung | Tidak menyatakan barang sudah disiapkan |
| Catatan fisik terbaru | Satu charger terakhir dicatat di ransel | Dibuat setelah tindakan pengguna; waktu dan sumber konfirmasi jelas |
| Pemeriksaan | Charger dikonfirmasi sebelum berangkat pukul 07.10 | Berlaku terhadap versi data tertentu; bisa perlu diulang setelah perubahan |

Lokasi asal dapat tetap “Kotak Elektronik” walaupun barang sedang dibawa. Detail barang harus menjelaskan kedua konteks, bukan menimpa lokasi asal dengan nama tas.

### 5.2 Aturan kuantitas pada tahap persiapan

Untuk keputusan `Dibawa`:

```text
plannedQuantity >= 1
0 <= packedQuantity <= plannedQuantity
sum(packedAllocations.quantity) == packedQuantity
remainingToPack = plannedQuantity - packedQuantity
```

Alokasi mencakup tas bernama, dibawa di badan, di tangan, dan lokasi belum dicatat. Tas yang tidak diisi tetap memiliki alokasi bertipe `unspecified`; jangan menggunakan kuantitas negatif atau tas palsu.

Untuk `Tidak Dibawa` dan `Belum Diputuskan`, kontribusi pada progres packing dan permintaan stok adalah nol. Rekomendasi penyimpanan: jumlah aktif rencana dan packing nol, sedangkan jumlah saran sebelumnya dapat disimpan terpisah bila dibutuhkan. Jika kode lama memakai jumlah minimum satu untuk semua keputusan, sesuaikan makna di repository dan migrasi; jangan mengubah data secara diam-diam.

Ketika pengguna mengubah keputusan barang yang sudah dikemas, aplikasi harus meminta pilihan untuk membatalkan catatan packing terkait. Setelah perjalanan dimulai, keputusan tersebut tidak boleh menghapus barang dari manifest historis.

### 5.3 Status dan label pengguna

| Kondisi | Label utama | Efek pada kesiapan |
| --- | --- | --- |
| Belum memilih keputusan | Belum diputuskan | Ditampilkan sebagai hal yang perlu ditinjau |
| Tidak ikut perjalanan | Tidak dibawa | Dikeluarkan dari penyebut packing |
| Rencana ada, packing nol | Belum disiapkan | Belum selesai |
| Packing sebagian | Disiapkan 2 dari 4 | Belum selesai |
| Semua unit disiapkan | Sudah disiapkan | Selesai packing; belum otomatis lulus pemeriksaan terbaru |
| Barang yang semula siap dikeluarkan untuk dipakai | Sedang dipakai | Jumlah yang dikeluarkan perlu disiapkan kembali |
| Jumlah cukup, belum mencatat tas | Sudah disiapkan · lokasi belum dicatat | Tidak menghalangi kesiapan karena tas opsional |
| Catatan berubah setelah diperiksa | Perlu cek ulang | Pemeriksaan terbaru tidak lagi berlaku |
| Barang tidak ditemukan dalam pemeriksaan | Belum ditemukan | Masalah terbuka; bukan “sengaja ditinggal” |

Status tersebut sebagian merupakan hasil perhitungan. Jangan menyimpan banyak boolean yang dapat saling bertentangan, misalnya `isReady=true` sementara jumlah belum cukup.

### 5.4 Progres harus dihitung secara jelas

```text
quantityProgress = totalPackedForCarriedItems / totalPlannedForCarriedItems
lineProgress = fullyPackedCarriedLines / totalCarriedLines
```

Gunakan progres jumlah sebagai bilah utama dan tampilkan jumlah jenis barang sebagai keterangan. Barang `Tidak Dibawa` dan `Belum Diputuskan` tidak masuk rumus. Jika penyebut nol, tampilkan “Belum ada daftar bawaan”, bukan 100% siap.

Kesiapan keberangkatan merupakan hasil pemeriksaan terpisah. Packing 100% tidak boleh menutupi barang penting yang sedang dipakai, konflik yang belum ditinjau, atau perubahan setelah pemeriksaan terakhir. Jika persen dibulatkan, jangan menampilkan 100% untuk nilai yang masih kurang dari lengkap; lebih aman tampilkan `9/10 unit`.

## 6. Spesifikasi perbaikan P0

### CORE-01 — Packing, pembatalan, dan catatan yang dapat dipercaya

**Masalah:** centang lama bisa terus tampil walaupun pengguna sudah mengeluarkan barang atau mengubah rencana.

**Kebutuhan:**

- Barang satu unit dapat dikonfirmasi dalam satu tap setelah tindakan fisik pengguna. Untuk jumlah banyak, tampilkan jumlah saat ini dan kontrol tambah/kurang pada bottom sheet ringkas.
- Sediakan aksi `Keluarkan`, `Sedang dipakai`, `Masukkan kembali`, dan `Pindahkan` sesuai fase perjalanan. Jangan menampilkan seluruh opsi pada setiap baris.
- Pada tahap persiapan, mengeluarkan satu unit mengurangi `packedQuantity` satu unit. Bila dicatat sedang dipakai, pertahankan daftar pengingat jumlah yang perlu dikembalikan.
- `Masukkan kembali` hanya mengembalikan jumlah yang dikonfirmasi pengguna; tidak boleh melewati rencana.
- Catat waktu perubahan dan konfirmasi fisik sebagai hal berbeda. Mengedit nama tidak boleh memperbarui waktu konfirmasi fisik.
- Gunakan istilah “Terakhir dikonfirmasi”, bukan “Pasti ada”. Catatan lama tanpa timestamp tampil sebagai “Waktu konfirmasi belum tersedia”.
- Perubahan tulis harus selesai ke database atau dikembalikan jika gagal. Pada UI optimistis, tampilkan kegagalan dan pulihkan keadaan; jangan meninggalkan centang palsu.
- Tap cepat tidak boleh menggandakan jumlah. Gunakan command yang serial per item atau transaksi dengan pemeriksaan revisi.

**Kriteria selesai:** pengguna mengemas charger, mengeluarkannya, menutup aplikasi, dan membukanya lagi. Charger masih ditandai perlu disiapkan kembali; histori menunjukkan tindakan yang dilakukan. Dua tap cepat tidak membuat jumlah melebihi rencana.

### CORE-02 — Pemeriksaan keberangkatan yang mengikuti perubahan

**Kebutuhan:**

- Buat satu layar `Cek sebelum berangkat` dengan kelompok: belum siap, sedang dipakai, barang penting, belum diputuskan, dan konflik yang perlu ditinjau.
- Tampilkan kebutuhan tindakan terlebih dahulu. Tombol utama mengarah ke barang bermasalah berikutnya.
- Konfirmasi penting boleh berupa satu tap per barang. Foto bersifat opsional dan bukan syarat penggunaan normal.
- Simpan pemeriksaan terhadap revisi packing/perjalanan yang relevan. Mengubah jumlah, keputusan, atau lokasi barang setelah pemeriksaan menandai barang tersebut perlu diperiksa kembali.
- Pertahankan pemeriksaan barang lain yang tidak berubah. Gunakan versi per item dan versi daftar bila memungkinkan.
- Kondisi normal lulus ketika semua barang yang diputuskan dibawa sudah disiapkan, barang penting telah dikonfirmasi untuk kondisi terkini, tidak ada barang sedang dipakai yang wajib kembali, dan masalah keputusan/konflik sudah ditinjau.
- Tetap boleh `Berangkat dengan catatan` untuk perjalanan nyata yang sudah harus dimulai. Tampilkan daftar masalah, minta konfirmasi eksplisit, simpan alasan atau catatan opsional, dan jangan memberi label “Semua siap”.
- Barang biasa yang belum memiliki nama tas tidak menjadi hambatan. Kejelasan lokasi dan kesiapan adalah dua ukuran berbeda.
- Perubahan waktu di perangkat tidak otomatis membuat barang tidak siap. Usia konfirmasi boleh ditampilkan sebagai informasi; invalidasi utama mengikuti perubahan data dan pemeriksaan baru.

**Kriteria selesai:** setelah pemeriksaan lulus, rencana kaus berubah dari dua menjadi tiga. Progres dan pemeriksaan berubah tanpa menandai barang lain sebagai belum diperiksa. Berangkat dengan satu barang kurang menyimpan pengecualian dan jumlah fisik yang benar.

### CORE-03 — Manifest keberangkatan dan riwayat yang stabil

**Masalah:** membuat checkpoint dari jumlah packing hidup pada saat pulang dapat kehilangan informasi barang yang benar-benar dibawa saat berangkat.

**Kebutuhan:**

- Saat perjalanan dimulai, simpan manifest fisik yang berisi barang dan jumlah yang dikonfirmasi benar-benar ikut berangkat. Sertakan nama, satuan, penanda penting, lokasi asal, serta alokasi tas sebagai snapshot yang relevan.
- Manifest dibangun dari jumlah aktual yang dikonfirmasi, bukan seluruh jumlah rencana. Barang yang belum disiapkan tetap terlihat sebagai kekurangan keberangkatan.
- Manifest bersifat historis. Pengeditan inventaris atau packing berikutnya tidak boleh menulis ulang manifest.
- Simpan koreksi manifest sebagai revisi/koreksi dengan alasan, tanpa menghilangkan versi lama. Jangan memakai “hapus baris” untuk barang yang sudah ikut perjalanan.
- Pisahkan `packedQuantity` untuk persiapan dari saldo barang selama perjalanan. Barang baru di perjalanan boleh membuat saldo lebih besar dari rencana lama tanpa melanggar batas persiapan.
- Item yang dibeli di perjalanan boleh memiliki identitas lokal perjalanan terlebih dahulu. Pengguna dapat memilih menambahkannya ke inventaris kemudian; jangan membuat stok rumah tanpa persetujuan.
- Perjalanan lama yang tidak memiliki manifest ditandai sebagai data lama. Tawarkan pembentukan baseline dari catatan yang masih tersedia dengan label sumber “Diambil dari catatan packing lama”. Jangan mengarang tanggal keberangkatan atau konfirmasi.

**Kriteria selesai:** setelah berangkat membawa tiga kaus, pengguna mengedit master menjadi “Kaus Hitam” atau mengarsipkannya. Manifest tetap menampilkan nama dan jumlah saat keberangkatan. Menghapus rencana live tidak menghapus barang dari pemeriksaan pulang.

### CORE-04 — Checkpoint antar-kota dan pulang yang tidak menghitung barang dua kali

**Kebutuhan:**

- Checkpoint dapat digunakan saat keluar hotel, berpindah kota, dan pulang. Hubungkan dengan destinasi bila ada; jangan mewajibkan destinasi.
- Pada rilis awal, batasi satu checkpoint aktif untuk satu tahap perjalanan. Checkpoint berikutnya mengambil baseline setelah tahap sebelumnya diselesaikan. Penyisipan checkpoint ke tahap historis memakai jalur koreksi/revisi, bukan mengubah urutan saldo diam-diam.
- Tentukan baseline tahap dari manifest keberangkatan atau checkpoint sebelumnya, ditambah barang yang diterima/dibeli setelahnya.
- Untuk checkpoint yang sedang dibuat, snapshot baseline dan jumlah yang harus dipertanggungjawabkan. Konsumsi, sengaja ditinggal, dan kehilangan yang sudah dicatat pada tahap tersebut mengisi hasil checkpoint, masing-masing satu kali.
- Pergerakan atau konsumsi setelah snapshot tidak mengubah jumlah snapshot diam-diam. Tawarkan penyegaran sebelum pemeriksaan dimulai, atau tambahkan koreksi yang terlihat. Checkpoint yang sudah ditutup tetap immutable.
- Konfirmasi per jumlah: `Dibawa lanjut/kembali`, `Habis dipakai`, `Sengaja ditinggal`, `Hilang dikonfirmasi`, dan `Belum ditemukan`.
- Label `Dibawa lanjut` digunakan untuk pindah kota, sedangkan `Dibawa kembali` untuk pulang.
- `Belum ditemukan` berarti ketidakpastian; jangan otomatis menganggapnya hilang atau sengaja ditinggal.
- Catatan wajib untuk kehilangan atau sengaja ditinggal dapat berupa alasan singkat, dengan waktu dan lokasi terakhir bila tersedia.
- Aplikasi boleh menutup checkpoint dengan kekurangan melalui konfirmasi eksplisit. Status hasil harus `Ditutup dengan masalah`, bukan `Lengkap`.
- Saldo untuk tahap berikutnya mencakup jumlah yang dikonfirmasi dibawa dan jumlah yang masih belum ditemukan. Jumlah belum ditemukan tetap membawa penanda masalah agar tidak hilang dari pencarian. Hanya penyelesaian eksplisit yang mengeluarkannya dari saldo.
- Jumlah habis, sengaja ditinggal, dan hilang yang sudah diselesaikan pada checkpoint lama tidak ditanyakan ulang pada checkpoint berikutnya.
- Jika stok rumah perlu disesuaikan setelah perjalanan, tampilkan pratinjau perubahan dan tombol eksplisit. Membuka atau menutup checkpoint tidak mengubah stok master.

**Rumus dalam satu snapshot checkpoint:**

```text
accounted = carriedConfirmed + consumed + intentionallyLeft + lostConfirmed
unconfirmed = expected - accounted
expected >= 0
semua jumlah hasil >= 0
accounted <= expected
nextStageBalance = carriedConfirmed + unconfirmed
```

`expected` adalah jumlah untuk tahap checkpoint tersebut, bukan stok inventaris dan bukan saldo semua perjalanan. Jangan mengurangi konsumsi saat membentuk `expected` lalu menghitung konsumsi yang sama lagi sebagai hasil. Event yang sudah dipakai checkpoint sebelumnya memiliki penanda baseline/relasi agar tidak dipakai lagi.

**Contoh wajib:** berangkat membawa empat botol minuman. Pada kota pertama, dua habis dan dua dibawa lanjut. Checkpoint pertama mencatat `expected=4`, `consumed=2`, `carried=2`. Kota berikutnya memeriksa dua botol. Pengguna membeli satu botol lagi sehingga pemeriksaan berikutnya menjadi tiga. Konsumsi dua botol pertama tidak muncul lagi sebagai kekurangan.

**Contoh barang hilang:** charger satu unit belum ditemukan. Checkpoint ditutup dengan masalah, saldo pencarian tetap satu. Jika ditemukan kemudian, pengguna menyelesaikan masalah dan mencatat lokasinya; total tidak bertambah menjadi dua. Jika kehilangan dikonfirmasi, saldo berikutnya nol, tetapi riwayat kehilangan tetap ada.

**Kriteria selesai:** kedua contoh berjalan setelah restart aplikasi, perubahan master, dan backup/restore. Satu unit tidak dapat sekaligus diberi dua hasil berbeda dalam snapshot yang sama.

### CORE-05 — Konflik jumlah dan perjalanan berdekatan

**Kebutuhan:**

- Hitung hanya keputusan `Dibawa` pada perjalanan Persiapan/Berlangsung yang relevan. Perjalanan selesai atau dibatalkan tidak menjadi pemesan stok baru.
- Untuk tanggal lengkap berbasis hari, definisikan interval inklusif. Perjalanan 14–16 dan 17–18 tidak overlap. Perjalanan yang sama-sama mencakup tanggal 16 berpotensi overlap. Jika memakai jam, definisikan batas interval secara eksplisit sesuai data nyata.
- Konflik terjadi saat jumlah kebutuhan pada **waktu yang sama** melebihi stok. Jangan menjumlahkan semua perjalanan yang masing-masing overlap sebagian dengan perjalanan panjang.
- Tanggal akhir kosong menghasilkan `Belum dapat memastikan ketersediaan`, bukan otomatis aman atau dianggap berlangsung selamanya sebagai konflik pasti.
- Tampilkan barang, stok, perjalanan terkait, tanggal benturan, dan kekurangan pada waktu tersebut. Ini peringatan untuk ditinjau, bukan perubahan packing otomatis.
- Saat stok master diturunkan di bawah rencana lama, simpan rencana dan tandai perlu ditinjau. Jangan memotong rencana atau kuantitas historis tanpa konfirmasi. Validasi stok ketat tetap berlaku saat membuat/menaikkan rencana baru.
- Barang pada perjalanan sebelumnya yang masih belum ditemukan boleh menghasilkan peringatan `Ketersediaan belum dikonfirmasi` walaupun tanggal tidak overlap.
- Barang yang telah dikonfirmasi hilang atau ditinggal juga perlu peringatan ketersediaan bila stok master belum disesuaikan. Tawarkan peninjauan stok; jangan menyatakan unit tersebut tersedia hanya karena angka master masih lama.
- Untuk perjalanan berurutan, sediakan catatan serah lanjut opsional: barang langsung dibawa ke perjalanan berikutnya atau perlu dikembalikan/disiapkan lagi. Ini berbeda dari konflik overlap.

**Kasus algoritma:** stok dua; A berlangsung tanggal 1–10 dengan kebutuhan satu, B tanggal 1–3 kebutuhan satu, C tanggal 8–10 kebutuhan satu. Permintaan maksimum dua; bukan konflik tiga. Jika ada D tanggal 2–9 kebutuhan satu, ada konflik pada tanggal 2–3 dan 8–9.

**Kriteria selesai:** uji dua, tiga, dan empat interval; tanggal akhir kosong; tanggal sama; perjalanan dibatalkan; stok diubah; serta barang belum ditemukan dari perjalanan sebelumnya.

### CORE-06 — Pengeditan dan penghapusan aman

**Kebutuhan:**

- Bedakan `Hapus dari daftar bawaan` dengan `Arsipkan barang inventaris`. Jangan gunakan satu tombol hapus untuk keduanya.
- Pada persiapan, penghapusan barang yang belum dikemas dapat memakai undo. Untuk barang yang sudah dikemas, jelaskan dampak dan minta konfirmasi pembatalan catatan packing.
- Saat perjalanan berlangsung, mengurangi rencana atau menghapus baris tidak menghapus saldo barang yang telah dibawa. Gunakan aksi perjalanan yang sesuai: dipindahkan, habis, ditinggal, hilang, atau koreksi.
- Pengurangan jumlah rencana di bawah jumlah terkemas memerlukan pilihan eksplisit mengenai unit berlebih. Tolak perubahan jika pengguna belum menentukan hasil; jangan melakukan clamp diam-diam.
- Mengarsipkan tempat simpan, tas, atau kategori tidak menghapus snapshot lama. Tas yang masih memiliki alokasi aktif harus dikosongkan/dipindahkan lebih dahulu atau tetap terlihat sebagai terarsip.
- Undo menyimpan perubahan yang tepat. Jika ada edit baru pada item yang sama, undo lama tidak boleh menimpa revisi baru; tawarkan pemulihan melalui detail.
- Undo untuk aksi yang membutuhkannya diberi waktu wajar, misalnya 5–8 detik, dan tetap mudah dijangkau. Pesan informasi biasa boleh lebih singkat. Jangan menerapkan 1,5 detik untuk semua pesan.

**Kriteria selesai:** salah hapus dapat dipulihkan; penghapusan tidak membuat barang yang sudah dibawa lenyap dari checkpoint; perubahan jumlah tidak memalsukan kondisi fisik.

### UX-01 — Area aman, teks terbaca, dan aksesibilitas

**Kebutuhan:**

- Terapkan area aman dengan `SafeArea`, `MediaQuery`, dan penempatan `Scaffold` yang sesuai. Padding tetap 80 bukan satu-satunya penanganan.
- Hitung ruang bottom bar, gesture inset, keyboard, FAB, dan tombol tetap tanpa menggandakan padding.
- Form dan bottom sheet dapat digulir sampai tombol terakhir saat keyboard terbuka.
- Pada daftar, nama boleh dua baris. Detail harus menampilkan nama dan lokasi lengkap; elipsis bukan pengganti akses ke informasi.
- Target sentuh utama minimal 48 dp. Ikon mendapat label semantics dan tooltip; status tidak hanya dibedakan melalui warna.
- Gunakan warna teks/tombol yang memenuhi kontras. Aksen oranye dan hijau lama perlu diukur sebelum dipakai sebagai latar teks putih.
- Pertahankan label pendek pada tindakan yang mudah ambigu, terutama `Kemas`, `Keluarkan`, dan `Cek`. Ikon lebih dominan boleh digunakan tanpa menghilangkan makna.
- Jangan menonaktifkan skala font pengguna untuk menyembunyikan overflow. Uji 360 dp, 1,5×, 2×, landscape, TalkBack, keyboard, dan navigasi gesture/3 tombol.
- Loading, error database, aset gagal, dan data kosong memiliki tampilan serta tindakan pemulihan yang jelas.

**Kriteria selesai:** packing dan pemeriksaan keberangkatan tetap dapat digunakan pada semua konfigurasi uji. Tidak ada tombol tertutup atau label penting yang hanya tersedia lewat warna.

### TECH-01 — Backup dan restore yang benar-benar konsisten

**Kebutuhan:**

- Verifikasi implementasi BAK yang sudah ada. Backup SQLite yang aktif harus menggunakan mekanisme snapshot yang konsisten, bukan menyalin file `.sqlite` saja saat masih ada write/WAL aktif.
- Gunakan fasilitas backup SQLite yang tersedia melalui binding proyek, `VACUUM INTO` bila didukung, atau penutupan koneksi terkoordinasi yang terbukti menghasilkan snapshot konsisten. Jangan memilih API yang tidak tersedia pada versi dependency.
- Database snapshot dan file aset harus konsisten satu sama lain. Lindungi aset yang dirujuk snapshot dari penghapusan sampai ekspor selesai; hentikan write singkat atau gunakan mekanisme pinning yang sederhana.
- Arsip mencakup manifest format, versi skema, versi aplikasi, waktu backup, jumlah entitas, daftar aset, ukuran, dan checksum. Thumbnail dapat dibuat ulang; foto dan tiket asli yang dirujuk tidak boleh tertinggal.
- Gunakan path aset relatif terhadap direktori aplikasi. Path absolut perangkat lama tidak boleh menjadi lokasi permanen setelah restore.
- Tolak arsip dengan path traversal, path absolut, symlink yang berbahaya, ukuran ekstraksi melebihi batas, atau format tidak dikenal. Ekstraksi hanya di direktori staging.
- Validasi checksum, ruang kosong, integritas database, foreign key, dan versi sebelum mengganti data aktif.
- Restore `Replace-All` tetap menjadi default. Tampilkan data yang akan diganti dan sediakan backup keadaan sekarang sebelum penggantian.
- Penggantian database dan direktori aset memerlukan protokol pemulihan tahan crash. Satu transaksi SQLite saja tidak mencakup operasi filesystem; gunakan staging, penanda status/journal, dan pemulihan saat startup.
- Tutup koneksi lama dengan benar dan jangan izinkan write ketika pergantian berlangsung. Alarm dijadwalkan ulang sesudah data baru aktif; kegagalan alarm dilaporkan sebagai masalah pengingat, bukan alasan memusnahkan hasil restore yang valid.
- Versi backup yang lebih baru dan tidak kompatibel ditolak dengan alasan yang mudah dipahami. Backup lama dimigrasi melalui jalur yang diuji.
- Jika pengguna membatalkan dialog SAF atau write gagal, backup tidak ditandai sukses. Catat keberhasilan setelah file tujuan selesai ditulis.

**Kriteria selesai:** backup/restore mempertahankan barang, foto, tiket, manifest, alokasi, dan checkpoint. Simulasikan write aktif, ruang habis, arsip rusak, serta crash pada beberapa tahap pergantian; data lama atau data baru dapat dipulihkan secara utuh.

### TECH-02 — Pengingat Android dengan status nyata

**Kebutuhan:**

- Izin notifikasi dan akses exact alarm adalah kemampuan berbeda. Simpan konfigurasi pengguna terpisah dari kemampuan perangkat saat ini.
- Periksa izin notifikasi dan kemampuan penjadwalan exact alarm sebelum menjanjikan pengingat presisi. Jika tidak tersedia, gunakan fallback yang sesuai dan tampilkan `Perkiraan` atau `Notifikasi belum diizinkan`.
- Minta izin saat pengguna mengaktifkan fitur terkait, bukan semua izin pada pembukaan pertama. Penolakan izin tidak menghalangi inventaris dan packing.
- Jadwal tersimpan tidak sama dengan alarm berhasil dijadwalkan. Catat hasil penjadwalan dan pesan gagal yang bisa diperbaiki.
- Gunakan identitas pengingat stabil. Edit jadwal membatalkan jadwal lama dan tidak membuat notifikasi ganda.
- Rekonsiliasi pada reboot, aplikasi dibuka, pemulihan backup, dan perubahan kemampuan yang relevan. Pengingat yang sudah lewat tidak boleh semuanya ditembakkan sekaligus; tentukan aturan, misalnya masuk ringkasan terlewat.
- Notifikasi membuka perjalanan/checkpoint yang benar. Bila target dihapus atau dibatalkan, tampilkan fallback yang ramah.
- Untuk agenda tanpa jam, pengingat memerlukan jam pilihan pengguna. Jangan menyimpan agenda sebagai 00.00 hanya agar bisa membuat alarm.
- Tambahkan pengingat lokal menjelang berangkat, barang yang masih dipakai, dan sebelum checkout/pindah kota. Jadwalkan hanya yang diaktifkan pengguna.
- Uji pada perangkat nyata untuk background, reboot, battery saver, izin dicabut, dan aplikasi dihentikan paksa. Laporkan batas yang ditemukan; jangan menjanjikan alarm selalu berbunyi dalam semua kondisi.

**Landasan platform:** Android membedakan exact/inexact alarm dan mensyaratkan pemeriksaan akses exact alarm pada skenario terkait. Android 13+ memiliki izin runtime notifikasi. Dokumentasi resmi ditautkan di bagian 15.

**Kriteria selesai:** menolak kedua izin tetap memungkinkan packing; pengingat menampilkan status yang benar; edit dan restore tidak menggandakan alarm. Hasil uji mencantumkan Android dan model perangkat.

### TECH-03 — Klaim offline dan privasi yang dapat dibuktikan

**Kebutuhan:**

- Audit manifest release hasil merge dan seluruh dependency untuk izin/jalur network yang tidak dibutuhkan. Tidak menambahkan analytics, iklan, atau layanan remote pada pembaruan ini.
- Audit Android Auto Backup. Default platform dapat mencakup data aplikasi; konfigurasi `allowBackup` saja tidak boleh dianggap bukti bahwa semua bentuk transfer pada semua perangkat sudah dihentikan.
- Karena produk menyatakan tanpa cloud, konfigurasi aturan backup/extraction lintas versi Android harus mengecualikan data sensitif dari backup cloud sistem. Tentukan aturan device transfer secara eksplisit dan uji sesuai perangkat yang tersedia.
- Backup manual melalui SAF tetap boleh. Tujuan yang dipilih pengguna bisa disediakan penyedia penyimpanan lain; aplikasi tidak boleh mengklaim file ekspor selalu lokal di luar kendalinya.
- Kamera/galeri diminta ketika digunakan. Penyimpanan memakai akses yang paling terbatas untuk fungsi tersebut; jangan menambahkan akses semua file hanya untuk impor/ekspor.
- File tiket dan foto disalin ke area internal aplikasi; sharing keluar hanya setelah aksi pengguna.
- Log diagnostik tidak memuat nomor booking, nama file tiket pribadi, isi catatan, atau foto. Pesan error pengguna tetap cukup jelas untuk ditindaklanjuti.
- Ubah copy “Privasi mutlak/bebas kebocoran” menjadi pernyataan faktual: “Data disimpan di perangkat; aplikasi tidak mengirim data ke server.” Gunakan hanya setelah audit mendukung klaim.
- Kunci biometrik/PIN dapat dipertimbangkan P2. Kunci layar aplikasi sendiri bukan klaim enkripsi database atau backup.

**Kriteria selesai:** daftar izin dan dependency yang relevan terdokumentasi; aplikasi tetap bekerja dalam mode pesawat; aturan backup cloud diuji/diperiksa; tidak ada data pribadi dalam log release.

## 7. Peningkatan P1 yang langsung berguna

### LOC-01 — Tas, kantong, dan pembagian jumlah barang

**Tujuan:** menjawab “barang ada di tas mana dan bagian mana?”

- Tambahkan kompartemen sederhana di dalam tas: kantong depan, ruang utama, organizer kabel. Nama bebas dan opsional.
- Satu item perjalanan dapat dialokasikan ke beberapa tujuan. Contoh: empat kaus, dua di Koper Kabin dan dua di Ransel.
- Tujuan alokasi: `bag`, `on_person`, `in_hand`, `unspecified`. Kompartemen hanya valid bila tujuan tas.
- Saat packing sebagian, alokasikan hanya jumlah yang benar-benar dikemas. Rencana lokasi boleh ada sebagai preferensi terpisah dan tidak dihitung sebagai packing.
- Pindah satu unit antartas dilakukan dalam satu transaksi tanpa mengubah jumlah total.
- Detail tas menampilkan jumlah jenis, jumlah unit, isi per kompartemen, barang penting, dan waktu pencatatan yang tersedia.
- Di fase perjalanan, tampilan lokasi bersumber dari catatan fisik terbaru; snapshot keberangkatan tetap tersedia di riwayat.
- Jika beberapa unit berada di beberapa lokasi, tampilkan ringkasan dan detail jumlah; jangan tampilkan satu lokasi seolah mencakup semua unit.
- Memilih kompartemen tidak wajib untuk menyelesaikan packing. Saat lokasi tidak dicatat, tampilkan keterbatasannya secara ringan.

**Kriteria selesai:** lima kaus dapat dibagi 3+2; pindah satu menghasilkan 2+3; menghapus tas aktif meminta penyelesaian alokasi; pencarian menampilkan kedua lokasi.

### FIND-01 — Pencarian barang dari satu tempat

- Sediakan pencarian barang di Beranda dan pada daftar Bawaan. Hasil membedakan `Inventaris rumah`, `Perjalanan dipilih`, dan `Perjalanan lain`.
- Untuk perjalanan yang dipilih, tampilkan nama, jumlah, status, lokasi terakhir, dan waktu konfirmasi. Nama perjalanan selalu terlihat jika hasil lintas perjalanan.
- Pencarian mengenali nama, kategori, nama tempat simpan, nama tas, kompartemen, dan alias yang dicatat pengguna.
- Normalisasi huruf dan spasi; alias sederhana seperti charger/adaptor boleh ditambahkan manual. Hindari asumsi NLP atau AI online.
- Tombol pada hasil: `Lihat letak`, `Buka detail`, atau `Siapkan`, sesuai konteks. Mencari barang tidak mengubah status.
- Filter dan hasil tidak boleh berpindah ke perjalanan lain tanpa tindakan pengguna. Perjalanan terakhir dipilih dapat dipulihkan setelah restart.

**Kriteria selesai:** mencari charger membutuhkan satu akses pencarian dan menampilkan lokasi relevan tanpa membuka beberapa kotak/tas. Hasil rumah tidak dianggap barang sudah masuk tas.

### UX-02 — Navigasi dan hierarki halaman yang lebih jelas

Pertahankan empat tab untuk menghindari migrasi navigasi besar. Rekomendasi label:

| Tab | Isi utama | Aksi utama |
| --- | --- | --- |
| Beranda | Perjalanan dipilih, tugas yang belum selesai, agenda terdekat | Lanjut siapkan / Cek sebelum berangkat |
| Barang | Mode Bawaan dan Inventaris, dengan tempat simpan dan tas pada konteks yang tepat | Tambah bawaan / Tambah barang |
| Perjalanan | Daftar perjalanan, destinasi, tahap, template | Buat perjalanan |
| Agenda | Kegiatan, tiket, pengingat lokal | Tambah agenda |

Jika label `Tas` tetap dipertahankan, tampilkan mode `Bawaan perjalanan` dan `Inventaris rumah` secara jelas. Route lama `/inventory` tidak perlu diubah hanya demi label.

**Detail kebutuhan:**

- Header Bawaan menampilkan nama perjalanan, tanggal, fase, dan pemilih perjalanan. Status “Belum ada perjalanan dipilih” memiliki aksi jelas.
- Jangan mengganti perjalanan aktif hanya berdasarkan tanggal ketika pengguna sedang bekerja. Istilah “dipilih” berbeda dari “berlangsung”.
- Beranda menampilkan pekerjaan nyata: dua barang belum siap, satu barang sedang dipakai, satu pemeriksaan perlu diulang. Statistik total inventaris menjadi informasi sekunder.
- Detail perjalanan memiliki akses cepat `Bawaan`, `Tas`, `Checkpoint`, dan `Agenda`. Tanggal/destinasi tidak perlu mendominasi layar packing.
- Simpan scroll dan filter saat berpindah tab. Kembali dari detail mengembalikan posisi sebelumnya.
- Kartu barang: thumbnail opsional, nama, jumlah `1/2`, lokasi asal atau lokasi perjalanan sesuai konteks, label penting, dan satu aksi utama. Opsi jarang berada di menu tambahan.
- Jangan menaruh ikon hapus sejajar dan terlalu dekat dengan centang. Hindari chart atau kartu dekoratif yang menggantikan daftar pekerjaan.
- Agenda dan tiket tetap tersedia, tetapi packing mendapat akses tercepat karena merupakan tujuan utama produk.

**Kriteria selesai:** pengguna dapat membedakan inventaris rumah dari bawaan perjalanan tanpa membuka pengaturan. Perjalanan terpilih konsisten pada Beranda, Bawaan, dan pemeriksaan.

### PACK-01 — Barang yang dipakai sampai terakhir dan mode packing fokus

- Tambahkan penanda `Disiapkan terakhir` untuk HP, charger yang masih dipakai, sikat gigi, atau barang sejenis. Penanda ini tidak berarti sudah disiapkan.
- Berikan kelompok khusus dan pengingat waktu opsional. Saat waktu tiba, notifikasi membuka daftar barang tersebut.
- Mode fokus menampilkan barang yang belum selesai dan lokasi asalnya, serta jumlah tersisa. Urutan boleh berdasarkan tempat simpan untuk mengurangi bolak-balik.
- Saat baris selesai hilang dari filter, pertahankan posisi scroll dan sediakan undo yang mudah. Pengguna tidak boleh kehilangan kendali karena daftar terus melompat.
- Quick action per unit tetap dapat dibatalkan. `Tandai semua sudah siap` tidak menjadi aksi utama; pemeriksaan barang penting harus tetap terpisah.
- Haptic singkat bersifat opsional. Tidak ada dialog konfirmasi untuk setiap centang biasa.

**Kriteria selesai:** charger dapat tetap berada dalam kelompok “Terakhir” sampai benar-benar dimasukkan; tidak dianggap selesai hanya karena jadwal keberangkatan sudah dekat.

### INPUT-01 — Tambah barang tanpa terlalu banyak pekerjaan

- Form awal hanya meminta nama. Jumlah default satu, foto opsional, kategori dan lokasi dapat diisi kemudian.
- Pada konteks perjalanan, sediakan `Tambah ke daftar bawaan` dengan pilihan menggunakan inventaris atau membuat barang khusus perjalanan. Packing tetap nol setelah penambahan rencana.
- Master baru dibuat hanya bila pengguna memilih menyimpan ke inventaris. Untuk barang khusus perjalanan, jelaskan bahwa data hanya dipakai pada perjalanan itu.
- Multi-select dari inventaris memperbolehkan edit jumlah dan pratinjau sebelum menambah. Merge item yang sama di perjalanan mengikuti kebijakan jelas; jangan menggandakan baris tanpa alasan.
- Sediakan duplikasi barang untuk varian, dengan status packing tidak ikut tersalin.
- Deteksi nama serupa berupa saran, bukan larangan. Pengguna boleh memiliki dua barang bernama sama dengan varian atau tempat simpan berbeda.
- Simpan draft form secara lokal bila proses input panjang. Pembatalan memberi pilihan ketika draft sudah berisi data bermakna.
- Label “Masukkan ke Tas Perjalanan” diganti menjadi “Tambahkan ke daftar bawaan”.

**Kriteria selesai:** barang bisa ditambahkan tanpa foto/kategori/lokasi. Tambah dari form atau template tidak mengubah packing menjadi siap.

### TPL-01 — Template yang tidak membuat inventaris palsu

Template sudah ada di sumber. Peningkatan berfokus pada pemetaan dan penerapan yang aman.

- Pengguna dapat menyimpan daftar bawaan menjadi template, memilih item mana yang ikut, dan menghapus tanggal/status fisik.
- Template personal dapat merujuk barang master. Template bawaan seperti “Liburan singkat” harus berisi saran kebutuhan, bukan `itemId` yang tidak ada di perangkat.
- Sebelum penerapan, tampilkan item cocok, item belum ada, stok kurang, dan item terarsip.
- Untuk saran yang belum cocok, pengguna memilih barang yang dimiliki, membuat barang khusus perjalanan, atau melewatinya. Jangan otomatis menambah stok yang belum dimiliki.
- Terapkan secara idempotent sesuai identitas template line yang dipetakan: penggunaan ulang memberi pilihan tambahkan yang belum ada, sesuaikan jumlah, atau batal. Tidak menggandakan barang diam-diam.
- Duplikasi perjalanan menyalin rencana serta destinasi yang dipilih pengguna, tetapi mereset packing, pemeriksaan, manifest, checkpoint, dan timestamp konfirmasi.
- Agenda/tiket/alarm tidak disalin otomatis dengan tanggal lama. Bila pengguna memilih ikut menyalin, tampilkan pratinjau tanggal baru dan minta konfirmasi penjadwalan.

**Kriteria selesai:** template dua kali tidak menambah stok palsu atau menggandakan packing; perjalanan hasil duplikasi tidak tampil siap sebelum dikemas ulang.

### INV-01 — Stok nol dan pemeliharaan inventaris

- Dokumen lama mewajibkan stok minimal satu. Tambahkan dukungan stok nol secara eksplisit untuk barang habis atau hilang tanpa menghapus riwayat.
- Barang stok nol tetap dapat dilihat dan diisi ulang, tetapi tidak dapat dipilih sebagai bawaan baru dengan jumlah positif tanpa pembaruan stok.
- Tawarkan penyesuaian stok setelah checkpoint sebagai pratinjau. Pengguna boleh melewatinya; catatan perjalanan tetap selesai menurut hasil pemeriksaan.
- Pisahkan `Arsip` dari `Stok nol`. Keduanya memiliki makna berbeda.
- Lokasi rumah yang berpindah diperbarui melalui tindakan pengguna. Jangan otomatis menyatakan semua barang kembali ke kotak asal ketika perjalanan selesai.
- Sediakan filter `Lokasi belum dicatat`, `Stok nol`, dan `Perlu ditinjau` sesuai kebutuhan.

**Kriteria selesai:** satu obat habis dapat membuat stok nol melalui persetujuan pengguna; perjalanan lama tetap menunjukkan obat yang pernah dibawa; template memberi peringatan stok habis.

### FILE-01 — Foto dan tiket yang tetap dapat digunakan offline

- Pertahankan hingga lima foto per barang sesuai sumber, tetapi tampilkan foto utama lebih dulu.
- Buat thumbnail lokal untuk daftar dan baca gambar besar sesuai kebutuhan. Foto tidak di-decode penuh untuk setiap baris.
- Salin file hasil picker ke penyimpanan internal sebelum menyatakan penambahan berhasil. Nama internal unik, path relatif, dan metadata jelas.
- Validasi file dengan tipe yang diizinkan dan kemampuan pembaca, bukan ekstensi saja. Batas 20 MB dari sumber diberi pesan yang jelas bila terlampaui.
- Aset yang masih dirujuk item, tiket, atau snapshot tidak boleh dihapus sebagai orphan. Cleanup menggunakan referensi nyata dan masa tenggang.
- Aset hilang menampilkan placeholder dan tombol ganti, tanpa membuat halaman crash.
- Detail tiket memiliki aksi buka, zoom, dan salin nomor booking. Dokumen diprioritaskan untuk dibuka dalam aplikasi secara offline bila library yang dipakai mendukung.
- Uji file dengan nama sama, foto besar, PDF rusak, lampiran dicabut dari galeri, dan backup/restore ke path baru.

**Kriteria selesai:** tiket tetap terbuka dalam mode pesawat setelah sumber aslinya dihapus; foto yang hilang tidak merusak daftar; aset snapshot tetap tersedia selama riwayat memerlukannya.

## 8. Tambahan P2 setelah alur inti stabil

Fitur berikut adalah pilihan, bukan kewajiban dalam rilis pertama pembaruan.

| ID | Fitur | Nilai bagi pengguna | Batas implementasi |
| --- | --- | --- | --- |
| OPT-01 | Foto referensi isi tas | Mengingat penataan tas dan kantong | Opsional; tidak menganalisis atau menjamin semua barang ada |
| OPT-02 | QR label tas/kotak | Membuka isi wadah langsung | QR hanya berisi ID lokal dan jenis wadah; pemindaian tidak menandai barang hadir |
| OPT-03 | Widget persiapan | Melihat jumlah barang belum siap dari layar utama | Dimulai dari ringkasan dan deep link; aksi tulis harus mengikuti aturan konfirmasi yang sama |
| OPT-04 | Ekspor daftar bawaan untuk dibaca | Menyimpan daftar teks/PDF untuk perjalanan | Bedakan ekspor ringkasan dari backup; berbagi hanya atas tindakan pengguna |
| OPT-05 | Berat bawaan | Memperkirakan berat tas | Berat unit manual dan opsional; tampilkan cakupan data yang terisi serta label perkiraan |
| OPT-06 | Perlengkapan berbentuk set | Mengingat pasangan kabel/adaptor atau perlengkapan mandi | Saran kelengkapan; tidak otomatis mencentang anggota set |
| OPT-07 | Inventaris per beberapa lokasi rumah | Menangani barang identik tersebar di dua kotak | Tambahkan alokasi stok per lokasi setelah model tas stabil; cegah penghitungan stok ganda |
| OPT-08 | Kunci aplikasi | Membatasi akses ringan ke tiket/catatan | Jelaskan batasnya; mekanisme pemulihan jangan membuat pengguna kehilangan data |
| OPT-09 | Backup terenkripsi | Melindungi file cadangan yang dibawa keluar aplikasi | Gunakan implementasi kriptografi yang teruji, format berversi, dan pengujian sandi salah; jangan merancang algoritma sendiri |
| OPT-10 | OCR tiket lokal | Mengurangi input nomor booking dan jadwal | Hanya setelah kelayakan offline, ukuran APK, bahasa, dan koreksi manual dinilai |

Jangan menambahkan kolaborasi online, GPS tracking, marketplace, chatbot online, login wajib, atau sinkronisasi cloud pada pekerjaan ini. Fitur tersebut mengubah scope produk dan tidak diperlukan untuk tujuan utama saat ini.

## 9. Rancangan data dan service yang disarankan

Rancangan berikut merupakan **model konseptual**, bukan perintah membuat semua tabel dengan nama ini. Cari tabel dan kolom yang sudah ada, petakan kesetaraannya, lalu ubah sesedikit mungkin. Dokumentasi sumber menunjukkan sebagian relasi dan menyebut 16 tabel, tetapi tidak menyajikan semua DDL, constraint, atau migrasi.

### 9.1 Entitas dan informasi tambahan

| Entitas konseptual | Informasi penting | Fungsi dan batas |
| --- | --- | --- |
| Item master | `quantity >= 0`, waktu edit, arsip | Stok kepemilikan; tidak otomatis berubah karena packing |
| Item perjalanan | Keputusan, jumlah rencana, jumlah persiapan, revisi, penting saat perjalanan, penanda disiapkan terakhir | Data rencana; master boleh nullable untuk barang khusus perjalanan dengan identitas tetap |
| Tas perjalanan | Identitas, relasi perjalanan, nama, arsip | Pertahankan tas per perjalanan seperti sumber; katalog tas reusable dapat ditambahkan nanti bila perlu |
| Kompartemen | Tas induk, nama, urutan | Satu tingkat sudah cukup untuk rilis awal |
| Alokasi fisik | Item perjalanan, jenis tujuan, tas/kompartemen opsional, jumlah, fase/konteks, waktu konfirmasi | Beberapa alokasi per item; bedakan alokasi persiapan dan keadaan selama perjalanan |
| Pemeriksaan keberangkatan | Perjalanan, status, waktu, revisi daftar, pengecualian | Pemeriksaan dapat perlu diulang; jangan menyimpan boolean global tanpa versi |
| Detail pemeriksaan | Item, revisi item yang diperiksa, hasil, waktu | Invalidasi hanya item yang terdampak bila memungkinkan |
| Manifest keberangkatan | Perjalanan, waktu aktual/label sumber, versi | Snapshot historis dan koreksi yang dapat ditelusuri |
| Item manifest | Identitas, snapshot nama/satuan/penting/lokasi, jumlah, referensi foto yang dipertahankan bila diperlukan | Tidak bergantung pada nama master terbaru agar riwayat terbaca |
| Perubahan barang selama perjalanan | Item, jenis tindakan, jumlah, waktu, asal/tujuan, checkpoint terkait, revisi/koreksi | Jejak untuk barang baru, konsumsi, dipindah, ditinggal, hilang, ditemukan; bukan kewajiban menerapkan event sourcing seluruh aplikasi |
| Checkpoint | Perjalanan, destinasi opsional, baseline sebelumnya, versi, status penutupan | Snapshot yang stabil dan urutan tahap jelas |
| Item checkpoint | Expected, dibawa, habis, ditinggal, hilang, masalah, snapshot identitas | Unconfirmed dihitung; hasil tidak melewati expected |
| Aset | Path relatif, MIME, ukuran, checksum, jenis asli/thumbnail, status | Referensi yang aman untuk offline dan backup |
| Pengingat | Target, preferensi presisi, waktu, identitas alarm, hasil penjadwalan | Izin/capability perangkat diperiksa ulang; bukan disimpulkan dari backup |

Untuk rilis awal, saldo perjalanan dapat berupa tabel/proyeksi keadaan terkini yang diperbarui bersama catatan perubahan dalam satu transaksi. Tidak perlu membangun ulang seluruh state dari event setiap kali halaman dibuka. Snapshot historis dan jejak perubahan tetap diperlukan untuk kasus yang berdampak pada pemeriksaan.

### 9.2 Constraint wajib

- ID dan foreign key valid. Referensi tas atau kompartemen harus berada pada perjalanan yang sama dengan item terkait.
- Jumlah integer non-negatif, satuan tetap konsisten dalam satu item. Dukungan pecahan bukan bagian scope awal.
- Alokasi aktif per fase menjumlah ke kuantitas fisik pada fase itu. Perpindahan tas tidak membuat atau menghilangkan unit.
- Identitas kompartemen berasal dari tas yang dipilih. Tujuan `on_person`, `in_hand`, dan `unspecified` tidak memiliki kompartemen.
- Baris inventaris yang sama pada satu perjalanan sebaiknya unik sesuai model yang ditemukan; jumlah lokasi ditangani pada alokasi, bukan duplikasi TripItems. Barang khusus perjalanan menggunakan identitas tersendiri.
- Snapshot lama tidak cascade-delete ketika master diarsipkan. Jika hard delete didukung, gunakan referensi nullable yang aman dan snapshot teks yang sudah lengkap.
- Satu hasil checkpoint tidak boleh melampaui expected. Jumlah belum ditemukan dihitung dari sisa dan tidak ditulis sebagai salinan yang mudah tidak sinkron.
- Catatan perubahan dapat ditandai sudah masuk baseline tertentu agar konsumsi/kehilangan tidak dihitung berulang.
- Koreksi terhadap perubahan lama tidak boleh membuat jumlah negatif. Jika memengaruhi checkpoint yang sudah tutup, tampilkan revisi historis yang jelas dan hitung ulang hanya melalui jalur koreksi resmi.
- `updatedAt` tidak sama dengan `lastPhysicallyConfirmedAt`. Timestamp migrasi tidak boleh dipresentasikan sebagai konfirmasi pengguna.
- Index ditambahkan mengikuti query: item per perjalanan, alokasi per item/tas, checkpoint per perjalanan, status/arsip, dan waktu agenda. Ukur query sebelum menambah index yang tidak diperlukan.

### 9.3 Batas service/use case

| Tanggung jawab | Operasi yang perlu ditangani |
| --- | --- |
| Packing | Ubah jumlah, batalkan, tandai sedang dipakai, masukkan kembali, alokasikan/pindahkan, invalidasi pemeriksaan |
| Kesiapan | Hitung progres, masalah terbuka, validitas pemeriksaan, hasil normal atau berangkat dengan catatan |
| Manifest dan saldo perjalanan | Mulai perjalanan, snapshot, barang baru, konsumsi, ditinggal, hilang/ditemukan, koreksi |
| Checkpoint | Buat baseline, freeze, konfirmasi hasil, tutup, bawa saldo/masalah ke tahap berikutnya |
| Konflik | Permintaan simultan, interval tidak lengkap, ketersediaan belum dikonfirmasi |
| Aset | Import, thumbnail, referensi, pinning backup, cleanup, resolve path relatif |
| Backup/restore | Snapshot konsisten, validasi arsip, staging, rollback/recovery, aktivasi data |
| Pengingat | Pemeriksaan kemampuan, schedule/cancel, rekonsiliasi idempotent, deep link |

Aturan domain tidak ditempatkan terpisah-pisah dalam handler tombol widget. Repository dan use case harus menjadi sumber kebenaran yang dapat diuji; Riverpod menyajikan perubahan state dan error secara konsisten.

## 10. Migrasi data tanpa kehilangan catatan lama

1. Audit `tables.dart`, `app_database.dart`, generated schema, versi migrasi, foreign key, dan sample database lama. Jangan menebak nomor schemaVersion dari dokumen.
2. Simpan backup uji sebelum perubahan dan pastikan jalur restore yang ada dapat digunakan. Jangan meminta pengguna uninstall untuk menyelesaikan migrasi.
3. Tambahkan kolom nullable atau default yang jujur terlebih dahulu. Field waktu konfirmasi lama tetap kosong bila datanya tidak tersedia.
4. Migrasi `bagId` lama menjadi satu alokasi untuk jumlah terkemas. Jika bagId kosong, alokasi `unspecified`. Jika jumlah terkemas nol, tidak ada alokasi fisik positif.
5. Pertahankan nilai dan relasi lama. Bila ada data tidak valid, buat laporan dan jalur koreksi; jangan mengubah jumlah aktual/historis tanpa jejak.
6. Perjalanan persiapan lama tidak dibuat seolah sudah memiliki manifest keberangkatan. Perjalanan berlangsung/selesai tanpa manifest memakai mode legacy dengan provenance yang jelas.
7. Checkpoint lama mempertahankan expected dan hasil asal. Penambahan kategori hilang tidak mengklasifikasi semua sisa sebagai hilang.
8. Master yang dulu wajib minimal satu dapat tetap memiliki nilai lama. Dukungan nol tidak perlu mengubah stok yang sudah ada.
9. Path aset lama diubah ke model relatif setelah file berhasil dipetakan. File gagal dipetakan ditandai missing, bukan dihapus dari data.
10. Naikkan schemaVersion sesuai perubahan yang benar-benar dibuat; sertakan migrasi maju dan pengujian dari versi lama yang didukung.
11. Regenerasi file Drift melalui perintah proyek. Jangan mengedit generated file manual untuk menyamarkan mismatch.
12. Jalankan uji integritas, jumlah baris, referensi aset, dan data perjalanan sebelum/sesudah. Setelah sukses, tulis dokumentasi migrasi serta batas versi backup.

**Jalur upgrade** dan **restore backup lama** perlu diuji terpisah. Keduanya dapat melewati migrasi yang sama, tetapi lifecycle koneksi dan file aset berbeda.

## 11. Urutan implementasi yang realistis

Perkiraan ukuran relatif menggunakan S/M/L, bukan janji durasi. Durasi nyata bergantung pada keadaan repositori.

| Urutan | Paket kerja | ID terkait | Dependensi | Ukuran relatif | Bukti hasil |
| --- | --- | --- | --- | --- | --- |
| 0 | Audit repositori dan alur inti | Semua | Tidak ada | S–M | Matriks fitur ada/belum, baseline test, peta data |
| 1 | Pengamanan operasi inti dan area aksi | CORE-01, CORE-06, UX-01 | Audit | M | Packing dan edit tidak memalsukan jumlah; tombol terjangkau |
| 2 | Cadangan konsisten dan pemulihan | TECH-01 | Audit | M–L | Bukti round-trip dan recovery sebelum migrasi domain besar |
| 3 | Model alokasi dan migrasi persiapan | LOC-01, §9–10 | 1–2 | M–L | Jumlah tersebar per tas tanpa kehilangan data lama |
| 4 | Kesiapan dan manifest keberangkatan | CORE-02/03 | 1, 3 | L | Pemeriksaan berversi dan manifest historis |
| 5 | Saldo perjalanan serta checkpoint bertahap | CORE-04 | 4 | L | Contoh konsumsi, barang baru, hilang/ditemukan lolos |
| 6 | Konflik dan stok nol | CORE-05, INV-01 | Model terbaru | M | Konflik simultan dan penyesuaian stok eksplisit |
| 7 | Pengingat serta audit offline | TECH-02/03 | Audit; 4–5 untuk pengingat checkpoint | M | Status izin dan audit manifest release |
| 8 | Navigasi, pencarian, dan packing fokus | UX-02, FIND-01, PACK-01 | 3–5 | M | Alur menemukan/menyiapkan barang lebih pendek |
| 9 | Input, template, dan aset | INPUT-01, TPL-01, FILE-01 | Model terbaru | M | Tidak ada packing/stok palsu saat tambah atau salin |
| 10 | Tambahan pilihan | OPT-01–10 | Semua P0 stabil | Sesuai fitur | Bukti manfaat dan pengujian offline |

Audit TECH-03 dilakukan sejak tahap 0; perbaikannya dapat berjalan sebelum tahap 7 jika ditemukan perilaku cloud yang bertentangan dengan scope. Bug backup atau kehilangan data yang sudah terbukti mengalahkan urutan fitur di tabel.

Untuk rilis kecil pertama, fokuskan CORE-01, CORE-06, UX-01, dan temuan backup/privasi yang terbukti. Untuk rilis inti berikutnya, tuntaskan manifest, kesiapan, serta checkpoint sebelum menawarkan fitur multi-kota yang lebih kaya. Fitur belum selesai jangan ditampilkan seolah sudah mendukung kasus baru.

## 12. Skenario pengujian wajib

Tabel ini menguji perilaku bisnis dan risiko data. Jangan membuat test yang hanya mengulang nilai konstan atau memeriksa keberadaan widget tanpa menguji tujuan fitur.

### 12.1 Packing, lokasi, dan kesiapan

| ID | Skenario | Hasil yang diharapkan |
| --- | --- | --- |
| QA-01 | Tambah barang ke rencana | Jumlah rencana bertambah; packing tetap nol; stok master tetap |
| QA-02 | Kemas satu barang, restart | Catatan tersimpan dan jumlah tidak berubah |
| QA-03 | Lima unit, kemas dua | Progres 2/5; status sebagian; sisa tiga |
| QA-04 | Tap cepat dan write DB gagal | Tidak ada jumlah berlebih; UI kembali benar dan error terlihat |
| QA-05 | Charger siap lalu dikeluarkan untuk dipakai | Perlu disiapkan kembali; pemeriksaan item terinvalidasi |
| QA-06 | Masukkan kembali sebagian jumlah yang dipakai | Hanya jumlah yang dikonfirmasi berubah |
| QA-07 | Ubah rencana tiga menjadi dua saat tiga dikemas | Tidak dipotong diam-diam; pengguna harus menyelesaikan unit berlebih |
| QA-08 | Ubah keputusan item yang sudah dikemas | Dampak dijelaskan; manifest lama tidak berubah |
| QA-09 | Empat kaus dibagi dua tas | Total alokasi empat; detail menunjukkan 2+2 |
| QA-10 | Pindah satu unit antartas | Total fisik tetap; alokasi berubah dalam transaksi |
| QA-11 | Barang dibawa di badan atau tas kosong | Packing sah; lokasi tidak dipalsukan menjadi tas bernama |
| QA-12 | Hapus tas dengan isi aktif | Ada penyelesaian alokasi; tidak orphan |
| QA-13 | Semua barang disetel Tidak Dibawa | Tidak tampil 100% siap; tidak ada denominator palsu |
| QA-14 | Pemeriksaan lulus lalu edit satu item | Hanya item/struktur terkait perlu dicek lagi |
| QA-15 | Packing 100%, barang penting belum diperiksa | Hasil kesiapan menunjukkan tugas penting yang tersisa |
| QA-16 | Berangkat dengan kekurangan | Pengecualian tersimpan; manifest memakai jumlah aktual |
| QA-17 | Hapus dari rencana lalu undo | Baris/jumlah kembali sesuai revisi; edit baru tidak tertimpa |

### 12.2 Manifest, checkpoint, stok, dan konflik

| ID | Skenario | Hasil yang diharapkan |
| --- | --- | --- |
| QA-18 | Edit/arsip master sesudah berangkat | Manifest dan checkpoint historis tetap terbaca |
| QA-19 | Pulang setelah live packing diubah | Expected berasal dari baseline yang benar, bukan daftar hidup semata |
| QA-20 | Empat minuman, habis dua, lanjut dua | Checkpoint pertama 4; berikutnya 2; konsumsi tidak ditanyakan dua kali |
| QA-21 | Beli satu minuman pada kota kedua | Baseline tahap berikutnya menambahkan satu dengan identitas jelas |
| QA-22 | Unit hasil checkpoint melebihi expected | Operasi ditolak; hasil lama tidak rusak |
| QA-23 | Charger belum ditemukan lalu tutup checkpoint | Status dengan masalah; jumlah masih masuk daftar pencarian |
| QA-24 | Charger ditemukan kemudian | Masalah selesai; tidak menambah unit menjadi dua |
| QA-25 | Charger hilang dikonfirmasi | Riwayat kehilangan ada; saldo lanjut berkurang eksplisit |
| QA-26 | Dua checkpoint terbuka dalam tahap yang sama | Baseline tidak tumpang tindih; aplikasi membatasi atau memberi jalur revisi yang jelas |
| QA-27 | Konsumsi setelah checkpoint freeze | Tidak mengubah snapshot diam-diam; koreksi/refresh terlihat |
| QA-28 | Stok obat disesuaikan ke nol setelah persetujuan | Riwayat tetap; rencana baru positif membutuhkan stok yang tersedia |
| QA-29 | Turunkan stok di bawah rencana perjalanan lama | Rencana dipertahankan dan ditandai perlu ditinjau |
| QA-30 | Dua perjalanan overlap melebihi stok | Peringatan menampilkan tanggal dan kekurangan |
| QA-31 | A panjang, B awal, C akhir; stok dua | Tidak ada konflik palsu tiga unit |
| QA-32 | Tambah D yang overlap B/C | Konflik muncul hanya pada rentang permintaan berlebih |
| QA-33 | Tanggal akhir kosong | Hasil belum pasti, bukan aman otomatis |
| QA-34 | Perjalanan berurutan tanpa overlap | Tidak ada konflik stok overlap; peringatan ketersediaan terpisah bila barang belum ditemukan |
| QA-35 | Batalkan perjalanan | Permintaan stok aktif dan alarm terkait tidak tertinggal |

### 12.3 Migrasi, backup, aset, dan Android

| ID | Skenario | Hasil yang diharapkan |
| --- | --- | --- |
| QA-36 | Upgrade DB lama dengan bagId dan packing sebagian | Alokasi migrasi setara; waktu konfirmasi tidak dikarang |
| QA-37 | Perjalanan lama tanpa manifest | Mode legacy jelas; tidak dianggap snapshot keberangkatan yang diverifikasi |
| QA-38 | Restore backup lama | Migrasi data dan path aset valid; hasil tetap terbaca |
| QA-39 | Backup saat write dan WAL aktif | Snapshot konsisten; perubahan tidak hilang akibat salin SQLite yang salah |
| QA-40 | Foto dihapus saat ekspor berjalan | Aset yang dirujuk snapshot terlindungi sampai ekspor selesai |
| QA-41 | Ekspor SAF dibatalkan/gagal | Tidak dicatat sebagai backup sukses |
| QA-42 | Arsip rusak, traversal, atau ekstraksi terlalu besar | Ditolak sebelum data aktif diganti |
| QA-43 | Restore terputus saat pergantian DB/aset | Startup memulihkan pasangan data/aset utuh |
| QA-44 | Tiket dibuka dalam mode pesawat setelah file galeri dihapus | Salinan internal tetap dapat dibuka |
| QA-45 | Aset hilang atau PDF rusak | Placeholder/pesan pemulihan, tanpa crash |
| QA-46 | Izin notifikasi dan exact alarm ditolak | Packing tetap berjalan; status pengingat menjelaskan batasnya |
| QA-47 | Edit agenda, reboot, restore | Pengingat aktif direkonsiliasi tanpa duplikasi |
| QA-48 | Semua pengingat lama sudah lewat | Tidak membunyikan seluruh alarm sekaligus |
| QA-49 | Ganti zona perangkat WIB ke WITA | Agenda berzona tertentu menjaga instant; label zona jelas |
| QA-50 | Agenda hanya tanggal | Tidak dipaksa menjadi 00.00; jam pengingat dipilih terpisah |
| QA-51 | Template diterapkan dua kali / trip diduplikasi | Tidak ada stok palsu, centang tersalin, atau alarm bertanggal lama |
| QA-52 | 360 dp, font 1,5×/2×, keyboard, gesture/3 tombol | Semua aksi inti dapat dijangkau dan dibaca |
| QA-53 | TalkBack pada checklist dan status warna | Nama, jumlah, status, dan aksi dibacakan jelas |
| QA-54 | Force stop, battery saver, perubahan izin | Batas nyata dilaporkan; aplikasi tidak mengklaim pengingat pasti terkirim |
| QA-55 | Audit release dan aturan backup cloud | Sesuai scope tanpa server/cloud; izin berlebihan ditindaklanjuti |

### 12.4 Jenis verifikasi dan perintah

- Unit test untuk transisi jumlah, progres, kesiapan, baseline checkpoint, dan konflik interval.
- Repository/integration test untuk transaksi, constraint, snapshot, migrasi, dan recovery backup.
- Widget test untuk interaksi inti, tampilan error, label aksesibilitas, dan tata letak yang berisiko.
- Uji perangkat nyata untuk alarm, file picker, reboot, UI sistem, dan penanganan izin. Emulator saja tidak membuktikan perilaku OEM.
- Dataset lokal sintetis untuk QA: misalnya 1.000 barang, 50 tempat simpan, 20 perjalanan, dan foto bervariasi. Data ini hanya data uji, bukan hasil pengukuran aplikasi saat ini.
- Ukur pencarian, scrolling, thumbnail, dan ekspor dalam profile/release. Target awal pencarian lokal sederhana sekitar 300 ms pada dataset uji tersebut, lalu sesuaikan berdasarkan perangkat. Catat waktu respons UI terpisah dari waktu persist database dan ukuran backup.

Jalankan perintah proyek yang relevan. Minimum dari dokumentasi sumber:

```bash
flutter analyze
flutter test
```

Tambahkan integration test/build release bila diperlukan oleh perubahan dan tersedia dalam proyek. Untuk perubahan skema, jalankan generator dan migration test yang digunakan repositori. Jika versi Drift mendukung tooling terkait, gunakan fasilitas resminya; jangan menebak command atau API.

Jangan menulis “semua lolos” jika lingkungan tidak memiliki Flutter, emulator, perangkat, atau dependency yang dibutuhkan. Tuliskan pemeriksaan yang benar-benar dijalankan beserta batasnya.

## 13. Perbaikan dokumentasi pengembang

AI pengembang juga perlu memperbaiki dokumentasi setelah implementasi, agar AI berikutnya tidak menerima klaim yang sudah usang.

| Bagian | Pembaruan yang perlu dibuat |
| --- | --- |
| Identitas teknis | Versi Flutter/Dart/Drift/Riverpod dan SDK aktual berdasarkan file proyek |
| Status fitur | Pisahkan implemented, partial, planned, dan known issue dengan bukti |
| Model mental | Rencana, konfirmasi fisik, alokasi, manifest, dan checkpoint dijelaskan terpisah |
| Istilah UI | Nama tab, label “Tambahkan ke daftar bawaan”, status siap vs diperiksa |
| Database | Semua tabel nyata, constraint, index, versi, dan jalur migrasi |
| Backup | Format arsip, cakupan aset, kompatibilitas, proses recovery, dan batas Replace-All |
| Pengingat | Capability/izin, fallback, jenis alarm, dan hasil uji perangkat |
| Offline dan privasi | Klaim faktual berdasarkan manifest release, dependency, dan backup sistem |
| Struktur kode | Struktur aktual dan arah dependensi; hindari menyebut domain layer yang belum ada |
| Referensi file | Path relatif repo seperti `lib/core/utils/datetime_utils.dart`; hapus tautan `file:///d:/...` yang tidak portabel |
| Ukuran/performa | Hasil yang diukur beserta ABI, build mode, perangkat, dan tanggal |
| Pengujian | Command, hasil, skenario yang diuji, dan pemeriksaan yang belum dilakukan |

`Expanded`/`Flexible` serta elipsis membantu sebagian layout, tetapi jangan mendokumentasikan keduanya sebagai jaminan universal bebas overflow. Gunakan aturan layout dan bukti pengujian yang lebih spesifik.

## 14. Instruksi siap diberikan kepada AI pengembang

Gunakan instruksi berikut bersama `AI_DOCUMENTATION.md`, dokumen ini, dan akses ke repositori aplikasi.

```text
Anda bertindak sebagai Flutter engineer dan product engineer untuk aplikasi
Android pribadi “Siapkan Tas”. Tujuannya membantu pengguna menyiapkan bawaan,
mengetahui lokasi terakhir barang yang dicatat, serta mencegah barang tertinggal
saat berangkat, pindah kota, dan pulang.

Baca AI_DOCUMENTATION.md dan RENCANA_PERBAIKAN_SIAPKAN_TAS.md sampai selesai.
Dokumen perbaikan adalah backlog dan kontrak perilaku usulan. Jangan menganggap
semua fitur yang dibahas belum ada atau semua risiko sudah terbukti sebagai bug.

Mulai dengan audit repositori:
1. Baca instruksi lokal proyek, pubspec, versi SDK, navigation, provider,
   repository, Drift tables, schemaVersion, migrasi, file aset, backup,
   notification service, AndroidManifest release, dan test yang ada.
2. Petakan requirement ID menjadi sudah ada, sebagian, belum ada, atau tidak
   relevan, dengan file dan perilaku sebagai bukti.
3. Identifikasi bug data/packing yang terbukti, dependency perubahan, dan paket
   implementasi kecil pertama. Catat keputusan model sebelum migrasi.
4. Jalankan pemeriksaan baseline yang tersedia. Jangan mengubah semuanya sebelum
   mengetahui hasil awal dan kondisi data lama.

Implementasikan pekerjaan bertahap mengikuti bagian 11. Prioritaskan keselamatan
data, jumlah yang konsisten, pembatalan packing, pemeriksaan berversi, manifest
keberangkatan, dan checkpoint yang mengikuti saldo barang. Bila audit menemukan
risiko kehilangan data pada backup, perbaiki itu sebelum migrasi domain besar.

Aturan yang wajib dipertahankan:
- Tanpa akun, backend, cloud, analytics, atau ketergantungan internet untuk inti.
- Tempat simpan rumah berbeda dari tas dan lokasi perjalanan terbaru.
- Masuk daftar rencana tidak berarti sudah dikemas.
- Packing, konsumsi, kehilangan, dan penutupan checkpoint tidak otomatis
  mengubah stok master. Penyesuaian stok memerlukan tindakan eksplisit.
- Tas dan kompartemen opsional; packing tanpa nama tas tetap sah.
- Status perjalanan independen; konflik berupa pemeriksaan ketersediaan.
- Snapshot historis tidak berubah karena master atau live packing diedit.
- Catatan fisik manual tidak boleh ditampilkan sebagai deteksi sensor.
- Jangan mengarang timestamp, manifest, atau hasil verifikasi data lama.
- Jangan melakukan reset database, uninstall, atau penghapusan data untuk
  menyelesaikan masalah migrasi.

Pertahankan dependency dan identitas desain yang ada bila layak. Jangan
melakukan rewrite, upgrade massal, atau mengganti state management hanya demi
preferensi. Tambahkan kebutuhan domain pada repository/use case, bukan logika
tersebar di widget. Semua perubahan jumlah dan alokasi harus konsisten melalui
transaksi. Jangan menyelesaikan masalah dengan clamp atau hapus data diam-diam.

Perbaiki UI agar pekerjaan utama mudah diakses: konteks perjalanan jelas,
inventaris dan bawaan berbeda, status terbaca, aksi packing cepat, serta tombol
aman dari keyboard dan navbar. Ikon memiliki label aksesibilitas. Warna saja
tidak boleh menjadi satu-satunya pembeda status.

Untuk setiap paket pekerjaan:
1. Jelaskan ID requirement, perilaku yang berubah, dan data yang terdampak.
2. Terapkan perubahan minimal yang menyelesaikan kasus bisnis.
3. Sertakan migrasi dan compatibility jika skema/aset berubah.
4. Jalankan unit/repository/widget/integration test yang relevan, flutter analyze,
   dan flutter test. Uji perangkat nyata untuk fitur yang memerlukannya.
5. Laporkan hasil nyata; pisahkan yang belum diuji karena batas lingkungan.
6. Perbarui dokumentasi implemented/partial/planned dan known issue.

Jangan berhenti pada usulan tampilan atau implementasi dummy. Fitur yang
ditandai selesai harus memiliki persistensi, state/error handling, dan bukti
perilaku sesuai acceptance criteria. Fitur yang belum selesai tidak boleh
ditampilkan sebagai tersedia.

Hasil akhir pekerjaan harus berisi ringkasan perubahan, ID yang selesai,
file yang diubah, versi/migrasi jika ada, hasil pemeriksaan, masalah tersisa,
dan langkah pemakaian fitur baru. Tidak perlu menerapkan semua P2 sekaligus.
```

## 15. Referensi teknis resmi

Referensi berikut diperiksa pada 14 Oktober 2026 untuk menjelaskan bagian platform. Spesifikasi perilaku packing, saldo perjalanan, prioritas, dan target QA di dokumen ini merupakan rekomendasi desain berdasarkan kebutuhan pengguna, bukan fitur bawaan Flutter/Android.

| Referensi | Pokok yang dipakai |
| --- | --- |
| [Android — Schedule alarms](https://developer.android.com/develop/background-work/services/alarms) | Perbedaan exact/inexact, pemeriksaan kemampuan exact alarm, dan rekonsiliasi setelah reboot |
| [Android — Notification runtime permission](https://developer.android.com/develop/ui/compose/notifications/notification-permission) | Izin notifikasi Android 13+ yang berbeda dari izin exact alarm |
| [Android — Auto Backup](https://developer.android.com/identity/data/autobackup) | Default backup platform, allowBackup, dan aturan cloud/device transfer lintas versi |
| [Flutter — SafeArea dan MediaQuery](https://docs.flutter.dev/ui/adaptive-responsive/safearea-mediaquery) | Area yang tertutup UI sistem, ukuran layar, dan pengaturan aksesibilitas |
| [Drift — Migrations](https://drift.simonbinder.eu/migrations/) | Migrasi skema dan dukungan tooling/pengujian; sesuaikan dengan versi proyek |
| [SQLite — Backup API](https://www.sqlite.org/backup.html) | Snapshot konsisten dari database aktif dan alternatif seperti VACUUM INTO |

Dokumen ini tidak menetapkan versi dependency terbaru dan tidak menyatakan implementasi lama sudah memenuhi perilaku platform tersebut. AI pengembang harus memeriksa API serta konfigurasi sesuai versi repositori dan perangkat target.

## 16. Kriteria selesai pembaruan inti

Pembaruan inti dapat dinyatakan selesai setelah hal berikut terbukti:

- Pengguna dapat menemukan lokasi asal dan lokasi perjalanan terbaru dengan konteks yang jelas.
- Barang yang dikeluarkan, dipakai, atau jumlahnya berubah tidak terus dianggap siap dari centang lama.
- Packing 100%, pemeriksaan keberangkatan, dan informasi lokasi tidak dicampur menjadi satu boolean.
- Manifest mencatat barang yang benar-benar dikonfirmasi ikut berangkat; kekurangan tidak disembunyikan.
- Checkpoint dapat mempertanggungjawabkan konsumsi, barang baru, ditinggal, hilang, dan belum ditemukan tanpa hitungan ganda.
- Barang yang belum ditemukan tetap terlihat sampai diselesaikan, termasuk setelah checkpoint ditutup dengan masalah.
- Master, riwayat, snapshot, foto, dan tiket bertahan setelah upgrade serta backup/restore.
- Tidak ada perubahan stok atau hilangnya data historis yang terjadi tanpa tindakan yang jelas.
- Alur utama dapat dipakai offline, dengan font besar dan UI sistem Android yang diuji.
- Pengingat menyatakan kemampuan dan kegagalan sebenarnya; hasil perangkat nyata terdokumentasi.
- Setiap P0 yang dinyatakan selesai memiliki bukti implementasi dan pengujian. P1/P2 yang belum diterapkan tercatat secara jujur.

