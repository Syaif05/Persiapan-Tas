import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/datetime_utils.dart';
import '../../core/widgets/bawa_button.dart';
import '../../core/widgets/bawa_filter_chip.dart';
import '../../core/widgets/bawa_progress_bar.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/trips_repository.dart';
import '../../data/repositories/trip_packing_repository.dart';
import '../../data/repositories/trip_departure_repository.dart';
import 'departure_check_screen.dart';
import 'trip_item_picker_sheet.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _subTabController;
  PackingFilter _currentFilter = PackingFilter.all;

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  String _formatDates(String start, String? end) {
    try {
      final s = DateTime.parse(start);
      final fmt = DateFormat('d MMM yyyy');
      if (end != null && end.isNotEmpty) {
        final e = DateTime.parse(end);
        return '${fmt.format(s)} - ${fmt.format(e)}';
      }
      return '${fmt.format(s)} (Fleksibel)';
    } catch (_) {
      return '$start - ${end ?? "Fleksibel"}';
    }
  }

  void _showDepartureCheck(BuildContext context, TripWithDetails details) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DepartureCheckScreen(tripId: widget.tripId),
      ),
    );
  }

  void _showManifestDetailsSheet(BuildContext context, TripWithDetails details) {
    final departureRepo = ref.read(tripDepartureRepositoryProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StreamBuilder<DepartureManifestWithDetails?>(
          stream: departureRepo.watchDepartureManifest(widget.tripId),
          builder: (context, snapshot) {
            final manifestDetails = snapshot.data;

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),
              ),
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Manifest Keberangkatan',
                          style: AppTypography.itemTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (manifestDetails == null) ...[
                    // Legacy trip without manifest (QA-37)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.base),
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSheet),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.history, color: AppColors.textSecondary),
                              SizedBox(width: AppSpacing.sm),
                              Text('Data Lama (Belum Ada Manifest)', style: AppTypography.itemTitle),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Perjalanan ini belum memiliki snapshot manifest fisik keberangkatan.',
                            style: AppTypography.bodySecondary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          BawaButton(
                            label: 'Buat Baseline dari Catatan Sekarang',
                            variant: BawaButtonVariant.secondary,
                            onPressed: () async {
                              await departureRepo.createLegacyBaselineManifest(widget.tripId);
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(content: Text('Baseline manifest berhasil dibuat.')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Manifest summary banner
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: manifestDetails.manifest.isDepartedWithIssues ? AppColors.warningSoft : AppColors.successSoft,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                        border: Border.all(
                          color: manifestDetails.manifest.isDepartedWithIssues ? AppColors.warning : AppColors.success,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                manifestDetails.manifest.isDepartedWithIssues ? Icons.warning_amber_rounded : Icons.verified_outlined,
                                color: manifestDetails.manifest.isDepartedWithIssues ? AppColors.warning : AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  manifestDetails.manifest.isDepartedWithIssues
                                      ? 'Berangkat dengan Catatan'
                                      : 'Snapshot Fisik Terverifikasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: manifestDetails.manifest.isDepartedWithIssues ? AppColors.warning : AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (manifestDetails.manifest.departureNotes != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Catatan: ${manifestDetails.manifest.departureNotes}',
                              style: AppTypography.metadata,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Sumber: ${manifestDetails.manifest.sourceLabel} • ${manifestDetails.totalCarriedQuantity} unit dibawa • ${manifestDetails.totalDeficiencyQuantity} unit kurang',
                            style: AppTypography.metadata,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Daftar Fisik Saat Keberangkatan:', style: AppTypography.itemTitle),
                    const SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: ListView.separated(
                        itemCount: manifestDetails.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final mItem = manifestDetails.items[index];
                          final hasDeficiency = mItem.deficiencyQuantity > 0;

                          return ListTile(
                            leading: Icon(
                              mItem.isImportant ? Icons.star : Icons.inventory_2_outlined,
                              color: mItem.isImportant ? AppColors.warning : AppColors.textSecondary,
                            ),
                            title: Text(mItem.itemNameSnapshot, style: AppTypography.itemTitle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Asal: ${mItem.storageLocationSnapshot ?? "Lokasi belum dicatat"} • Dibawa: ${mItem.carriedQuantity}/${mItem.plannedQuantity} ${mItem.itemUnitSnapshot}',
                                  style: AppTypography.metadata,
                                ),
                                if (hasDeficiency)
                                  Text(
                                    'Kurang: ${mItem.deficiencyQuantity} unit saat berangkat',
                                    style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold),
                                  ),
                                if (mItem.notes != null && mItem.notes!.isNotEmpty)
                                  Text(
                                    mItem.notes!,
                                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit_note, size: 20),
                              tooltip: 'Koreksi Jumlah',
                              onPressed: () => _showCorrectManifestItemDialog(ctx, mItem),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCorrectManifestItemDialog(BuildContext context, DepartureManifestItemEntry item) async {
    final qtyController = TextEditingController(text: item.carriedQuantity.toString());
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Koreksi ${item.itemNameSnapshot}', style: AppTypography.itemTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Jumlah tercatat saat ini: ${item.carriedQuantity} unit (Rencana: ${item.plannedQuantity}).',
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Fisik Sebenarnya',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Alasan Koreksi',
                hintText: 'Contoh: Ternyata terselip di kantong jaket',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Simpan Koreksi'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      final newQty = int.tryParse(qtyController.text.trim()) ?? item.carriedQuantity;
      final reason = reasonController.text.trim();
      if (reason.isEmpty) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Alasan koreksi wajib diisi.')),
        );
        return;
      }

      await ref.read(tripDepartureRepositoryProvider).correctManifestItem(
            manifestItemId: item.id,
            newCarriedQuantity: newQty,
            reason: reason,
          );
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(content: Text('Manifest berhasil dikoreksi.')),
        );
      }
    }
  }

  void _showDuplicateDialog(BuildContext context, TripWithDetails details) {
    final nameCtrl = TextEditingController(text: '${details.trip.name} (Salinan)');
    final startDateCtrl = TextEditingController(text: details.trip.startDate);
    final endDateCtrl = TextEditingController(text: details.trip.endDate ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Duplikasi Perjalanan', style: AppTypography.itemTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Barang dan jumlah rencana akan disalin. Status packing akan direset ke 0 (belum dikemas). Tiket dan tas lama tidak disalin.',
                  style: AppTypography.metadata,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('Nama Perjalanan Baru', style: AppTypography.body),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(hintText: 'Nama perjalanan'),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text('Tanggal Mulai (YYYY-MM-DD)', style: AppTypography.body),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: startDateCtrl,
                  decoration: const InputDecoration(hintText: '2026-11-01'),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text('Tanggal Selesai (Opsional)', style: AppTypography.body),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: endDateCtrl,
                  decoration: const InputDecoration(hintText: '2026-11-05'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                final newName = nameCtrl.text.trim();
                final newStart = startDateCtrl.text.trim();
                final newEnd = endDateCtrl.text.trim();
                if (newName.isEmpty || newStart.isEmpty) return;

                Navigator.of(ctx).pop();
                try {
                  final newId = await ref.read(tripsRepositoryProvider).duplicateTrip(
                        originalTripId: widget.tripId,
                        newName: newName,
                        newStartDate: newStart,
                        newEndDate: newEnd.isNotEmpty ? newEnd : null,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perjalanan berhasil diduplikasi')),
                    );
                    context.push('/trips/$newId');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal duplikasi: $e'), backgroundColor: AppColors.error),
                    );
                  }
                }
              },
              child: const Text('Duplikasi'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmAndChangeStatus(BuildContext context, TripEntry trip, String newStatus) async {
    if (trip.status == newStatus) return;

    final statusLabels = {
      'planning': 'Dalam Persiapan',
      'ongoing': 'Sedang Berlangsung',
      'completed': 'Selesai',
      'cancelled': 'Dibatalkan',
    };

    final oldLabel = statusLabels[trip.status] ?? trip.status;
    final newLabel = statusLabels[newStatus] ?? newStatus;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.swap_horiz, color: AppColors.primary),
            SizedBox(width: AppSpacing.sm),
            Text('Ubah Status Perjalanan', style: AppTypography.itemTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin mengubah status perjalanan "${trip.name}"?'),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Text(oldLabel, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                  ),
                  Text(newLabel, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Status ini bersifat fleksibel dan dapat diubah kembali kapan saja jika tidak sengaja tertekan.',
              style: AppTypography.metadata,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Ubah Status'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final oldStatus = trip.status;
      await ref.read(tripsRepositoryProvider).updateTripStatus(trip.id, newStatus);
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status perjalanan diubah menjadi "$newLabel"'),
            action: SnackBarAction(
              label: 'Urungkan',
              textColor: AppColors.primarySoft,
              onPressed: () {
                ref.read(tripsRepositoryProvider).updateTripStatus(trip.id, oldStatus);
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showChangeStatusSheet(BuildContext context, TripEntry trip) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),
        ),
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Pilih Status Perjalanan', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Status dapat diubah kembali kapan saja jika tidak sengaja tertekan.',
              style: AppTypography.metadata,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildStatusOptionTile(
              sheetCtx: sheetCtx,
              trip: trip,
              targetStatus: 'planning',
              label: 'Dalam Persiapan',
              icon: Icons.edit_calendar_outlined,
              description: 'Sedang memilih barang dan menyusun jadwal',
            ),
            _buildStatusOptionTile(
              sheetCtx: sheetCtx,
              trip: trip,
              targetStatus: 'ongoing',
              label: 'Sedang Berlangsung',
              icon: Icons.flight_takeoff,
              description: 'Perjalanan sedang aktif dijalani',
            ),
            _buildStatusOptionTile(
              sheetCtx: sheetCtx,
              trip: trip,
              targetStatus: 'completed',
              label: 'Selesai',
              icon: Icons.check_circle_outline,
              description: 'Perjalanan sudah selesai dilaksanakan',
            ),
            _buildStatusOptionTile(
              sheetCtx: sheetCtx,
              trip: trip,
              targetStatus: 'cancelled',
              label: 'Dibatalkan',
              icon: Icons.cancel_outlined,
              description: 'Perjalanan tidak jadi dilaksanakan',
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOptionTile({
    required BuildContext sheetCtx,
    required TripEntry trip,
    required String targetStatus,
    required String label,
    required IconData icon,
    required String description,
  }) {
    final isSelected = trip.status == targetStatus;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected ? AppColors.primary : AppColors.surfaceMuted,
        foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
        child: Icon(icon, size: 20),
      ),
      title: Text(label, style: AppTypography.itemTitle),
      subtitle: Text(description, style: AppTypography.metadata),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
      onTap: () {
        Navigator.of(sheetCtx).pop();
        _confirmAndChangeStatus(context, trip, targetStatus);
      },
    );
  }

  void _showSaveAsTemplateDialog(BuildContext context, TripWithDetails details) {
    final nameCtrl = TextEditingController(text: 'Template ${details.trip.name}');
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Simpan Bawaan sbg Template', style: AppTypography.itemTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menyimpan seluruh barang yang ditandai "Dibawa" pada perjalanan ini menjadi template packing reusable.',
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Template *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Catatan (Opsional)',
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
                await ref.read(templatesRepositoryProvider).createTemplateFromTrip(
                      name: name,
                      tripId: details.trip.id,
                      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Template "$name" berhasil disimpan!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menyimpan template: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan Template'),
          ),
        ],
      ),
    );
  }

  void _showApplyTemplateSheet(BuildContext context, String tripId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return Consumer(
          builder: (context, ref, _) {
            final templatesAsync = ref.watch(templatesStreamProvider);

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Terapkan Template Packing', style: AppTypography.sectionTitle),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(sheetCtx).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: templatesAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Gagal memuat template: $err')),
                      data: (templates) {
                        if (templates.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.xl),
                              child: Text(
                                'Belum ada template packing tersimpan.\nSimpan bawaan perjalanan ini sebagai template terlebih dahulu.',
                                style: AppTypography.bodySecondary,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.base),
                          itemCount: templates.length,
                          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final template = templates[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.primarySoft,
                                  child: Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                                ),
                                title: Text(template.name, style: AppTypography.itemTitle),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (template.notes != null && template.notes!.isNotEmpty)
                                      Text(template.notes!, style: AppTypography.metadata),
                                    Text(
                                      '${template.totalItemTypes} jenis barang • ${template.totalUnits} unit total',
                                      style: AppTypography.metadata.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                trailing: FilledButton.tonal(
                                  child: const Text('Terapkan'),
                                  onPressed: () async {
                                    Navigator.of(sheetCtx).pop();
                                    try {
                                      final result = await ref
                                          .read(templatesRepositoryProvider)
                                          .applyTemplateToTrip(
                                            templateId: template.id,
                                            tripId: tripId,
                                          );

                                      if (!context.mounted) return;

                                      if (result.warnings.isNotEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (dialogCtx) => AlertDialog(
                                            title: const Row(
                                              children: [
                                                Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                                                SizedBox(width: AppSpacing.sm),
                                                Flexible(
                                                  child: Text('Peringatan Template (TPL-03)', style: AppTypography.itemTitle),
                                                ),
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Template "${template.name}" berhasil diterapkan (${result.appliedCount} barang), namun ada beberapa catatan penting:',
                                                    style: AppTypography.bodySecondary,
                                                  ),
                                                  const SizedBox(height: AppSpacing.sm),
                                                  ...result.warnings.map(
                                                    (w) => Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                          Expanded(
                                                            child: Text(w, style: AppTypography.metadata),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              FilledButton(
                                                onPressed: () => Navigator.of(dialogCtx).pop(),
                                                child: const Text('Mengerti'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Template "${template.name}" berhasil diterapkan (${result.appliedCount} barang). Kuantitas kemas direset ke 0.',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Gagal menerapkan template: $e'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddBagDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Tas Perjalanan', style: AppTypography.itemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tas perjalanan bersifat opsional untuk mengelompokkan barang.',
                style: AppTypography.metadata,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(hintText: 'Nama tas (contoh: Ransel Hitam)'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(hintText: 'Keterangan tas (opsional)'),
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
                await ref.read(tripPackingRepositoryProvider).createTripBag(
                      widget.tripId,
                      name,
                      description: descCtrl.text.trim(),
                    );
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignBagDialog(BuildContext context, TripItemWithDetails item, List<TripBagEntry> bags) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pilih Tas Perjalanan', style: AppTypography.itemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tanpa Tas (Bebas)'),
                trailing: item.tripItem.tripBagId == null ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(tripPackingRepositoryProvider).assignItemToBag(item.tripItem.id, null);
                  Navigator.of(ctx).pop();
                },
              ),
              ...bags.map((bag) {
                final isSelected = item.tripItem.tripBagId == bag.id;
                return ListTile(
                  title: Text(bag.name),
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    ref.read(tripPackingRepositoryProvider).assignItemToBag(item.tripItem.id, bag.id);
                    Navigator.of(ctx).pop();
                  },
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showQuantityDialog(BuildContext context, TripItemWithDetails item) {
    int selectedQty = item.tripItem.packedQuantity;
    final maxQty = item.tripItem.plannedQuantity;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              title: Text('Atur Jumlah Kemas', style: AppTypography.itemTitle.copyWith(fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.displayName, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Rencana bawaan: $maxQty buah', style: AppTypography.metadata),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        onPressed: selectedQty > 0
                            ? () => setDialogState(() => selectedQty--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Text('$selectedQty', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add),
                        onPressed: selectedQty < maxQty
                            ? () => setDialogState(() => selectedQty++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() => selectedQty = maxQty);
                  },
                  child: const Text('Tandai Semua Selesai'),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    final prev = await ref.read(tripPackingRepositoryProvider).updatePackedQuantity(
                          item.tripItem.id,
                          selectedQty,
                        );
                    if (context.mounted) {
                      _showUndoSnackBar(context, item.tripItem.id, prev);
                    }
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

  void _showUndoSnackBar(BuildContext context, String tripItemId, int previousQty) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Status packing diperbarui'),
        action: SnackBarAction(
          label: 'Urungkan',
          textColor: AppColors.primarySoft,
          onPressed: () {
            ref.read(tripPackingRepositoryProvider).updatePackedQuantity(tripItemId, previousQty);
          },
        ),
        duration: const Duration(seconds: 6), // 6 detik untuk aksi undo (CORE-06)
      ),
    );
  }

  void _confirmSetNotCarried(BuildContext context, TripItemWithDetails item) {
    if (item.tripItem.packedQuantity > 0) {
      // AT-04: Confirmation required before resetting packed items
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Barang Sudah Masuk Tas', style: AppTypography.itemTitle),
            content: Text(
              '${item.displayName} sudah dikemas ${item.tripItem.packedQuantity} buah. Jika diubah menjadi "Tidak dibawa", status kemas akan direset ke 0. Lanjutkan?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ref.read(tripPackingRepositoryProvider).setItemNotCarried(item.tripItem.id);
                },
                child: const Text('Reset & Tidak Dibawa'),
              ),
            ],
          );
        },
      );
    } else {
      ref.read(tripPackingRepositoryProvider).setItemNotCarried(item.tripItem.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripDetailsAsync = ref.watch(tripDetailStreamProvider(widget.tripId));
    final tripItemsAsync = ref.watch(tripItemsStreamProvider(
      (tripId: widget.tripId, filter: _currentFilter),
    ));

    return tripDetailsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Gagal memuat detail perjalanan: $err'))),
      data: (details) {
        if (details == null) {
          return const Scaffold(body: Center(child: Text('Perjalanan tidak ditemukan')));
        }

        final trip = details.trip;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.name, style: AppTypography.itemTitle.copyWith(fontSize: 18), overflow: TextOverflow.ellipsis),
                Text(_formatDates(trip.startDate, trip.endDate), style: AppTypography.metadata),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                tooltip: 'Aksi Perjalanan',
                icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                onSelected: (value) async {
                  if (value == 'checkpoint') {
                    context.push('/trips/${trip.id}/checkpoint');
                  } else if (value == 'save_as_template') {
                    _showSaveAsTemplateDialog(context, details);
                  } else if (value == 'apply_template') {
                    _showApplyTemplateSheet(context, trip.id);
                  } else if (value == 'duplicate') {
                    _showDuplicateDialog(context, details);
                  } else if (value == 'departure_check') {
                    _showDepartureCheck(context, details);
                  } else if (value == 'view_manifest') {
                    _showManifestDetailsSheet(context, details);
                  } else if (value == 'edit') {
                    context.push('/trips/edit/${trip.id}');
                  } else if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Perjalanan', style: AppTypography.itemTitle),
                        content: Text('Yakin ingin menghapus perjalanan "${trip.name}"? Seluruh daftar bawaan akan terhapus.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && mounted) {
                      await ref.read(tripsRepositoryProvider).deleteTrip(trip.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perjalanan dihapus')));
                        context.pop();
                      }
                    }
                  }
                },
                itemBuilder: (context) => [
                  if (trip.status == 'planning')
                    const PopupMenuItem(
                      value: 'departure_check',
                      child: Row(
                        children: [
                          Icon(Icons.checklist_rtl_rounded, size: 20, color: AppColors.primary),
                          SizedBox(width: AppSpacing.sm),
                          Text('Cek Sebelum Berangkat'),
                        ],
                      ),
                    ),
                  if (trip.status == 'ongoing' || trip.status == 'completed')
                    const PopupMenuItem(
                      value: 'view_manifest',
                      child: Row(
                        children: [
                          Icon(Icons.history_edu_outlined, size: 20, color: AppColors.primary),
                          SizedBox(width: AppSpacing.sm),
                          Text('Manifest Keberangkatan'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'checkpoint',
                    child: Row(
                      children: [
                        Icon(Icons.fact_check_outlined, size: 20, color: AppColors.primary),
                        SizedBox(width: AppSpacing.sm),
                        Text('Cek Sebelum Pulang'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'save_as_template',
                    child: Row(
                      children: [
                        Icon(Icons.bookmark_add_outlined, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Simpan Bawaan sbg Template'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'apply_template',
                    child: Row(
                      children: [
                        Icon(Icons.playlist_add_check_outlined, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Terapkan Template'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy_outlined, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Duplikasi Perjalanan'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Edit Perjalanan'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                        SizedBox(width: AppSpacing.sm),
                        Text('Hapus Perjalanan', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _subTabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3.0,
              tabs: const [
                Tab(text: 'Ringkasan'),
                Tab(text: 'Bawaan'),
                Tab(text: 'Jadwal'),
                Tab(text: 'Tiket'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _subTabController,
            children: [
              // 1. TAB RINGKASAN
              _buildSummaryTab(context, details),

              // 2. TAB BAWAAN
              _buildPackingTab(context, details, tripItemsAsync),

              // 3. TAB JADWAL (Fase 4)
              _buildSchedulesTab(context, details),

              // 4. TAB TIKET (Fase 4)
              _buildTicketsTab(context, details),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryTab(BuildContext context, TripWithDetails details) {
    final trip = details.trip;
    final summary = details.summary;
    final stops = details.stops;
    final bags = details.bags;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Perjalanan & Aksi Transisi (Reversible & Konfirmasi - Requirement 3)
          Card(
            color: AppColors.primarySoft.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              side: const BorderSide(color: AppColors.border),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Status Perjalanan Saat Ini', style: AppTypography.metadata),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  trip.status == 'planning'
                                      ? Icons.edit_calendar_outlined
                                      : trip.status == 'ongoing'
                                          ? Icons.flight_takeoff
                                          : trip.status == 'completed'
                                              ? Icons.check_circle_outline
                                              : Icons.cancel_outlined,
                                  size: 18,
                                  color: trip.status == 'ongoing'
                                      ? AppColors.success
                                      : trip.status == 'completed'
                                          ? AppColors.primaryDark
                                          : trip.status == 'cancelled'
                                              ? AppColors.error
                                              : AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    trip.status == 'planning'
                                        ? 'Dalam Persiapan'
                                        : trip.status == 'ongoing'
                                            ? 'Sedang Berlangsung'
                                            : trip.status == 'completed'
                                                ? 'Selesai'
                                                : 'Dibatalkan',
                                    style: AppTypography.itemTitle.copyWith(
                                      color: trip.status == 'ongoing'
                                          ? AppColors.success
                                          : trip.status == 'completed'
                                              ? AppColors.primaryDark
                                              : trip.status == 'cancelled'
                                                  ? AppColors.error
                                                  : AppColors.primaryDark,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: AppColors.primary),
                        ),
                        icon: const Icon(Icons.swap_horiz, size: 16, color: AppColors.primary),
                        label: const Text('Ubah Status', style: TextStyle(fontSize: 12)),
                        onPressed: () => _showChangeStatusSheet(context, trip),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  // Tombol Cepat Aksi Transisi (Dapat Dibalikkan Kapan Saja)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (trip.status == 'planning') ...[
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: const Text('Mulai Perjalanan'),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'ongoing'),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                          label: const Text('Batalkan', style: TextStyle(color: AppColors.error)),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'cancelled'),
                        ),
                      ] else if (trip.status == 'ongoing') ...[
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Selesaikan Perjalanan'),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'completed'),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.undo, size: 16),
                          label: const Text('Kembali ke Persiapan'),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'planning'),
                        ),
                      ] else if (trip.status == 'completed') ...[
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Aktifkan Lagi (Sedang Berjalan)'),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'ongoing'),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit_calendar_outlined, size: 16),
                          label: const Text('Kembali ke Persiapan'),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'planning'),
                        ),
                      ] else if (trip.status == 'cancelled') ...[
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.restart_alt, size: 16),
                          label: const Text('Pulihkan ke Persiapan'),
                          onPressed: () => _confirmAndChangeStatus(context, trip, 'planning'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Progres Packing Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kesiapan Bawaan', style: AppTypography.sectionTitle),
                      Flexible(
                        child: Text(
                          summary.progressLabel,
                          style: AppTypography.metadata.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  BawaProgressBar(
                    completedLines: summary.completedRows,
                    totalLines: summary.totalCarriedRows,
                    completedUnits: summary.totalPackedUnits,
                    totalUnits: summary.totalPlannedUnits,
                  ),
                  if (summary.hasUnfinishedEssential) ...[
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.warningSoft,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, color: AppColors.warning, size: 18),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Ada barang berpenanda penting yang belum dikemas!',
                              style: TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (trip.status == 'planning') ...[
                    const SizedBox(height: AppSpacing.base),
                    BawaButton(
                      label: 'Pemeriksaan Sebelum Berangkat',
                      variant: BawaButtonVariant.secondary,
                      icon: Icons.checklist_rtl_rounded,
                      onPressed: () => _showDepartureCheck(context, details),
                    ),
                  ] else ...[
                    const SizedBox(height: AppSpacing.base),
                    BawaButton(
                      label: 'Lihat Manifest Keberangkatan',
                      variant: BawaButtonVariant.secondary,
                      icon: Icons.history_edu_outlined,
                      onPressed: () => _showManifestDetailsSheet(context, details),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Card: Cek Sebelum Pulang & Checkpoint (RET-01..05)
          Consumer(
            builder: (context, ref, _) {
              final checkpointsAsync = ref.watch(tripCheckpointsStreamProvider(trip.id));

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Cek Sebelum Pulang',
                              style: AppTypography.sectionTitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.arrow_forward, size: 16),
                            label: const Text('Buka Checkpoint'),
                            onPressed: () => context.push('/trips/${trip.id}/checkpoint'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      checkpointsAsync.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (checkpoints) {
                          if (checkpoints.isEmpty) {
                            return const Text(
                              'Belum ada snapshot checkpoint. Gunakan fitur ini sebelum pulang untuk memastikan barang yang dikemas tidak tertinggal.',
                              style: AppTypography.bodySecondary,
                            );
                          }

                          final latest = checkpoints.first;
                          String statusText;
                          Color statusColor;

                          if (latest.isOpen) {
                            statusText = latest.isFullyConfirmed
                                ? 'Aktif (Semua Terkonfirmasi)'
                                : 'Aktif (${latest.totalUnconfirmed} unit belum terkonfirmasi)';
                            statusColor = latest.isFullyConfirmed ? AppColors.success : AppColors.warning;
                          } else if (latest.isCompleted) {
                            statusText = 'Selesai: Semua barang lengkap';
                            statusColor = AppColors.success;
                          } else {
                            statusText = 'Ditutup dengan sisa (${latest.totalUnconfirmed} unit belum terkonfirmasi)';
                            statusColor = AppColors.warning;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Expanded(
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${latest.title} • Dikemas: ${latest.totalExpected} • Terkonfirmasi: ${latest.totalConfirmed}',
                                style: AppTypography.metadata,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.base),

          // Rute Kota / Tujuan
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rute & Tujuan Kota', style: AppTypography.sectionTitle),
                  const SizedBox(height: AppSpacing.sm),
                  if (stops.isEmpty)
                    const Text('Belum ada kota tujuan', style: AppTypography.bodySecondary)
                  else
                    ...stops.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final stop = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primarySoft,
                              child: Text(
                                '${idx + 1}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(stop.label, style: AppTypography.itemTitle),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Tas Perjalanan (PCK-08)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Tas Perjalanan (Opsional)',
                          style: AppTypography.sectionTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Tambah Tas'),
                        onPressed: () => _showAddBagDialog(context),
                      ),
                    ],
                  ),
                  if (bags.isEmpty)
                    const Text(
                      'Pencatatan tas bersifat opsional. Kamu tetap bisa melakukan packing tanpa membuat daftar tas.',
                      style: AppTypography.bodySecondary,
                    )
                  else
                    ...bags.map((bag) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.backpack_outlined, color: AppColors.primary),
                        title: Text(bag.name, style: AppTypography.itemTitle),
                        subtitle: bag.description != null && bag.description!.isNotEmpty
                            ? Text(bag.description!, style: AppTypography.metadata)
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.textTertiary, size: 20),
                          onPressed: () => ref.read(tripPackingRepositoryProvider).deleteTripBag(bag.id),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackingTab(
    BuildContext context,
    TripWithDetails details,
    AsyncValue<List<TripItemWithDetails>> itemsAsync,
  ) {
    return Column(
      children: [
        // Filter Chips Horizontal
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
          child: Row(
            children: PackingFilter.values.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: BawaFilterChip(
                  label: filter.label,
                  isSelected: _currentFilter == filter,
                  onTap: () => setState(() => _currentFilter = filter),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1, color: AppColors.border),

        // List Barang Bawaan
        Expanded(
          child: itemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Gagal memuat bawaan: $err')),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.luggage_outlined, size: 48, color: AppColors.textTertiary),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _currentFilter == PackingFilter.all
                              ? 'Belum ada barang yang dipilih untuk perjalanan ini.'
                              : 'Tidak ada barang dengan filter "${_currentFilter.label}".',
                          style: AppTypography.bodySecondary,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        FilledButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Pilih dari Inventaris'),
                          onPressed: () => _openItemPicker(context),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.base),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildPackingItemCard(context, item, details.bags);
                },
              );
            },
          ),
        ),

        // Bottom Action Bar: Tombol Pilih dari Inventaris & Terapkan Template
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              children: [
                Expanded(
                  child: BawaButton(
                    label: 'Pilih dari Inventaris',
                    icon: Icons.add_circle_outline,
                    onPressed: () => _openItemPicker(context),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filledTonal(
                  tooltip: 'Terapkan Template Packing',
                  icon: const Icon(Icons.playlist_add_check_outlined),
                  onPressed: () => _showApplyTemplateSheet(context, widget.tripId),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openItemPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TripItemPickerSheet(tripId: widget.tripId),
    );
  }

  Widget _buildPackingItemCard(BuildContext context, TripItemWithDetails item, List<TripBagEntry> bags) {
    final packingRepo = ref.read(tripPackingRepositoryProvider);
    final tripItem = item.tripItem;
    final isCarried = tripItem.decision == 'carried';

    return Container(
      decoration: BoxDecoration(
        color: item.isCompleted ? AppColors.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
        border: Border.all(
          color: item.isCompleted ? AppColors.success.withValues(alpha: 0.4) : AppColors.border,
          width: item.isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Checkbox Button (PCK-05, CORE-01)
                if (isCarried)
                  IconButton(
                    icon: Icon(
                      item.isInUse
                          ? Icons.replay_rounded
                          : item.isCompleted
                              ? Icons.check_circle
                              : tripItem.packedQuantity > 0
                                  ? Icons.remove_circle_outline
                                  : Icons.radio_button_unchecked,
                      color: item.isInUse
                          ? AppColors.warning
                          : item.isCompleted
                              ? AppColors.success
                              : tripItem.packedQuantity > 0
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                      size: 26,
                    ),
                    tooltip: item.isInUse ? 'Kembalikan ke tas' : 'Kemas / Buka',
                    onPressed: () async {
                      if (item.isInUse) {
                        await packingRepo.returnInUseUnit(tripItem.id, count: item.inUseQuantity);
                      } else if (tripItem.plannedQuantity == 1) {
                        final res = await packingRepo.quickTogglePacked(tripItem.id);
                        if (context.mounted) _showUndoSnackBar(context, tripItem.id, res.previous);
                      } else {
                        _showQuantityDialog(context, item);
                      }
                    },
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.block, color: AppColors.textTertiary, size: 22),
                  ),

                // Informasi Barang & Asal Kotak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.displayName,
                              style: AppTypography.itemTitle.copyWith(
                                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                color: item.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.isPackedLast)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.purple.shade300, width: 0.8),
                              ),
                              child: Text(
                                'TERAKHIR',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
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
                                style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // PCK-07: Asal kotak terlihat jelas
                      Text(
                        'Asal: ${item.displayLocation}',
                        style: AppTypography.metadata.copyWith(color: AppColors.primaryDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.tripBagName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Tas: ${item.tripBagName}',
                          style: AppTypography.metadata.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                      if (item.isInUse) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 13, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(
                              '${item.inUseQuantity} sedang dipakai',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 2),
                      // CORE-01: Waktu konfirmasi fisik
                      Text(
                        AppDateTimeUtils.formatConfirmationTime(item.lastPhysicallyConfirmedAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: item.lastPhysicallyConfirmedAt != null ? AppColors.textTertiary : AppColors.textTertiary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Kuantitas & Menu Item
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isCarried)
                      InkWell(
                        onTap: () => _showQuantityDialog(context, item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.isInUse
                                ? AppColors.warningSoft
                                : item.isCompleted
                                    ? AppColors.successSoft
                                    : AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${tripItem.packedQuantity}/${tripItem.plannedQuantity}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: item.isInUse
                                  ? AppColors.warning
                                  : item.isCompleted
                                      ? AppColors.success
                                      : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Tidak dibawa', style: TextStyle(fontSize: 11)),
                      ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: AppColors.textTertiary, size: 20),
                      onSelected: (action) async {
                        if (action == 'unpack') {
                          await packingRepo.unpackUnit(item.tripItem.id, delta: 1);
                        } else if (action == 'in_use') {
                          await packingRepo.setUnitInUse(item.tripItem.id, count: 1);
                        } else if (action == 'return_in_use') {
                          await packingRepo.returnInUseUnit(item.tripItem.id, count: item.inUseQuantity > 0 ? item.inUseQuantity : 1);
                        } else if (action == 'assign_bag') {
                          _showAssignBagDialog(context, item, bags);
                        } else if (action == 'not_carried') {
                          _confirmSetNotCarried(context, item);
                        } else if (action == 'carried') {
                          packingRepo.setPlannedItem(
                            tripId: widget.tripId,
                            itemId: item.tripItem.itemId,
                            plannedQuantity: 1,
                          );
                        } else if (action == 'remove') {
                          if (item.packedQuantity > 0 || item.inUseQuantity > 0) {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Hapus dari Daftar Bawaan?'),
                                content: Text(
                                  '${item.displayName} sudah disiapkan (${item.packedQuantity} dikemas${item.inUseQuantity > 0 ? ', ${item.inUseQuantity} dipakai' : ''}). Yakin ingin menghapus dari rencana perjalanan ini?',
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                  FilledButton(
                                    style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Hapus dari Bawaan'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm != true) return;
                          }
                          await packingRepo.removeTripItem(item.tripItem.id);
                        } else if (action == 'toggle_packed_last') {
                          await packingRepo.togglePackedLast(item.tripItem.id, !item.isPackedLast);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  item.isPackedLast
                                      ? '${item.displayName} tidak lagi ditandai disiapkan terakhir'
                                      : '${item.displayName} ditandai disiapkan terakhir',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                      itemBuilder: (ctx) => [
                        if (item.packedQuantity > 0) ...[
                          const PopupMenuItem(
                            value: 'unpack',
                            child: Row(
                              children: [
                                Icon(Icons.remove_circle_outline, size: 18, color: AppColors.textSecondary),
                                SizedBox(width: 8),
                                Text('Keluarkan 1 Unit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'in_use',
                            child: Row(
                              children: [
                                Icon(Icons.lock_clock, size: 18, color: AppColors.warning),
                                SizedBox(width: 8),
                                Text('Tandai Sedang Dipakai'),
                              ],
                            ),
                          ),
                        ],
                        if (item.inUseQuantity > 0)
                          const PopupMenuItem(
                            value: 'return_in_use',
                            child: Row(
                              children: [
                                Icon(Icons.replay_rounded, size: 18, color: AppColors.success),
                                SizedBox(width: 8),
                                Text('Masukkan Kembali ke Tas'),
                              ],
                            ),
                          ),
                        if (bags.isNotEmpty && isCarried)
                          const PopupMenuItem(value: 'assign_bag', child: Text('Pilih Tas')),
                        if (isCarried) ...[
                          PopupMenuItem(
                            value: 'toggle_packed_last',
                            child: Row(
                              children: [
                                Icon(
                                  item.isPackedLast ? Icons.alarm_off : Icons.alarm_on,
                                  size: 18,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 8),
                                Text(item.isPackedLast ? 'Batal Siapkan Terakhir' : 'Disiapkan Terakhir'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(value: 'not_carried', child: Text('Tandai Tidak Dibawa')),
                        ] else
                          const PopupMenuItem(value: 'carried', child: Text('Tandai Dibawa')),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('Hapus dari Perjalanan', style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Peringatan Konflik Tanggal Overlap (PCK-09)
            if (item.hasConflict) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.warning, size: 16),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item.conflictMessage ?? 'Potensi bentrok tanggal',
                        style: const TextStyle(color: AppColors.warning, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulesTab(BuildContext context, TripWithDetails details) {
    final schedulesAsync = ref.watch(tripSchedulesStreamProvider(widget.tripId));

    return schedulesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat jadwal: $err')),
      data: (schedules) {
        if (schedules.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: AppSpacing.base),
                  const Text('Belum ada jadwal', style: AppTypography.itemTitle),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Tambah jadwal transportasi, akomodasi, atau kegiatan agar perjalananmu terstruktur.',
                    style: AppTypography.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Jadwal'),
                    onPressed: () {
                      context.push('/trips/${widget.tripId}/schedules/new');
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${schedules.length} Agenda Jadwal',
                  style: AppTypography.sectionTitle,
                ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Jadwal'),
                  onPressed: () {
                    context.push('/trips/${widget.tripId}/schedules/new');
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...schedules.map((item) {
              IconData typeIcon;
              const iconColor = AppColors.primary;
              switch (item.type) {
                case 'transport':
                  typeIcon = Icons.directions_transit_outlined;
                  break;
                case 'lodging':
                  typeIcon = Icons.hotel_outlined;
                  break;
                case 'activity':
                  typeIcon = Icons.local_activity_outlined;
                  break;
                case 'preparation':
                  typeIcon = Icons.checklist_outlined;
                  break;
                default:
                  typeIcon = Icons.event_outlined;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Icon(typeIcon, color: iconColor, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTypography.itemTitle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.formattedDate} • ${item.formattedTime}',
                                  style: AppTypography.metadata.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            if (item.tripStop != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_city, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.tripStop!.label,
                                    style: AppTypography.metadata,
                                  ),
                                ],
                              ),
                            ],
                            if (item.locationText != null && item.locationText!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.locationText!,
                                      style: AppTypography.metadata,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (item.linkedTickets.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${item.linkedTickets.length} tiket terhubung',
                                  style: AppTypography.metadata.copyWith(fontSize: 11),
                                ),
                              ),
                            ],
                            if (item.hasReminders) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: item.hasActiveReminders
                                      ? AppColors.primarySoft
                                      : (item.hasPendingPermissionReminders
                                          ? AppColors.warningSoft
                                          : AppColors.surfaceMuted),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.hasActiveReminders
                                          ? Icons.notifications_active_outlined
                                          : (item.hasPendingPermissionReminders
                                              ? Icons.notifications_off_outlined
                                              : Icons.notifications_none_outlined),
                                      size: 12,
                                      color: item.hasActiveReminders
                                          ? AppColors.primary
                                          : (item.hasPendingPermissionReminders
                                              ? AppColors.warning
                                              : AppColors.textSecondary),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.reminders.length} pengingat',
                                      style: AppTypography.metadata.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: item.hasActiveReminders
                                            ? AppColors.primary
                                            : (item.hasPendingPermissionReminders
                                                ? AppColors.warning
                                                : AppColors.textSecondary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Aksi',
                        onSelected: (val) async {
                          if (val == 'edit') {
                            context.push('/trips/${widget.tripId}/schedules/edit/${item.id}');
                          } else if (val == 'delete') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Hapus Jadwal', style: AppTypography.itemTitle),
                                content: Text('Hapus jadwal "${item.title}"? Tiket yang terhubung akan tetap tersimpan.'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
                                  FilledButton(
                                    style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await ref.read(schedulesRepositoryProvider).deleteSchedule(item.id);
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit Jadwal')),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Hapus', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildTicketsTab(BuildContext context, TripWithDetails details) {
    final ticketsAsync = ref.watch(tripTicketsStreamProvider(widget.tripId));

    return ticketsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat tiket: $err')),
      data: (tickets) {
        if (tickets.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.confirmation_number_outlined, size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: AppSpacing.base),
                  const Text('Belum ada tiket', style: AppTypography.itemTitle),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Simpan nomor reservasi dan lampirkan tiket PDF atau foto barcode agar selalu siap dibuka offline.',
                    style: AppTypography.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Tiket'),
                    onPressed: () {
                      context.push('/trips/${widget.tripId}/tickets/new');
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tickets.length} Tiket & Reservasi',
                  style: AppTypography.sectionTitle,
                ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Tiket'),
                  onPressed: () {
                    context.push('/trips/${widget.tripId}/tickets/new');
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...tickets.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  onTap: () {
                    context.push('/trips/${widget.tripId}/tickets/${item.id}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 24),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppTypography.itemTitle.copyWith(fontSize: 16),
                                  ),
                                  if (item.provider != null && item.provider!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      item.provider!,
                                      style: AppTypography.metadata,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                context.push('/trips/${widget.tripId}/tickets/${item.id}');
                              },
                            ),
                          ],
                        ),
                        if (item.bookingCode != null && item.bookingCode!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('KODE: ', style: AppTypography.badge),
                                Text(
                                  item.bookingCode!,
                                  style: AppTypography.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              item.attachments.isNotEmpty ? Icons.attach_file : Icons.attachment,
                              size: 14,
                              color: item.attachments.isNotEmpty ? AppColors.primary : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.attachments.isEmpty
                                  ? 'Belum ada lampiran berkas'
                                  : '${item.attachments.length} berkas tersimpan offline',
                              style: AppTypography.metadata.copyWith(
                                color: item.attachments.isNotEmpty ? AppColors.primaryDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
