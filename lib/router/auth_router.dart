import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/router/routes.dart';
import 'package:kermesse_frontend/screens/auth/login_screen.dart';
import 'package:kermesse_frontend/screens/auth/register_screen.dart';

class AuthRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: AuthRoutes.register,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RegisterScreen(),
      ),
    ),
    GoRoute(
      path: AuthRoutes.login,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginScreen(),
      ),
    ),
  ];
}
