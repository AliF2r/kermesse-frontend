import 'package:flutter/material.dart';
import 'package:kermesse_frontend/router/app_router.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: widget.router.goRouter(context),
    );
  }
}
