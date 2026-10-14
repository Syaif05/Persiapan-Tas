import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/trip_departure_repository.dart';
import '../../data/repositories/trip_packing_repository.dart';

class DepartureCheckScreen extends ConsumerStatefulWidget {
  final String tripId;

  const DepartureCheckScreen({super.key, required this.tripId});

  @override
  ConsumerState<DepartureCheckScreen> createState() => _DepartureCheckScreenState();
}

class _DepartureCheckScreenState extends ConsumerState<DepartureCheckScreen> {
  bool _isLoading = false;

  Future<void> _handleQuickPack(TripItemWithDetails item) async {
    final missing = item.tripItem.plannedQuantity - item.tripItem.packedQuantity;
    if (missing <= 0) return;

    await ref.read(tripPackingRepositoryProvider).packUnit(item.tripItem.id, delta: missing);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.displayName} berhasil dikemas penuh!'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleReturnInUse(TripItemWithDetails item) async {
    await ref.read(tripPackingRepositoryProvider).returnInUseUnit(
          item.tripItem.id,
          count: item.tripItem.inUseQuantity,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.displayName} dimasukkan kembali ke tas!'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleConfirmImportant(TripItemWithDetails item) async {
    await ref.read(tripDepartureRepositoryProvider).confirmItemDepartureCheck(item.tripItem.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.displayName} telah diverifikasi secara fisik!'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleConfirmAllImportant() async {
    await ref.read(tripDepartureRepositoryProvider).confirmAllImportantItems(widget.tripId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua barang penting berhasil diverifikasi!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _departNormally() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(tripDepartureRepositoryProvider).startTripAndCreateManifest(
            tripId: widget.tripId,
            departedWithIssues: false,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perjalanan dimulai! Manifest fisik keberangkatan telah disimpan.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memulai perjalanan: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showDepartWithIssuesDialog(TripReadinessReport report) async {
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            SizedBox(width: AppSpacing.sm),
            Flexible(child: Text('Berangkat dengan Catatan?', style: AppTypography.itemTitle)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masih ada ${report.totalIssuesCount} hal yang belum selesai dikemas atau diverifikasi:',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: report.allIssues.take(5).map((issue) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              '${issue.itemName}: ${issue.description}',
                              style: AppTypography.metadata,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (report.allIssues.length > 5) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '+ ${report.allIssues.length - 5} masalah lainnya',
                  style: AppTypography.metadata,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Manifest keberangkatan akan mencatat jumlah fisik yang benar-benar ada saat ini.',
                style: AppTypography.metadata,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan Keberangkatan (opsional)',
                  hintText: 'Contoh: Payung ditinggal di rumah, charger menyusul',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal & Periksa Lagi'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Lanjutkan Berangkat'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      try {
        await ref.read(tripDepartureRepositoryProvider).startTripAndCreateManifest(
              tripId: widget.tripId,
              departureNotes: notesController.text.trim(),
              departedWithIssues: true,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perjalanan dimulai dengan catatan. Manifest fisik tersimpan.'),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memulai perjalanan: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch items stream agar perubahan packing/konfirmasi langsung menginvalidasi atau memperbarui UI
    final itemsAsync = ref.watch(tripItemsStreamProvider((tripId: widget.tripId, filter: PackingFilter.all)));
    final departureRepo = ref.watch(tripDepartureRepositoryProvider);

    return Scaffold(
      appBar: const BawaAppBar(title: 'Cek Sebelum Berangkat'),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat status: $err')),
        data: (_) {
          return FutureBuilder<TripReadinessReport>(
            future: departureRepo.evaluateReadiness(widget.tripId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
              }

              final report = snapshot.data!;
              return SafeArea(
                child: Column(
                  children: [
                    // Status Banner
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.base),
                      child: _buildReadinessBanner(report),
                    ),

                    // Issue lists & Item views
                    Expanded(
                      child: report.isReadyForDeparture
                          ? _buildAllReadyView(report)
                          : _buildIssuesListView(report),
                    ),

                    // Bottom Action Bar
                    _buildBottomActionBar(report),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReadinessBanner(TripReadinessReport report) {
    if (report.hasNoCarriedItems) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.textSecondary, size: 32),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Belum Ada Daftar Bawaan', style: AppTypography.itemTitle),
                  SizedBox(height: 2),
                  Text(
                    'Pilih barang yang akan dibawa pada detail perjalanan.',
                    style: AppTypography.metadata,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (report.isReadyForDeparture) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.successSoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 36),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Semua Siap Berangkat!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.success)),
                  const SizedBox(height: 2),
                  Text(
                    'Seluruh ${report.totalCarriedItems} baris barang telah dikemas dan diverifikasi.',
                    style: AppTypography.metadata,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.warningSoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 36),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${report.totalIssuesCount} Hal Perlu Ditinjau',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.warning),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report.fullyPackedItems}/${report.totalCarriedItems} barang telah siap penuh.',
                      style: AppTypography.metadata,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (report.unconfirmedImportantItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(color: AppColors.warning, height: 1),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${report.unconfirmedImportantItems.length} barang penting butuh konfirmasi fisik:',
                    style: AppTypography.metadata,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.done_all, size: 16),
                  label: const Text('Verifikasi Semua', style: TextStyle(fontSize: 12)),
                  onPressed: _handleConfirmAllImportant,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllReadyView(TripReadinessReport report) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child: const Icon(Icons.flight_takeoff, color: AppColors.success, size: 40),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Perjalanan "${report.tripName}" Siap!',
              style: AppTypography.screenTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Semua ${report.totalCarriedItems} barang telah dikemas dalam tas atau wadah perjalanan masing-masing. Siap berangkat tanpa ada yang tertinggal.',
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesListView(TripReadinessReport report) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      children: [
        // 1. Barang Belum Siap Dikemas
        if (report.unpackedItems.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Belum Selesai Dikemas (${report.unpackedItems.length})',
            icon: Icons.inventory_2_outlined,
            color: AppColors.warning,
          ),
          ...report.unpackedItems.map((item) {
            final missing = item.tripItem.plannedQuantity - item.tripItem.packedQuantity;
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: Icon(
                  item.isImportant ? Icons.star : Icons.inventory_2_outlined,
                  color: item.isImportant ? AppColors.warning : AppColors.textSecondary,
                ),
                title: Text(item.displayName, style: AppTypography.itemTitle),
                subtitle: Text(
                  'Asal: ${item.displayLocation} • Masuk: ${item.tripItem.packedQuantity}/${item.tripItem.plannedQuantity} (Kurang $missing)',
                  style: AppTypography.metadata,
                ),
                trailing: TextButton(
                  onPressed: () => _handleQuickPack(item),
                  child: const Text('Kemas Sisa'),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
        ],

        // 2. Barang Sedang Dipakai
        if (report.inUseItems.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Sedang Dipakai (${report.inUseItems.length})',
            icon: Icons.timelapse,
            color: AppColors.primary,
          ),
          ...report.inUseItems.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(Icons.timelapse, color: AppColors.primary),
                title: Text(item.displayName, style: AppTypography.itemTitle),
                subtitle: Text(
                  '${item.tripItem.inUseQuantity} unit sedang dipakai dan perlu dimasukkan kembali ke tas.',
                  style: AppTypography.metadata,
                ),
                trailing: TextButton(
                  onPressed: () => _handleReturnInUse(item),
                  child: const Text('Kembalikan'),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
        ],

        // 3. Barang Penting Belum Dikonfirmasi
        if (report.unconfirmedImportantItems.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Barang Penting Butuh Verifikasi (${report.unconfirmedImportantItems.length})',
            icon: Icons.star_rate_rounded,
            color: AppColors.warning,
          ),
          ...report.unconfirmedImportantItems.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(Icons.star, color: AppColors.warning),
                title: Text(item.displayName, style: AppTypography.itemTitle),
                subtitle: Text(
                  'Lokasi: ${item.displayLocation} • ${item.allocationSummary}',
                  style: AppTypography.metadata,
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warningSoft,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                  ),
                  onPressed: () => _handleConfirmImportant(item),
                  child: const Text('Verifikasi Fisik'),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
        ],

        // 4. Bentrok Jadwal / Konflik
        if (report.conflictItems.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Potensi Bentrok Jadwal (${report.conflictItems.length})',
            icon: Icons.event_busy,
            color: AppColors.error,
          ),
          ...report.conflictItems.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(Icons.error_outline, color: AppColors.error),
                title: Text(item.displayName, style: AppTypography.itemTitle),
                subtitle: Text(
                  item.conflictMessage ?? 'Item digunakan pada perjalanan lain yang beririsan.',
                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(TripReadinessReport report) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: report.isReadyForDeparture
          ? BawaButton(
              label: 'Mulai Perjalanan Sekarang',
              icon: Icons.flight_takeoff,
              isLoading: _isLoading,
              onPressed: _departNormally,
            )
          : Row(
              children: [
                Expanded(
                  child: BawaButton(
                    label: 'Berangkat dengan Catatan',
                    icon: Icons.playlist_add_check,
                    isLoading: _isLoading,
                    onPressed: () => _showDepartWithIssuesDialog(report),
                  ),
                ),
              ],
            ),
    );
  }
}
