import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enie/models/salon_model.dart';
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/utillity/my_dialog.dart';
import 'package:enie/widgets/show_image.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:enie/widgets/show_text_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool obsecuPassword = true;
  final formKey = GlobalKey<FormState>();

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Container(
            decoration: Myconstant().gradianBox(),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                newLogo(constraints),
                                newTitle(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      buildUser(size),
                      buildPassword(size),
                      newForgotPassword(),
                      newButtonLogin(),
                      newCreateAccount()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Row newCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowText(label: 'ยังไม่มีบัญชี ? '),
        ShowTextButton(
          label: 'สมัครใช้งาน',
          pressFunc: () {
            Navigator.pushNamed(context, Myconstant.rountCreateAccount);
          },
        )
      ],
    );
  }

  Row newButtonLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: 270,
          child: ElevatedButton(
            style: Myconstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String user = userController.text;
                String password = passwordController.text;
                print('## user = $user, password = $password');

                checkAuthen(user: user, password: password);
              }
            },
            child: Text('Login'),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen({String? user, String? password}) async {
    String apiCheckAuthen =
        'https://office.fantasy.co.th/api/salon/login?username=$user&password=$password';
    await Dio().post(apiCheckAuthen).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() ==
          '{"error":["Username and Password are wrong."]}') {
        MyDialog(context: context).normalDialog(
            title: 'Username หรือ Password ไม่ถูกต้อง',
            subTitle: 'กรุณาตรวจสอบอีกครั้งค่ะ');
      } else {
        for (var item in json.decode(value.data)) {
          SalonModel model = SalonModel.fromMap(item);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setInt('id', model.id);
          preferences.setString('username', model.username);
          preferences.setString('password', model.password);
          preferences.setString('salon_name', model.salon_name);
          preferences.setString('token', model.token);
          Navigator.pushNamedAndRemoveUntil(
              context, Myconstant.rountHomeScreen, (route) => false);
        }
      }
    });
  }

  ShowTextButton newForgotPassword() =>
      ShowTextButton(label: 'ลืมรหัสผ่าน ?', pressFunc: () {});

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.7,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Plezse Fill User in Blank';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.5),
              filled: true,
              labelStyle: Myconstant().h3Style(),
              labelText: 'Username :',
              prefixIcon: Icon(
                Icons.account_circle_rounded,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.7,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Plezse Fill Password in Blank';
              } else {
                return null;
              }
            },
            obscureText: obsecuPassword,
            decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.5),
              filled: true,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecuPassword = !obsecuPassword;
                  });
                },
                icon: obsecuPassword
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Myconstant.dark,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: Myconstant.dark,
                      ),
              ),
              labelStyle: Myconstant().h3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.lock,
                color: Myconstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Myconstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ShowText newTitle() {
    return ShowText(
      label: 'เข้าสู่ระบบ',
      textStyle: Myconstant().h2Style(),
    );
  }

  SizedBox newLogo(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.3,
      child: ShowImage(),
    );
  }
}
