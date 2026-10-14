import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_button.dart';
import '../../core/widgets/bawa_filter_chip.dart';
import '../../core/widgets/bawa_progress_bar.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/trips_repository.dart';

enum HomeTripFilter {
  all('Semua'),
  active('Aktif'),
  completed('Selesai');

  final String label;
  const HomeTripFilter(this.label);
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  HomeTripFilter _tripFilter = HomeTripFilter.all;

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

  @override
  Widget build(BuildContext context) {
    final allTripsAsync = ref.watch(allTripsWithDetailsStreamProvider(null));
    final inventoryAsync = ref.watch(filteredInventoryStreamProvider);
    final locationsAsync = ref.watch(activeLocationsStreamProvider);
    final agendaAsync = ref.watch(globalAgendaStreamProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/logo/logo_96.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.luggage_rounded, color: AppColors.primary, size: 20),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Siapkan Tas', style: AppTypography.screenTitle),
                  Text(
                    'Barang, Bawaan & Perjalanan',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cari Barang Terpadu (FIND-01)',
            icon: const Icon(Icons.search, color: AppColors.textPrimary, size: 24),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            tooltip: 'Tambah Perjalanan Baru',
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 26),
            onPressed: () => context.push('/trips/new'),
          ),
          IconButton(
            tooltip: 'Pengaturan & Backup',
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push('/settings'),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Micro-Stats Overview Bar (Minimalis & Elegan)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 350),
              builder: (context, val, child) {
                return Opacity(
                  opacity: val,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - val)),
                    child: child,
                  ),
                );
              },
              child: _buildOverviewStats(allTripsAsync.value ?? [], inventoryAsync.value?.length ?? 0, locationsAsync.value?.length ?? 0),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 1: Ringkasan Seluruh Daftar Perjalanan (Requirement 1 & 5)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Daftar Seluruh Perjalanan', style: AppTypography.sectionTitle),
                ),
                TextButton.icon(
                  onPressed: () => context.push('/trips/new'),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Baru', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Filter Chips Perjalanan (Semua, Aktif, Selesai)
            allTripsAsync.when(
              data: (allTrips) {
                final activeCount = allTrips.where((t) => t.trip.status == 'planning' || t.trip.status == 'ongoing').length;
                final completedCount = allTrips.where((t) => t.trip.status == 'completed').length;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      BawaFilterChip(
                        label: 'Semua (${allTrips.length})',
                        isSelected: _tripFilter == HomeTripFilter.all,
                        onTap: () => setState(() => _tripFilter = HomeTripFilter.all),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      BawaFilterChip(
                        label: 'Aktif ($activeCount)',
                        isSelected: _tripFilter == HomeTripFilter.active,
                        onTap: () => setState(() => _tripFilter = HomeTripFilter.active),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      BawaFilterChip(
                        label: 'Selesai ($completedCount)',
                        isSelected: _tripFilter == HomeTripFilter.completed,
                        onTap: () => setState(() => _tripFilter = HomeTripFilter.completed),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: AppSpacing.md),

            // Daftar Kartu Perjalanan
            allTripsAsync.when(
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (err, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Text('Gagal memuat daftar perjalanan: $err'),
                ),
              ),
              data: (allTrips) {
                if (allTrips.isEmpty) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.flight_takeoff, color: AppColors.primary, size: 28),
                              SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text('Belum Ada Perjalanan Aktif', style: AppTypography.itemTitle),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Buat perjalanan pertama kamu untuk mulai memilih barang bawaan ke dalam tas.',
                            style: AppTypography.bodySecondary,
                          ),
                          const SizedBox(height: AppSpacing.base),
                          BawaButton(
                            label: 'Buat Perjalanan Baru',
                            icon: Icons.add,
                            onPressed: () => context.push('/trips/new'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredList = allTrips.where((t) {
                  if (_tripFilter == HomeTripFilter.active) {
                    return t.trip.status == 'planning' || t.trip.status == 'ongoing';
                  } else if (_tripFilter == HomeTripFilter.completed) {
                    return t.trip.status == 'completed';
                  }
                  return true;
                }).toList();

                if (filteredList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Center(
                      child: Text(
                        'Tidak ada perjalanan dengan filter "${_tripFilter.label}".',
                        style: AppTypography.bodySecondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(item.trip.id),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 60)),
                      builder: (context, val, child) {
                        return Opacity(
                          opacity: val,
                          child: Transform.translate(
                            offset: Offset(0, 15 * (1 - val)),
                            child: child,
                          ),
                        );
                      },
                      child: _buildTripCard(context, item),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Section 2: Jadwal Terdekat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Jadwal Berikutnya', style: AppTypography.sectionTitle),
                ),
                TextButton(
                  onPressed: () => context.go('/agenda'),
                  child: const Text('Buka Agenda', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            agendaAsync.when(
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.base),
                  child: Center(child: LinearProgressIndicator()),
                ),
              ),
              error: (err, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Text('Gagal memuat jadwal: $err'),
                ),
              ),
              data: (schedules) {
                if (schedules.isEmpty) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: InkWell(
                      onTap: () => context.go('/agenda'),
                      borderRadius: AppSpacing.roundedCard,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.base),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                              ),
                              child: const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Belum Ada Jadwal Terdekat', style: AppTypography.itemTitle),
                                  SizedBox(height: 2),
                                  Text(
                                    'Buka Agenda untuk melihat kalender atau menambah tiket & jadwal.',
                                    style: AppTypography.metadata,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final nextSchedule = schedules.first;
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: InkWell(
                    onTap: () => context.go('/agenda'),
                    borderRadius: AppSpacing.roundedCard,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.base),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                            ),
                            child: const Icon(Icons.event_available_outlined, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nextSchedule.title,
                                  style: AppTypography.itemTitle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${nextSchedule.formattedDate} • ${nextSchedule.formattedTime}',
                                  style: AppTypography.metadata.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Perjalanan: ${nextSchedule.trip.name}',
                                  style: AppTypography.metadata,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats(List<TripWithDetails> trips, int totalItems, int totalLocations) {
    final activeTrips = trips.where((t) => t.trip.status == 'planning' || t.trip.status == 'ongoing').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _tripFilter = HomeTripFilter.active),
              child: Column(
                children: [
                  Text(
                    '$activeTrips',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 2),
                  const Text('Perjalanan Aktif', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 32, color: AppColors.border),
          Expanded(
            child: InkWell(
              onTap: () => context.go('/inventory'),
              child: Column(
                children: [
                  Text(
                    '$totalItems',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  const Text('Barang Tersimpan', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 32, color: AppColors.border),
          Expanded(
            child: InkWell(
              onTap: () => context.push('/inventory/locations'),
              child: Column(
                children: [
                  Text(
                    '$totalLocations',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  const Text('Lokasi / Kotak', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, TripWithDetails details) {
    final trip = details.trip;
    final summary = details.summary;
    final stopsText = details.stops.map((s) => s.label).join(' ➔ ');

    final isOngoing = trip.status == 'ongoing';
    final isCompleted = trip.status == 'completed';
    final isCancelled = trip.status == 'cancelled';

    final Color statusBg = isOngoing
        ? AppColors.successSoft
        : isCompleted
            ? AppColors.surfaceMuted
            : isCancelled
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.primarySoft;

    final Color statusTextColor = isOngoing
        ? AppColors.success
        : isCompleted
            ? AppColors.textSecondary
            : isCancelled
                ? AppColors.error
                : AppColors.primaryDark;

    final String statusLabel = isOngoing
        ? 'Sedang Berlangsung'
        : isCompleted
            ? 'Selesai'
            : isCancelled
                ? 'Dibatalkan'
                : 'Dalam Persiapan';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: BorderSide(
          color: isOngoing ? AppColors.success.withValues(alpha: 0.5) : AppColors.border,
          width: isOngoing ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/trips/${trip.id}'),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Kartu: Nama & Badge Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      trip.name,
                      style: AppTypography.itemTitle.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Tanggal & Rute Kota
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _formatDates(trip.startDate, trip.endDate),
                      style: AppTypography.metadata,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (stopsText.isNotEmpty) ...[
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        stopsText,
                        style: AppTypography.metadata.copyWith(color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              // Progress Bar Kesiapan Bawaan
              BawaProgressBar(
                completedLines: summary.completedRows,
                totalLines: summary.totalCarriedRows,
                completedUnits: summary.totalPackedUnits,
                totalUnits: summary.totalPlannedUnits,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Baris Aksi Cepat (Wrap agar adaptif di layar sempit / font besar)
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    summary.totalCarriedRows == 0
                        ? 'Belum ada barang di tas'
                        : '${summary.completedRows}/${summary.totalCarriedRows} jenis barang siap',
                    style: AppTypography.metadata,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 14),
                    label: const Text('Buka Bawaan & Packing', style: TextStyle(fontSize: 12)),
                    onPressed: () => context.push('/trips/${trip.id}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
