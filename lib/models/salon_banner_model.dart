import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SalonBannerModel {
  final int id;
  final String sb_picture;
  SalonBannerModel({
    required this.id,
    required this.sb_picture,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sb_picture': sb_picture,
    };
  }

  factory SalonBannerModel.fromMap(Map<String, dynamic> map) {
    return SalonBannerModel(
      id: map['id']?.toInt() ?? 0,
      sb_picture: map['sb_picture'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonBannerModel.fromJson(String source) =>
      SalonBannerModel.fromMap(json.decode(source));
}
