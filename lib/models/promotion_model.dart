import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PromotionModel {
  final String id;
  final String promotion;
  final String pathImage;
  final String member;
  PromotionModel({
    required this.id,
    required this.promotion,
    required this.pathImage,
    required this.member,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'promotion': promotion,
      'pathImage': pathImage,
      'member': member,
    };
  }

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(
      id: (map['id'] ?? '') as String,
      promotion: (map['promotion'] ?? '') as String,
      pathImage: (map['pathImage'] ?? '') as String,
      member: (map['member'] ?? '') as String,
    );
  }

  factory PromotionModel.fromJson(String source) => PromotionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
