import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/datetime_utils.dart';
import '../../core/widgets/bawa_search_field.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/search_repository.dart';

class UnifiedSearchScreen extends ConsumerStatefulWidget {
  final String? initialTripId;

  const UnifiedSearchScreen({
    super.key,
    this.initialTripId,
  });

  @override
  ConsumerState<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends ConsumerState<UnifiedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil perjalanan terdekat bila tidak ada initialTripId eksplisit
    final upcomingTripAsync = ref.watch(upcomingTripStreamProvider);
    final activeTripId = widget.initialTripId ?? upcomingTripAsync.value?.trip.id;

    final searchAsync = _currentQuery.trim().isEmpty
        ? null
        : ref.watch(unifiedSearchProvider((
            query: _currentQuery.trim(),
            selectedTripId: activeTripId,
          )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Barang Terpadu', style: AppTypography.screenTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
            child: BawaSearchField(
              controller: _searchController,
              hintText: 'Cari nama, kotak, tas, atau alias...',
              autofocus: true,
              onChanged: (val) {
                setState(() => _currentQuery = val);
              },
              onClear: () {
                _searchController.clear();
                setState(() => _currentQuery = '');
              },
            ),
          ),
        ),
      ),
      body: _buildBody(context, searchAsync, activeTripId),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<UnifiedSearchResults>? searchAsync,
    String? activeTripId,
  ) {
    if (_currentQuery.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search, size: 64, color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Cari Dari Satu Tempat (FIND-01)',
                style: AppTypography.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Mencakup stok inventaris rumah, bawaan perjalanan aktif, dan perjalanan lain. Mengenali alias umum (charger/casan/adaptor/ponsel/obat/sikat gigi).',
                style: AppTypography.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (searchAsync == null || searchAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchAsync.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Text('Terjadi kesalahan: ${searchAsync.error}'),
        ),
      );
    }

    final results = searchAsync.value;
    if (results == null || results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_outlined, size: 56, color: AppColors.textSecondary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tidak ada hasil untuk "$_currentQuery"',
                style: AppTypography.itemTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Coba gunakan kata kunci umum, nama kotak penyimpanan, atau nama tas perjalanan.',
                style: AppTypography.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.base),
      children: [
        // 1. Kategori: Perjalanan Dipilih (Jika ada)
        if (results.selectedTripResults.isNotEmpty) ...[
          _buildSectionHeader(
            icon: Icons.luggage_outlined,
            title: 'Perjalanan Dipilih (${results.selectedTripResults.length})',
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.xs),
          ...results.selectedTripResults.map((r) => _buildTripResultCard(context, r, isSelected: true)),
          const SizedBox(height: AppSpacing.lg),
        ],

        // 2. Kategori: Inventaris Rumah
        if (results.homeInventoryResults.isNotEmpty) ...[
          _buildSectionHeader(
            icon: Icons.home_work_outlined,
            title: 'Inventaris Rumah (${results.homeInventoryResults.length})',
            color: AppColors.accentOrange,
          ),
          const SizedBox(height: AppSpacing.xs),
          ...results.homeInventoryResults.map((r) => _buildHomeResultCard(context, r)),
          const SizedBox(height: AppSpacing.lg),
        ],

        // 3. Kategori: Perjalanan Lain
        if (results.otherTripResults.isNotEmpty) ...[
          _buildSectionHeader(
            icon: Icons.flight_takeoff_outlined,
            title: 'Perjalanan Lain (${results.otherTripResults.length})',
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.xs),
          ...results.otherTripResults.map((r) => _buildTripResultCard(context, r, isSelected: false)),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: AppTypography.sectionTitle.copyWith(fontSize: 15, color: color),
        ),
      ],
    );
  }

  Widget _buildHomeResultCard(BuildContext context, UnifiedSearchResult item) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceMuted,
          foregroundColor: AppColors.textPrimary,
          child: const Icon(Icons.inventory_2_outlined, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(item.itemName, style: AppTypography.itemTitle),
            ),
            if (item.isImportant) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFD97706), width: 0.8),
                ),
                child: const Text(
                  'PENTING',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
            Text(
              'Stok Rumah: ${item.totalQuantity} ${item.unit} • Asal: ${item.storageLocationName ?? "Belum dicatat"}',
              style: AppTypography.metadata,
            ),
            if (item.categoryName != null)
              Text('Kategori: ${item.categoryName}', style: AppTypography.metadata),
          ],
        ),
        trailing: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => context.push('/inventory/items/${item.itemId}'),
          child: const Text('Lihat Letak', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildTripResultCard(
    BuildContext context,
    UnifiedSearchResult item, {
    required bool isSelected,
  }) {
    final statusColor = item.packingStatus == 'selesai'
        ? AppColors.success
        : (item.packingStatus == 'sebagian'
            ? AppColors.primary
            : (item.packingStatus == 'sedang_dipakai'
                ? AppColors.warning
                : AppColors.textSecondary));

    final statusLabel = item.packingStatus == 'selesai'
        ? 'Selesai'
        : (item.packingStatus == 'sebagian'
            ? 'Sebagian'
            : (item.packingStatus == 'sedang_dipakai'
                ? 'Sedang Dipakai'
                : 'Belum Dikemas'));

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
          width: isSelected ? 1.2 : 1.0,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(item.itemName, style: AppTypography.itemTitle),
                ),
                if (item.isPackedLast) ...[
                  Container(
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
                  const SizedBox(width: 4),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Perjalanan: ${item.tripName ?? "-"}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              'Jumlah Bawaan: ${item.packedQuantity ?? 0}/${item.plannedQuantity ?? 0} ${item.unit} • Asal: ${item.storageLocationName ?? "Belum dicatat"}',
              style: AppTypography.metadata,
            ),
            const SizedBox(height: 2),
            Text(
              'Lokasi di Perjalanan: ${item.bagOrLocationDisplay ?? "Belum dicatat"}',
              style: AppTypography.metadata.copyWith(color: AppColors.primaryDark),
            ),
            if (item.lastPhysicallyConfirmedAt != null) ...[
              const SizedBox(height: 2),
              Text(
                AppDateTimeUtils.formatConfirmationTime(item.lastPhysicallyConfirmedAt),
                style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (item.tripId != null)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: Text(isSelected ? 'Buka Detail' : 'Buka Perjalanan', style: const TextStyle(fontSize: 12)),
                    onPressed: () {
                      context.push('/trips/${item.tripId}');
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
