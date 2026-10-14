import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/agenda/agenda_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/inventory/inventory_screen.dart';
import '../../features/inventory/item_detail_screen.dart';
import '../../features/inventory/item_form_screen.dart';
import '../../features/inventory/location_detail_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/trips/checkpoint_screen.dart';
import '../../features/trips/ticket_detail_screen.dart';
import '../../features/trips/ticket_form_screen.dart';
import '../../features/trips/trip_detail_screen.dart';
import '../../features/trips/trip_form_screen.dart';
import '../../features/trips/trips_screen.dart';
import '../../features/agenda/schedule_form_screen.dart';
import '../../features/search/unified_search_screen.dart';

GoRouter createAppRouter({String initialLocation = '/home', GlobalKey<NavigatorState>? navigatorKey}) {
  final rootNavKey = navigatorKey ?? GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: initialLocation,
    routes: [
    // ShellRoute untuk 4 Tab Utama (Beranda, Barang, Perjalanan, Agenda)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            backgroundColor: AppColors.surface,
            elevation: 3.0,
            indicatorColor: AppColors.primarySoft,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: AppColors.primary),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag, color: AppColors.primary),
                label: 'Tas',
              ),
              NavigationDestination(
                icon: Icon(Icons.luggage_outlined),
                selectedIcon: Icon(Icons.luggage, color: AppColors.primary),
                label: 'Perjalanan',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month, color: AppColors.primary),
                label: 'Agenda',
              ),
            ],
          ),
        );
      },
      branches: [
        // Tab 1: Beranda
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 2: Barang
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'locations',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) => const LocationDetailScreen(),
                ),
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) {
                    final locationId = state.uri.queryParameters['locationId'];
                    final tripId = state.uri.queryParameters['tripId'];
                    return ItemFormScreen(
                      initialLocationId: locationId,
                      initialTripId: tripId,
                    );
                  },
                ),
                GoRoute(
                  path: 'items/:itemId',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) {
                    final itemId = state.pathParameters['itemId']!;
                    return ItemDetailScreen(itemId: itemId);
                  },
                ),
                GoRoute(
                  path: 'edit/:itemId',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) {
                    final itemId = state.pathParameters['itemId']!;
                    final tripId = state.uri.queryParameters['tripId'];
                    return ItemFormScreen(
                      itemId: itemId,
                      initialTripId: tripId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // Tab 3: Perjalanan
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/trips',
              builder: (context, state) => const TripsScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) => const TripFormScreen(),
                ),
                GoRoute(
                  path: 'edit/:tripId',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) {
                    final tripId = state.pathParameters['tripId'];
                    return TripFormScreen(tripId: tripId);
                  },
                ),
                GoRoute(
                  path: ':tripId',
                  parentNavigatorKey: rootNavKey,
                  builder: (context, state) {
                    final tripId = state.pathParameters['tripId'] ?? 'trip-1';
                    return TripDetailScreen(tripId: tripId);
                  },
                  routes: [
                    GoRoute(
                      path: 'checkpoint',
                      parentNavigatorKey: rootNavKey,
                      builder: (context, state) {
                        final tripId = state.pathParameters['tripId'] ?? 'trip-1';
                        return CheckpointScreen(tripId: tripId);
                      },
                    ),
                    GoRoute(
                      path: 'schedules/new',
                      parentNavigatorKey: rootNavKey,
                      builder: (context, state) {
                        final tripId = state.pathParameters['tripId'] ?? 'trip-1';
                        return ScheduleFormScreen(tripId: tripId);
                      },
                    ),
                    GoRoute(
                      path: 'schedules/edit/:scheduleId',
                      parentNavigatorKey: rootNavKey,
                      builder: (context, state) {
                        final tripId = state.pathParameters['tripId'] ?? 'trip-1';
                        final scheduleId = state.pathParameters['scheduleId']!;
                        return ScheduleFormScreen(tripId: tripId, scheduleId: scheduleId);
                      },
                    ),
                    GoRoute(
                      path: 'tickets/new',
                      parentNavigatorKey: rootNavKey,
                      builder: (context, state) {
                        final tripId = state.pathParameters['tripId'] ?? 'trip-1';
                        return TicketFormScreen(tripId: tripId);
                      },
                    ),
                    GoRoute(
                      path: 'tickets/edit/:ticketId',
                      parentNavigatorKey: rootNavKey,
                      builder: (context, state) {
                        final tripId = state.pathParameters['tripId'] ?? 'trip-1';
                        final ticketId = state.pathParameters['ticketId']!;
                        return TicketFormScreen(tripId: tripId, ticketId: ticketId);
                      },
                    ),
                    GoRoute(
                      path: 'tickets/:ticketId',
                      parentNavigatorKey: rootNavKey,
                      builder: (context, state) {
                        final ticketId = state.pathParameters['ticketId'] ?? 'tkt-1';
                        return TicketDetailScreen(ticketId: ticketId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 4: Agenda
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/agenda',
              builder: (context, state) => const AgendaScreen(),
            ),
          ],
        ),
      ],
    ),

    // Rute Global di Luar Tab
    GoRoute(
      path: '/search',
      parentNavigatorKey: rootNavKey,
      builder: (context, state) {
        final tripId = state.uri.queryParameters['tripId'];
        return UnifiedSearchScreen(initialTripId: tripId);
      },
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: rootNavKey,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  );
}

final GoRouter appRouter = createAppRouter();
