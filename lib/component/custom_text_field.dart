
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({ super.key,required this.handle});

  final void Function(String) handle;
  @override
  Widget build(BuildContext context) {
  return  Padding(
    padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
    child: TextFormField(
      onChanged: handle,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter student code',
        )),
  );
  }

}