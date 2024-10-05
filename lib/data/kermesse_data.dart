import 'dart:convert';

class KermesseAddRequest {
  final String name;
  final String description;

  KermesseAddRequest({
    required this.name,
    required this.description,
  });

  String toJson() {
    return json.encode({
      'name': name,
      'description': description,
    });
  }
}

// ----------------------------

class KermesseModifyRequest {
  final String name;
  final String description;

  KermesseModifyRequest({
    required this.name,
    required this.description,
  });

  String toJson() {
    return json.encode({
      'name': name,
      'description': description,
    });
  }
}

// ----------------------------

class KermesseDetailsResponse {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String status;

  KermesseDetailsResponse({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.status,
  });

  factory KermesseDetailsResponse.fromMap(Map<String, dynamic> json) {
    return KermesseDetailsResponse(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      description: json['description'],
      status: json['status'],
    );
  }

  factory KermesseDetailsResponse.fromJson(String source) {
    return KermesseDetailsResponse.fromMap(json.decode(source));
  }
}

// ----------------------------

class KermesseList {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String status;

  KermesseList({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.status,
  });

  factory KermesseList.fromMap(Map<String, dynamic> json) {
    return KermesseList(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }

  factory KermesseList.fromJson(String source) {
    return KermesseList.fromMap(json.decode(source));
  }
}

class KermesseListResponse {
  final List<KermesseList> kermesses;

  KermesseListResponse({
    required this.kermesses,
  });

  factory KermesseListResponse.fromList(List<dynamic> list) {
    return KermesseListResponse(
      kermesses: list.map((item) => KermesseList.fromMap(item)).toList(),
    );
  }

  factory KermesseListResponse.fromJson(String source) {
    return KermesseListResponse.fromList(json.decode(source));
  }
}


class KermesseUserInvitationRequest {
  final int userId;

  KermesseUserInvitationRequest({
    required this.userId,
  });

  String toJson() {
    return json.encode({
      'user_id': userId,
    });
  }
}
