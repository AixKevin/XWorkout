import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:xworkout/features/workout/presentation/workout_screen.dart';
import 'package:xworkout/features/history/presentation/workout_history_screen.dart';
import 'package:xworkout/features/more/presentation/more_screen.dart';
import 'package:xworkout/shared/widgets/bottom_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/workout',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workout',
              builder: (context, state) => const WorkoutScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MoreScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
