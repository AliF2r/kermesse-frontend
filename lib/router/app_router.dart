import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/router/auth_router.dart';
import 'package:kermesse_frontend/router/routes.dart';
import 'package:provider/provider.dart';

class AppRouter {
  GoRouter goRouter(BuildContext context) {
    return GoRouter(
      initialLocation: AuthRoutes.login,
      refreshListenable: Provider.of<AuthProvider>(context, listen: false),
      routes: [
        ...AuthRouter.routes,
      ],
    );
  }
}
