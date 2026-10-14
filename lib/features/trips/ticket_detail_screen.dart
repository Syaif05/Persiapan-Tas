import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../data/providers/database_providers.dart';

class TicketDetailScreen extends ConsumerWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  void _copyBookingCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode booking "$code" disalin ke papan klip'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openFileLocally(BuildContext context, String relativePath, WidgetRef ref) async {
    final storage = ref.read(assetStorageServiceProvider);
    final file = await storage.resolveRelativeFile(relativePath);

    if (!await file.exists()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berkas lampiran tidak ditemukan di penyimpanan lokal'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak dapat membuka berkas: ${result.message}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showZoomImageModal(BuildContext context, File imageFile, String title) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 6.0,
                child: Center(
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
              Positioned(
                top: 48,
                left: 70,
                right: 16,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Cubit atau geser untuk zoom QR / Barcode',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addMoreAttachment(BuildContext context, WidgetRef ref) async {
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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Berkas melebihi batas 20 MB'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        await ref.read(ticketsRepositoryProvider).addAttachment(
              ticketId: ticketId,
              file: file,
              originalName: result.first.name,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lampiran berhasil ditambahkan')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(ticketDetailStreamProvider(ticketId));

    return ticketAsync.when(
      loading: () => const Scaffold(
        appBar: BawaAppBar(title: 'Memuat Tiket...'),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: const BawaAppBar(title: 'Detail Tiket'),
        body: Center(child: Text('Gagal memuat tiket: $err')),
      ),
      data: (details) {
        if (details == null) {
          return const Scaffold(
            appBar: BawaAppBar(title: 'Detail Tiket'),
            body: Center(child: Text('Tiket tidak ditemukan')),
          );
        }

        final ticket = details.ticket;
        final trip = details.trip;
        final schedule = details.schedule;
        final attachments = details.attachments;

        return Scaffold(
          appBar: BawaAppBar(
            title: 'Detail Tiket',
            subtitle: ticket.provider ?? trip.name,
            actions: [
              IconButton(
                tooltip: 'Edit Tiket',
                icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                onPressed: () {
                  context.push('/trips/${trip.id}/tickets/edit/${ticket.id}');
                },
              ),
              IconButton(
                tooltip: 'Hapus Tiket',
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Hapus Tiket', style: AppTypography.itemTitle),
                      content: Text('Yakin ingin menghapus tiket "${ticket.title}" beserta seluruh lampirannya?'),
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

                  if (confirm == true && context.mounted) {
                    await ref.read(ticketsRepositoryProvider).deleteTicket(ticket.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tiket berhasil dihapus')),
                      );
                      context.pop();
                    }
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Kartu Informasi Utama Tiket
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 22),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                ticket.title,
                                style: AppTypography.itemTitle.copyWith(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        if (ticket.provider != null && ticket.provider!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text('Penyedia: ${ticket.provider}', style: AppTypography.metadata),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        const Divider(),
                        const SizedBox(height: AppSpacing.sm),

                        // Kode Booking (Prominen)
                        if (ticket.bookingCode != null && ticket.bookingCode!.isNotEmpty) ...[
                          const Text('KODE BOOKING / NOMOR RESERVASI', style: AppTypography.badge),
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SelectableText(
                                    ticket.bookingCode!,
                                    style: AppTypography.screenTitle.copyWith(
                                      fontSize: 22,
                                      color: AppColors.primaryDark,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Salin Kode Booking',
                                  icon: const Icon(Icons.copy, color: AppColors.primary),
                                  onPressed: () => _copyBookingCode(context, ticket.bookingCode!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],

                        // Jadwal Terkait
                        if (schedule != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.event_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  'Jadwal: ${schedule.localDate} • ${schedule.title}',
                                  style: AppTypography.body,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ] else ...[
                          Row(
                            children: [
                              const Icon(Icons.link_off_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: AppSpacing.xs),
                              const Text('Tiket mandiri (belum ditautkan ke jadwal)', style: AppTypography.metadata),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],

                        Row(
                          children: [
                            const Icon(Icons.flight_takeoff_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Text('Perjalanan: ${trip.name}', style: AppTypography.metadata),
                          ],
                        ),

                        if (ticket.notes != null && ticket.notes!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          const Divider(),
                          const SizedBox(height: AppSpacing.xs),
                          const Text('Catatan Tambahan:', style: AppTypography.metadata),
                          const SizedBox(height: 2),
                          Text(ticket.notes!, style: AppTypography.body),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 2. Lampiran Dokumen Offline (AT-09)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Lampiran Tiket (Offline)', style: AppTypography.sectionTitle),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Tambah File'),
                      onPressed: () => _addMoreAttachment(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Lampiran tersimpan di perangkat lokal dan dapat dibuka saat mode pesawat. '
                  'Resolusi asli dipertahankan agar barcode/QR tetap tajam saat di-zoom.',
                  style: AppTypography.metadata,
                ),
                const SizedBox(height: AppSpacing.md),

                if (attachments.isEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.base),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.attach_file_outlined, size: 40, color: AppColors.textSecondary),
                            const SizedBox(height: AppSpacing.sm),
                            const Text('Belum ada lampiran berkas', style: AppTypography.itemTitle),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              'Lampirkan PDF atau gambar tiket agar tidak perlu repot mencari saat bepergian.',
                              style: AppTypography.metadata,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            FilledButton.icon(
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Tambah Lampiran Tiket'),
                              onPressed: () => _addMoreAttachment(context, ref),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ...attachments.map((att) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.base),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  att.isPdf ? Icons.picture_as_pdf : Icons.image,
                                  color: att.isPdf ? Colors.red : AppColors.primary,
                                  size: 28,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        att.originalName,
                                        style: AppTypography.itemTitle.copyWith(fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${(att.sizeBytes / 1024).toStringAsFixed(1)} KB • SHA-256: ${att.sha256.substring(0, 8)}...',
                                        style: AppTypography.metadata,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Hapus Lampiran',
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                  onPressed: () async {
                                    await ref.read(ticketsRepositoryProvider).removeAttachment(att.id);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),

                            // Preview gambar jika tipe gambar
                            if (att.isImage) ...[
                              FutureBuilder<File>(
                                future: ref.read(assetStorageServiceProvider).resolveRelativeFile(att.relativePath),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                                  }
                                  final file = snapshot.data!;
                                  return GestureDetector(
                                    onTap: () => _showZoomImageModal(context, file, att.originalName),
                                    child: Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceMuted,
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.file(file, fit: BoxFit.cover),
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.7),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.zoom_in, color: Colors.white, size: 14),
                                                  SizedBox(width: 4),
                                                  Text('Ketuk untuk Zoom QR', style: TextStyle(color: Colors.white, fontSize: 11)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],

                            // Tombol Buka Berkas via OpenFilex
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Icon(att.isPdf ? Icons.open_in_new : Icons.fullscreen),
                                label: Text(att.isPdf ? 'Buka Dokumen PDF' : 'Buka di Aplikasi Gambar'),
                                onPressed: () => _openFileLocally(context, att.relativePath, ref),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
