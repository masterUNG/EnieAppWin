import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_text.dart';
import 'package:flutter/material.dart';

class ShowTextButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  const ShowTextButton({
    Key? key,
    required this.label,
    required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: pressFunc,
        child: ShowText(
          label: label,
          textStyle: Myconstant().h3ActionStyle(),
        ));
  }
}
