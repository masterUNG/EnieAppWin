import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class CarouselModel {
  final int id;
  final String sb_picture;
  CarouselModel({
    required this.id,
    required this.sb_picture,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sb_picture': sb_picture,
    };
  }

  factory CarouselModel.fromMap(Map<String, dynamic> map) {
    return CarouselModel(
      id: map['id']?.toInt() ?? 0,
      sb_picture: map['sb_picture'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarouselModel.fromJson(String source) =>
      CarouselModel.fromMap(json.decode(source));
}

class EventModel {
  final int id;
  final String sev_title;
  final String sev_text;
  final int sev_type;
  final String sev_location;
  final DateTime sev_start_date;
  final DateTime sev_start_time;
  final DateTime sev_end_date;
  final DateTime sev_end_time;
  final int sev_register_qty;
  final int sev_qty;
  final double sev_fee;
  final int tech_id;
  final String sev_charge;
  final String sev_phone;
  final int sev_status;
  final String sev_picture;
  EventModel({
    required this.id,
    required this.sev_title,
    required this.sev_text,
    required this.sev_type,
    required this.sev_location,
    required this.sev_start_date,
    required this.sev_start_time,
    required this.sev_end_date,
    required this.sev_end_time,
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
      'sev_start_date': sev_start_date.millisecondsSinceEpoch,
      'sev_start_time': sev_start_time.millisecondsSinceEpoch,
      'sev_end_date': sev_end_date.millisecondsSinceEpoch,
      'sev_end_time': sev_end_time.millisecondsSinceEpoch,
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

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toInt() ?? 0,
      sev_title: map['sev_title'] ?? '',
      sev_text: map['sev_text'] ?? '',
      sev_type: map['sev_type']?.toInt() ?? 0,
      sev_location: map['sev_location'] ?? '',
      sev_start_date:
          DateTime.fromMillisecondsSinceEpoch(map['sev_start_date']),
      sev_start_time:
          DateTime.fromMillisecondsSinceEpoch(map['sev_start_time']),
      sev_end_date: DateTime.fromMillisecondsSinceEpoch(map['sev_end_date']),
      sev_end_time: DateTime.fromMillisecondsSinceEpoch(map['sev_end_time']),
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

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));
}
