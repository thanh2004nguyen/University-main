
import 'package:flutter/material.dart';
import 'package:university/extention/text_extention.dart';

import '../shared/shared.dart';

AppBar header(
  BuildContext context, {
  required String text,
      required GlobalKey<ScaffoldState> scaffoldKey
}) {
  return AppBar(
    backgroundColor: MainColor,
    title: Text(
      text.capitalize(),

      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    leading: Navigator.of(context).canPop() ? IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_outlined,
        size: 26,
        color: Colors.white,
      ),
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(false);
        }
      },
    ) :null,
    actions: [
      IconButton(
        icon: const Icon(
          Icons.menu,
          size: 26,
          color: Colors.white,
        ),
        onPressed: () {
          scaffoldKey.currentState?.openEndDrawer();
        },
      ),
    ],
  );
}
