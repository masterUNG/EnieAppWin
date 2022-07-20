import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class SubDistrictModel {
  final int id;
  final String sub_district_code;
  final String sub_district_name_th;
  final String sub_district_zip_code;
  final int district_id;
  SubDistrictModel({
    required this.id,
    required this.sub_district_code,
    required this.sub_district_name_th,
    required this.sub_district_zip_code,
    required this.district_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sub_district_code': sub_district_code,
      'sub_district_name_th': sub_district_name_th,
      'sub_district_zip_code': sub_district_zip_code,
      'district_id': district_id,
    };
  }

  factory SubDistrictModel.fromMap(Map<String, dynamic> map) {
    return SubDistrictModel(
      id: map['id']?.toInt() ?? 0,
      sub_district_code: map['sub_district_code'] ?? '',
      sub_district_name_th: map['sub_district_name_th'] ?? '',
      sub_district_zip_code: map['sub_district_zip_code'] ?? '',
      district_id: map['district_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubDistrictModel.fromJson(String source) => SubDistrictModel.fromMap(json.decode(source));
}
