import 'dart:convert';

class TombolaList {
  final int id;
  final int kermesseId;
  final String name;
  final String prize;
  final int price;
  final String status;

  TombolaList({
    required this.id,
    required this.kermesseId,
    required this.name,
    required this.prize,
    required this.price,
    required this.status,
  });

  factory TombolaList.fromMap(Map<String, dynamic> json) {
    return TombolaList(
      id: json['id'],
      kermesseId: json['kermesse_id'],
      name: json['name'],
      prize: json['prize'],
      price: json['price'],
      status: json['status'],
    );
  }

  factory TombolaList.fromJson(String source) {
    return TombolaList.fromMap(json.decode(source));
  }
}

class TombolaListResponse {
  final List<TombolaList> tombolas;

  TombolaListResponse({
    required this.tombolas,
  });

  factory TombolaListResponse.fromList(List<dynamic> list) {
    return TombolaListResponse(
      tombolas: list.map((item) => TombolaList.fromMap(item)).toList(),
    );
  }

  factory TombolaListResponse.fromJson(String source) {
    return TombolaListResponse.fromList(json.decode(source));
  }
}


class TombolaCreateRequest {
  final int kermesseId;
  final String name;
  final String prize;
  final int price;

  TombolaCreateRequest({
    required this.kermesseId,
    required this.name,
    required this.prize,
    required this.price,
  });

  String toJson() {
    return json.encode({
      'kermesse_id': kermesseId,
      'name': name,
      'prize': prize,
      'price': price,
    });
  }
}


class TombolaDetailsResponse {
  final int id;
  final int kermesseId;
  final String name;
  final String prize;
  final int price;
  final String status;

  TombolaDetailsResponse({
    required this.id,
    required this.kermesseId,
    required this.name,
    required this.prize,
    required this.price,
    required this.status,
  });

  factory TombolaDetailsResponse.fromMap(Map<String, dynamic> json) {
    return TombolaDetailsResponse(
      id: json['id'],
      kermesseId: json['kermesse_id'],
      name: json['name'],
      prize: json['prize'],
      price: json['price'],
      status: json['status'],
    );
  }

  factory TombolaDetailsResponse.fromJson(String source) {
    return TombolaDetailsResponse.fromMap(json.decode(source));
  }
}

class TombolaModifyRequest {
  final String name;
  final String prize;
  final int price;

  TombolaModifyRequest({
    required this.name,
    required this.prize,
    required this.price,
  });

  String toJson() {
    return json.encode({
      'name': name,
      'prize': prize,
      'price': price,
    });
  }
}
