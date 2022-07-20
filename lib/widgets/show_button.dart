// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:enie/utillity/my_constant.dart';

class ShowButton extends StatelessWidget {
  final String label;
  final Function() pressFunc;
  final double? size;
  const ShowButton({
    Key? key,
    required this.label,
    required this.pressFunc,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 250,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Myconstant.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: pressFunc,
        child: Text(label),
      ),
    );
  }
}
