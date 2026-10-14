import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../core/widgets/full_screen_image_viewer.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/inventory_repository.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  ItemWithDetails? _details;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(inventoryRepositoryProvider);
      final data = await repo.getItemWithDetailsById(widget.itemId);
      if (mounted) {
        setState(() {
          _details = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: BawaAppBar(title: 'Detail Barang'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _details == null) {
      return Scaffold(
        appBar: const BawaAppBar(title: 'Detail Barang'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(_error ?? 'Barang tidak ditemukan', style: AppTypography.itemTitle),
              const SizedBox(height: AppSpacing.base),
              BawaButton(
                label: 'Kembali',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    final item = _details!.item;
    final category = _details!.category;
    final location = _details!.location;
    final photos = _details!.photos;
    final isArchived = item.archivedAt != null;

    return Scaffold(
      appBar: BawaAppBar(
        title: item.name,
        actions: [
          IconButton(
            tooltip: isArchived ? 'Pulihkan dari Arsip' : 'Arsipkan Barang',
            icon: Icon(
              isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () => _toggleArchive(isArchived),
          ),
          IconButton(
            tooltip: 'Hapus Barang',
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galeri Foto (INV-06)
            if (photos.isNotEmpty)
              _buildPhotoGallery(photos)
            else
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image_not_supported_outlined, size: 40, color: AppColors.textSecondary),
                    SizedBox(height: AppSpacing.xs),
                    Text('Belum ada foto', style: AppTypography.metadata),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Banner Arsip jika diarsipkan
            if (isArchived)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.base),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.inventory_2, color: AppColors.textSecondary, size: 20),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Barang ini diarsipkan. Data tetap tersimpan aman untuk riwayat perjalanan.',
                        style: AppTypography.metadata,
                      ),
                    ),
                  ],
                ),
              ),

            // Nama & Badge Penting
            Row(
              children: [
                Expanded(
                  child: Text(item.name, style: AppTypography.screenTitle),
                ),
                if (item.isImportant)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.errorSoft,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.star, size: 14, color: AppColors.error),
                        SizedBox(width: 4),
                        Text(
                          'PENTING',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Ringkasan Jumlah & Satuan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                      ),
                      child: const Icon(Icons.layers_outlined, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Jumlah Stok Tersedia', style: AppTypography.metadata),
                        Text(
                          '${item.quantity} ${item.unit}',
                          style: AppTypography.screenTitle.copyWith(color: AppColors.primary, fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            // Detail Kategori dan Tempat Simpan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.category_outlined,
                      label: 'Kategori',
                      value: category?.name ?? 'Tanpa Kategori',
                    ),
                    const Divider(height: AppSpacing.lg),
                    _buildInfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: 'Tempat Simpan Asal',
                      value: location?.name ?? 'Lokasi belum dicatat',
                      subvalue: location?.description,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),

            // Catatan
            if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
              const Text('Catatan', style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.xs),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Text(item.notes!, style: AppTypography.body),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Tombol Edit
            BawaButton(
              label: 'Ubah Data Barang',
              icon: Icons.edit_outlined,
              variant: BawaButtonVariant.secondary,
              onPressed: () async {
                await context.push('/inventory/edit/${item.id}');
                _loadDetails();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGallery(List<AssetEntry> photos) {
    final assetService = ref.read(assetStorageServiceProvider);

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final photo = photos[index];
          return FutureBuilder<File>(
            future: assetService.resolveRelativeFile(photo.relativePath),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.existsSync()) {
                final file = snapshot.data!;
                return GestureDetector(
                  onTap: () {
                    FullScreenImageViewer.show(
                      context,
                      file: file,
                      title: _details?.item.name,
                    );
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                        child: Image.file(
                          file,
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.fullscreen, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined, color: AppColors.textSecondary),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    String? subvalue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.metadata),
              const SizedBox(height: 2),
              Text(value, style: AppTypography.itemTitle),
              if (subvalue != null && subvalue.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(subvalue, style: AppTypography.bodySecondary),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _toggleArchive(bool isArchived) async {
    final repo = ref.read(inventoryRepositoryProvider);
    if (isArchived) {
      await repo.unarchiveItem(widget.itemId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil dipulihkan dari arsip')),
        );
      }
    } else {
      await repo.archiveItem(widget.itemId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barang berhasil diarsipkan')),
        );
      }
    }
    _loadDetails();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Barang?'),
        content: const Text(
          'Tindakan ini akan menghapus barang secara permanen. Jika barang sudah pernah dipakai dalam perjalanan, gunakan opsi Arsip agar riwayat bawaan tidak rusak.',
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => ctx.pop(true),
            child: const Text('Hapus Permanen', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final repo = ref.read(inventoryRepositoryProvider);
        await repo.deleteItem(widget.itemId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barang berhasil dihapus')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.error,
              content: Text(e.toString().replaceAll('Exception: ', '').replaceAll('StateError: ', '')),
            ),
          );
        }
      }
    }
  }
}
