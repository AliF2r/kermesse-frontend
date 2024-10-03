import 'dart:convert';

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String role;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  String toJson() {
    return json.encode({
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    });
  }
}

// ----------------------------

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  String toJson() {
    return json.encode({
      'email': email,
      'password': password,
    });
  }
}

// ----------------------------

class LoginResponse {
  final int id;
  final String name;
  final String email;
  final String role;
  final String token;

  LoginResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }

  factory LoginResponse.fromJson(String source) {
    return LoginResponse.fromMap(json.decode(source));
  }
}
