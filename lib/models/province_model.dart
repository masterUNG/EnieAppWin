import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class ProvinceModel {
  final int id;
  final String province_code;
  final String province_name_th;
  ProvinceModel({
    required this.id,
    required this.province_code,
    required this.province_name_th,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'province_code': province_code,
      'province_name_th': province_name_th,
    };
  }

  factory ProvinceModel.fromMap(Map<String, dynamic> map) {
    return ProvinceModel(
      id: map['id']?.toInt() ?? 0,
      province_code: map['province_code'] ?? '',
      province_name_th: map['province_name_th'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvinceModel.fromJson(String source) =>
      ProvinceModel.fromMap(json.decode(source));
}
