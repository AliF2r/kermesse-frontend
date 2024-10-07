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
  final bool   withStand;
  final int    balance;

  LoginResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    required this.withStand,
    required this.balance,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
      withStand: json['with_stand'],
      balance: json['balance'],
    );
  }

  factory LoginResponse.fromJson(String source) {
    return LoginResponse.fromMap(json.decode(source));
  }
}

// ----------------------------

class CurrentUserResponse {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool   withStand;
  final int    balance;

  CurrentUserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.withStand,
    required this.balance,
  });

  factory CurrentUserResponse.fromMap(Map<String, dynamic> json) {
    return CurrentUserResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      withStand: json['with_stand'],
      balance: json['balance'],
    );
  }

  factory CurrentUserResponse.fromJson(String source) {
    return CurrentUserResponse.fromMap(json.decode(source));
  }
}
