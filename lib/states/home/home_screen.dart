import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enie/bodys/show_cart.dart';
import 'package:enie/bodys/show_demo.dart';
import 'package:enie/bodys/show_product.dart';
import 'package:enie/models/promotion_model.dart';
import 'package:enie/utillity/app_service.dart';
import 'package:enie/utillity/my_dialog.dart';
import 'package:enie/widgets/demo_test_login.dart';
import 'package:enie/widgets/show_icon_button.dart';
import 'package:enie/widgets/show_memu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PromotionModel? promotionModel;
  int? idLogin;
  var members = <String>[];

  var titles = <String>[
    'Product',
    'Cart',
    'Demo',
  ];

  var iconDatas = <IconData>[
    Icons.filter_1,
    Icons.filter_2,
    Icons.filter_3,
  ];

  var bodys = <Widget>[
    const ShowProduct(),
    const ShowCart(),
    const ShowDemo(),
  ];

  int indexBody = 0;

  var bottomNavigationBarItmes = <BottomNavigationBarItem>[];

  @override
  void initState() {
    super.initState();
    processMessageing();
    findIdLogin();
    readPromotion();
    createListButtonNavgtion();
  }

  void createListButtonNavgtion() {
    for (var i = 0; i < bodys.length; i++) {
      bottomNavigationBarItmes.add(
        BottomNavigationBarItem(
          label: titles[i],
          icon: Icon(
            iconDatas[i],
          ),
        ),
      );
    }
  }

  Future<void> findIdLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idLogin = preferences.getInt('id');
    idLogin = idLogin! + 1;
  }

  Future<void> readPromotion() async {
    String path = 'https://www.androidthai.in.th/flutter/getAllPromotion.php';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        promotionModel = PromotionModel.fromMap(element);
      }

      String string = promotionModel!.member;
      print('string ==> ${string.length}');
      if (string.length != 2) {
        print('string == $string');

        string = string.substring(1, string.length - 1);

        print('string ตัดแล้ว == $string');

        members = string.split(',');
        for (var i = 0; i < members.length; i++) {
          members[i] = members[i].trim();
        }
      }

      print('members ==> $members');
      bool memberBool = false; // false ==> ยังไม่ได้ คลิก Keep

      if (members.isEmpty) {
        showDialogPromotion();
      } else {
        for (var element in members) {
          if (int.parse(element) == idLogin) {
            memberBool = true;
          }
        }

        if (!memberBool) {
          showDialogPromotion();
        }
      }

      setState(() {});
    });
  }

  void showDialogPromotion() {
    MyDialog(context: context).promotionDialog(
        title: promotionModel!.promotion,
        urlPath:
            'https://www.androidthai.in.th/flutter${promotionModel!.pathImage}',
        pressFunc: () async {
          print('idLogin ==> $idLogin, members ==> $members');

          members.add(idLogin.toString());

          print('members หลัง add ==> $members');

          String apiEditMember =
              'https://www.androidthai.in.th/flutter/editPromotionWhereId.php?isAdd=true&id=${promotionModel!.id}&member=${members.toString()}';
          await Dio().get(apiEditMember).then((value) {
            Navigator.pop(context);
          });
        });
  }

  Future<void> processMessageing() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print('token ===> $token');

    //Open App
    FirebaseMessaging.onMessage.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      MyDialog(context: context).normalDialog(title: title!, subTitle: body!);
    });

    //Off App
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      MyDialog(context: context).normalDialog(title: title!, subTitle: body!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newApp(),
      drawer: newDrawer(context),
      body: bodys[indexBody],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItmes,
        currentIndex: indexBody,
        onTap: (value) {
          setState(() {
            indexBody = value;
          });
        },
      ),
    );
  }

  Drawer newDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const Spacer(),
          ShowMenu(
            iconData: Icons.exit_to_app,
            title: 'Sign Out',
            tapFunc: () {
              Navigator.pop(context);
              MyDialog(context: context).normalDialog(
                  label: 'SignOut',
                  pressFunc: () {
                    AppService().processSignOut(context: context);
                  },
                  title: 'Sign Out ?',
                  subTitle: 'Please Confirm SignOut');
            },
          ),
        ],
      ),
    );
  }

  AppBar newApp() {
    return AppBar(
      actions: [
        ShowIconButton(
          iconData: Icons.send,
          tapFunc: () {
            String token =
                'efOwuga_Rrmar8Z3N4-BDo:APA91bFWfLz5-SP-1_uWb2V2jzW-ludEOziFbAWauchwtdlBCzwvN7clKa5gdbELOi5RX9nNMjV8j14p4BBQcyP6RXPgM3HJE2qLTicwDLGcioXBRI7bENPID7n6bjNIUA8TWQh3OtyR';
            String title = 'ทดสองส่ง Noti';
            String body = 'ส่วนของ Body ของ Noti';
            AppService()
                .processSentNoti(token: token, title: title, body: body);
          },
        ),
      ],
    );
  }
}
