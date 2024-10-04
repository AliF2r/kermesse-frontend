import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/routers/organizer_navigation.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_dashboard_screen.dart';
import 'package:kermesse_frontend/screens/organizer/organizer_profile_screen.dart';


class OrganizerRouter {
  static final routes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => OrganizerNavigation(navigationShell: navigationShell),
    branches: [
      _createBranch(OrganizerRoutes.dashboard, const OrganizerDashboardScreen()),
      _createBranch(OrganizerRoutes.profile, const OrganizerProfileScreen()),
    ],
  );

  static StatefulShellBranch _createBranch(String path, Widget screen) {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: path,
          pageBuilder: (context, state) => NoTransitionPage(child: screen),
        ),
      ],
    );
  }
}
