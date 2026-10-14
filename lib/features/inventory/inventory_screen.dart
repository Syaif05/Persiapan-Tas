import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/datetime_utils.dart';
import '../../core/utils/trip_text_formatter.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_empty_state.dart';
import '../../core/widgets/bawa_filter_chip.dart';
import '../../core/widgets/bawa_progress_bar.dart';
import '../../core/widgets/bawa_search_field.dart';
import '../../core/widgets/full_screen_image_viewer.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/repositories/trip_packing_repository.dart';
import '../../data/repositories/trips_repository.dart';
import '../trips/trip_item_picker_sheet.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedTripId; // null = Semua Inventaris (Katalog Gudang)
  PackingFilter _tripPackingFilter = PackingFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTripsAsync = ref.watch(allTripsWithDetailsStreamProvider(null));

    return Scaffold(
      appBar: BawaAppBar(
        title: _selectedTripId == null ? 'Tas & Bawaan' : 'Tas Perjalanan',
        actions: [
          IconButton(
            tooltip: 'Cari Barang Terpadu (FIND-01)',
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () => context.push(_selectedTripId != null ? '/search?tripId=$_selectedTripId' : '/search'),
          ),
          IconButton(
            tooltip: 'Kelola Kotak & Lokasi',
            icon: const Icon(Icons.archive_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push('/inventory/locations'),
          ),
          IconButton(
            tooltip: _selectedTripId != null ? 'Tambah Barang ke Bawaan' : 'Tambah Barang Baru ke Gudang',
            icon: const Icon(Icons.add, color: AppColors.primary, size: 28),
            onPressed: () => context.push(_selectedTripId != null ? '/inventory/new?tripId=$_selectedTripId' : '/inventory/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Selector Perjalanan di Bagian Atas (Dropdown / Filter Pilihan Perjalanan)
          _buildTripSelectorHeader(context, allTripsAsync),

          const Divider(height: 1),

          // 2. Konten Layar: Mode Tas Perjalanan vs Mode Semua Inventaris
          Expanded(
            child: _selectedTripId != null
                ? _buildTripCartView(context, _selectedTripId!, allTripsAsync.value ?? [])
                : _buildMasterInventoryView(context, allTripsAsync.value ?? []),
          ),
        ],
      ),
    );
  }

  // --- TOP TRIP SELECTOR (Dropdown / Filter Perjalanan) ---
  Widget _buildTripSelectorHeader(BuildContext context, AsyncValue<List<TripWithDetails>> allTripsAsync) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
      child: allTripsAsync.when(
        loading: () => const SizedBox(
          height: 48,
          child: Center(child: LinearProgressIndicator()),
        ),
        error: (err, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Text('Gagal memuat perjalanan: $err', style: AppTypography.metadata),
        ),
        data: (allTrips) {
          final currentTrip = _selectedTripId != null
              ? allTrips.where((t) => t.trip.id == _selectedTripId).firstOrNull
              : null;

          return InkWell(
            onTap: () => _showTripSelectionSheet(context, allTrips),
            borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedTripId != null
                    ? AppColors.primarySoft.withValues(alpha: 0.25)
                    : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                border: Border.all(
                  color: _selectedTripId != null ? AppColors.primary : AppColors.border,
                  width: _selectedTripId != null ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _selectedTripId != null ? Icons.shopping_bag : Icons.inventory_2_outlined,
                    color: _selectedTripId != null ? AppColors.primary : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedTripId != null ? 'Tas Perjalanan Aktif:' : 'Filter Tampilan Bawaan:',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          currentTrip != null
                              ? '${currentTrip.trip.name} (${currentTrip.trip.status == 'ongoing' ? 'Sedang Berjalan' : 'Persiapan'})'
                              : 'Semua Inventaris (Katalog Gudang)',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _selectedTripId != null ? AppColors.primaryDark : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTripSelectionSheet(BuildContext context, List<TripWithDetails> allTrips) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        final activeTrips = allTrips.where((t) => t.trip.status != 'completed' && !t.trip.isArchived).toList();
        final completedTrips = allTrips.where((t) => t.trip.status == 'completed' || t.trip.isArchived).toList();

        return Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),
        ),
        padding: const EdgeInsets.all(AppSpacing.base),
        child: SafeArea(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pilih Perjalanan', style: AppTypography.sectionTitle),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Perjalanan Baru', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      context.push('/trips/new');
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Pilih perjalanan untuk melihat dan mengelola isi tas khusus perjalanan tersebut.',
                style: AppTypography.metadata,
              ),
              const SizedBox(height: AppSpacing.md),
              // Pilihan 1: Semua Inventaris (Katalog)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _selectedTripId == null ? AppColors.primary : AppColors.surfaceMuted,
                  foregroundColor: _selectedTripId == null ? Colors.white : AppColors.textPrimary,
                  child: const Icon(Icons.inventory_2_outlined, size: 20),
                ),
                title: const Text('Semua Inventaris (Katalog Gudang)', style: AppTypography.itemTitle),
                subtitle: const Text('Lihat seluruh stok dan pilih barang untuk dibawa', style: AppTypography.metadata),
                trailing: _selectedTripId == null ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _selectedTripId = null);
                  Navigator.of(sheetCtx).pop();
                },
              ),
              const Divider(height: 1),
              // Pilihan 2: Daftar Perjalanan (Dipisahkan Aktif vs Selesai)

              if (allTrips.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.base),
                  child: Center(
                    child: Text('Belum ada perjalanan dibuat.', style: AppTypography.bodySecondary),
                  ),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Subheading: Perjalanan Aktif
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: 8),
                        child: Text(
                          'PERJALANAN AKTIF / PERSIAPAN (${activeTrips.length})',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (activeTrips.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: 8),
                          child: Text('Tidak ada perjalanan aktif. Buat perjalanan baru untuk membawa barang.', style: AppTypography.metadata),
                        )
                      else
                        ...activeTrips.map((item) {
                          final isSelected = _selectedTripId == item.trip.id;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSelected ? AppColors.primary : AppColors.surfaceMuted,
                              foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
                              child: const Icon(Icons.shopping_bag_outlined, size: 20),
                            ),
                            title: Text(item.trip.name, style: AppTypography.itemTitle),
                            subtitle: Text(
                              '${item.summary.completedRows}/${item.summary.totalCarriedRows} barang siap • Status: ${item.trip.status == 'ongoing' ? 'Sedang Berjalan' : 'Persiapan'}',
                              style: AppTypography.metadata,
                            ),
                            trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                            onTap: () {
                              setState(() => _selectedTripId = item.trip.id);
                              Navigator.of(sheetCtx).pop();
                            },
                          );
                        }),

                      // Subheading: Menu Khusus Riwayat Selesai
                      if (completedTrips.isNotEmpty) ...[
                        const Divider(height: AppSpacing.md),
                        ExpansionTile(
                          initiallyExpanded: completedTrips.any((t) => t.trip.id == _selectedTripId),
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.surfaceMuted,
                            child: Icon(Icons.history_outlined, size: 20, color: AppColors.textSecondary),
                          ),
                          title: Text('Menu Khusus: Riwayat Selesai (${completedTrips.length})', style: AppTypography.itemTitle.copyWith(fontSize: 14)),
                          subtitle: const Text('Perjalanan selesai & arsip terdahulu', style: AppTypography.metadata),
                          children: completedTrips.map((item) {
                            final isSelected = _selectedTripId == item.trip.id;
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                              leading: CircleAvatar(
                                backgroundColor: isSelected ? AppColors.success : AppColors.surfaceMuted,
                                foregroundColor: isSelected ? Colors.white : AppColors.textSecondary,
                                child: const Icon(Icons.check_circle_outline, size: 18),
                              ),
                              title: Text(item.trip.name, style: AppTypography.itemTitle),
                              subtitle: Text(
                                'Selesai • ${item.summary.completedRows}/${item.summary.totalCarriedRows} barang terkemas',
                                style: AppTypography.metadata,
                              ),
                              trailing: isSelected ? const Icon(Icons.check, color: AppColors.success) : null,
                              onTap: () {
                                setState(() => _selectedTripId = item.trip.id);
                                Navigator.of(sheetCtx).pop();
                              },
                            );
                          }).toList(),
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
}

  // --- VIEW 1: MODE TAS PERJALANAN (SHOPPING CART STYLE) ---
  Widget _buildTripCartView(BuildContext context, String tripId, List<TripWithDetails> allTrips) {
    final tripDetailsAsync = ref.watch(tripDetailStreamProvider(tripId));
    final tripItemsAsync = ref.watch(tripItemsStreamProvider((tripId: tripId, filter: _tripPackingFilter)));
    final bagsAsync = ref.watch(tripBagsStreamProvider(tripId));

    return Column(
      children: [
        // Ringkasan Keranjang Tas & Tombol Tambah Barang
        tripDetailsAsync.when(
          data: (details) {
            if (details == null) return const SizedBox.shrink();
            final summary = details.summary;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
              color: AppColors.primarySoft.withValues(alpha: 0.12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Isi Tas: ${summary.completedRows}/${summary.totalCarriedRows} Barang Selesai',
                            style: AppTypography.itemTitle.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.copy_all_outlined, size: 15),
                            label: const Text('Salin Teks', style: TextStyle(fontSize: 11)),
                            onPressed: () => _copyTripToClipboard(context, details, tripItemsAsync.value ?? []),
                          ),
                          const SizedBox(width: 6),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Isi Tas', style: TextStyle(fontSize: 12)),
                            onPressed: () => _openItemPicker(context, tripId),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BawaProgressBar(
                    completedLines: summary.completedRows,
                    totalLines: summary.totalCarriedRows,
                    completedUnits: summary.totalPackedUnits,
                    totalUnits: summary.totalPlannedUnits,
                  ),
                  // Banner Jika Perjalanan Sudah Selesai (Opsi Hapus Bersih Media)
                  if (details.trip.status == 'completed' || details.trip.isArchived) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Perjalanan Selesai (Riwayat)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                Text('Hapus seluruh data & media foto/tiket untuk menghemat memori.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.errorSoft,
                              foregroundColor: AppColors.error,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.delete_forever_outlined, size: 15),
                            label: const Text('Hapus Bersih', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            onPressed: () => _confirmDeleteCompletedTrip(context, details.trip),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),

        // Filter status packing
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
          child: Row(
            children: PackingFilter.values.map((f) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: BawaFilterChip(
                  label: f.label,
                  isSelected: _tripPackingFilter == f,
                  onTap: () => setState(() => _tripPackingFilter = f),
                ),
              );
            }).toList(),
          ),
        ),

        const Divider(height: 1),

        // Daftar Barang Gaya Keranjang Belanja (Shopping Cart Style)
        Expanded(
          child: tripItemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Gagal memuat barang tas: $err')),
            data: (items) {
              if (items.isEmpty) {
                return BawaEmptyState(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Daftar Bawaan Masih Kosong',
                  message: 'Pilih barang dari inventaris gudang untuk dimasukkan ke dalam daftar rencana perjalanan ini.',
                  actionLabel: 'Tambah ke Daftar Bawaan',
                  onAction: () => _openItemPicker(context, tripId),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.base),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final tripItem = items[index];
                  return _buildCartItemCard(context, tripItem, tripId, allTrips, bagsAsync.value ?? []);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // --- KARTU BARANG GAYA KERANJANG BELANJA (SHOPPING CART STYLE) ---
  Widget _buildCartItemCard(
    BuildContext context,
    TripItemWithDetails item,
    String tripId,
    List<TripWithDetails> allTrips,
    List<TripBagEntry> bags,
  ) {
    final packingRepo = ref.read(tripPackingRepositoryProvider);
    final assetService = ref.read(assetStorageServiceProvider);
    final isDone = item.isCompleted;
    final isImportant = item.isImportant;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: BorderSide(
          color: isImportant
              ? const Color(0xFFF59E0B) // Aksen Emas/Amber Mencolok untuk Barang Penting
              : isDone
                  ? AppColors.border
                  : AppColors.border,
          width: isImportant ? 1.5 : 1.0,
        ),
      ),
      color: isImportant
          ? const Color(0xFFFFFBEB)
          : isDone
              ? AppColors.surfaceMuted.withValues(alpha: 0.45)
              : AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Thumbnail Gambar (Tap untuk Full Screen Lightbox)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 54,
                height: 54,
                child: _buildItemImageThumbnail(item.item?.id, assetService),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // 2. Info Barang (Nama, Jumlah Bawaan, Asal Kotak, Tas)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.displayName,
                          style: AppTypography.itemTitle.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            color: isDone ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isPackedLast) ...[
                        const SizedBox(width: 4),
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
                      ],
                      if (isImportant) ...[
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
                  const SizedBox(height: 3),
                  // Jumlah yang dibawa & Asal penyimpanan
                  Text(
                    '${item.packedQuantity}/${item.plannedQuantity} ${item.item?.unit ?? 'buah'} • Asal: ${item.displayLocation}',
                    style: AppTypography.metadata.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Wadah Tas Perjalanan (Opsional - Tappable)
                  InkWell(
                    onTap: () => _showAssignBagModal(context, item, bags),
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.tripBagName != null ? Icons.work : Icons.work_outline,
                          size: 13,
                          color: item.tripBagName != null ? AppColors.primary : AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.tripBagName != null ? 'Tas: ${item.tripBagName}' : 'Pilih tas (ketuk)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: item.tripBagName != null ? AppColors.primaryDark : AppColors.textTertiary,
                              decoration: item.tripBagName == null ? TextDecoration.underline : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 3. Tombol Status Kemas (CORE-01: Mendukung Sedang Dipakai & Kemas Cepat)
            InkWell(
              onTap: () async {
                if (item.isInUse) {
                  // Kembalikan barang yang sedang dipakai
                  await packingRepo.returnInUseUnit(item.tripItem.id, count: item.inUseQuantity);
                } else {
                  await packingRepo.quickTogglePacked(item.tripItem.id);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: item.isInUse
                      ? AppColors.warningSoft
                      : isDone
                          ? const Color(0xFFE8F5E9)
                          : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: item.isInUse
                        ? AppColors.warning
                        : isDone
                            ? const Color(0xFF81C784)
                            : AppColors.border,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.isInUse
                          ? Icons.replay_rounded
                          : isDone
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked,
                      size: 15,
                      color: item.isInUse
                          ? AppColors.warning
                          : isDone
                              ? const Color(0xFF2E7D32)
                              : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isInUse
                          ? 'Kembalikan'
                          : isDone
                              ? 'Siap'
                              : 'Kemas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item.isInUse
                            ? AppColors.warning
                            : isDone
                                ? const Color(0xFF2E7D32)
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 4. Tombol Tandai Disiapkan Terakhir (PACK-01)
            IconButton(
              icon: Icon(
                item.isPackedLast ? Icons.alarm_on : Icons.alarm_add_outlined,
                size: 20,
                color: item.isPackedLast ? Colors.purple : AppColors.textSecondary,
              ),
              tooltip: item.isPackedLast ? 'Disiapkan terakhir (Ketuk untuk batal)' : 'Tandai disiapkan terakhir (PACK-01)',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              onPressed: () async {
                await packingRepo.togglePackedLast(item.tripItem.id, !item.isPackedLast);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        item.isPackedLast
                            ? '${item.displayName} tidak lagi ditandai disiapkan terakhir'
                            : '${item.displayName} ditandai disiapkan terakhir (HP/charger/sikat gigi)',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),

            // 5. Tombol Hapus Aman dari Daftar Bawaan (CORE-06)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textSecondary),
              tooltip: 'Hapus dari Daftar Bawaan',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              onPressed: () async {
                // Konfirmasi aman jika barang sudah disiapkan atau sedang dipakai
                if (item.packedQuantity > 0 || item.inUseQuantity > 0) {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Hapus dari Daftar Bawaan?'),
                      content: Text(
                        '${item.displayName} sudah disiapkan (${item.packedQuantity} dikemas${item.inUseQuantity > 0 ? ', ${item.inUseQuantity} dipakai' : ''}). Yakin ingin menghapus dari rencana perjalanan ini?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Batal'),
                        ),
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

                final backupTripId = item.tripItem.tripId;
                final backupItemId = item.tripItem.itemId;
                final backupPlanned = item.tripItem.plannedQuantity;
                final backupPacked = item.tripItem.packedQuantity;
                final backupBagId = item.tripItem.tripBagId;
                final backupNotes = item.tripItem.notes;

                await packingRepo.deleteTripItem(item.tripItem.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.displayName} dihapus dari bawaan'),
                      duration: const Duration(seconds: 6), // 6 detik untuk aksi undo (CORE-06)
                      action: SnackBarAction(
                        label: 'Urungkan',
                        textColor: AppColors.primary,
                        onPressed: () async {
                          await packingRepo.setPlannedItem(
                            tripId: backupTripId,
                            itemId: backupItemId,
                            plannedQuantity: backupPlanned,
                            tripBagId: backupBagId,
                            notes: backupNotes,
                          );
                          if (backupPacked > 0) {
                            final restored = await packingRepo.getTripItem(backupTripId, backupItemId);
                            if (restored != null) {
                              await packingRepo.packUnit(restored.id, delta: backupPacked);
                            }
                          }
                        },
                      ),
                    ),
                  );
                }
              },
            ),

            // 5. Opsi Tindakan Tambahan (Keluarkan, Sedang Dipakai, Salin)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              onSelected: (val) async {
                if (val == 'unpack') {
                  await packingRepo.unpackUnit(item.tripItem.id, delta: 1);
                } else if (val == 'in_use') {
                  await packingRepo.setUnitInUse(item.tripItem.id, count: 1);
                } else if (val == 'return_in_use') {
                  await packingRepo.returnInUseUnit(item.tripItem.id, count: item.inUseQuantity > 0 ? item.inUseQuantity : 1);
                } else if (val == 'copy') {
                  _showCopyItemDialog(context, item, allTrips);
                } else if (val == 'detail' && item.item != null) {
                  context.push('/inventory/items/${item.item!.id}');
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
                const PopupMenuItem(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy_outlined, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Salin ke Perjalanan Lain'),
                    ],
                  ),
                ),
                if (item.item != null)
                  const PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Detail Barang Master'),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- VIEW 2: MODE SEMUA INVENTARIS (KATALOG GUDANG) ---
  Widget _buildMasterInventoryView(BuildContext context, List<TripWithDetails> allTrips) {
    final filter = ref.watch(inventoryFilterProvider);
    final inventoryAsync = ref.watch(filteredInventoryStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Column(
      children: [
        // Baris Pencarian
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.xs),
          child: BawaSearchField(
            controller: _searchController,
            hintText: 'Cari nama barang, kotak, atau kategori...',
            onChanged: (val) => ref.read(inventoryFilterProvider.notifier).setSearchQuery(val),
            onClear: () => ref.read(inventoryFilterProvider.notifier).setSearchQuery(''),
          ),
        ),

        // Filter Chips (Kategori, ⭐ Penting, Arsip, Urutan)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.xs),
          child: Row(
            children: [
              BawaFilterChip(
                label: 'Semua',
                isSelected: filter.categoryId == null && filter.isImportantOnly != true && !filter.includeArchived,
                onTap: () => ref.read(inventoryFilterProvider.notifier).reset(),
              ),
              const SizedBox(width: AppSpacing.xs),
              BawaFilterChip(
                label: '⭐ Penting',
                isSelected: filter.isImportantOnly == true,
                onTap: () => ref.read(inventoryFilterProvider.notifier).toggleImportantOnly(),
              ),
              const SizedBox(width: AppSpacing.xs),
              categoriesAsync.when(
                data: (categories) => Row(
                  children: categories.map((cat) {
                    final isSelected = filter.categoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: BawaFilterChip(
                        label: cat.name,
                        isSelected: isSelected,
                        onTap: () => ref.read(inventoryFilterProvider.notifier).setCategory(cat.id),
                      ),
                    );
                  }).toList(),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              BawaFilterChip(
                label: '📦 Arsip',
                isSelected: filter.includeArchived,
                onTap: () => ref.read(inventoryFilterProvider.notifier).toggleArchived(),
              ),
              const SizedBox(width: AppSpacing.xs),
              BawaFilterChip(
                label: filter.sortByNameAsc ? 'A-Z' : 'Terbaru',
                isSelected: false,
                onTap: () => ref.read(inventoryFilterProvider.notifier).toggleSort(),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Daftar Master Barang
        Expanded(
          child: inventoryAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Terjadi kesalahan memuat data: $err')),
            data: (items) {
              if (items.isEmpty) {
                final hasFilter = filter.searchQuery.isNotEmpty || filter.categoryId != null || filter.isImportantOnly == true;
                if (hasFilter) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                          const SizedBox(height: AppSpacing.md),
                          const Text('Barang tidak ditemukan', style: AppTypography.itemTitle),
                          const SizedBox(height: AppSpacing.base),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(inventoryFilterProvider.notifier).reset();
                            },
                            child: const Text('Reset Pencarian & Filter'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return BawaEmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'Belum ada barang',
                  message: 'Catat barang pertama dan tempat menyimpannya agar tidak perlu membongkar kotak fisik.',
                  actionLabel: 'Tambah Barang',
                  onAction: () => context.push('/inventory/new'),
                  secondaryActionLabel: 'Muat Contoh Barang',
                  onSecondaryAction: () => _seedSampleItems(context, ref),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.base),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final itemDetails = items[index];
                  return _buildMasterItemCard(context, itemDetails, allTrips);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // --- KARTU MASTER BARANG (DENGAN HIGHLIGHT PENTING & AKSI KE TAS) ---
  Widget _buildMasterItemCard(BuildContext context, ItemWithDetails itemDetails, List<TripWithDetails> allTrips) {
    final item = itemDetails.item;
    final category = itemDetails.category;
    final location = itemDetails.location;
    final primaryPhoto = itemDetails.photos.isNotEmpty ? itemDetails.photos.first : null;
    final assetService = ref.read(assetStorageServiceProvider);
    final isArchived = item.archivedAt != null;
    final isImportant = item.isImportant;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: BorderSide(
          color: isImportant ? const Color(0xFFF59E0B) : AppColors.border,
          width: isImportant ? 1.8 : 1.0,
        ),
      ),
      color: isImportant ? const Color(0xFFFFFBEB) : AppColors.surface,
      child: InkWell(
        onTap: () => context.push('/inventory/items/${item.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Foto dengan Full Screen Lightbox Preview (Requirement 4)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: primaryPhoto != null
                      ? FutureBuilder<File>(
                          future: assetService.resolveRelativeFile(primaryPhoto.relativePath),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.existsSync()) {
                              return GestureDetector(
                                onTap: () => FullScreenImageViewer.show(
                                  context,
                                  file: snapshot.data!,
                                  title: item.name,
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(snapshot.data!, fit: BoxFit.cover),
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.fullscreen, color: Colors.white, size: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              color: AppColors.primarySoft,
                              child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 26),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.primarySoft,
                          child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 26),
                        ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // Detail Barang
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTypography.itemTitle.copyWith(
                              decoration: isArchived ? TextDecoration.lineThrough : null,
                              color: isArchived ? AppColors.textSecondary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Badge Mencolok Barang Penting (Requirement 5)
                        if (isImportant)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFD97706)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.push_pin, size: 12, color: Color(0xFFB45309)),
                                SizedBox(width: 2),
                                Text(
                                  'PENTING',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 3),
                    Text(
                      '${category?.name ?? 'Tanpa Kategori'} • Stok: ${item.quantity} ${item.unit}',
                      style: AppTypography.bodySecondary,
                    ),

                    const SizedBox(height: 4),

                    // Penanda Lokasi Simpan Asal (Opsional - Requirement 5 & PRD Seksi 4.2)
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                location != null ? Icons.archive_outlined : Icons.help_outline,
                                size: 12,
                                color: location != null ? AppColors.primary : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                location != null ? 'Asal: ${location.name}' : 'Lokasi belum dicatat',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        // Tombol Cepat Tambah ke Daftar Bawaan
                        if (!isArchived)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.shopping_bag_outlined, size: 14),
                            label: const Text('+ Bawaan', style: TextStyle(fontSize: 11)),
                            onPressed: () => _showAddItemToTripModal(context, item, allTrips),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER: THUMBNAIL GAMBAR DENGAN PREVIEW FULL SCREEN ---
  Widget _buildItemImageThumbnail(String? itemId, dynamic assetService) {
    if (itemId == null) {
      return Container(
        color: AppColors.primarySoft,
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 28),
      );
    }

    return FutureBuilder<ItemWithDetails?>(
      future: ref.read(inventoryRepositoryProvider).getItemWithDetailsById(itemId),
      builder: (context, snapshot) {
        final photos = snapshot.data?.photos ?? [];
        if (photos.isNotEmpty) {
          final photo = photos.first;
          return FutureBuilder<File>(
            future: assetService.resolveRelativeFile(photo.relativePath),
            builder: (context, fileSnap) {
              if (fileSnap.hasData && fileSnap.data!.existsSync()) {
                return GestureDetector(
                  onTap: () => FullScreenImageViewer.show(
                    context,
                    file: fileSnap.data!,
                    title: 'Foto Barang',
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(fileSnap.data!, fit: BoxFit.cover),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.fullscreen, color: Colors.white, size: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                color: AppColors.primarySoft,
                child: const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 28),
              );
            },
          );
        }
        return Container(
          color: AppColors.primarySoft,
          child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 28),
        );
      },
    );
  }

  // --- DIALOG: DUPLIKASI / SALIN ITEM KE PERJALANAN LAIN (Requirement 2) ---
  void _showCopyItemDialog(BuildContext context, TripItemWithDetails sourceItem, List<TripWithDetails> allTrips) {
    final otherTrips = allTrips.where((t) => t.trip.id != sourceItem.tripItem.tripId).toList();

    if (otherTrips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada perjalanan lain untuk menerima salinan barang ini.')),
      );
      return;
    }

    String selectedTargetTripId = otherTrips.first.trip.id;
    int plannedQty = sourceItem.tripItem.plannedQuantity;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.copy_outlined, color: AppColors.primary),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text('Salin Item ke Perjalanan Lain', style: AppTypography.itemTitle),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salin "${sourceItem.displayName}" ke perjalanan lain tanpa menduplikasi data inventaris master.',
                style: AppTypography.metadata,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Pilih Perjalanan Tujuan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                initialValue: selectedTargetTripId,
                isExpanded: true,
                items: otherTrips.map((t) {
                  return DropdownMenuItem(
                    value: t.trip.id,
                    child: Text(t.trip.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedTargetTripId = val);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Jumlah Rencana Bawaan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.remove),
                    onPressed: plannedQty > 1 ? () => setDialogState(() => plannedQty--) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$plannedQty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add),
                    onPressed: () => setDialogState(() => plannedQty++),
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
                await ref.read(tripPackingRepositoryProvider).copyItemToTrip(
                      sourceTripItemId: sourceItem.tripItem.id,
                      targetTripId: selectedTargetTripId,
                      customPlannedQuantity: plannedQty,
                    );
                final targetTripName = otherTrips.firstWhere((t) => t.trip.id == selectedTargetTripId).trip.name;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Item "${sourceItem.displayName}" berhasil disalin ke "$targetTripName"!')),
                  );
                }
              },
              child: const Text('Salin Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  // --- DIALOG: TAMBAH MASTER ITEM KE DAFTAR BAWAAN PERJALANAN ---
  void _showAddItemToTripModal(BuildContext context, ItemEntry item, List<TripWithDetails> allTrips) {
    // Filter HANYA perjalanan aktif (persiapan/berjalan), kecualikan yang sudah selesai agar fokus menaruh bawaan baru
    final activeTrips = allTrips.where((t) => t.trip.status != 'completed' && !t.trip.isArchived).toList();

    if (activeTrips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada perjalanan aktif. Buat perjalanan baru terlebih dahulu.')),
      );
      return;
    }

    String selectedTripId = activeTrips.first.trip.id;
    int qty = 1;
    final maxQty = item.quantity;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Text('Tambah ke Daftar Bawaan: ${item.name}', style: AppTypography.itemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih perjalanan untuk membawa "${item.name}":', style: AppTypography.metadata),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: selectedTripId,
                isExpanded: true,
                items: activeTrips.map((t) {
                  return DropdownMenuItem(
                    value: t.trip.id,
                    child: Text(t.trip.name, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedTripId = val);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Jumlah Dibawa (Maks. $maxQty ${item.unit}):', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.remove),
                    onPressed: qty > 1 ? () => setDialogState(() => qty--) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$qty', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add),
                    onPressed: qty < maxQty ? () => setDialogState(() => qty++) : null,
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
                await ref.read(tripPackingRepositoryProvider).setItemCarried(
                      tripId: selectedTripId,
                      itemId: item.id,
                      plannedQuantity: qty,
                    );
                final targetTripName = allTrips.firstWhere((t) => t.trip.id == selectedTripId).trip.name;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${item.name}" ditambahkan ke daftar bawaan perjalanan "$targetTripName"!')),
                  );
                }
              },
              child: const Text('Tambah ke Bawaan'),
            ),
          ],
        ),
      ),
    );
  }

  // --- SHEET: PILIH TAS WADAH ---
  void _showAssignBagModal(BuildContext context, TripItemWithDetails item, List<TripBagEntry> bags) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pilih Tas Khusus', style: AppTypography.itemTitle),
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
      ),
    );
  }

  void _openItemPicker(BuildContext context, String tripId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TripItemPickerSheet(tripId: tripId),
    );
  }

  // --- SALIN DATA BAWAAN PERJALANAN (FORMAT AI & MANUSIA) ---
  void _copyTripToClipboard(BuildContext context, TripWithDetails details, List<TripItemWithDetails> items) {
    final text = TripTextFormatter.formatTrip(
      trip: details.trip,
      stops: details.stops,
      items: items,
      summary: details.summary,
      bags: details.bags,
    );
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daftar bawaan berhasil disalin ke clipboard! Siap dibaca atau dicek AI.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // --- KONFIRMASI HAPUS BERSIH PERJALANAN SELESAI ---
  Future<void> _confirmDeleteCompletedTrip(BuildContext context, TripEntry trip) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Bersih Perjalanan?', style: AppTypography.itemTitle),
        content: Text(
          'Perjalanan "${trip.name}" telah selesai. Menghapus perjalanan ini akan membersihkan seluruh data perjalanan, daftar bawaan, riwayat checkpoint, serta menghapus seluruh berkas foto & lampiran tiket dari media storage perangkat untuk menghemat ruang memori.\n\nApakah Anda yakin ingin menghapus bersih?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            icon: const Icon(Icons.delete_forever, size: 18),
            label: const Text('Hapus Bersih'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(tripsRepositoryProvider).deleteTrip(trip.id, deleteMedia: true);
      setState(() => _selectedTripId = null);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perjalanan "${trip.name}" beserta seluruh data & fotonya berhasil dihapus bersih!')),
        );
      }
    }
  }

  // --- SEED CONTOH BARANG ---
  Future<void> _seedSampleItems(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(inventoryRepositoryProvider);
    final locs = await ref.read(locationsRepositoryProvider).getActiveLocations();
    final cats = await ref.read(categoriesRepositoryProvider).getAllCategories();

    final elektronikCat = cats.firstWhere((c) => c.name == 'Elektronik', orElse: () => cats.first).id;
    final pakaianCat = cats.firstWhere((c) => c.name == 'Pakaian', orElse: () => cats.first).id;
    final dokumenCat = cats.firstWhere((c) => c.name == 'Dokumen', orElse: () => cats.first).id;
    final obatCat = cats.firstWhere((c) => c.name == 'Obat & P3K', orElse: () => cats.first).id;

    final kotakElektronikId = locs.isNotEmpty ? locs.first.id : null;
    final lemariId = locs.length > 1 ? locs[1].id : null;

    await repo.createItem(
      name: 'Charger USB-C 65W',
      quantity: 2,
      unit: 'buah',
      categoryId: elektronikCat,
      storageLocationId: kotakElektronikId,
      notes: 'Warna hitam, port ganda USB-C',
      isImportant: true,
    );

    await repo.createItem(
      name: 'Powerbank 10000mAh',
      quantity: 1,
      unit: 'buah',
      categoryId: elektronikCat,
      storageLocationId: kotakElektronikId,
      notes: 'Bisa dibawa ke kabin pesawat',
      isImportant: false,
    );

    await repo.createItem(
      name: 'Kaus Hitam Polos',
      quantity: 5,
      unit: 'helai',
      categoryId: pakaianCat,
      storageLocationId: lemariId,
      notes: 'Bahan katun combed 30s',
      isImportant: false,
    );

    await repo.createItem(
      name: 'Paspor RI',
      quantity: 1,
      unit: 'buah',
      categoryId: dokumenCat,
      storageLocationId: lemariId,
      notes: 'Masa berlaku s/d 2030',
      isImportant: true,
    );

    await repo.createItem(
      name: 'Kotak P3K & Paracetamol',
      quantity: 1,
      unit: 'kotak',
      categoryId: obatCat,
      storageLocationId: null,
      notes: 'Obat pribadi perjalanan',
      isImportant: true,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('5 contoh barang berhasil dimuat ke database lokal')),
      );
    }
  }
}
