import 'package:flutter/material.dart';
import 'package:kermesse_frontend/widgets/logout_button.dart';

class StandHolderDashboardScreen extends StatefulWidget {
  const StandHolderDashboardScreen({super.key});

  @override
  State<StandHolderDashboardScreen> createState() => _StandHolderDashboardScreenState();
}

class _StandHolderDashboardScreenState extends State<StandHolderDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Dashboard stand holder',
            ),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
