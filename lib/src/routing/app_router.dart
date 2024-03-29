import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:walking_simulator/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:walking_simulator/src/features/authentication/presentation/custom_profile_screen.dart';
import 'package:walking_simulator/src/features/authentication/presentation/custom_sign_in_screen.dart';
import 'package:walking_simulator/src/features/entries/presentation/entries_screen.dart';
import 'package:walking_simulator/src/features/entries/domain/entry.dart';
import 'package:walking_simulator/src/features/journeys/domain/journey.dart';
import 'package:walking_simulator/src/features/entries/presentation/entry_screen/entry_screen.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journey_entries_screen/journey_entries_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:walking_simulator/src/features/journeys/presentation/edit_journey_screen/edit_journey_screen.dart';
import 'package:walking_simulator/src/features/journeys/presentation/journeys_screen/journeys_screen.dart';
import 'package:walking_simulator/src/features/onboarding/data/onboarding_repository.dart';
import 'package:walking_simulator/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:walking_simulator/src/routing/go_router_refresh_stream.dart';
import 'package:walking_simulator/src/routing/scaffold_with_bottom_nav_bar.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  onboarding,
  signIn,
  journeys,
  journey,
  addJourney,
  editJourney,
  entry,
  addEntry,
  editEntry,
  entries,
  profile,
}

@riverpod
// ignore: unsupported_provider_value
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (state.subloc != '/onboarding') {
          return '/onboarding';
        }
      }
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.subloc.startsWith('/signIn')) {
          return '/journeys';
        }
      } else {
        if (state.subloc.startsWith('/journeys') ||
            state.subloc.startsWith('/entries') ||
            state.subloc.startsWith('/account')) {
          return '/signIn';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CustomSignInScreen(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/journeys',
            name: AppRoute.journeys.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const JourneysScreen(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: AppRoute.addJourney.name,
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: const EditJourneyScreen(),
                  );
                },
              ),
              GoRoute(
                path: ':id',
                name: AppRoute.journey.name,
                pageBuilder: (context, state) {
                  final id = state.params['id']!;
                  return MaterialPage(
                    key: state.pageKey,
                    child: JourneyEntriesScreen(journeyId: id),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'entries/add',
                    name: AppRoute.addEntry.name,
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) {
                      final jobId = state.params['id']!;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: EntryScreen(
                          jobId: jobId,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'entries/:eid',
                    name: AppRoute.entry.name,
                    pageBuilder: (context, state) {
                      final jobId = state.params['id']!;
                      final entryId = state.params['eid']!;
                      final entry = state.extra as Entry?;
                      return MaterialPage(
                        key: state.pageKey,
                        child: EntryScreen(
                          jobId: jobId,
                          entryId: entryId,
                          entry: entry,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'edit',
                    name: AppRoute.editJourney.name,
                    pageBuilder: (context, state) {
                      final jobId = state.params['id'];
                      final job = state.extra as Journey?;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: EditJourneyScreen(journeyId: jobId, journey: job),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/entries',
            name: AppRoute.entries.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const EntriesScreen(),
            ),
          ),
          GoRoute(
            path: '/account',
            name: AppRoute.profile.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CustomProfileScreen(),
            ),
          ),
        ],
      ),
    ],
    //errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
