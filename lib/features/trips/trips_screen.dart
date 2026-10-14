import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_empty_state.dart';
import '../../core/widgets/bawa_progress_bar.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({super.key});

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planningAsync = ref.watch(tripsStreamProvider('planning'));
    final ongoingAsync = ref.watch(tripsStreamProvider('ongoing'));
    final completedAsync = ref.watch(tripsStreamProvider('completed'));

    final planningCount = planningAsync.value?.length ?? 0;
    final ongoingCount = ongoingAsync.value?.length ?? 0;
    final completedCount = completedAsync.value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perjalanan', style: AppTypography.screenTitle),
        actions: [
          IconButton(
            tooltip: 'Buat Perjalanan Baru',
            icon: const Icon(Icons.add, color: AppColors.primary, size: 28),
            onPressed: () => context.push('/trips/new'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3.0,
          tabs: [
            Tab(text: 'Persiapan ($planningCount)'),
            Tab(text: 'Berlangsung ($ongoingCount)'),
            Tab(text: 'Riwayat ($completedCount)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTripList(
            asyncValue: planningAsync,
            emptyTitle: 'Belum ada perjalanan persiapan',
            emptySubtitle: 'Buat perjalanan baru untuk mulai memilih barang bawaan dan tas.',
            actionLabel: 'Buat Perjalanan',
            onAction: () => context.push('/trips/new'),
          ),
          _buildTripList(
            asyncValue: ongoingAsync,
            emptyTitle: 'Tidak ada perjalanan aktif',
            emptySubtitle: 'Perjalanan yang dimulai akan berpindah ke tab ini.',
          ),
          _buildTripList(
            asyncValue: completedAsync,
            emptyTitle: 'Belum ada riwayat perjalanan',
            emptySubtitle: 'Perjalanan yang telah diselesaikan akan tersimpan rapi di sini.',
          ),
        ],
      ),
    );
  }

  Widget _buildTripList({
    required AsyncValue<List<TripEntry>> asyncValue,
    required String emptyTitle,
    required String emptySubtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat perjalanan: $err')),
      data: (trips) {
        if (trips.isEmpty) {
          return BawaEmptyState(
            icon: Icons.luggage_outlined,
            title: emptyTitle,
            message: emptySubtitle,
            actionLabel: actionLabel,
            onAction: onAction,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.base),
          itemCount: trips.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.base),
          itemBuilder: (context, index) {
            return _TripCard(trip: trips[index]);
          },
        );
      },
    );
  }
}

class _TripCard extends ConsumerWidget {
  final TripEntry trip;

  const _TripCard({required this.trip});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(tripDetailStreamProvider(trip.id));

    return Card(
      child: InkWell(
        onTap: () => context.push('/trips/${trip.id}'),
        borderRadius: AppSpacing.roundedCard,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      trip.name,
                      style: AppTypography.itemTitle.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      _formatDates(trip.startDate, trip.endDate),
                      style: AppTypography.bodySecondary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              detailsAsync.when(
                data: (details) {
                  final stopsText = details?.stops.map((s) => s.label).join(' -> ') ?? 'Tujuan belum diatur';
                  final summary = details?.summary;
                  final unitsLabel = summary?.hasItems == true ? summary?.unitsLabel : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              stopsText,
                              style: AppTypography.bodySecondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      BawaProgressBar(
                        completedLines: summary?.completedRows ?? 0,
                        totalLines: summary?.totalCarriedRows ?? 0,
                        completedUnits: summary?.totalPackedUnits,
                        totalUnits: summary?.totalPlannedUnits,
                      ),
                      if (unitsLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(unitsLabel, style: AppTypography.metadata),
                      ],
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
