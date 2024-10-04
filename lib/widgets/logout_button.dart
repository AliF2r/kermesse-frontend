import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_constants.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(ApiConstants.tokenKey);
    Provider.of<AuthProvider>(context, listen: false).setUser(-1, "", "", "");
    context.go(AuthRoutes.login);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("logout successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: logout,
      child: const Text("logout"),
    );
  }
}
