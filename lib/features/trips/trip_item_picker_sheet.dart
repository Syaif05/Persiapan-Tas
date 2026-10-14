import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_button.dart';
import '../../core/widgets/bawa_search_field.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/trip_packing_repository.dart';

class TripItemPickerSheet extends ConsumerStatefulWidget {
  final String tripId;

  const TripItemPickerSheet({super.key, required this.tripId});

  @override
  ConsumerState<TripItemPickerSheet> createState() => _TripItemPickerSheetState();
}

class _TripItemPickerSheetState extends ConsumerState<TripItemPickerSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(filteredInventoryStreamProvider);
    final tripItemsAsync = ref.watch(tripItemsStreamProvider(
      (tripId: widget.tripId, filter: PackingFilter.all),
    ));

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),
          ),
          child: Column(
            children: [
              // Header Sheet
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pilih dari Inventaris', style: AppTypography.screenTitle),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    BawaSearchField(
                      hintText: 'Cari nama barang atau lokasi...',
                      onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),

              // Daftar Barang
              Expanded(
                child: inventoryAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Gagal memuat inventaris: $err')),
                  data: (items) {
                    final tripItems = tripItemsAsync.value ?? [];
                    final Map<String, TripItemWithDetails> carriedMap = {
                      for (var ti in tripItems) ti.tripItem.itemId: ti
                    };

                    final filtered = items.where((i) {
                      if (_searchQuery.isEmpty) return true;
                      final nameMatch = i.item.name.toLowerCase().contains(_searchQuery);
                      final locMatch = (i.location?.name.toLowerCase() ?? '').contains(_searchQuery);
                      return nameMatch || locMatch;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            items.isEmpty
                                ? 'Belum ada barang di inventaris.\nTambahkan barang di tab Barang terlebih dahulu.'
                                : 'Tidak ada barang yang cocok dengan pencarian.',
                            style: AppTypography.bodySecondary,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(AppSpacing.base),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final itemWithDetails = filtered[index];
                        final item = itemWithDetails.item;
                        final carried = carriedMap[item.id];
                        final isCarried = carried != null && carried.tripItem.decision == 'carried';
                        final plannedQty = carried?.tripItem.plannedQuantity ?? 0;

                        return Container(
                          decoration: BoxDecoration(
                            color: isCarried ? AppColors.primarySoft.withValues(alpha: 0.3) : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                            border: Border.all(
                              color: isCarried ? AppColors.primary : AppColors.border,
                              width: isCarried ? 1.5 : 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                // Checkbox status
                                Checkbox(
                                  value: isCarried,
                                  activeColor: AppColors.primary,
                                  onChanged: (checked) {
                                    if (checked == true) {
                                      if (item.quantity <= 0) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Stok "${item.name}" habis (0 ${item.unit}). Perbarui stok inventaris terlebih dahulu.'),
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      }
                                      _showQuantityDialog(context, item.id, item.name, item.quantity, item.unit, 1);
                                    } else {
                                      if (carried != null) {
                                        ref.read(tripPackingRepositoryProvider).removeTripItem(carried.tripItem.id);
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(width: AppSpacing.xs),

                                // Informasi Barang
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              style: AppTypography.itemTitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (item.isImportant)
                                            Container(
                                              margin: const EdgeInsets.only(left: 4),
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.warningSoft,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'Penting',
                                                style: TextStyle(
                                                  color: AppColors.warning,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Asal: ${itemWithDetails.location?.name ?? "Lokasi belum dicatat"} • Stok: ${item.quantity} ${item.unit}',
                                        style: AppTypography.metadata,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (isCarried) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              'Rencana dibawa: $plannedQty ${item.unit}',
                                              style: AppTypography.metadata.copyWith(
                                                color: AppColors.primaryDark,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: AppSpacing.sm),
                                            InkWell(
                                              onTap: () {
                                                _showQuantityDialog(
                                                  context,
                                                  item.id,
                                                  item.name,
                                                  item.quantity,
                                                  item.unit,
                                                  plannedQty,
                                                );
                                              },
                                              child: const Text(
                                                'Ubah',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (carried?.hasConflict ?? false) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          carried!.conflictMessage ?? 'Potensi bentrok tanggal',
                                          style: const TextStyle(
                                            color: AppColors.warning,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Bottom Button Selesai
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: BawaButton(
                    label: 'Selesai Memilih',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuantityDialog(
    BuildContext context,
    String itemId,
    String itemName,
    int maxStock,
    String unit,
    int initialQty,
  ) {
    if (maxStock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok "$itemName" habis (0 $unit). Perbarui stok terlebih dahulu.'),
        ),
      );
      return;
    }
    int selectedQty = initialQty.clamp(1, maxStock);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Text('Jumlah Rencana Bawaan', style: AppTypography.itemTitle.copyWith(fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Stok inventaris tersedia: $maxStock $unit',
                    style: AppTypography.metadata,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        onPressed: selectedQty > 1
                            ? () => setDialogState(() => selectedQty--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Text(
                          '$selectedQty $unit',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add),
                        onPressed: selectedQty < maxStock
                            ? () => setDialogState(() => selectedQty++)
                            : null,
                      ),
                    ],
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
                    Navigator.of(ctx).pop();
                    await ref.read(tripPackingRepositoryProvider).setPlannedItem(
                          tripId: widget.tripId,
                          itemId: itemId,
                          plannedQuantity: selectedQty,
                        );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
