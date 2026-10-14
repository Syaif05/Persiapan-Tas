import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../data/providers/database_providers.dart';

class TripFormScreen extends ConsumerStatefulWidget {
  final String? tripId;

  const TripFormScreen({super.key, this.tripId});

  @override
  ConsumerState<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends ConsumerState<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  final DateFormat _displayFormat = DateFormat('d MMM yyyy');

  final List<TextEditingController> _stopControllers = [
    TextEditingController(text: 'Bandung'),
  ];

  bool _isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit && widget.tripId != null) {
      _loadExistingTrip(widget.tripId!);
      _isInit = true;
    }
  }

  Future<void> _loadExistingTrip(String id) async {
    final tripRepo = ref.read(tripsRepositoryProvider);
    final tripDetails = await tripRepo.watchTripWithDetails(id).first;
    if (tripDetails != null && mounted) {
      setState(() {
        _nameController.text = tripDetails.trip.name;
        _notesController.text = tripDetails.trip.notes ?? '';
        _startDate = DateTime.tryParse(tripDetails.trip.startDate) ?? DateTime.now();
        if (tripDetails.trip.endDate != null) {
          _endDate = DateTime.tryParse(tripDetails.trip.endDate!);
        }

        for (var c in _stopControllers) {
          c.dispose();
        }
        _stopControllers.clear();

        if (tripDetails.stops.isNotEmpty) {
          for (var stop in tripDetails.stops) {
            _stopControllers.add(TextEditingController(text: stop.label));
          }
        } else {
          _stopControllers.add(TextEditingController(text: 'Bandung'));
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    for (var c in _stopControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addStop() {
    setState(() {
      _stopControllers.add(TextEditingController());
    });
  }

  void _removeStop(int index) {
    if (_stopControllers.length > 1) {
      setState(() {
        final c = _stopControllers.removeAt(index);
        c.dispose();
      });
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _saveTrip() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final stops = _stopControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (stops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal satu tujuan kota wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tripRepo = ref.read(tripsRepositoryProvider);
      final startDateIso = DateFormat('yyyy-MM-dd').format(_startDate);
      final endDateIso = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : null;

      if (widget.tripId != null) {
        await tripRepo.updateTrip(
          id: widget.tripId!,
          name: _nameController.text.trim(),
          startDate: startDateIso,
          endDate: endDateIso,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          stops: stops,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perjalanan berhasil diperbarui')),
          );
          context.pop();
        }
      } else {
        final newId = await tripRepo.createTrip(
          name: _nameController.text.trim(),
          startDate: startDateIso,
          endDate: endDateIso,
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          stops: stops,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perjalanan baru berhasil dibuat')),
          );
          context.pushReplacement('/trips/$newId');
        }
      }
    } catch (e, stack) {
      debugPrint('Error _saveTrip: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan perjalanan: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tripId != null;

    return Scaffold(
      appBar: BawaAppBar(
        title: isEdit ? 'Edit Perjalanan' : 'Buat Perjalanan',
        subtitle: 'Atur rencana perjalanan dan tujuan kota',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Perjalanan
              const Text('Nama Perjalanan *', style: AppTypography.itemTitle),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Contoh: Bandung Akhir Pekan'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama perjalanan tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.base),

              // Tanggal Mulai dan Selesai
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanggal Mulai *', style: AppTypography.itemTitle),
                        const SizedBox(height: AppSpacing.xs),
                        InkWell(
                          onTap: _pickStartDate,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today, size: 18),
                            ),
                            child: Text(
                              _displayFormat.format(_startDate),
                              style: AppTypography.body,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Selesai', style: AppTypography.itemTitle),
                            if (_endDate != null)
                              InkWell(
                                onTap: () => setState(() => _endDate = null),
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: AppColors.error, fontSize: 11),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        InkWell(
                          onTap: _pickEndDate,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_month, size: 18),
                            ),
                            child: Text(
                              _endDate != null ? _displayFormat.format(_endDate!) : 'Belum pasti',
                              style: _endDate != null ? AppTypography.body : AppTypography.bodySecondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),

              // Rute & Tujuan Kota (Dapat Berulang, Multi-kota)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text('Tujuan Perjalanan *', style: AppTypography.itemTitle, overflow: TextOverflow.ellipsis),
                  ),
                  TextButton.icon(
                    onPressed: _addStop,
                    icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                    label: const Text('Tambah Kota'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ...List.generate(_stopControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primarySoft,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextFormField(
                          controller: _stopControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Kota atau tempat tujuan ${index + 1}',
                          ),
                          validator: (val) {
                            if (index == 0 && (val == null || val.trim().isEmpty)) {
                              return 'Tujuan pertama wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_stopControllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 20),
                          onPressed: () => _removeStop(index),
                          tooltip: 'Hapus tujuan',
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.base),

              // Catatan Perjalanan
              const Text('Catatan Perjalanan (Opsional)', style: AppTypography.itemTitle),
              const SizedBox(height: AppSpacing.xs),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tulis keperluan, catatan hotel, atau rencana umum...',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Tombol Simpan
              BawaButton(
                label: isEdit ? 'Simpan Perubahan' : 'Buat Perjalanan',
                isLoading: _isLoading,
                onPressed: _saveTrip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
