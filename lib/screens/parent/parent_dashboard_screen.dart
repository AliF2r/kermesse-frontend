import 'package:flutter/material.dart';
import 'package:kermesse_frontend/widgets/logout_button.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Dashboard parent dddddd',
            ),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
