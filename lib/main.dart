import 'package:flutter/material.dart';
import 'package:kermesse_frontend/app.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/router/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //await NotificationService.initializeNotification();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: App(
        router: AppRouter(),
      ),
    ),
  );
}
