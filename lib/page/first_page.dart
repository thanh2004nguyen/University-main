import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/model/user.dart';
import 'package:university/page/homepage.dart';
import 'package:university/shared/common.dart';
import 'package:http/http.dart' as http;

import '../shared/shared.dart';
import 'account/login_page.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> check() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? jwt=  prefs.getString("refreshToken");
      if(jwt==null){
        return false;
      }
      String? token = await CommonMethod.refreshToken();
      if (token == null) {
        return false;
      } else {
        prefs.setString("jwt", token);
        final int userId = prefs.getInt("id")!;
        String url = "$mainURL/api/user/info/$userId";
        var response = await http.get(Uri.parse(url), headers: CommonMethod.createHeader(token));

        if (response.statusCode == 200) {
          User userData = User.fromJson(jsonDecode(response.body));
          prefs.setInt("id", userData.userId!);
          prefs.setString("userInfo", jsonEncode(userData));

          return true;
        } else {
          return false;
        }

      }
    }

    Future.delayed(Duration(seconds: 2), () async {

      bool result= await check();
      if(result){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }

    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                body: Column(children: [
          Expanded(flex: 2, child: Image.asset("assets/images/logo.png", width: 280, height: 280)),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(bottom: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please Waiting",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: MainColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: MainColor,
                    size: 40,
                  ),
                )
              ],
            ),
          ))
        ]))));
  }
}
