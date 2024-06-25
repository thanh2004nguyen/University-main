import 'package:flutter/material.dart';
import 'package:university/component/custom_filled_button.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../component/input_custom.dart';
import '../../shared/shared.dart';
import 'login_page.dart';  // Import the LoginPage

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  ChangePasswordScreen({required this.email});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    void _changePassword() async {
      if (_formKey.currentState!.validate()) {
        if (passwordController.text != confirmPasswordController.text) {
          setState(() {
            errorMessage = 'Passwords do not match';
          });
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changing Password...')),
        );

        try {
          bool success = await changePassword(widget.email, passwordController.text);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          }
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
          });
        }
      }
    }

    return NormalLayout(
      headText: "Change Password",
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
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            InputCustom(
              hintText: 'Enter new password',
              labelText: 'New Password',
              controller: passwordController,
              isPassword: true,
              notNull: true,
            ),
            InputCustom(
              hintText: 'Confirm new password',
              labelText: 'Confirm Password',
              controller: confirmPasswordController,
              isPassword: true,
              notNull: true,
            ),
            CustomFilledButton(text: "Change Password", onTap: _changePassword),
          ],
        ),
      ),
    );
  }

  Future<bool> changePassword(String email, String password) async {
    final response = await http.post(
      Uri.parse("$mainURL/flutter/change-password"),
      body: jsonEncode({'email': email, 'newPassword': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      var jsonResponse = jsonDecode(response.body);
      throw Exception(jsonResponse['message'] ?? 'Failed to change password');
    }
  }
}
