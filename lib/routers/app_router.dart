import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/routers/auth_router.dart';
import 'package:kermesse_frontend/routers/organizer_router.dart';
import 'package:kermesse_frontend/routers/parent_router.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/routers/student_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  GoRouter goRouter(BuildContext context) {
    return GoRouter(
      initialLocation: AuthRoutes.login,
      refreshListenable: Provider.of<AuthProvider>(context, listen: false),
      redirect: (BuildContext context, GoRouterState state) {
        AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
        final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLogged;
        if (!isLoggedIn && !state.fullPath!.startsWith("/connect")) {
          return AuthRoutes.login;
        }
        if (isLoggedIn && state.fullPath!.startsWith("/connect")) {
          //TODO: Redirect to home for other roles
          if (user.role == "ORGANIZER") {
            return OrganizerRoutes.dashboard;
          } else if (user.role == "PARENT") {
            return ParentRoutes.dashboard;
          } else if (user.role == "STUDENT") {
            return StudentRoutes.dashboard;
          }
        }
        return state.fullPath;
      },
      routes: [
        ...AuthRouter.routes,
        OrganizerRouter.routes,
        ParentRouter.routes,
        StudentRouter.routes,
      ],
    );
  }
}
