
import 'package:flutter/material.dart';

import '../shared/shared.dart';
import 'custom_appbar.dart';
import 'custom_drawer.dart';

class NormalLayout extends StatelessWidget {
  final String headText;
  final Widget child;
final GlobalKey<ScaffoldState> scaffloldKey= GlobalKey<ScaffoldState>();
   NormalLayout({
    Key? key,
    required this.headText,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      key:scaffloldKey ,
      appBar: header(context, text: headText, scaffoldKey: scaffloldKey),
      body: child,
      endDrawer: CustomDrawer(),
    );
  }
}
