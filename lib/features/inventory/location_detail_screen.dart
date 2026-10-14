import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/inventory_repository.dart';

class LocationDetailScreen extends ConsumerStatefulWidget {
  const LocationDetailScreen({super.key});

  @override
  ConsumerState<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends ConsumerState<LocationDetailScreen> {
  String? _selectedLocationId;

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(activeLocationsStreamProvider);

    return Scaffold(
      appBar: BawaAppBar(
        title: 'Kotak & Lokasi',
        subtitle: 'Melihat isi tempat simpan tanpa membongkar fisik',
        actions: [
          IconButton(
            tooltip: 'Tambah Lokasi Baru',
            icon: const Icon(Icons.add, color: AppColors.primary, size: 28),
            onPressed: _showAddLocationDialog,
          ),
        ],
      ),
      body: locationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat lokasi: $err')),
        data: (locations) {
          if (locations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.archive_outlined, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Belum ada lokasi simpan', style: AppTypography.itemTitle),
                  const SizedBox(height: AppSpacing.base),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Buat Tempat Simpan Pertama'),
                    onPressed: _showAddLocationDialog,
                  ),
                ],
              ),
            );
          }

          // Atur selected location default jika belum ada atau terhapus
          final activeLocation = locations.firstWhere(
            (l) => l.id == _selectedLocationId,
            orElse: () => locations.first,
          );

          return Column(
            children: [
              // Horizontal Chips Lokasi
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  children: locations.map((loc) {
                    final isSelected = loc.id == activeLocation.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        selected: isSelected,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getLocationIcon(loc.type),
                              size: 16,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(loc.name),
                          ],
                        ),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedLocationId = loc.id;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Kartu Informasi Lokasi Terpilih
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Card(
                  color: AppColors.surfaceMuted,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(_getLocationIcon(activeLocation.type), color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(activeLocation.name, style: AppTypography.itemTitle),
                              if (activeLocation.description != null && activeLocation.description!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  activeLocation.description!,
                                  style: AppTypography.bodySecondary,
                                ),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                          onSelected: (action) {
                            if (action == 'edit') {
                              _showEditLocationDialog(activeLocation);
                            } else if (action == 'delete') {
                              _confirmDeleteLocation(activeLocation, locations);
                            }
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Ubah Lokasi'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Hapus Lokasi', style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Header Bagian Daftar Isi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daftar Isi Tempat Simpan', style: AppTypography.sectionTitle),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah ke Sini'),
                      onPressed: () {
                        context.push('/inventory/new?locationId=${activeLocation.id}');
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Daftar Barang Nyata di Lokasi (INV-04)
              Expanded(
                child: FutureBuilder<List<ItemWithDetails>>(
                  future: ref.read(inventoryRepositoryProvider).getItemsByLocationId(activeLocation.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final itemsInLocation = snapshot.data ?? [];

                    if (itemsInLocation.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tempat simpan ini masih kosong.',
                          style: AppTypography.bodySecondary,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.base),
                      itemCount: itemsInLocation.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final itemDetails = itemsInLocation[index];
                        final item = itemDetails.item;
                        final category = itemDetails.category;

                        return Card(
                          child: ListTile(
                            onTap: () => context.push('/inventory/items/${item.id}'),
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primarySoft,
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            title: Text(item.name, style: AppTypography.itemTitle),
                            subtitle: Text(
                              '${item.unit} • ${category?.name ?? 'Tanpa Kategori'}${item.notes != null && item.notes!.isNotEmpty ? ' • ${item.notes}' : ''}',
                              style: AppTypography.metadata,
                            ),
                            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'box':
        return Icons.inventory_2_outlined;
      case 'wardrobe':
        return Icons.door_sliding_outlined;
      case 'drawer':
        return Icons.table_restaurant_outlined;
      default:
        return Icons.archive_outlined;
    }
  }

  void _showAddLocationDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedType = 'box';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Tambah Lokasi Simpan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Lokasi / Kotak *', hintText: 'Contoh: Kotak Perkakas'),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'Jenis Tempat Simpan'),
                items: const [
                  DropdownMenuItem(value: 'box', child: Text('Kotak (Box)')),
                  DropdownMenuItem(value: 'wardrobe', child: Text('Lemari')),
                  DropdownMenuItem(value: 'drawer', child: Text('Laci Meja')),
                  DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                ],
                onChanged: (val) => setDialogState(() => selectedType = val ?? 'box'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Keterangan Lokasi', hintText: 'Contoh: Di bawah meja kamar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => ctx.pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final repo = ref.read(locationsRepositoryProvider);
                final newLoc = await repo.createLocation(
                  name: nameCtrl.text.trim(),
                  type: selectedType,
                  description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                );
                if (mounted) {
                  setState(() => _selectedLocationId = newLoc.id);
                }
                if (ctx.mounted) {
                  ctx.pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditLocationDialog(StorageLocationEntry location) {
    final nameCtrl = TextEditingController(text: location.name);
    final descCtrl = TextEditingController(text: location.description ?? '');
    String selectedType = location.type;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Ubah Lokasi Simpan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Lokasi / Kotak *'),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(labelText: 'Jenis Tempat Simpan'),
                items: const [
                  DropdownMenuItem(value: 'box', child: Text('Kotak (Box)')),
                  DropdownMenuItem(value: 'wardrobe', child: Text('Lemari')),
                  DropdownMenuItem(value: 'drawer', child: Text('Laci Meja')),
                  DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                ],
                onChanged: (val) => setDialogState(() => selectedType = val ?? 'box'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Keterangan Lokasi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => ctx.pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final repo = ref.read(locationsRepositoryProvider);
                await repo.updateLocation(
                  id: location.id,
                  name: nameCtrl.text.trim(),
                  type: selectedType,
                  description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                );
                if (mounted) {
                  setState(() {});
                }
                if (ctx.mounted) {
                  ctx.pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteLocation(
    StorageLocationEntry location,
    List<StorageLocationEntry> allLocations,
  ) async {
    final repo = ref.read(locationsRepositoryProvider);
    final itemCount = await repo.getItemCountInLocation(location.id);

    final otherLocations = allLocations.where((l) => l.id != location.id).toList();
    String? targetTransferLocationId;

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Hapus "${location.name}"?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (itemCount > 0) ...[
                Text(
                  'Terdapat $itemCount barang yang tersimpan di lokasi ini. Sesuai prinsip Bawa, barang tidak akan terhapus.',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('Pindahkan barang ke:', style: AppTypography.itemTitle),
                const SizedBox(height: AppSpacing.xs),
                DropdownButtonFormField<String?>(
                  initialValue: targetTransferLocationId,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Lepaskan (Lokasi belum dicatat)')),
                    ...otherLocations.map(
                      (l) => DropdownMenuItem(value: l.id, child: Text(l.name)),
                    ),
                  ],
                  onChanged: (val) => setDialogState(() => targetTransferLocationId = val),
                ),
              ] else ...[
                const Text('Lokasi ini kosong. Anda yakin ingin menghapusnya?'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => ctx.pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => ctx.pop(true),
              child: const Text('Hapus Lokasi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await repo.deleteLocation(location.id, targetLocationId: targetTransferLocationId);
      setState(() {
        _selectedLocationId = otherLocations.isNotEmpty ? otherLocations.first.id : null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lokasi "${location.name}" telah dihapus')),
        );
      }
    }
  }
}
