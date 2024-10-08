import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/providers/auth_provider.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:provider/provider.dart';

class StandHolderNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const StandHolderNavigation({
    super.key,
    required this.navigationShell,
  });

  @override
  State<StandHolderNavigation> createState() => _StandHolderNavigationState();
}

@override
class _StandHolderNavigationState extends State<StandHolderNavigation> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    AuthUser user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      body: FutureBuilder<void>(
        future: _init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return widget.navigationShell;
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _goBranch,
        selectedItemColor: AppThemeHelper.getColorForRole(user.role),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Kermesses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stadium),
            label: 'My Stand',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
