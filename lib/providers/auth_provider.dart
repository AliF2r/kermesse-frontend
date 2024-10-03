import 'package:flutter/material.dart';
import 'package:kermesse_frontend/providers/auth_user.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser _user = AuthUser.getEmpty();

  AuthUser get user {
    return _user;
  }

  bool get isLogged {
    return _user.id >= 0;
  }

  void setUser(int id, String name, String email, String role) {
    _user = AuthUser(
      id: id,
      name: name,
      email: email,
      role: role,
    );
    notifyListeners();
  }
}