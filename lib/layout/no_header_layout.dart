
import 'package:flutter/material.dart';

import 'custom_drawer.dart';
GlobalKey<ScaffoldState> scaffloldKey= GlobalKey<ScaffoldState>();
MaterialApp NoHeadLayout(context,
    {required Widget child}) {
  return MaterialApp(
    home: SafeArea(
      child: Scaffold(
        key: scaffloldKey,
        appBar:null,
        body: child,
        drawer: CustomDrawer(),
      ),
    ),
    debugShowCheckedModeBanner: false,
  );
}
