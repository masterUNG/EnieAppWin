import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SqliteModel {
  final int? id;
  final String nameProduct;
  final String price;
  SqliteModel({
    this.id,
    required this.nameProduct,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameProduct': nameProduct,
      'price': price,
    };
  }

  factory SqliteModel.fromMap(Map<String, dynamic> map) {
    return SqliteModel(
      id: map['id'] != null ? map['id'] as int : null,
      nameProduct: (map['nameProduct'] ?? '') as String,
      price: (map['price'] ?? '') as String,
    );
  }

  factory SqliteModel.fromJson(String source) => SqliteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
