import 'dart:convert';

class ParticipationUserModel {
  final int id;
  final String name;
  final String email;
  final String role;

  ParticipationUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory ParticipationUserModel.fromMap(Map<String, dynamic> json) {
    return ParticipationUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  factory ParticipationUserModel.fromJson(String source) {
    return ParticipationUserModel.fromMap(json.decode(source));
  }
}

class ParticipationStandModel {
  final int id;
  final String name;
  final int price;
  final String description;
  final String category;

  ParticipationStandModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  factory ParticipationStandModel.fromMap(Map<String, dynamic> json) {
    return ParticipationStandModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      category: json['category'],
    );
  }

  factory ParticipationStandModel.fromJson(String source) {
    return ParticipationStandModel.fromMap(json.decode(source));
  }
}

class ParticipationList {
  final int id;
  final int balance;
  final int point;
  final String category;
  final String status;
  final ParticipationUserModel user;
  final ParticipationStandModel stand;

  ParticipationList({
    required this.id,
    required this.point,
    required this.category,
    required this.status,
    required this.balance,
    required this.user,
    required this.stand,
  });

  factory ParticipationList.fromMap(Map<String, dynamic> json) {
    return ParticipationList(
      id: json['id'],
      point: json['point'],
      category: json['category'],
      status: json['status'],
      balance: json['balance'],
      user: ParticipationUserModel.fromMap(json['user']),
      stand: ParticipationStandModel.fromMap(json['stand']),
    );
  }

  factory ParticipationList.fromJson(String source) {
    return ParticipationList.fromMap(json.decode(source));
  }
}

class ParticipationListResponse {
  final List<ParticipationList> participations;

  ParticipationListResponse({
    required this.participations,
  });

  factory ParticipationListResponse.fromList(List<dynamic> list) {
    return ParticipationListResponse(
      participations: list.map((item) => ParticipationList.fromMap(item)).toList());
  }

  factory ParticipationListResponse.fromJson(String source) {
    return ParticipationListResponse.fromList(json.decode(source));
  }
}

class ParticipationKermesseModel {
  final int id;
  final String name;
  final String description;
  final String status;

  ParticipationKermesseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  factory ParticipationKermesseModel.fromMap(Map<String, dynamic> json) {
    return ParticipationKermesseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }

  factory ParticipationKermesseModel.fromJson(String source) {
    return ParticipationKermesseModel.fromMap(json.decode(source));
  }
}

class ParticipationDetailsResponse {
  final int id;
  final String category;
  final int point;
  final String status;
  final int balance;
  final ParticipationUserModel user;
  final ParticipationStandModel stand;
  final ParticipationKermesseModel kermesse;

  ParticipationDetailsResponse({
    required this.id,
    required this.category,
    required this.point,
    required this.status,
    required this.balance,
    required this.user,
    required this.stand,
    required this.kermesse,
  });

  factory ParticipationDetailsResponse.fromMap(Map<String, dynamic> json) {
    return ParticipationDetailsResponse(
      id: json['id'],
      category: json['category'],
      point: json['point'],
      status: json['status'],
      balance: json['balance'],
      user: ParticipationUserModel.fromMap(json['user']),
      stand: ParticipationStandModel.fromMap(json['stand']),
      kermesse: ParticipationKermesseModel.fromMap(json['kermesse']),
    );
  }

  factory ParticipationDetailsResponse.fromJson(String source) {
    return ParticipationDetailsResponse.fromMap(json.decode(source));
  }
}
