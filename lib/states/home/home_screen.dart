import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:enie/models/salon_model.dart';
import 'package:enie/states/home/views/enie_carousel.dart';
import 'package:enie/widgets/scaffold.dart';
import 'package:get/get.dart';
import 'package:enie/config/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  final int? index;
  Home({this.index});

  @override
  Widget build(BuildContext context) {
    return EnieScaffold(
      bottomMenuIndex: index,
      title: null,
      background: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              EnieCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
