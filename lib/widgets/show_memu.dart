// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:flutter/material.dart';

class ShowMenu extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function() tapFunc;
  const ShowMenu({
    Key? key,
    required this.iconData,
    required this.title,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tapFunc,
      leading: Icon(iconData),
      title: ShowText(
        label: title,
        textStyle: Myconstant().h2Style(),
      ),
    );
  }
}
