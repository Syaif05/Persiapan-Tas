import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bawa/app/navigation/app_router.dart';
import 'package:bawa/data/database/app_database.dart';
import 'package:bawa/data/providers/database_providers.dart';
import 'package:bawa/data/repositories/inventory_repository.dart';
import 'package:bawa/data/repositories/locations_repository.dart';
import 'package:bawa/data/repositories/trips_repository.dart';
import 'package:bawa/data/repositories/trip_packing_repository.dart';
import 'package:bawa/data/repositories/schedules_repository.dart';
import 'package:bawa/main.dart';

Future<void> seedTestTripAndItem(AppDatabase testDb) async {
  final locs = await LocationsRepository(testDb).getActiveLocations();
  final item = await InventoryRepository(testDb).createItem(
    name: 'Charger USB-C 65W',
    quantity: 1,
    storageLocationId: locs.isNotEmpty ? locs.first.id : null,
  );
  final tripId = await TripsRepository(testDb).createTrip(
    name: 'Bandung Akhir Pekan',
    startDate: '2026-10-18',
    endDate: '2026-10-20',
    stops: ['Bandung'],
  );
  await TripPackingRepository(testDb).setPlannedItem(
    tripId: tripId,
    itemId: item.item.id,
    plannedQuantity: 1,
  );
  await SchedulesRepository(testDb).createSchedule(
    tripId: tripId,
    title: 'Kereta Argo Parahyangan ke Bandung',
    type: 'transport',
    localDate: '2026-10-18',
    localStart: '07:30',
    startZone: 'Asia/Jakarta',
  );
}

void main() {
  testWidgets('Smoke test: BawaApp mounts successfully with 4 navigation tabs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() => tester.view.resetPhysicalSize());

    final testDb = AppDatabase.inMemory();
    addTearDown(() => testDb.close());

    await seedTestTripAndItem(testDb);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: BawaApp(router: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('Siapkan Tas'), findsOneWidget);

    // Verify 4 Bottom Navigation Tabs
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Tas'), findsOneWidget);
    expect(find.text('Perjalanan'), findsOneWidget);
    expect(find.text('Agenda'), findsOneWidget);

    // Verify Active Trip Card on Home
    expect(find.text('Bandung Akhir Pekan'), findsOneWidget);
    expect(find.text('Buka Bawaan & Packing'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('Accessibility test: Narrow 360dp width and 1.5x font scale does not crash/overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 2.0, 800 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    final testDb = AppDatabase.inMemory();
    addTearDown(() => testDb.close());

    await seedTestTripAndItem(testDb);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: BawaApp(router: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();

    // Verify essential elements still render
    expect(find.text('Siapkan Tas'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('Navigation test: Switch between tabs smoothly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() => tester.view.resetPhysicalSize());

    final testDb = AppDatabase.inMemory();
    addTearDown(() => testDb.close());

    await seedTestTripAndItem(testDb);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(testDb),
        ],
        child: BawaApp(router: createAppRouter()),
      ),
    );
    await tester.pumpAndSettle();

    // Tap on 'Tas' tab
    await tester.tap(find.text('Tas'));
    await tester.pumpAndSettle();

    expect(find.text('Cari nama barang, kotak, atau kategori...'), findsOneWidget);
    expect(find.text('Charger USB-C 65W'), findsOneWidget);
    expect(find.text('Asal: Kotak Elektronik'), findsWidgets);

    // Tap on 'Agenda' tab
    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();

    expect(find.text('Agenda'), findsWidgets);
    expect(find.text('Kereta Argo Parahyangan ke Bandung'), findsOneWidget);

    // Tap on 'Perjalanan' tab
    await tester.tap(find.text('Perjalanan'));
    await tester.pumpAndSettle();

    expect(find.text('Bandung Akhir Pekan'), findsOneWidget);

    // Unmount and flush pending timers
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));
  });
}
