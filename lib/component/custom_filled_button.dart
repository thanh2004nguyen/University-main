 import 'package:flutter/material.dart';

import '../shared/shared.dart';

class CustomFilledButton extends StatelessWidget{

   CustomFilledButton({required this.text, required this.onTap});
   final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor:MainColor,


      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,5, 20, 5),
        child:  Text(style: TextStyle(fontSize: 25, fontWeight:FontWeight.bold ),text),
      ),
    );
  }

}
