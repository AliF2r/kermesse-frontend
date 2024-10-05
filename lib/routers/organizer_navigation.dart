import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrganizerNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const OrganizerNavigation({
    super.key,
    required this.navigationShell,
  });

  void _navigateTo(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: _navigateTo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Kermesses',
          ),
        ],
      ),
    );
  }
}
