import 'package:flutter/material.dart';

class OrganizerProfileScreen extends StatefulWidget {
  const OrganizerProfileScreen({super.key});

  @override
  State<OrganizerProfileScreen> createState() => _OrganizerProfileScreenState();
}

class _OrganizerProfileScreenState extends State<OrganizerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Profile Organizer',
            ),
          ],
        ),
      ),
    );
  }
}
