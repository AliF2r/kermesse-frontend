import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/routers/organizer_navigation.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/screens/auth/login_screen.dart';
import 'package:kermesse_frontend/screens/auth/register_screen.dart';

class AuthRouter {
  static final routes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => OrganizerNavigation(navigationShell: navigationShell),
    branches: [
      _createBranch(AuthRoutes.register, const RegisterScreen()),
      _createBranch(AuthRoutes.login, const LoginScreen()),
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
