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
}

void main() {
  group('Fase 3 Feature Interaction Tests', () {
    testWidgets('Verify packing toggle, rapid check, and undo snackbar', (WidgetTester tester) async {
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

      // Navigate to Bandung trip detail via Home card button
      await tester.tap(find.text('Buka Bawaan & Packing'));
      await tester.pumpAndSettle();

      // Go to Bawaan sub-tab
      await tester.tap(find.text('Bawaan'));
      await tester.pumpAndSettle();

      // Verify item list displays source location (PCK-07)
      expect(find.text('Charger USB-C 65W'), findsOneWidget);
      expect(find.text('Asal: Kotak Elektronik'), findsWidgets);

      // Verify rapid check button interaction
      final uncheckedIcon = find.byIcon(Icons.radio_button_unchecked);
      expect(uncheckedIcon, findsOneWidget);

      await tester.tap(uncheckedIcon);
      await tester.pump(); // frame for snackbar
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Urungkan'), findsOneWidget);

      // Tap undo (PCK-10)
      await tester.tap(find.text('Urungkan'));
      await tester.pumpAndSettle();

      // Flush timers
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('Verify Empty State informative messages on blank database', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testDb = AppDatabase.inMemory();
      addTearDown(() => testDb.close());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(testDb),
          ],
          child: BawaApp(router: createAppRouter()),
        ),
      );
      await tester.pumpAndSettle();

      // Home shows no active trip
      expect(find.text('Belum Ada Perjalanan Aktif'), findsOneWidget);
      expect(find.text('Buat Perjalanan Baru'), findsOneWidget);

      // Navigate to Perjalanan tab
      await tester.tap(find.text('Perjalanan'));
      await tester.pumpAndSettle();
      expect(find.text('Belum ada perjalanan persiapan'), findsOneWidget);

      // Navigate to Tas tab
      await tester.tap(find.text('Tas'));
      await tester.pumpAndSettle();
      expect(find.text('Belum ada barang'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 200));
    });

    testWidgets('Form validation: ItemFormScreen rejects empty name and 0 quantity', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(() => tester.view.resetPhysicalSize());

      final testDb = AppDatabase.inMemory();
      addTearDown(() => testDb.close());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(testDb),
          ],
          child: BawaApp(router: createAppRouter()),
        ),
      );
      await tester.pumpAndSettle();

      // Go to Tas tab
      await tester.tap(find.text('Tas'));
      await tester.pumpAndSettle();

      // Tap add button (using first to avoid ambiguity with empty state button)
      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      // Scroll to button if needed and try submitting empty form
      final submitButton = find.text('Simpan ke Inventaris');
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Nama barang tidak boleh kosong'), findsOneWidget);

      // Enter valid name, enter 0 quantity
      await tester.enterText(find.byType(TextFormField).first, 'Test Item');
      await tester.pumpAndSettle();
      final qtyFinder = find.widgetWithText(TextFormField, '1');
      if (qtyFinder.evaluate().isNotEmpty) {
        await tester.enterText(qtyFinder, '0');
        await tester.pumpAndSettle();
      }

      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Min 1'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 200));
    });
  });
}
