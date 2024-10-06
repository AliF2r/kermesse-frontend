import 'dart:convert';

class TicketUserModel {
  final int id;
  final String name;
  final String email;
  final String role;

  TicketUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory TicketUserModel.fromMap(Map<String, dynamic> json) {
    return TicketUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  factory TicketUserModel.fromJson(String source) {
    return TicketUserModel.fromMap(json.decode(source));
  }
}

class TicketTombolaModel {
  final int id;
  final String name;
  final String prize;
  final int price;
  final String status;

  TicketTombolaModel({
    required this.id,
    required this.name,
    required this.prize,
    required this.price,
    required this.status,
  });

  factory TicketTombolaModel.fromMap(Map<String, dynamic> json) {
    return TicketTombolaModel(
      id: json['id'],
      name: json['name'],
      prize: json['prize'],
      price: json['price'],
      status: json['status'],
    );
  }

  factory TicketTombolaModel.fromJson(String source) {
    return TicketTombolaModel.fromMap(json.decode(source));
  }
}

class TicketKermesseModel {
  final int id;
  final String name;
  final String description;
  final String status;

  TicketKermesseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  factory TicketKermesseModel.fromMap(Map<String, dynamic> json) {
    return TicketKermesseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }

  factory TicketKermesseModel.fromJson(String source) {
    return TicketKermesseModel.fromMap(json.decode(source));
  }
}

class TicketList {
  final int id;
  final bool isWinner;
  final TicketUserModel user;
  final TicketKermesseModel kermesse;
  final TicketTombolaModel tombola;

  TicketList({
    required this.id,
    required this.isWinner,
    required this.user,
    required this.tombola,
    required this.kermesse,
  });

  factory TicketList.fromMap(Map<String, dynamic> json) {
    return TicketList(
      id: json['id'],
      isWinner: json['is_winner'],
      user: TicketUserModel.fromMap(json['user']),
      tombola: TicketTombolaModel.fromMap(json['tombola']),
      kermesse: TicketKermesseModel.fromMap(json['kermesse']),
    );
  }

  factory TicketList.fromJson(String source) {
    return TicketList.fromMap(json.decode(source));
  }
}

class TicketListResponse {
  final List<TicketList> tickets;

  TicketListResponse({
    required this.tickets,
  });

  factory TicketListResponse.fromList(List<dynamic> list) {
    return TicketListResponse(
      tickets: list.map((item) => TicketList.fromMap(item)).toList(),
    );
  }

  factory TicketListResponse.fromJson(String source) {
    return TicketListResponse.fromList(json.decode(source));
  }
}


class TicketDetailsResponse {
  final int id;
  final bool isWinner;
  final TicketUserModel user;
  final TicketTombolaModel tombola;
  final TicketKermesseModel kermesse;

  TicketDetailsResponse({
    required this.id,
    required this.isWinner,
    required this.user,
    required this.tombola,
    required this.kermesse,
  });

  factory TicketDetailsResponse.fromMap(Map<String, dynamic> json) {
    return TicketDetailsResponse(
      id: json['id'],
      isWinner: json['is_winner'],
      user: TicketUserModel.fromMap(json['user']),
      tombola: TicketTombolaModel.fromMap(json['tombola']),
      kermesse: TicketKermesseModel.fromMap(json['kermesse']),
    );
  }

  factory TicketDetailsResponse.fromJson(String source) {
    return TicketDetailsResponse.fromMap(json.decode(source));
  }
}


class TicketCreateRequest {
  final int tombolaId;

  TicketCreateRequest({
    required this.tombolaId,
  });

  String toJson() {
    return json.encode({
      'tombola_id': tombolaId,
    });
  }
}
