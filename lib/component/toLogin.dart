import 'package:flutter/material.dart';
import 'package:university/page/account/login_page.dart';

void toLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

