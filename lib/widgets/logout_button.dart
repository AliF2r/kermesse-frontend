import 'package:flutter/material.dart';
import 'package:kermesse_frontend/widgets/logout.dart';


class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => performLogout(context),
      child: const Text("Logout"),
    );
  }
}