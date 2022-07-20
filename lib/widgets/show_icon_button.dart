import 'package:enie/utillity/my_constant.dart';
import 'package:flutter/material.dart';

class ShowIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() tapFunc;
  const ShowIconButton({
    Key? key,
    required this.iconData,
    required this.tapFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: tapFunc,
        icon: Icon(
          iconData,
          color: Myconstant.dark,
        ));
  }
}
