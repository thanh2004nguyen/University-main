import 'package:flutter/material.dart';

class TwoRowText extends StatelessWidget {
  final String name;
  final String value;
  final bool bold;

  TwoRowText({required this.name, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: bold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
