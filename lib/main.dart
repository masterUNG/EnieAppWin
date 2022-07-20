// ignore_for_file: avoid_print

import 'dart:io';

import 'package:enie/states/authen.dart';
import 'package:enie/states/create_account.dart';
import 'package:enie/states/home/home_screen.dart';
import 'package:enie/states/my_service.dart';
import 'package:enie/states/privacy_policy.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  Myconstant.routeAuthen: (BuildContext context) => const Authen(),
  Myconstant.rountCreateAccount: (BuildContext context) =>
      const CreateAccount(),
  Myconstant.rountMyservice: (BuildContext context) => const MyService(),
  Myconstant.rountPrivacyPolicy: (BuildContext context) => PrivacyPolicy(),

  //home
  Myconstant.rountHomeScreen: (BuildContext context) => Home(),
};

String? initlalRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? username = preferences.getString('username');
  print('### username ===>> $username');
  if (username?.isEmpty ?? true) {
    initlalRoute = Myconstant.routeAuthen;
    runApp(const MyApp());
  } else {
    initlalRoute = Myconstant.rountHomeScreen;
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initlalRoute,
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
