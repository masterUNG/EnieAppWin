import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SalonModel {
  final int id;
  final String username;
  final String password;
  final String salon_web_code;
  final String salon_name;
  final String salon_phone;
  final String salon_address;
  final String salon_village;
  final String salon_alley;
  final String salon_road;
  final int country_id;
  final int province_id;
  final int district_id;
  final int subdistrict_id;
  final String token;
  SalonModel({
    required this.id,
    required this.username,
    required this.password,
    required this.salon_web_code,
    required this.salon_name,
    required this.salon_phone,
    required this.salon_address,
    required this.salon_village,
    required this.salon_alley,
    required this.salon_road,
    required this.country_id,
    required this.province_id,
    required this.district_id,
    required this.subdistrict_id,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'salon_web_code': salon_web_code,
      'salon_name': salon_name,
      'salon_phone': salon_phone,
      'salon_address': salon_address,
      'salon_village': salon_village,
      'salon_alley': salon_alley,
      'salon_road': salon_road,
      'country_id': country_id,
      'province_id': province_id,
      'district_id': district_id,
      'subdistrict_id': subdistrict_id,
      'token': token,
    };
  }

  factory SalonModel.fromMap(Map<String, dynamic> map) {
    return SalonModel(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      salon_web_code: map['salon_web_code'] ?? '',
      salon_name: map['salon_name'] ?? '',
      salon_phone: map['salon_phone'] ?? '',
      salon_address: map['salon_address'] ?? '',
      salon_village: map['salon_village'] ?? '',
      salon_alley: map['salon_alley'] ?? '',
      salon_road: map['salon_road'] ?? '',
      country_id: map['country_id']?.toInt() ?? 0,
      province_id: map['province_id']?.toInt() ?? 0,
      district_id: map['district_id']?.toInt() ?? 0,
      subdistrict_id: map['subdistrict_id']?.toInt() ?? 0,
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonModel.fromJson(String source) =>
      SalonModel.fromMap(json.decode(source));
}
