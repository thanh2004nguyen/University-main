import 'dart:async';
import 'dart:convert'; // Thêm thư viện này để xử lý JSON

import 'package:flutter/material.dart';
import 'package:university/component/custom_filled_button.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:http/http.dart' as http;
import 'package:university/page/account/verifyOtpScreen.dart';
import 'package:university/shared/shared.dart';
import '../../component/input_custom.dart';
import '../../layout/no_drawer_layout.dart';


class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _sendOtp() async {
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sending OTP...')),
        );

        try {
          String otp = await sendOtp(emailController.text);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpScreen(email: emailController.text, otp: otp),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }

    return NoDrawerLayout(
      headText: "ForgotPassword",
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
              hintText: 'Enter email',
              labelText: 'Email',
              controller: emailController,
              isEmail: true,
              notNull: true,
              prefixIcon: Icon(Icons.email, size: 20),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child:CustomFilledButton(text: "Submit", onTap: _sendOtp),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse("$mainURL/flutter/forgot"),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['otp'];
    } else {
      throw Exception('Failed to send OTP');
    }
  }
}
