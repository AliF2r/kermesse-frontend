import 'package:flutter/material.dart';
import 'package:kermesse_frontend/widgets/logout_button.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Dashboard student',
            ),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
