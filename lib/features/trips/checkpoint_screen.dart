import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../core/widgets/bawa_empty_state.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/checkpoints_repository.dart';

class CheckpointScreen extends ConsumerStatefulWidget {
  final String tripId;

  const CheckpointScreen({super.key, required this.tripId});

  @override
  ConsumerState<CheckpointScreen> createState() => _CheckpointScreenState();
}

class _CheckpointScreenState extends ConsumerState<CheckpointScreen> {
  String? _selectedCheckpointId;

  String _formatDateTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('d MMM yyyy, HH:mm').format(dt);
    } catch (_) {
      return iso;
    }
  }

  Future<void> _handleCreateCheckpoint(BuildContext context) async {
    final checkpointsRepo = ref.read(checkpointsRepositoryProvider);
    final packedCount = await checkpointsRepo.getPackedItemsCount(widget.tripId);

    if (!context.mounted) return;

    if (packedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Belum ada barang yang dikemas (kuantitas kemas > 0). Kemas barang terlebih dahulu di tab Bawaan.',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      final newId = await ref
          .read(checkpointsRepositoryProvider)
          .createCheckpoint(tripId: widget.tripId);
      setState(() {
        _selectedCheckpointId = newId;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checkpoint pulang berhasil dibuat.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat checkpoint: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showNoteDialog(BuildContext context, ReturnEntryWithItem entry) {
    final noteCtrl = TextEditingController(text: entry.notes ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Catatan untuk ${entry.nameSnapshot}', style: AppTypography.itemTitle),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Contoh: Diduga tertinggal di lemari hotel...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(checkpointsRepositoryProvider)
                  .updateReturnEntryQuantities(
                    entryId: entry.id,
                    returnedQuantity: entry.returnedQuantity,
                    consumedQuantity: entry.consumedQuantity,
                    leftQuantity: entry.leftQuantity,
                    lostQuantity: entry.lostQuantity,
                    notes: noteCtrl.text.trim(),
                  );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showCloseConfirmationDialog(
    BuildContext context,
    CheckpointWithDetails checkpoint,
  ) {
    final isFull = checkpoint.isFullyConfirmed;
    final unconfirmed = checkpoint.totalUnconfirmed;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isFull ? 'Tutup Checkpoint (Lengkap)' : 'Tutup dengan Sisa Belum Terkonfirmasi',
          style: AppTypography.itemTitle,
        ),
        content: Text(
          isFull
              ? 'Seluruh barang (${checkpoint.totalExpected} unit) telah terkonfirmasi. Status akan dicatat sebagai Selesai.'
              : 'PERHATIAN: Terdapat $unconfirmed unit barang yang belum terkonfirmasi.\n\nSesuai standar kejujuran data, status checkpoint akan dicatat sebagai "Ditutup dengan sisa", bukan selesai.\n\nStok inventaris master tidak akan diubah atau dikurangi secara otomatis.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: isFull
                ? null
                : FilledButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _handleCloseCheckpoint(context, checkpoint);
            },
            child: Text(isFull ? 'Tutup Checkpoint' : 'Tetap Tutup dengan Sisa'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCloseCheckpoint(BuildContext context, CheckpointWithDetails checkpoint) async {
    final repo = ref.read(checkpointsRepositoryProvider);
    final proposals = await repo.getStockAdjustmentProposals(checkpoint.id);

    if (proposals.isNotEmpty && context.mounted) {
      // Tampilkan dialog pratinjau penyesuaian stok (INV-01, QA-28)
      final applyAdjustments = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Penyesuaian Stok Inventaris'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Beberapa barang tercatat habis, hilang, atau ditinggal. Apakah Anda ingin memperbarui stok inventaris master?',
                    style: AppTypography.body,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...proposals.map((p) {
                    final reason = [
                      if (p.consumed > 0) '${p.consumed} habis',
                      if (p.lost > 0) '${p.lost} hilang',
                      if (p.left > 0) '${p.left} ditinggal',
                    ].join(', ');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.itemName, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                                Text('Alasan: $reason', style: AppTypography.metadata),
                              ],
                            ),
                          ),
                          Text(
                            '${p.currentStock} ➔ ${p.proposedStock} ${p.unit}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Lewati (Stok Tetap)'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Perbarui Stok Master'),
              ),
            ],
          );
        },
      );

      if (applyAdjustments == true) {
        await repo.applyStockAdjustments(proposals);
      }
    }

    await repo.closeCheckpoint(checkpoint.id);
    if (context.mounted) {
      final unconfirmed = checkpoint.totalUnconfirmed;
      final isFull = checkpoint.isFullyConfirmed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFull
                ? 'Checkpoint ditutup: Semua barang lengkap!'
                : 'Checkpoint ditutup dengan sisa $unconfirmed unit.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkpointsAsync = ref.watch(tripCheckpointsStreamProvider(widget.tripId));

    return Scaffold(
      appBar: BawaAppBar(
        title: 'Cek Sebelum Pulang',
        subtitle: 'Pastikan barang bawaan tidak tertinggal',
        actions: [
          IconButton(
            tooltip: 'Buat Checkpoint Baru',
            icon: const Icon(Icons.add_task_outlined),
            onPressed: () => _handleCreateCheckpoint(context),
          ),
        ],
      ),
      body: checkpointsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat checkpoint: $err')),
        data: (checkpoints) {
          if (checkpoints.isEmpty) {
            return BawaEmptyState(
              icon: Icons.checklist_rtl_rounded,
              title: 'Belum Ada Checkpoint Pulang',
              message:
                  'Checkpoint mengambil snapshot dari seluruh barang yang dikemas saat ini (packed_quantity > 0) untuk memastikan tidak ada barang tertinggal saat pulang atau pindah tujuan.',
              actionLabel: 'Buat Checkpoint Sekarang',
              onAction: () => _handleCreateCheckpoint(context),
            );
          }

          // Tentukan checkpoint aktif
          CheckpointWithDetails activeCheckpoint = checkpoints.first;
          if (_selectedCheckpointId != null) {
            final found = checkpoints.firstWhere(
              (c) => c.id == _selectedCheckpointId,
              orElse: () => checkpoints.first,
            );
            activeCheckpoint = found;
          }

          return Column(
            children: [
              // Selector jika ada lebih dari 1 checkpoint
              if (checkpoints.length > 1) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: checkpoints.map((cp) {
                      final isSelected = cp.id == activeCheckpoint.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: ChoiceChip(
                          label: Text(
                            '${cp.title} (${cp.isOpen ? "Aktif" : (cp.isCompleted ? "Lengkap" : "Sisa")})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCheckpointId = cp.id;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 1),
              ],

              // Header Status Checkpoint Aktif
              _buildCheckpointHeader(activeCheckpoint),
              const Divider(height: 1),

              // Daftar Entri Barang
              Expanded(
                child: activeCheckpoint.entries.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada barang yang terdaftar di checkpoint ini.',
                          style: AppTypography.bodySecondary,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.base),
                        itemCount: activeCheckpoint.entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final entry = activeCheckpoint.entries[index];
                          return _buildEntryCard(context, entry, activeCheckpoint.isOpen);
                        },
                      ),
              ),

              // Bottom Actions
              _buildBottomAction(context, activeCheckpoint),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckpointHeader(CheckpointWithDetails cp) {
    Color bannerColor;
    Color iconColor;
    IconData iconData;
    String statusTitle;
    String statusSubtitle;

    if (cp.isOpen) {
      if (cp.isFullyConfirmed) {
        bannerColor = AppColors.successSoft;
        iconColor = AppColors.success;
        iconData = Icons.check_circle_outline;
        statusTitle = 'Semua unit barang terkonfirmasi!';
        statusSubtitle =
            'Total dikemas: ${cp.totalExpected} unit • Kembali: ${cp.totalReturned}, Habis: ${cp.totalConsumed}, Ditinggal: ${cp.totalLeft}';
      } else {
        bannerColor = AppColors.warningSoft;
        iconColor = AppColors.warning;
        iconData = Icons.warning_amber_rounded;
        statusTitle = '${cp.totalUnconfirmed} unit belum terkonfirmasi';
        statusSubtitle =
            'Total dikemas: ${cp.totalExpected} unit • Terkonfirmasi: ${cp.totalConfirmed} unit';
      }
    } else if (cp.isCompleted) {
      bannerColor = AppColors.successSoft;
      iconColor = AppColors.success;
      iconData = Icons.verified_outlined;
      statusTitle = 'Checkpoint Ditutup: Lengkap';
      statusSubtitle =
          'Ditutup pada ${_formatDateTime(cp.closedAt ?? "")} • Semua unit terkonfirmasi';
    } else {
      bannerColor = AppColors.warningSoft;
      iconColor = AppColors.warning;
      iconData = Icons.assignment_late_outlined;
      statusTitle = 'Checkpoint Ditutup dengan Catatan Sisa';
      statusSubtitle =
          'Ditutup pada ${_formatDateTime(cp.closedAt ?? "")} • ${cp.totalUnconfirmed} unit belum terkonfirmasi';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      color: bannerColor,
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: AppTypography.itemTitle.copyWith(
                    fontSize: 15,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(statusSubtitle, style: AppTypography.metadata),
              ],
            ),
          ),
          if (!cp.isOpen)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cp.isCompleted ? AppColors.success : AppColors.warning,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Text(
                cp.isCompleted ? 'SELESAI' : 'DITUTUP DG SISA',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    ReturnEntryWithItem entry,
    bool isOpen,
  ) {
    final checkpointsRepo = ref.read(checkpointsRepositoryProvider);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        side: BorderSide(
          color: entry.isFullyConfirmed ? AppColors.border : AppColors.warning.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(entry.nameSnapshot, style: AppTypography.itemTitle),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Text(
                    'Dikemas: ${entry.expectedQuantity} unit',
                    style: AppTypography.badge.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Stok master: ${entry.item?.quantity ?? "-"} ${entry.item?.unit ?? "unit"}',
              style: AppTypography.metadata,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(),
            const SizedBox(height: AppSpacing.xs),

            // Form Konfirmasi 4 Status (CORE-04)
            Row(
              children: [
                Expanded(
                  child: _buildCountSelector(
                    'Dibawa',
                    entry.returnedQuantity,
                    isOpen
                        ? (newVal) {
                            final maxAllowed = entry.expectedQuantity - (entry.consumedQuantity + entry.leftQuantity + entry.lostQuantity);
                            if (newVal <= maxAllowed && newVal >= 0) {
                              checkpointsRepo.updateReturnEntryQuantities(
                                entryId: entry.id,
                                returnedQuantity: newVal,
                                consumedQuantity: entry.consumedQuantity,
                                leftQuantity: entry.leftQuantity,
                                lostQuantity: entry.lostQuantity,
                              );
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildCountSelector(
                    'Habis',
                    entry.consumedQuantity,
                    isOpen
                        ? (newVal) {
                            final maxAllowed = entry.expectedQuantity - (entry.returnedQuantity + entry.leftQuantity + entry.lostQuantity);
                            if (newVal <= maxAllowed && newVal >= 0) {
                              checkpointsRepo.updateReturnEntryQuantities(
                                entryId: entry.id,
                                returnedQuantity: entry.returnedQuantity,
                                consumedQuantity: newVal,
                                leftQuantity: entry.leftQuantity,
                                lostQuantity: entry.lostQuantity,
                              );
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildCountSelector(
                    'Ditinggal',
                    entry.leftQuantity,
                    isOpen
                        ? (newVal) {
                            final maxAllowed = entry.expectedQuantity - (entry.returnedQuantity + entry.consumedQuantity + entry.lostQuantity);
                            if (newVal <= maxAllowed && newVal >= 0) {
                              checkpointsRepo.updateReturnEntryQuantities(
                                entryId: entry.id,
                                returnedQuantity: entry.returnedQuantity,
                                consumedQuantity: entry.consumedQuantity,
                                leftQuantity: newVal,
                                lostQuantity: entry.lostQuantity,
                              );
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _buildCountSelector(
                    'Hilang',
                    entry.lostQuantity,
                    isOpen
                        ? (newVal) {
                            final maxAllowed = entry.expectedQuantity - (entry.returnedQuantity + entry.consumedQuantity + entry.leftQuantity);
                            if (newVal <= maxAllowed && newVal >= 0) {
                              checkpointsRepo.updateReturnEntryQuantities(
                                entryId: entry.id,
                                returnedQuantity: entry.returnedQuantity,
                                consumedQuantity: entry.consumedQuantity,
                                leftQuantity: entry.leftQuantity,
                                lostQuantity: newVal,
                              );
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),

            if (entry.unconfirmedQuantity > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '⚠️ ${entry.unconfirmedQuantity} unit belum ditemukan/terkonfirmasi',
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isOpen)
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () {
                        // Cepat tandai semua sisa sebagai dibawa kembali
                        checkpointsRepo.updateReturnEntryQuantities(
                          entryId: entry.id,
                          returnedQuantity: entry.expectedQuantity - (entry.consumedQuantity + entry.leftQuantity + entry.lostQuantity),
                          consumedQuantity: entry.consumedQuantity,
                          leftQuantity: entry.leftQuantity,
                          lostQuantity: entry.lostQuantity,
                        );
                      },
                      child: const Text('Kembali Semua', style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ],

            // Catatan Barang Checkpoint
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.notes != null && entry.notes!.isNotEmpty
                        ? 'Catatan: ${entry.notes}'
                        : (isOpen ? 'Tidak ada catatan' : ''),
                    style: AppTypography.metadata.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                if (isOpen)
                  IconButton(
                    icon: const Icon(Icons.note_add_outlined, size: 18, color: AppColors.primary),
                    tooltip: 'Tambah / Ubah Catatan',
                    onPressed: () => _showNoteDialog(context, entry),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountSelector(String label, int value, ValueChanged<int>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (onChanged != null && value > 0) ? () => onChanged(value - 1) : null,
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.remove_circle_outline,
                size: 20,
                color: (onChanged != null && value > 0) ? AppColors.textSecondary : AppColors.border,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                '$value',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            InkWell(
              onTap: onChanged != null ? () => onChanged(value + 1) : null,
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.add_circle_outline,
                size: 20,
                color: onChanged != null ? AppColors.primary : AppColors.border,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, CheckpointWithDetails cp) {
    if (cp.isOpen) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: BawaButton(
          label: cp.isFullyConfirmed ? 'Tutup Checkpoint (Lengkap)' : 'Tutup dengan Catatan Sisa',
          variant: cp.isFullyConfirmed ? BawaButtonVariant.primary : BawaButtonVariant.secondary,
          icon: Icons.check_circle_outline,
          onPressed: () => _showCloseConfirmationDialog(context, cp),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: BawaButton(
          label: 'Buat Checkpoint Baru',
          icon: Icons.add,
          onPressed: () => _handleCreateCheckpoint(context),
        ),
      );
    }
  }
}
