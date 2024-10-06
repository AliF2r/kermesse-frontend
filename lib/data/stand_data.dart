import 'dart:convert';

class StandList {
  final int id;
  final int userId;
  final String name;
  final int price;
  final int stock;
  final String category;
  final String description;

  StandList({
    required this.id,
    required this.userId,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
  });

  factory StandList.fromMap(Map<String, dynamic> json) {
    return StandList(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      category: json['category'],
      description: json['description'],
    );
  }

  factory StandList.fromJson(String source) {
    return StandList.fromMap(json.decode(source));
  }
}

class StandListResponse {
  final List<StandList> stands;

  StandListResponse({
    required this.stands,
  });

  factory StandListResponse.fromList(List<dynamic> list) {
    return StandListResponse(
      stands: list.map((item) => StandList.fromMap(item)).toList(),
    );
  }

  factory StandListResponse.fromJson(String source) {
    return StandListResponse.fromList(json.decode(source));
  }
}

class StandDetailsResponse {
  final int id;
  final int userId;
  final String name;
  final int price;
  final int stock;
  final String category;
  final String description;

  StandDetailsResponse({
    required this.id,
    required this.userId,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
  });

  factory StandDetailsResponse.fromMap(Map<String, dynamic> json) {
    return StandDetailsResponse(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      category: json['category'],
      description: json['description'],
    );
  }

  factory StandDetailsResponse.fromJson(String source) {
    return StandDetailsResponse.fromMap(json.decode(source));
  }
}


class StandAddRequest {
  final String name;
  final int price;
  final int stock;
  final String category;
  final String description;

  StandAddRequest({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
  });

  String toJson() {
    return json.encode({
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'description': description,
    });
  }
}


class StandEditRequest {
  final String name;
  final int price;
  final int stock;
  final String description;

  StandEditRequest({
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
  });

  String toJson() {
    return json.encode({
      'name': name,
      'price': price,
      'stock': stock,
      'description': description,
    });
  }
}
