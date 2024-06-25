import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/shared.dart';

class InputCustom extends StatelessWidget {
  InputCustom(
      {super.key,
        required this.hintText,
        this.isPassword=false,
        this.notNull=false,
        this.isEmail=false,
        this.prefixIcon,
        this.suffixIcon,
        this.readOnly = false,
        required this.labelText,
        required this.controller,});

  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final bool notNull;
  final bool isEmail;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: TextFormField(
        controller: controller,
        enabled: !readOnly,
        validator: (value) {
          if (value == null && notNull || value!.isEmpty && notNull) {
            return 'Please enter some text';

          }

          if(isEmail && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)){
            return 'Please input a email.';
          }
          return null;
        },
        obscureText: isPassword,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: BorderColor, width: 1.5),
          ),
          contentPadding: EdgeInsets.all(10),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MainColor, width: 1.5),
          ),
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
