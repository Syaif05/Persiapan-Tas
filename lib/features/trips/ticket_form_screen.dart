import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/tickets_repository.dart';

class TicketFormScreen extends ConsumerStatefulWidget {
  final String tripId;
  final String? ticketId; // null bila membuat baru

  const TicketFormScreen({
    super.key,
    required this.tripId,
    this.ticketId,
  });

  @override
  ConsumerState<TicketFormScreen> createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends ConsumerState<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _providerCtrl;
  late TextEditingController _bookingCodeCtrl;
  late TextEditingController _notesCtrl;

  String? _selectedScheduleEventId;
  bool _isLoading = true;

  // Berkas baru yang dipilih pengguna (File staging)
  final List<File> _pendingFiles = [];

  // Berkas lampiran lama (jika mode edit)
  List<TicketAttachmentWithAsset> _existingAttachments = [];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _providerCtrl = TextEditingController();
    _bookingCodeCtrl = TextEditingController();
    _notesCtrl = TextEditingController();

    _loadInitialData();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _providerCtrl.dispose();
    _bookingCodeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (widget.ticketId != null) {
      final ticketsRepo = ref.read(ticketsRepositoryProvider);
      final existing = await ticketsRepo.getTicketById(widget.ticketId!);

      if (existing != null) {
        _titleCtrl.text = existing.title;
        _providerCtrl.text = existing.provider ?? '';
        _bookingCodeCtrl.text = existing.bookingCode ?? '';
        _notesCtrl.text = existing.notes ?? '';
        _selectedScheduleEventId = existing.scheduleEventId;
        _existingAttachments = existing.attachments;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result.isNotEmpty) {
        final path = result.first.path;
        if (path != null) {
          final file = File(path);
          final bytes = await file.length();
          if (bytes > 20 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('File melebihi batas maksimal 20 MB'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
            return;
          }

          if (widget.ticketId != null) {
            // Mode edit: langsung simpan ke database
            final ticketsRepo = ref.read(ticketsRepositoryProvider);
            final newAtt = await ticketsRepo.addAttachment(
              ticketId: widget.ticketId!,
              file: file,
              originalName: result.first.name,
            );
            setState(() {
              _existingAttachments.add(newAtt);
            });
          } else {
            // Mode buat baru: simpan di staging
            setState(() {
              _pendingFiles.add(file);
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih dokumen: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        final bytes = await file.length();
        if (bytes > 20 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gambar melebihi batas maksimal 20 MB'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        if (widget.ticketId != null) {
          final ticketsRepo = ref.read(ticketsRepositoryProvider);
          final newAtt = await ticketsRepo.addAttachment(
            ticketId: widget.ticketId!,
            file: file,
            originalName: picked.name,
          );
          setState(() {
            _existingAttachments.add(newAtt);
          });
        } else {
          setState(() {
            _pendingFiles.add(file);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteExistingAttachment(TicketAttachmentWithAsset att) async {
    final ticketsRepo = ref.read(ticketsRepositoryProvider);
    await ticketsRepo.removeAttachment(att.id);
    setState(() {
      _existingAttachments.removeWhere((a) => a.id == att.id);
    });
  }

  Future<void> _saveTicket() async {
    if (!_formKey.currentState!.validate()) return;

    final ticketsRepo = ref.read(ticketsRepositoryProvider);

    try {
      if (widget.ticketId == null) {
        // Buat tiket baru
        final newTicketId = await ticketsRepo.createTicket(
          tripId: widget.tripId,
          title: _titleCtrl.text.trim(),
          provider: _providerCtrl.text.trim().isNotEmpty ? _providerCtrl.text.trim() : null,
          bookingCode: _bookingCodeCtrl.text.trim().isNotEmpty ? _bookingCodeCtrl.text.trim().toUpperCase() : null,
          notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
          scheduleEventId: _selectedScheduleEventId,
        );

        // Simpan file pending ke tiket yang baru dibuat
        for (final file in _pendingFiles) {
          await ticketsRepo.addAttachment(ticketId: newTicketId, file: file);
        }
      } else {
        // Update tiket
        await ticketsRepo.updateTicket(
          widget.ticketId!,
          title: _titleCtrl.text.trim(),
          provider: _providerCtrl.text.trim().isNotEmpty ? _providerCtrl.text.trim() : null,
          bookingCode: _bookingCodeCtrl.text.trim().isNotEmpty ? _bookingCodeCtrl.text.trim().toUpperCase() : null,
          notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
          scheduleEventId: _selectedScheduleEventId,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.ticketId == null
                ? 'Tiket berhasil disimpan'
                : 'Tiket berhasil diperbarui'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan tiket: $e'),
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
        appBar: BawaAppBar(title: 'Memuat Tiket...'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isEdit = widget.ticketId != null;
    final schedulesStream = ref.watch(tripSchedulesStreamProvider(widget.tripId));

    return Scaffold(
      appBar: BawaAppBar(
        title: isEdit ? 'Edit Tiket' : 'Tambah Tiket / Reservasi',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            // 1. Judul Tiket
            const Text('Judul Tiket / Reservasi *', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                hintText: 'Contoh: Kereta Argo Parahyangan / Hotel Santika',
                prefixIcon: Icon(Icons.confirmation_number_outlined),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Judul tiket tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // 2. Penyedia / Maskapai
            const Text('Penyedia / Maskapai / Hotel (Opsional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _providerCtrl,
              decoration: const InputDecoration(
                hintText: 'Contoh: KAI / Garuda Indonesia / Agoda',
                prefixIcon: Icon(Icons.business_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. Kode Pemesanan / Booking Code
            const Text('Kode Booking / Nomor Reservasi (Opsional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _bookingCodeCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'Contoh: ABC123XYZ',
                prefixIcon: Icon(Icons.qr_code_scanner_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 4. Hubungkan ke Jadwal Perjalanan (Opsional, SCH-07)
            const Text('Tautkan ke Jadwal Kegiatan (Opsional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            schedulesStream.when(
              data: (schedules) {
                return DropdownButtonFormField<String?>(
                  isExpanded: true,
                  initialValue: _selectedScheduleEventId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.event_available_outlined),
                  ),
                  hint: const Text('Pilih jadwal terkait (bisa nanti)'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Simpan mandiri (tanpa jadwal)'),
                    ),
                    ...schedules.map((s) => DropdownMenuItem<String?>(
                          value: s.id,
                          child: Text(
                            '${s.formattedDate} - ${s.title}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedScheduleEventId = val;
                    });
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('Gagal memuat jadwal perjalanan'),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 5. Lampiran Offline Tiket (PDF / Foto Resolusi Asli)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('Lampiran Tiket (Offline)', style: AppTypography.itemTitle),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Tambah Berkas Lampiran',
                          icon: const Icon(Icons.attach_file, color: AppColors.primary),
                          onSelected: (val) {
                            if (val == 'document') {
                              _pickDocument();
                            } else if (val == 'image') {
                              _pickImage();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'document',
                              child: Row(
                                children: [
                                  Icon(Icons.picture_as_pdf, color: AppColors.primary),
                                  SizedBox(width: AppSpacing.sm),
                                  Text('Pilih PDF / Dokumen'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'image',
                              child: Row(
                                children: [
                                  Icon(Icons.image_outlined, color: AppColors.primary),
                                  SizedBox(width: AppSpacing.sm),
                                  Text('Pilih Foto / Barcode Tiket'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      'File akan disalin ke penyimpanan aplikasi sehingga dapat dibuka saat mode pesawat. '
                      'Foto tiket mempertahankan resolusi penuh agar QR / Barcode tetap terbaca tajam.',
                      style: AppTypography.metadata,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Daftar Lampiran Lama (Mode Edit)
                    if (_existingAttachments.isNotEmpty) ...[
                      const Text('Lampiran Tersimpan:', style: AppTypography.metadata),
                      const SizedBox(height: AppSpacing.xs),
                      ..._existingAttachments.map((att) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            att.isPdf ? Icons.picture_as_pdf : Icons.image,
                            color: att.isPdf ? Colors.red : AppColors.primary,
                          ),
                          title: Text(att.originalName, overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                            '${(att.sizeBytes / 1024).toStringAsFixed(1)} KB',
                            style: AppTypography.metadata,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
                            onPressed: () => _deleteExistingAttachment(att),
                          ),
                        );
                      }),
                      const Divider(),
                    ],

                    // Daftar Lampiran Baru di Staging
                    if (_pendingFiles.isNotEmpty) ...[
                      const Text('Lampiran Baru Siap Disimpan:', style: AppTypography.metadata),
                      const SizedBox(height: AppSpacing.xs),
                      ..._pendingFiles.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final file = entry.value;
                        final isPdf = file.path.toLowerCase().endsWith('.pdf');
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            isPdf ? Icons.picture_as_pdf : Icons.image,
                            color: isPdf ? Colors.red : AppColors.primary,
                          ),
                          title: Text(file.path.split(Platform.pathSeparator).last, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: AppColors.error),
                            onPressed: () {
                              setState(() {
                                _pendingFiles.removeAt(idx);
                              });
                            },
                          ),
                        );
                      }),
                    ],

                    if (_existingAttachments.isEmpty && _pendingFiles.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.textSecondary),
                            const SizedBox(height: AppSpacing.xs),
                            const Text('Belum ada lampiran berkas', style: AppTypography.bodySecondary),
                            const SizedBox(height: AppSpacing.sm),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Lampirkan PDF atau Gambar'),
                              onPressed: _pickDocument,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 6. Catatan
            const Text('Catatan (Opsional)', style: AppTypography.body),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ketentuan check-in, terminal keberangkatan, atau catatan penting...',
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Tombol Simpan
            BawaButton(
              label: isEdit ? 'Simpan Perubahan' : 'Simpan Tiket',
              onPressed: _saveTicket,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
