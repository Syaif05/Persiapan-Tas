import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bawa_app_bar.dart';
import '../../core/widgets/bawa_button.dart';
import '../../data/providers/database_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionAsync = ref.watch(notificationPermissionStatusProvider);

    return Scaffold(
      appBar: const BawaAppBar(
        title: 'Pengaturan',
        subtitle: 'Preferensi lokal, pengingat & backup',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Privasi & Data Offline
            Card(
              color: AppColors.primarySoft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.primary, size: 28),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('100% Offline & Pribadi', style: AppTypography.itemTitle),
                          SizedBox(height: 2),
                          Text(
                            'Data disimpan hanya di dalam perangkat kamu. Tanpa akun, tanpa cloud, dan tanpa analitik.',
                            style: AppTypography.metadata,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Bagian Pengingat & Notifikasi Android (Fase 5 - SCH-09)
            const Text('Pengingat & Alarm Android', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    permissionAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (err, _) => Text('Gagal memeriksa izin: $err', style: AppTypography.metadata),
                      data: (perm) {
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                perm.notificationsAllowed
                                    ? Icons.notifications_active_outlined
                                    : Icons.notifications_off_outlined,
                                color: perm.notificationsAllowed ? AppColors.success : AppColors.warning,
                              ),
                              title: const Text('Izin Notifikasi Sistem', style: AppTypography.itemTitle),
                              subtitle: Text(
                                perm.notificationsAllowed
                                    ? 'Diizinkan (Aktif)'
                                    : 'Belum diizinkan — alarm tidak akan muncul',
                                style: AppTypography.metadata.copyWith(
                                  color: perm.notificationsAllowed ? AppColors.success : AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: !perm.notificationsAllowed
                                  ? TextButton(
                                      onPressed: () async {
                                        final svc = ref.read(notificationServiceProvider);
                                        await svc.requestNotificationPermission();
                                        ref.invalidate(notificationPermissionStatusProvider);
                                      },
                                      child: const Text('Izinkan'),
                                    )
                                  : const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                            ),
                            const Divider(),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                perm.exactAlarmsAllowed ? Icons.alarm_on_outlined : Icons.alarm_outlined,
                                color: perm.exactAlarmsAllowed ? AppColors.success : AppColors.textSecondary,
                              ),
                              title: const Text('Ketepatan Alarm Presisi (Exact)', style: AppTypography.itemTitle),
                              subtitle: Text(
                                perm.exactAlarmsAllowed
                                    ? 'Aktif (Tepat waktu menit per menit)'
                                    : 'Perkiraan waktu (Fallback inexact alarm)',
                                style: AppTypography.metadata,
                              ),
                              trailing: !perm.exactAlarmsAllowed
                                  ? TextButton(
                                      onPressed: () async {
                                        final svc = ref.read(notificationServiceProvider);
                                        await svc.requestExactAlarmsPermission();
                                        ref.invalidate(notificationPermissionStatusProvider);
                                      },
                                      child: const Text('Pengaturan'),
                                    )
                                  : const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final repo = ref.read(remindersRepositoryProvider);
                        await repo.reconcileAllReminders();
                        ref.invalidate(notificationPermissionStatusProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua pengingat aktif telah disinkronkan ulang dengan sistem.'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.sync, size: 18),
                      label: const Text('Sinkronkan Ulang Pengingat'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Text(
                        'Penting: Pada beberapa perangkat Android (Xiaomi MIUI, Samsung, Oppo, Vivo), sistem penghemat baterai agresif dapat mematikan proses di latar belakang. Pastikan aplikasi Bawa diizinkan berjalan di latar belakang dan hindari opsi "Force Stop".',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Preferensi Waktu & Tampilan
            const Text('Tampilan & Format', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.schedule, color: AppColors.primary),
                    title: const Text('Format Jam', style: AppTypography.itemTitle),
                    subtitle: const Text('24 Jam (Contoh: 14:30)', style: AppTypography.bodySecondary),
                    trailing: const Icon(Icons.check, color: AppColors.success),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: const Text('Bahasa Aplikasi', style: AppTypography.itemTitle),
                    subtitle: const Text('Bahasa Indonesia', style: AppTypography.bodySecondary),
                    trailing: const Icon(Icons.check, color: AppColors.success),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Cadangan & Pemulihan (Backup)
            const Text('Pencadangan Data (Backup)', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Consumer(
              builder: (context, ref, _) {
                final lastBackupAsync = ref.watch(lastBackupDateProvider);
                final statusText = lastBackupAsync.when(
                  data: (dateStr) {
                    if (dateStr == null || dateStr.isEmpty) {
                      return 'Status: Belum ada ekspor cadangan';
                    }
                    try {
                      final dt = DateTime.parse(dateStr).toLocal();
                      final formatted = DateFormat('dd MMMM yyyy, HH:mm', 'id').format(dt);
                      return 'Status: Terakhir dicadangkan pada $formatted';
                    } catch (_) {
                      return 'Status: Terakhir dicadangkan pada $dateStr';
                    }
                  },
                  loading: () => 'Status: Memeriksa riwayat cadangan...',
                  error: (_, _) => 'Status: Belum ada ekspor cadangan',
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.folder_zip_outlined, color: AppColors.primary, size: 24),
                            SizedBox(width: AppSpacing.sm),
                            Text('Ekspor Arsip Lengkap', style: AppTypography.itemTitle),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Menghasilkan 1 file ZIP berisi seluruh inventaris, daftar perjalanan, tiket, dan foto resolusi asli.',
                          style: AppTypography.bodySecondary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(statusText, style: AppTypography.metadata),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: BawaButton(
                                label: 'Ekspor Data (.zip)',
                                onPressed: () async {
                                  try {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Row(
                                          children: [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                            ),
                                            SizedBox(width: 12),
                                            Text('Menyiapkan snapshot database & aset...'),
                                          ],
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );

                                    final savedLocation = await ref.read(backupServiceProvider).exportBackupWithFilePicker();
                                    if (savedLocation != null && context.mounted) {
                                      ref.invalidate(lastBackupDateProvider);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Cadangan berhasil disimpan: $savedLocation'),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Gagal mengekspor cadangan: $e'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: BawaButton(
                                label: 'Pulihkan Data',
                                variant: BawaButtonVariant.secondary,
                                onPressed: () async {
                                  try {
                                    final picked = await FilePicker.pickFile(
                                      type: FileType.custom,
                                      allowedExtensions: ['zip'],
                                    );
                                    if (picked == null || picked.path == null) return;

                                    if (!context.mounted) return;

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(
                                        child: Card(
                                          child: Padding(
                                            padding: EdgeInsets.all(AppSpacing.base),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(width: AppSpacing.md),
                                                Text('Memeriksa integritas arsip...'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );

                                    final file = File(picked.path!);
                                    final preview = await ref.read(backupServiceProvider).inspectArchive(file);

                                    if (!context.mounted) return;
                                    Navigator.of(context).pop(); // dismiss loading

                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Row(
                                          children: [
                                            Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                                            SizedBox(width: 8),
                                            Text('Pratinjau Cadangan'),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Waktu Cadangan: ${preview.formattedDate}', style: AppTypography.itemTitle),
                                              const SizedBox(height: AppSpacing.sm),
                                              Text('• Inventaris: ${preview.itemCount} barang'),
                                              Text('• Perjalanan: ${preview.tripCount} perjalanan'),
                                              Text('• Tiket & Jadwal: ${preview.ticketCount} tiket, ${preview.scheduleCount} jadwal'),
                                              Text('• Aset (Foto/Tiket): ${preview.assetCount} file'),
                                              Text('• Versi Skema: v${preview.manifest.schemaVersion}'),
                                              Text('• Ukuran Arsip: ${(preview.totalArchiveBytes / (1024 * 1024)).toStringAsFixed(2)} MB'),
                                              if (preview.warnings.isNotEmpty) ...[
                                                const SizedBox(height: AppSpacing.sm),
                                                Container(
                                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber.shade50,
                                                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                                    border: Border.all(color: Colors.amber.shade300),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text('Peringatan:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                                                      ...preview.warnings.map((w) => Text('• $w', style: const TextStyle(fontSize: 12))),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              const SizedBox(height: AppSpacing.md),
                                              Container(
                                                padding: const EdgeInsets.all(AppSpacing.sm),
                                                decoration: BoxDecoration(
                                                  color: AppColors.error.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                                  border: Border.all(color: AppColors.error),
                                                ),
                                                child: const Text(
                                                  'PERHATIAN: Pemulihan data bersifat Replace-All (menggantikan seluruh data dan aset saat ini). Data lama akan digantikan dengan cadangan ini.',
                                                  style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              preview.stagingDirectory.delete(recursive: true);
                                            },
                                            child: const Text('Batal'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                            onPressed: () async {
                                              Navigator.of(ctx).pop();
                                              if (!context.mounted) return;

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (_) => const Center(
                                                  child: Card(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(AppSpacing.base),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(width: AppSpacing.md),
                                                          Text('Memulihkan database & aset...'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );

                                              try {
                                                await ref.read(backupServiceProvider).restoreFromBackup(
                                                  preview,
                                                  onBeforeReplace: () async {},
                                                  onAfterReplace: () async {
                                                    ref.invalidate(databaseProvider);
                                                    ref.invalidate(lastBackupDateProvider);
                                                  },
                                                );

                                                if (!context.mounted) return;
                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Data cadangan berhasil dipulihkan secara utuh!'),
                                                    backgroundColor: AppColors.success,
                                                  ),
                                                );
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Gagal memulihkan cadangan: $e'),
                                                    backgroundColor: AppColors.error,
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Konfirmasi Pulihkan'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Gagal membaca file cadangan: $e'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Privasi & Keamanan Data (TECH-03)
            const Text('Privasi & Keamanan Data', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.security, color: AppColors.primary, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('100% Offline & Lokal', style: AppTypography.itemTitle),
                          SizedBox(height: 4),
                          Text(
                            'Data disimpan di perangkat; aplikasi tidak mengirim data ke server. Tidak ada akun, tidak ada pelacakan analitik, dan backup cloud Android dinonaktifkan.',
                            style: AppTypography.bodySecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Zona Berbahaya (Reset Data)
            const Text('Zona Berbahaya', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.error),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: AppColors.error),
                title: const Text('Reset Seluruh Data Aplikasi', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                subtitle: const Text('Menghapus semua inventaris dan perjalanan secara permanen', style: AppTypography.metadata),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Hapus Semua Data?'),
                      content: const Text(
                        'Tindakan ini tidak dapat dibatalkan. Pastikan kamu sudah mengekspor file backup terlebih dahulu.',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Simulasi konfirmasi penghapusan aman')),
                            );
                          },
                          child: const Text('Hapus Permanen'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
            const Center(
              child: Text(
                'Siapkan Tas v1.0.0\nDibuat dengan Flutter untuk Android',
                textAlign: TextAlign.center,
                style: AppTypography.metadata,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
