import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/datetime_utils.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_empty_state.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/schedules_repository.dart';

class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  bool _isCalendarView = false;
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedCalendarDate;

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  Future<void> _showAddScheduleTripPicker(BuildContext context) async {
    final tripsRepo = ref.read(tripsRepositoryProvider);
    final activeTrips = await tripsRepo.getActiveTrips();

    if (!context.mounted) return;

    if (activeTrips.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Belum Ada Perjalanan', style: AppTypography.itemTitle),
          content: const Text(
            'Untuk menambahkan jadwal agenda, kamu perlu membuat perjalanan terlebih dahulu.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.push('/trips/new');
              },
              child: const Text('Buat Perjalanan'),
            ),
          ],
        ),
      );
      return;
    }

    if (activeTrips.length == 1) {
      context.push('/trips/${activeTrips.first.id}/schedules/new');
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih Perjalanan untuk Jadwal', style: AppTypography.itemTitle),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Jadwal akan dikaitkan ke perjalanan yang kamu pilih.',
                style: AppTypography.metadata,
              ),
              const SizedBox(height: AppSpacing.md),
              ...activeTrips.map((trip) {
                return ListTile(
                  leading: const Icon(Icons.flight_takeoff, color: AppColors.primary),
                  title: Text(trip.name, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text('${trip.startDate} - ${trip.endDate ?? "Fleksibel"}', style: AppTypography.metadata),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    context.push('/trips/${trip.id}/schedules/new');
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterDateStr = _selectedCalendarDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedCalendarDate!)
        : null;

    final agendaAsync = ref.watch(globalAgendaStreamProvider(_isCalendarView ? filterDateStr : null));

    return Scaffold(
      appBar: BawaAppBar(
        title: 'Agenda',
        actions: [
          IconButton(
            tooltip: _isCalendarView ? 'Beralih ke Tampilan Daftar' : 'Beralih ke Tampilan Kalender',
            icon: Icon(
              _isCalendarView ? Icons.view_list_outlined : Icons.calendar_view_month_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isCalendarView = !_isCalendarView;
              });
            },
          ),
        ],
      ),
      body: agendaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat agenda: $err')),
        data: (schedules) {
          if (schedules.isEmpty && !_isCalendarView) {
            return BawaEmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'Belum ada agenda',
              message: 'Tambah jadwal transportasi, akomodasi, atau kegiatan agar pengingat perjalananmu tepat waktu.',
              actionLabel: 'Tambah Jadwal',
              onAction: () => _showAddScheduleTripPicker(context),
            );
          }

          return Column(
            children: [
              // Banner info pengingat lokal
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.sm),
                color: AppColors.primarySoft.withValues(alpha: 0.15),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Agenda offline mandiri: Jam dan zona waktu IANA disimpan secara lokal.',
                        style: AppTypography.metadata.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Konten Kalender atau Daftar Kronologis
              Expanded(
                child: _isCalendarView
                    ? _buildCalendarView(context, schedules)
                    : _buildChronologicalListView(context, schedules),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Tambah Jadwal'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showAddScheduleTripPicker(context),
      ),
    );
  }

  Widget _buildChronologicalListView(BuildContext context, List<ScheduleEventWithDetails> schedules) {
    // Kelompokkan jadwal berdasarkan tanggal
    final Map<String, List<ScheduleEventWithDetails>> grouped = {};
    for (final s in schedules) {
      grouped.putIfAbsent(s.localDate, () => []).add(s);
    }

    final dates = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.base),
      itemCount: dates.length,
      itemBuilder: (context, idx) {
        final dateStr = dates[idx];
        final events = grouped[dateStr]!;

        String formattedHeader;
        try {
          final dt = DateTime.parse(dateStr);
          formattedHeader = AppDateTimeUtils.formatFullDate(dt);
        } catch (_) {
          formattedHeader = dateStr;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    formattedHeader,
                    style: AppTypography.sectionTitle.copyWith(fontSize: 15, color: AppColors.primaryDark),
                  ),
                ],
              ),
            ),
            ...events.map((e) => _buildScheduleCard(context, e)),
            const SizedBox(height: AppSpacing.md),
          ],
        );
      },
    );
  }

  Widget _buildCalendarView(BuildContext context, List<ScheduleEventWithDetails> schedules) {
    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1 = Senin, 7 = Minggu

    final monthTitle = AppDateTimeUtils.formatMonthYear(_currentMonth);

    // Ambil semua tanggal unik yang memiliki jadwal di bulan ini
    final allEventsAsync = ref.watch(globalAgendaStreamProvider(null));
    final Set<int> eventDaysInMonth = {};
    allEventsAsync.whenData((allEvents) {
      for (final ev in allEvents) {
        try {
          final dt = DateTime.parse(ev.localDate);
          if (dt.year == year && dt.month == month) {
            eventDaysInMonth.add(dt.day);
          }
        } catch (_) {}
      }
    });

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.base),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                // Header Navigasi Bulan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousMonth,
                    ),
                    Text(monthTitle, style: AppTypography.itemTitle),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: AppSpacing.xs),

                // Baris Nama Hari
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Sen', style: AppTypography.metadata),
                    Text('Sel', style: AppTypography.metadata),
                    Text('Rab', style: AppTypography.metadata),
                    Text('Kam', style: AppTypography.metadata),
                    Text('Jum', style: AppTypography.metadata),
                    Text('Sab', style: AppTypography.metadata),
                    Text('Min', style: AppTypography.metadata),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Grid Tanggal
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 42, // 6 baris x 7 hari
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final dayOffset = index - (firstWeekday - 1);
                    final dayNumber = dayOffset + 1;

                    if (dayNumber < 1 || dayNumber > daysInMonth) {
                      return const SizedBox.shrink();
                    }

                    final thisDate = DateTime(year, month, dayNumber);
                    final isSelected = _selectedCalendarDate != null &&
                        _selectedCalendarDate!.year == year &&
                        _selectedCalendarDate!.month == month &&
                        _selectedCalendarDate!.day == dayNumber;

                    final hasEvent = eventDaysInMonth.contains(dayNumber);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCalendarDate = null;
                          } else {
                            _selectedCalendarDate = thisDate;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected || hasEvent ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : hasEvent
                                        ? AppColors.primaryDark
                                        : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (hasEvent)
                            Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Header Filter & List
        if (_selectedCalendarDate != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agenda pada ${AppDateTimeUtils.formatDateMonthYear(_selectedCalendarDate!)}:',
                style: AppTypography.sectionTitle,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCalendarDate = null;
                  });
                },
                child: const Text('Reset Filter'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ] else ...[
          const Text('Semua Agenda Bulan Ini:', style: AppTypography.sectionTitle),
          const SizedBox(height: AppSpacing.xs),
        ],

        if (schedules.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(
              child: Text(
                _selectedCalendarDate != null
                    ? 'Tidak ada agenda pada tanggal ini.'
                    : 'Tidak ada agenda pada bulan ini.',
                style: AppTypography.bodySecondary,
              ),
            ),
          )
        else
          ...schedules.map((e) => _buildScheduleCard(context, e)),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context, ScheduleEventWithDetails item) {
    IconData typeIcon;
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
              child: Icon(typeIcon, color: AppColors.primary, size: 24),
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
                      Expanded(
                        child: Text(
                          item.formattedTime,
                          style: AppTypography.metadata.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Perjalanan: ${item.trip.name}', style: const TextStyle(fontSize: 11)),
                      ),
                      if (item.tripStop != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Kota: ${item.tripStop!.label}', style: const TextStyle(fontSize: 11)),
                        ),
                      if (item.linkedTickets.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.linkedTickets.length} Tiket',
                            style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (item.hasReminders)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.hasActiveReminders
                                ? AppColors.primarySoft.withValues(alpha: 0.2)
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
                                    : (item.hasPendingPermissionReminders ? AppColors.warning : AppColors.textSecondary),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${item.reminders.length} Pengingat',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: item.hasActiveReminders
                                      ? AppColors.primary
                                      : (item.hasPendingPermissionReminders ? AppColors.warning : AppColors.textSecondary),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Aksi',
              onSelected: (val) async {
                if (val == 'edit') {
                  context.push('/trips/${item.trip.id}/schedules/edit/${item.id}');
                } else if (val == 'trip') {
                  context.push('/trips/${item.trip.id}');
                } else if (val == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Hapus Jadwal', style: AppTypography.itemTitle),
                      content: Text('Yakin ingin menghapus jadwal "${item.title}"?'),
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
                const PopupMenuItem(value: 'trip', child: Text('Buka Perjalanan')),
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
  }
}
