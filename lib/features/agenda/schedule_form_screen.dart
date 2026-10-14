import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/datetime_utils.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../data/database/app_database.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/reminders_repository.dart';
import '../../data/services/notification_service.dart';

class ScheduleFormScreen extends ConsumerStatefulWidget {
  final String tripId;
  final String? scheduleId; // null bila membuat baru

  const ScheduleFormScreen({
    super.key,
    required this.tripId,
    this.scheduleId,
  });

  @override
  ConsumerState<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends ConsumerState<ScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _notesCtrl;

  String _selectedType = 'transport';
  String? _selectedTripStopId;
  late DateTime _selectedDate;
  bool _isDateOnly = false;

  TimeOfDay? _startTime;
  String _startZone = AppDateTimeUtils.defaultZoneId;
  TimeOfDay? _endTime;
  String _endZone = AppDateTimeUtils.defaultZoneId;

  List<ReminderConfig> _reminderConfigs = [];
  NotificationPermissionStatus? _permissionStatus;

  bool _isLoading = true;
  String? _tripStartDate;
  String? _tripEndDate;
  List<TripStopEntry> _tripStops = [];

  final List<Map<String, dynamic>> _typeOptions = [
    {'value': 'transport', 'label': 'Transportasi', 'icon': Icons.directions_transit_outlined},
    {'value': 'lodging', 'label': 'Penginapan', 'icon': Icons.hotel_outlined},
    {'value': 'activity', 'label': 'Kegiatan', 'icon': Icons.local_activity_outlined},
    {'value': 'preparation', 'label': 'Persiapan', 'icon': Icons.checklist_outlined},
    {'value': 'other', 'label': 'Lainnya', 'icon': Icons.more_horiz_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _locationCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
    _selectedDate = DateTime.now();

    _loadInitialData();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final tripsRepo = ref.read(tripsRepositoryProvider);
    final tripDetails = await tripsRepo.getTripWithDetails(widget.tripId);

    final notificationService = ref.read(notificationServiceProvider);
    _permissionStatus = await notificationService.checkPermissionStatus();

    if (tripDetails != null) {
      _tripStartDate = tripDetails.trip.startDate;
      _tripEndDate = tripDetails.trip.endDate;
      _tripStops = tripDetails.stops;

      try {
        _selectedDate = DateTime.parse(tripDetails.trip.startDate);
      } catch (_) {
        _selectedDate = DateTime.now();
      }
    }

    if (widget.scheduleId != null) {
      final schedulesRepo = ref.read(schedulesRepositoryProvider);
      final existing = await schedulesRepo.getScheduleById(widget.scheduleId!);

      if (existing != null) {
        _titleCtrl.text = existing.title;
        _selectedType = existing.type;
        _selectedTripStopId = existing.schedule.tripStopId;
        _isDateOnly = existing.isDateOnly;
        _locationCtrl.text = existing.locationText ?? '';
        _notesCtrl.text = existing.notes ?? '';

        try {
          _selectedDate = DateTime.parse(existing.localDate);
        } catch (_) {}

        if (existing.localStart != null) {
          final parts = existing.localStart!.split(':');
          _startTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        _startZone = existing.startZone ?? AppDateTimeUtils.defaultZoneId;

        if (existing.localEnd != null) {
          final parts = existing.localEnd!.split(':');
          _endTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
        _endZone = existing.endZone ?? AppDateTimeUtils.defaultZoneId;
      }

      final remindersRepo = ref.read(remindersRepositoryProvider);
      final existingReminders = await remindersRepo.getRemindersForSchedule(widget.scheduleId!);
      _reminderConfigs = existingReminders.map((r) {
        return ReminderConfig(
          id: r.id,
          type: 'custom',
          customDateTime: DateTime.parse(r.triggerUtc).toLocal(),
          precisionPreference: r.precisionPreference,
          enabled: r.enabled,
        );
      }).toList();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestNotificationPermission() async {
    final granted = await ref.read(notificationServiceProvider).requestNotificationPermission();
    final status = await ref.read(notificationServiceProvider).checkPermissionStatus();
    setState(() {
      _permissionStatus = status;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(granted
              ? 'Izin notifikasi telah diberikan'
              : 'Izin notifikasi tidak diberikan oleh sistem'),
        ),
      );
    }
  }

  void _showAddReminderDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedSheet,
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tambah Pengingat', style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Pilih preset waktu atau tentukan waktu khusus untuk alarm:',
                  style: AppTypography.metadata,
                ),
                const SizedBox(height: AppSpacing.md),
                if (!_isDateOnly) ...[
                  ListTile(
                    leading: const Icon(Icons.alarm, color: AppColors.primary),
                    title: const Text('Tepat saat acara'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(type: 'at_time'));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                    title: const Text('15 menit sebelumnya'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(type: '15_mins_before'));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                    title: const Text('30 menit sebelumnya'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(type: '30_mins_before'));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.hourglass_top_outlined, color: AppColors.primary),
                    title: const Text('1 jam sebelumnya'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(type: '1_hour_before'));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.hourglass_bottom_outlined, color: AppColors.primary),
                    title: const Text('2 jam sebelumnya'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(type: '2_hours_before'));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                    title: const Text('1 hari sebelumnya'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(type: '1_day_before'));
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.alarm, color: AppColors.primary),
                    title: const Text('Hari H pukul 09:00'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(
                        type: 'at_time',
                        explicitTimeForDateOnly: '09:00',
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                    title: const Text('1 hari sebelumnya (H-1) pukul 09:00'),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addReminder(const ReminderConfig(
                        type: '1_day_before',
                        explicitTimeForDateOnly: '09:00',
                      ));
                    },
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.edit_calendar_outlined, color: AppColors.primary),
                  title: const Text('Waktu kustom...'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 1)),
                      lastDate: DateTime(2040),
                    );
                    if (pickedDate != null && mounted) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (pickedTime != null) {
                        final customDt = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _addReminder(ReminderConfig(
                          type: 'custom',
                          customDateTime: customDt,
                        ));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addReminder(ReminderConfig config) {
    setState(() {
      _reminderConfigs.add(config);
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _reminderConfigs.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? (_startTime ?? const TimeOfDay(hour: 10, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay? tod) {
    if (tod == null) return '--:--';
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final startStr = _startTime != null ? _formatTimeOfDay(_startTime) : null;
    final endStr = _endTime != null ? _formatTimeOfDay(_endTime) : null;

    final schedulesRepo = ref.read(schedulesRepositoryProvider);

    try {
      final effectiveScheduleId = widget.scheduleId ??
          await schedulesRepo.createSchedule(
            tripId: widget.tripId,
            title: _titleCtrl.text.trim(),
            type: _selectedType,
            localDate: dateStr,
            isDateOnly: _isDateOnly,
            localStart: startStr,
            startZone: _startZone,
            localEnd: endStr,
            endZone: _endZone,
            locationText: _locationCtrl.text.trim().isNotEmpty ? _locationCtrl.text.trim() : null,
            notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
            tripStopId: _selectedTripStopId,
          );

      if (widget.scheduleId != null) {
        await schedulesRepo.updateSchedule(
          widget.scheduleId!,
          title: _titleCtrl.text.trim(),
          type: _selectedType,
          localDate: dateStr,
          isDateOnly: _isDateOnly,
          localStart: startStr,
          startZone: _startZone,
          localEnd: endStr,
          endZone: _endZone,
          locationText: _locationCtrl.text.trim().isNotEmpty ? _locationCtrl.text.trim() : null,
          notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
          tripStopId: _selectedTripStopId,
        );
      }

      // Simpan dan jadwalkan ulang seluruh pengingat (SCH-08, SCH-10, AT-14)
      final remindersRepo = ref.read(remindersRepositoryProvider);
      await remindersRepo.saveRemindersForSchedule(
        scheduleEventId: effectiveScheduleId,
        configs: _reminderConfigs,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.scheduleId == null
                ? 'Jadwal & pengingat berhasil ditambahkan'
                : 'Jadwal & pengingat berhasil diperbarui'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan jadwal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: BawaAppBar(title: 'Memuat Jadwal...'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isEdit = widget.scheduleId != null;
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final isOutOfTrip = _tripStartDate != null &&
        !AppDateTimeUtils.isDateWithinTripRange(dateStr, _tripStartDate!, _tripEndDate);

    return Scaffold(
      appBar: BawaAppBar(
        title: isEdit ? 'Edit Jadwal' : 'Tambah Jadwal',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            // Peringatan jika tanggal di luar rentang perjalanan (SCH-01 PRD)
            if (isOutOfTrip) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Peringatan: Tanggal jadwal ini ($dateStr) berada di luar rentang tanggal perjalanan '
                        '($_tripStartDate s/d ${_tripEndDate ?? "Fleksibel"}).',
                        style: AppTypography.metadata.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // 1. Judul Jadwal
            const Text('Judul Jadwal *', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                hintText: 'Contoh: Kereta Argo Parahyangan / Check-in Hotel',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Judul jadwal tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // 2. Jenis Jadwal
            const Text('Jenis Kegiatan', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _typeOptions.map((opt) {
                final isSelected = _selectedType == opt['value'];
                return ChoiceChip(
                  avatar: Icon(
                    opt['icon'] as IconData,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  label: Text(opt['label'] as String),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = opt['value'] as String;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. Destinasi / Titik Singgah Perjalanan (Opsional)
            if (_tripStops.isNotEmpty) ...[
              const Text('Terkait Kota / Tujuan (Opsional)', style: AppTypography.body),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String?>(
                isExpanded: true,
                initialValue: _selectedTripStopId,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                hint: const Text('Pilih tujuan perjalanan'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Tidak dikaitkan ke tujuan spesifik'),
                  ),
                  ..._tripStops.map((stop) => DropdownMenuItem<String?>(
                        value: stop.id,
                        child: Text(stop.label),
                      )),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedTripStopId = val;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // 4. Tanggal & Waktu
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Waktu & Tanggal', style: AppTypography.itemTitle),
                    const SizedBox(height: AppSpacing.md),

                    // Baris Pemilih Tanggal
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                      title: const Text('Tanggal Acara', style: AppTypography.metadata),
                      subtitle: Text(
                        AppDateTimeUtils.formatFullDate(_selectedDate),
                        style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: OutlinedButton(
                        onPressed: _pickDate,
                        child: const Text('Ubah'),
                      ),
                    ),
                    const Divider(),

                    // Switch "Hanya Tanggal (Tanpa Jam)" (SCH-12)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Hanya Tanggal (Tanpa Jam)', style: AppTypography.body),
                      subtitle: const Text(
                        'Aktifkan jika jadwal ini tidak memiliki waktu jam spesifik.',
                        style: AppTypography.metadata,
                      ),
                      value: _isDateOnly,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          _isDateOnly = val;
                        });
                      },
                    ),

                    if (!_isDateOnly) ...[
                      const Divider(),
                      const SizedBox(height: AppSpacing.sm),

                      // Jam Mulai & Zona Waktu
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Jam Mulai', style: AppTypography.metadata),
                                const SizedBox(height: AppSpacing.xs),
                                InkWell(
                                  onTap: _pickStartTime,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatTimeOfDay(_startTime),
                                          style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const Icon(Icons.access_time, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Zona Waktu Mulai', style: AppTypography.metadata),
                                const SizedBox(height: AppSpacing.xs),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: _startZone,
                                  items: AppDateTimeUtils.supportedTimezones.map((tz) {
                                    return DropdownMenuItem(
                                      value: tz.id,
                                      child: Text(tz.abbreviation, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _startZone = val;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Jam Selesai (Opsional)
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Jam Selesai (Opsional)', style: AppTypography.metadata),
                                const SizedBox(height: AppSpacing.xs),
                                InkWell(
                                  onTap: _pickEndTime,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                      vertical: AppSpacing.sm,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatTimeOfDay(_endTime),
                                          style: AppTypography.body,
                                        ),
                                        const Icon(Icons.access_time, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Zona Selesai', style: AppTypography.metadata),
                                const SizedBox(height: AppSpacing.xs),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: _endZone,
                                  items: AppDateTimeUtils.supportedTimezones.map((tz) {
                                    return DropdownMenuItem(
                                      value: tz.id,
                                      child: Text(tz.abbreviation, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _endZone = val;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 5. Lokasi Spesifik
            const Text('Lokasi / Tempat (Opsional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                hintText: 'Contoh: Stasiun Gambir / Hotel Grand Preanger',
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 6. Catatan Tambahan
            const Text('Catatan (Opsional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nomor gerbong/kursi, instruksi check-in, atau catatan persiapan...',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 7. Pengingat & Alarm (SCH-08, SCH-09, AT-12, AT-13)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pengingat & Alarm', style: AppTypography.sectionTitle),
                TextButton.icon(
                  onPressed: _showAddReminderDialog,
                  icon: const Icon(Icons.add_alarm, size: 20),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Peringatan Izin Notifikasi jika belum diberikan (AT-12)
            if (_permissionStatus != null && !_permissionStatus!.notificationsAllowed) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_off_outlined, color: AppColors.warning, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Izin notifikasi belum diizinkan',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warning),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Alarm tidak akan berbunyi di Android hingga izin diberikan.',
                            style: AppTypography.metadata,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          GestureDetector(
                            onTap: _requestNotificationPermission,
                            child: const Text(
                              'Ketuk untuk Berikan Izin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            if (_permissionStatus != null &&
                _permissionStatus!.notificationsAllowed &&
                !_permissionStatus!.exactAlarmsAllowed) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Izin alarm presisi belum aktif. Pengingat menggunakan mode perkiraan waktu.',
                        style: AppTypography.metadata,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            if (_reminderConfigs.isEmpty)
              Card(
                elevation: 0,
                color: AppColors.surfaceMuted.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: Text(
                      'Belum ada pengingat untuk jadwal ini.\nKetuk "Tambah" di atas untuk menambahkan pengingat.',
                      textAlign: TextAlign.center,
                      style: AppTypography.metadata,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reminderConfigs.length,
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, idx) {
                  final rem = _reminderConfigs[idx];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      title: Text(rem.displayLabel, style: AppTypography.body),
                      subtitle: Text(
                        rem.precisionPreference == 'exact' ? 'Presisi: Tepat Waktu' : 'Presisi: Perkiraan Waktu',
                        style: AppTypography.metadata,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                        onPressed: () => _removeReminder(idx),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Catatan: Sistem operasi Android atau fitur penghemat baterai agresif vendor (MIUI, Samsung, dsb.) dapat membatasi alarm. Hindari "Force Stop" agar pengingat tetap aktif.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Tombol Simpan
            BawaButton(
              label: isEdit ? 'Simpan Perubahan' : 'Simpan Jadwal',
              onPressed: _saveSchedule,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
