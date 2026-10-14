import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  final String? itemId;
  final String? initialLocationId;
  final String? initialTripId;

  const ItemFormScreen({
    super.key,
    this.itemId,
    this.initialLocationId,
    this.initialTripId,
  });

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'buah');
  final _notesController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedLocationId;
  String? _selectedTripId;
  bool _isImportant = false;
  bool _isLoadingInitial = false;
  bool _isSaving = false;

  // Foto yang dipilih (ID asset dari tabel Assets)
  final List<AssetEntry> _selectedPhotos = [];

  // Peringatan duplikasi nama (INV-09)
  List<ItemEntry> _duplicateMatches = [];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedLocationId = widget.initialLocationId;
    _selectedTripId = widget.initialTripId;
    if (widget.itemId != null) {
      _loadExistingItem(widget.itemId!);
    }
  }

  Future<void> _loadExistingItem(String id) async {
    setState(() => _isLoadingInitial = true);
    final repo = ref.read(inventoryRepositoryProvider);
    final details = await repo.getItemWithDetailsById(id);
    if (details != null && mounted) {
      final item = details.item;
      setState(() {
        _nameController.text = item.name;
        _quantityController.text = item.quantity.toString();
        _unitController.text = item.unit;
        _notesController.text = item.notes ?? '';
        _selectedCategoryId = item.categoryId;
        _selectedLocationId = item.storageLocationId;
        _isImportant = item.isImportant;
        _selectedPhotos.clear();
        _selectedPhotos.addAll(details.photos);
        _isLoadingInitial = false;
      });
    } else {
      if (mounted) setState(() => _isLoadingInitial = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Deteksi nama duplikat secara real-time (INV-09)
  Future<void> _onNameChanged(String val) async {
    if (val.trim().length < 2) {
      if (_duplicateMatches.isNotEmpty) {
        setState(() => _duplicateMatches = []);
      }
      return;
    }

    final repo = ref.read(inventoryRepositoryProvider);
    final matches = await repo.checkDuplicateName(val, excludeId: widget.itemId);
    if (mounted) {
      setState(() {
        _duplicateMatches = matches;
      });
    }
  }

  // Pilih foto via kamera atau galeri dengan penanganan pembatalan (INV-06)
  Future<void> _pickImage(ImageSource source) async {
    if (_selectedPhotos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksimal 5 foto per barang (1 utama + 4 tambahan)')),
      );
      return;
    }

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );

      // Canceled picker ditangani dengan aman tanpa crash
      if (pickedFile == null) return;

      final assetService = ref.read(assetStorageServiceProvider);
      final asset = await assetService.savePickedImage(
        pickedFile,
        kind: 'item_photo',
        originalName: pickedFile.name,
      );

      if (mounted) {
        setState(() {
          _selectedPhotos.add(asset);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Gagal menyimpan foto: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusCard)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: const Text('Ambil Foto Baru (Kamera)', style: AppTypography.itemTitle),
                onTap: () {
                  ctx.pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: const Text('Pilih dari Galeri', style: AppTypography.itemTitle),
                onTap: () {
                  ctx.pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddLocationDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Tempat Simpan Baru', style: AppTypography.itemTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tulis nama kotak, lemari, atau tempat simpan lainnya.',
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nama Lokasi / Kotak *',
                hintText: 'Contoh: Kotak Kabel, Laci Meja',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: 'Keterangan Lokasi (Opsional)',
                hintText: 'Contoh: Di bawah meja kerja',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              Navigator.of(ctx).pop();
              try {
                final locationEntry = await ref.read(locationsRepositoryProvider).createLocation(
                      name: name,
                      type: 'box',
                      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                    );
                setState(() {
                  _selectedLocationId = locationEntry.id;
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lokasi "$name" berhasil ditambahkan dan dipilih')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat lokasi: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Simpan Lokasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingInitial) {
      return const Scaffold(
        appBar: BawaAppBar(title: 'Memuat...'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final locationsAsync = ref.watch(activeLocationsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final allTripsAsync = ref.watch(allTripsWithDetailsStreamProvider(null));
    final isEditing = widget.itemId != null;

    return Scaffold(
      appBar: BawaAppBar(
        title: isEditing ? 'Ubah Barang' : 'Tambah Barang',
        subtitle: 'Catat inventaris dan rencana bawaan perjalanan',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Peringatan Kemungkinan Duplikasi Nama (INV-09)
              if (_duplicateMatches.isNotEmpty)
                _buildDuplicateWarningBanner(),

              // KARTU 1: Informasi Utama Barang
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 18),
                          SizedBox(width: 8),
                          Text('Informasi Barang', style: AppTypography.itemTitle),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Nama Barang (Wajib)
                      const Text('Nama Barang *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Charger USB-C 65W',
                          prefixIcon: Icon(Icons.label_outline, size: 20),
                        ),
                        onChanged: _onNameChanged,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama barang tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Jumlah Stok & Satuan (INV-01)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Jumlah Stok *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '1',
                                    prefixIcon: Icon(Icons.numbers, size: 18),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                                    final parsed = int.tryParse(val.trim());
                                    if (widget.itemId != null) {
                                      if (parsed == null || parsed < 0) return 'Min 0';
                                    } else {
                                      if (parsed == null || parsed < 1) return 'Min 1';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Satuan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _unitController,
                                  decoration: const InputDecoration(
                                    hintText: 'buah / helai / pasang',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // KARTU 2: Masukkan Langsung ke Tas Perjalanan (Fitur Baru)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  side: BorderSide(
                    color: _selectedTripId != null ? AppColors.primary : AppColors.border,
                    width: _selectedTripId != null ? 1.5 : 1.0,
                  ),
                ),
                color: _selectedTripId != null
                    ? AppColors.primarySoft.withValues(alpha: 0.2)
                    : AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: _selectedTripId != null ? AppColors.primary : AppColors.textPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tambahkan ke daftar bawaan (Opsional)',
                              style: AppTypography.itemTitle.copyWith(
                                color: _selectedTripId != null ? AppColors.primaryDark : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih perjalanan untuk memasukkan barang ini ke daftar rencana bawaan (status awal belum dikemas).',
                        style: AppTypography.metadata,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      allTripsAsync.when(
                        data: (trips) {
                          final activeTrips = trips.where((t) => !t.trip.isArchived && t.trip.status != 'cancelled').toList();
                          return DropdownButtonFormField<String?>(
                            isExpanded: true,
                            initialValue: _selectedTripId,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.luggage_outlined, size: 20),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Simpan di Gudang saja (Tanpa Perjalanan)'),
                              ),
                              ...activeTrips.map(
                                (t) => DropdownMenuItem(
                                  value: t.trip.id,
                                  child: Text(
                                    '${t.trip.name} (${t.trip.status == 'ongoing' ? 'Sedang Berjalan' : 'Persiapan'})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) => setState(() => _selectedTripId = val),
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Gagal memuat perjalanan: $e', style: AppTypography.metadata),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // KARTU 3: Lokasi Simpan Asal & Kategori
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.archive_outlined, color: AppColors.primary, size: 18),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text('Tempat Simpan Asal', style: AppTypography.itemTitle, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            ),
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text('Tambah Lokasi', style: TextStyle(fontSize: 11)),
                            onPressed: () => _showAddLocationDialog(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      locationsAsync.when(
                        data: (locations) {
                          return DropdownButtonFormField<String?>(
                            isExpanded: true,
                            initialValue: _selectedLocationId,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('Lokasi belum dicatat')),
                              ...locations.map(
                                (loc) => DropdownMenuItem(
                                  value: loc.id,
                                  child: Text(
                                    '${loc.name}${loc.description != null && loc.description!.isNotEmpty ? ' (${loc.description})' : ''}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (val) => setState(() => _selectedLocationId = val),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.inbox_outlined, size: 20),
                            ),
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Gagal memuat lokasi: $e'),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Kategori Barang
                      const Text('Kategori Barang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      categoriesAsync.when(
                        data: (categories) {
                          if (_selectedCategoryId == null && categories.isNotEmpty) {
                            _selectedCategoryId = categories.first.id;
                          }
                          return DropdownButtonFormField<String?>(
                            isExpanded: true,
                            initialValue: _selectedCategoryId,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('Tanpa Kategori')),
                              ...categories.map(
                                (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                              ),
                            ],
                            onChanged: (val) => setState(() => _selectedCategoryId = val),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.category_outlined, size: 20),
                            ),
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Gagal memuat kategori: $e'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // KARTU 4: Foto Barang (INV-06)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: _buildPhotoPickerSection(),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // KARTU 5: Pengaturan Tambahan (Penting & Catatan)
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.push_pin_outlined, color: AppColors.primary),
                        title: const Text('Barang Penting', style: AppTypography.itemTitle),
                        subtitle: const Text('Dokumen, obat, atau barang bernilai tinggi', style: AppTypography.metadata),
                        value: _isImportant,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isImportant = val),
                      ),
                      const Divider(height: AppSpacing.md),
                      const Text('Catatan Tambahan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Warna, ukuran, atau tips penyimpanan...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Tombol Simpan
              BawaButton(
                label: isEditing ? 'Simpan Perubahan' : 'Simpan ke Inventaris',
                icon: Icons.check,
                isLoading: _isSaving,
                onPressed: _saveItem,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerSection() {
    final assetService = ref.read(assetStorageServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text('Foto Barang (Maks. 5)', style: AppTypography.itemTitle, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text('${_selectedPhotos.length} / 5', style: AppTypography.metadata),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Tombol Tambah Foto
              if (_selectedPhotos.length < 5)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: InkWell(
                    onTap: _showImagePickerModal,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                        border: Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo_outlined, size: 28, color: AppColors.primary),
                          SizedBox(height: 4),
                          Text('Tambah', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),

              // Foto-foto yang telah ditambahkan
              ..._selectedPhotos.asMap().entries.map((entry) {
                final index = entry.key;
                final photo = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Stack(
                    children: [
                      FutureBuilder<File>(
                        future: assetService.resolveRelativeFile(photo.relativePath),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.existsSync()) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                              child: Image.file(
                                snapshot.data!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                            ),
                            child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
                          );
                        },
                      ),
                      // Badge Foto Utama untuk foto pertama
                      if (index == 0)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Utama', style: TextStyle(color: Colors.white, fontSize: 9)),
                          ),
                        ),
                      // Tombol Hapus Foto
                      Positioned(
                        top: 2,
                        right: 2,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedPhotos.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDuplicateWarningBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        border: Border.all(color: AppColors.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
              SizedBox(width: AppSpacing.xs),
              Text('Kemungkinan Nama Serupa', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Barang dengan nama serupa sudah ada: ${_duplicateMatches.map((m) => m.name).take(3).join(', ')}. Anda tetap boleh menyimpannya bila ini unit barang yang berbeda.',
            style: AppTypography.metadata,
          ),
        ],
      ),
    );
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final repo = ref.read(inventoryRepositoryProvider);
    final tripPackingRepo = ref.read(tripPackingRepositoryProvider);

    try {
      final name = _nameController.text.trim();
      final quantity = int.parse(_quantityController.text.trim());
      final unit = _unitController.text.trim().isEmpty ? 'buah' : _unitController.text.trim();
      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
      final photoIds = _selectedPhotos.map((p) => p.id).toList();

      if (widget.itemId != null) {
        await repo.updateItem(
          id: widget.itemId!,
          name: name,
          quantity: quantity,
          unit: unit,
          categoryId: _selectedCategoryId,
          storageLocationId: _selectedLocationId,
          notes: notes,
          isImportant: _isImportant,
          photoAssetIds: photoIds,
        );

        if (_selectedTripId != null && quantity > 0) {
          await tripPackingRepo.setPlannedItem(
            tripId: _selectedTripId!,
            itemId: widget.itemId!,
            plannedQuantity: quantity,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Barang "$name" berhasil diperbarui'),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      } else {
        final created = await repo.createItem(
          name: name,
          quantity: quantity,
          unit: unit,
          categoryId: _selectedCategoryId,
          storageLocationId: _selectedLocationId,
          notes: notes,
          isImportant: _isImportant,
          photoAssetIds: photoIds,
        );

        if (_selectedTripId != null && quantity > 0) {
          await tripPackingRepo.setPlannedItem(
            tripId: _selectedTripId!,
            itemId: created.item.id,
            plannedQuantity: quantity,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_selectedTripId != null
                  ? 'Barang "$name" ditambahkan ke inventaris & daftar bawaan!'
                  : 'Barang "$name" berhasil ditambahkan'),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Gagal menyimpan: ${e.toString()}'),
            duration: const Duration(milliseconds: 2000),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
