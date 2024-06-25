import 'package:flutter/material.dart';

class TextBox extends StatelessWidget{
  late  String TextContent;
  TextBox(
  {
    required this.TextContent
  }
      );
  @override
  Widget build(BuildContext context) {
    return Text(TextContent,style:TextStyle(
      fontSize:20,
      fontWeight: FontWeight.w500,
    ));
  }

}