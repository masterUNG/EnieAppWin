import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class DistrictModel {
  final int id;
  final String district_code;
  final String district_name_th;
  final int province_id;
  DistrictModel({
    required this.id,
    required this.district_code,
    required this.district_name_th,
    required this.province_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'district_code': district_code,
      'district_name_th': district_name_th,
      'province_id': province_id,
    };
  }

  factory DistrictModel.fromMap(Map<String, dynamic> map) {
    return DistrictModel(
      id: map['id']?.toInt() ?? 0,
      district_code: map['district_code'] ?? '',
      district_name_th: map['district_name_th'] ?? '',
      province_id: map['province_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DistrictModel.fromJson(String source) =>
      DistrictModel.fromMap(json.decode(source));
}
