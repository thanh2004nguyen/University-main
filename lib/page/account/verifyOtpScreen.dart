import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:university/component/custom_filled_button.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:university/page/account/changePassword.dart'; // Import the ChangePasswordScreen
import '../../component/input_custom.dart';
import '../../shared/shared.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String email;
  final String otp;

  VerifyOtpScreen({required this.email, required this.otp});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _verifyOtp() async {
      if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifying OTP...')),
        );

        try {
          bool isValid = await verifyOtp(email, otpController.text);
          if (isValid) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordScreen(email: email), // Navigate to ChangePasswordScreen
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid OTP. Please try again.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }

    return NormalLayout(
      headText: "Verify OTP",
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
              hintText: 'Enter OTP',
              labelText: 'OTP',
              controller: otpController,
              notNull: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: CustomFilledButton(text: "Verify OTP", onTap: _verifyOtp),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> verifyOtp(String email, String otp) async {
    print(email);
    print(otp);
    final response = await http.post(
      Uri.parse("$mainURL/flutter/verify-otp"),
      body: jsonEncode({'email': email, 'otp': otp}),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to verify OTP');
    }
  }
}
