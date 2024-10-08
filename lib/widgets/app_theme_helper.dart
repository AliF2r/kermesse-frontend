import 'package:flutter/material.dart';

class AppThemeHelper {

  static Color getColorForRole(String role) {
    switch (role) {
      case 'ORGANIZER':
        return Colors.deepPurple;
      case 'STAND_HOLDER':
        return Colors.orange;
      case 'STUDENT':
        return Colors.green;
      case 'PARENT':
        return Colors.blue;
      default:
        return const Color(0xFF0D1723);
    }
  }

  static Icon getStandIcon(String category) {
    switch (category) {
      case 'FOOD':
        return const Icon(Icons.fastfood, size: 40, color: Colors.orange);
    default:
        return const Icon(Icons.videogame_asset, size: 40, color: Colors.green);
    }
  }
}
