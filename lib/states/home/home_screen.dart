import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enie/models/promotion_model.dart';
import 'package:enie/utillity/app_service.dart';
import 'package:enie/utillity/my_dialog.dart';
import 'package:enie/widgets/demo_test_login.dart';
import 'package:enie/widgets/show_icon_button.dart';
import 'package:enie/widgets/show_memu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PromotionModel? promotionModel;

  @override
  void initState() {
    super.initState();
    processMessageing();
    readPromotion();
  }

  Future<void> readPromotion() async {
    String path = 'https://www.androidthai.in.th/flutter/getAllPromotion.php';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        promotionModel = PromotionModel.fromMap(element);
      }
      MyDialog(context: context).promotionDialog(
          title: promotionModel!.promotion,
          urlPath:
              'https://www.androidthai.in.th/flutter${promotionModel!.pathImage}',
          pressFunc: () {});
      setState(() {});
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
      appBar: AppBar(
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
      ),
      drawer: Drawer(
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
      ),
      body: DamoTestLogin(),
    );
  }
}
