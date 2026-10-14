import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/database_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale formatting untuk Bahasa Indonesia (id_ID & id) (SCH-03, SCH-04)
  await initializeDateFormatting('id_ID', null);
  await initializeDateFormatting('id', null);

  final container = ProviderContainer();

  // Inisialisasi service notifikasi lokal (SCH-11, AT-16)
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.initialize(
    onTapped: (payload) {
      if (payload.tripId != null) {
        appRouter.push('/trips/${payload.tripId}');
      } else {
        appRouter.go('/agenda');
      }
    },
  );

  // Pemulihan jika proses restore sebelumnya terputus/crash (TECH-01, QA-43)
  try {
    final backupService = container.read(backupServiceProvider);
    await backupService.checkAndRecoverInterruptedRestore(
      onAfterRecover: () async {
        container.invalidate(databaseProvider);
      },
    );
  } catch (e) {
    debugPrint('Crash recovery on startup: $e');
  }

  // Rekonsiliasi pengingat setelah start / reboot (AT-15)
  try {
    final remindersRepo = container.read(remindersRepositoryProvider);
    await remindersRepo.reconcileAllReminders();
  } catch (e) {
    debugPrint('Reminder reconciliation on startup: $e');
  }

  // Handle cold start launch payload jika aplikasi dibuka dari tap notifikasi
  final coldStartPayload = notificationService.initialLaunchPayload;
  if (coldStartPayload != null && coldStartPayload.tripId != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appRouter.push('/trips/${coldStartPayload.tripId}');
    });
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BawaApp(),
    ),
  );
}

class BawaApp extends StatelessWidget {
  final GoRouter? router;

  const BawaApp({super.key, this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Siapkan Tas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router ?? appRouter,
    );
  }
}
