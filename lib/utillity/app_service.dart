import 'package:dio/dio.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  Future<void> processSignOut({required BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear().then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, Myconstant.routeAuthen, (route) => false);
    });
  }

  Future<void> processSentNoti(
      {required String token,
      required String title,
      required String body}) async {
    String path =
        'https://www.androidthai.in.th/flutter/apiNotiWin.php?isAdd=true&token=$token&title=$title&body=$body';
    await Dio().get(path).then((value) => print('Success Sent Noti'));
  }
} // end Class