
import 'package:flutter/material.dart';

import '../shared/shared.dart';
import 'no_drawer_appbar.dart';

class NoDrawerLayout extends StatelessWidget {
  final String headText;
  final Widget child;
  final GlobalKey<ScaffoldState> scaffloldKey= GlobalKey<ScaffoldState>();
  NoDrawerLayout({
    Key? key,
    required this.headText,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:BackgroundColor,
      key:scaffloldKey ,
      appBar: NoDrawerAppbar(context, text: headText),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: child,
      ),
    );
  }
}
