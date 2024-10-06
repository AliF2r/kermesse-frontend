import 'dart:convert';

class UserList {
  final int id;
  final String name;
  final String email;
  final int balance;
  final String role;

  UserList({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.role,
  });

  factory UserList.fromMap(Map<String, dynamic> json) {
    return UserList(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      balance: json['balance'],
      role: json['role'],
    );
  }

  factory UserList.fromJson(String source) {
    return UserList.fromMap(json.decode(source));
  }
}

class UserListResponse {
  final List<UserList> users;

  UserListResponse({
    required this.users,
  });

  factory UserListResponse.fromList(List<dynamic> list) {
    return UserListResponse(
      users: list.map((item) => UserList.fromMap(item)).toList(),
    );
  }

  factory UserListResponse.fromJson(String source) {
    return UserListResponse.fromList(json.decode(source));
  }
}

class UserModifyPasswordRequest {
  final String password;
  final String newPassword;

  UserModifyPasswordRequest({
    required this.password,
    required this.newPassword,
  });

  String toJson() {
    return json.encode({
      'password': password,
      'new_password': newPassword,
    });
  }
}