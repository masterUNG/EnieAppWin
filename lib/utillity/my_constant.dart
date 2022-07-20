import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Myconstant {
  //field

  static String pathApiReadAllProvince =
      'https://office.fantasy.co.th/api/salon/province/all';
  static String pathApiReadDistrictByProvinceId =
      'https://office.fantasy.co.th/api/salon/district-by-province?id=';
  static String pathApiReadSubDistrictByDistrictId =
      'https://office.fantasy.co.th/api/salon/sub-district-by-district?id=';

  static Color primary = Color.fromARGB(255, 10, 86, 19);
  static Color dark = Color.fromRGBO(19, 60, 41, 1);
  static Color bgColor = Color.fromARGB(150, 2, 131, 17);
  static Color light = Color(0xff76d275);

  static String routeAuthen = '/authen';
  static String rountCreateAccount = '/createAccount';
  static String rountMyservice = '/myService';
  static String rountPrivacyPolicy = '/privacy_policy';

//home
  static String rountHomeScreen = '/homeScreen';

  //method

  BoxDecoration coverBox() => BoxDecoration(
        border: Border.all(color: Myconstant.dark),
        borderRadius: BorderRadius.circular(30),
      );

  BoxDecoration basicBox() => BoxDecoration(
        color: bgColor.withOpacity(0.5),
      );

  BoxDecoration gradianBox() => BoxDecoration(
        gradient: RadialGradient(
          colors: [Color.fromARGB(255, 110, 244, 105), bgColor],
          radius: 1.0,
          center: Alignment(0, -0.4),
        ),
      );

  BoxDecoration pictureBox() => BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/bg.png'), fit: BoxFit.cover),
      );

  TextStyle h1Style() => GoogleFonts.notoSansThai(
          textStyle: TextStyle(
        fontSize: 48,
        color: dark,
        fontWeight: FontWeight.bold,
      ));

  TextStyle h2Style() => GoogleFonts.notoSansThai(
          textStyle: TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      ));

       TextStyle h2WhiteStyle() => GoogleFonts.notoSansThai(
          textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ));

  TextStyle h3Style() => GoogleFonts.notoSansThai(
          textStyle: TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      ));

  TextStyle h3ActionStyle() => GoogleFonts.notoSansThai(
          textStyle: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 0, 30, 254),
        fontWeight: FontWeight.w500,
      ));

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: Myconstant.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
} // end Class