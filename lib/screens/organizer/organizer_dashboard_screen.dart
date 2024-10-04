import 'package:flutter/material.dart';
import 'package:kermesse_frontend/widgets/logout_button.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() => _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Dashboard Organizer',
            ),
            LogoutButton()
          ],
        ),
      ),
    );
  }
}
