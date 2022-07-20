import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:flutter/material.dart';

class PageNoneLogin extends StatelessWidget {
  const PageNoneLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ShowText(
        label: 'Page Non Login',
        textStyle: Myconstant().h1Style(),
      )),
    );
  }
}
