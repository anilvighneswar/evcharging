import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MF extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextInputType keyboardtype;
  final ValueChanged<String>? onChanged;

  const MF({
    Key? key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.decoration,
    required this.keyboardtype,
    this.onChanged,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardtype,
        decoration: decoration.copyWith(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: HexColor("#CFCFCF"),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: HexColor("#58B15C"),
            ),
          ),
        ),
      ),
    );
  }
}