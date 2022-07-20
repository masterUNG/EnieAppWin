import 'package:flutter/material.dart';

import 'package:enie/utillity/my_constant.dart';
import 'package:enie/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String label;
  final IconData iconData;
  final TextInputType? textInputType;
  final Function(String) changeFunc;
  final Widget? subfixIcon;
  final bool? obsecu;
  const ShowForm({
    Key? key,
    required this.label,
    required this.iconData,
    this.textInputType,
    required this.changeFunc,
    this.subfixIcon,
    this.obsecu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: 250,
      height: 40,
      child: TextFormField(
        obscureText: obsecu ?? false,
        onChanged: changeFunc,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.5),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          suffixIcon: subfixIcon,
          prefixIcon: Icon(
            iconData,
            color: Myconstant.dark,
          ),
          label: ShowText(label: label),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Myconstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Myconstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
