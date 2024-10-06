import 'dart:convert';

class AuthUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool withStand;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.withStand,
  });

  factory AuthUser.getEmpty() {
    return AuthUser(
      id: -1,
      name: '',
      email: '',
      role: '',
      withStand: false,
    );
  }

  factory AuthUser.fromMap(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      withStand: json['with_stand'],
    );
  }

  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(json.decode(source));
}
