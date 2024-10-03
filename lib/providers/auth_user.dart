import 'dart:convert';

class AuthUser {
  final int id;
  final String name;
  final String email;
  final String role;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuthUser.getEmpty() {
    return AuthUser(
      id: -1,
      name: '',
      email: '',
      role: '',
    );
  }

  factory AuthUser.fromMap(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(json.decode(source));
}
