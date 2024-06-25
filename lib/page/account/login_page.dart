import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/model/login_data.dart';
import 'package:university/shared/common.dart';

import '../../component/custom_filled_button.dart';
import '../../component/custom_text_field.dart';
import '../../component/input_custom.dart';
import '../../layout/no_drawer_layout.dart';
import '../../shared/shared.dart';
import '../homepage.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() {
    return _loginPageState();
  }
}


class _loginPageState extends State<LoginPage> {
  bool checked = false;
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool _obscureText = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;

    });
  }

  @override
  Widget build(BuildContext context) {
    return NoDrawerLayout(
      headText: 'Login',
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Image.asset("assets/images/logo.png",
                      width: 150, height: 150),
                ),
              ),
              InputCustom(
                hintText: 'Email',
                labelText: 'Email',
                controller: nameController,
                notNull: true,
                prefixIcon: Icon(Icons.email, size: 20),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                child:InputCustom(
                  hintText: 'Enter password',
                  labelText: 'Password',
                  controller: passController,
                  isPassword: !_obscureText,
                  notNull: true,
                  prefixIcon: Icon(Icons.lock_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                    ),
                    onPressed: _toggle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
             SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: ForgotPassword(),
                                ctx: context,
                              ),
                            );
                          },
                          child: const Text(
                            style: TextStyle(color: Colors.red),
                            'Forgot Password',
                          )),
                    )
                  ],
                ),
              ),
              CustomFilledButton(
                text: 'Login',
                onTap: _handleTap,
              )
            ],
          ),
        ),
      ),
    );
  }

  void test() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  _handleTap() async {
    String useUrl = '$mainURL/api/login';
    var url = Uri.parse(useUrl);
    Map<String, String> headers = {"Content-type": "application/json"};
    String jsonSourec =
        '{"email":"${nameController.text}", "password" :"${passController.text}"}';
    var response = await http.post(url, headers: headers, body: jsonSourec);
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var jsonData = json.decode(response.body);

      LoginData data = LoginData.fromJson(jsonData);
      prefs.setInt("id", data.user!.userId!);
      prefs.setString("userInfo",jsonEncode(data.user));
      prefs.setString("jwt", data.token!.accessToken!);
      prefs.setString("refreshToken", data.token!.refeshToken!);
String? fmcToken=CommonMethod.FmcToken;
      String fmcBody =
          '{"fmc":"${fmcToken}", "userId" :"${ data.user!.userId!}"}';
      print(fmcBody);
      String fmcUrl='$mainURL/api/user/save/app';
      var fmcResult= await http.post(Uri.parse(fmcUrl),
          headers: CommonMethod.createHeader(data.token!.accessToken!),
        body: fmcBody);

      if(fmcResult.statusCode==200){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }else{
        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          body: Center(
            child: Text(
              "Have error please try again",
              style: TextStyle(fontStyle: FontStyle.normal),
            ),
          ),
          title: 'This is Ignored',
          desc: 'This is also Ignored',
          btnOkOnPress: () {},
        )..show();
      }



    }else{
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        body: Center(
          child: Text(
            "Email or password wrong",
            style: TextStyle(fontStyle: FontStyle.normal),
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {},
      )..show();
    }
  }
}
