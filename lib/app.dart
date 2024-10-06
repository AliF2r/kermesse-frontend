import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/auth_data.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/app_router.dart';
import 'package:kermesse_frontend/services/auth_service.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final AppRouter router;

  const App({
    super.key,
    required this.router,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    ApiResponse<CurrentUserResponse> response = await _authService.getCurrentUserResponse();
    if (response.error == null && response.data != null) {
      Provider.of<AuthProvider>(context, listen: false).setUser(
        response.data!.id,
        response.data!.name,
        response.data!.email,
        response.data!.role,
        response.data!.withStand,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: widget.router.goRouter(context),
    );
  }
}
