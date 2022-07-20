// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class SalonEventModel {
  final int id;
  final String sev_title;
  final String sev_text;
  final int sev_type;
  final String sev_location;
  final int sev_register_qty;
  final int sev_qty;
  final double sev_fee;
  final int tech_id;
  final String sev_charge;
  final String sev_phone;
  final int sev_status;
  final String sev_picture;
  SalonEventModel({
    required this.id,
    required this.sev_title,
    required this.sev_text,
    required this.sev_type,
    required this.sev_location,
    required this.sev_register_qty,
    required this.sev_qty,
    required this.sev_fee,
    required this.tech_id,
    required this.sev_charge,
    required this.sev_phone,
    required this.sev_status,
    required this.sev_picture,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sev_title': sev_title,
      'sev_text': sev_text,
      'sev_type': sev_type,
      'sev_location': sev_location,
      'sev_register_qty': sev_register_qty,
      'sev_qty': sev_qty,
      'sev_fee': sev_fee,
      'tech_id': tech_id,
      'sev_charge': sev_charge,
      'sev_phone': sev_phone,
      'sev_status': sev_status,
      'sev_picture': sev_picture,
    };
  }

  factory SalonEventModel.fromMap(Map<String, dynamic> map) {
    return SalonEventModel(
      id: map['id']?.toInt() ?? 0,
      sev_title: map['sev_title'] ?? '',
      sev_text: map['sev_text'] ?? '',
      sev_type: map['sev_type']?.toInt() ?? 0,
      sev_location: map['sev_location'] ?? '',
      sev_register_qty: map['sev_register_qty']?.toInt() ?? 0,
      sev_qty: map['sev_qty']?.toInt() ?? 0,
      sev_fee: map['sev_fee']?.toDouble() ?? 0.0,
      tech_id: map['tech_id']?.toInt() ?? 0,
      sev_charge: map['sev_charge'] ?? '',
      sev_phone: map['sev_phone'] ?? '',
      sev_status: map['sev_status']?.toInt() ?? 0,
      sev_picture: map['sev_picture'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SalonEventModel.fromJson(String source) => SalonEventModel.fromMap(json.decode(source));
}
