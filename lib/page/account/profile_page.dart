import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/model/profileInfo.dart';
import 'package:http/http.dart' as http;
import 'package:university/shared/shared.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../component/input_custom.dart';
import '../../layout/normal_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  static var client = http.Client();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _informationController;

  int? _userId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _informationController = TextEditingController();
    _getUserId();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _informationController.dispose();
    super.dispose();
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt("id");
  }

  Future<Profile?> _getUserInfo() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("id");
    var url = Uri.parse('$mainURL/info/$userId');
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var decodedResponse = utf8.decode(response.bodyBytes);
      var data = jsonDecode(decodedResponse);
      return Profile.fromJson(data);
    }
    return null;
  }

  Future<void> _updateProfileData(BuildContext context, Profile updatedProfile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (_userId != null) {
        final url = Uri.parse('$mainURL/updateApi/$_userId');
        final response = await http.put(
          url,
          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(updatedProfile.toJson()),
        );

        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Success',
            desc: 'Profile updated successfully!',
            btnOkOnPress: () {},
          ).show();
        } else {
          throw 'Failed to update profile. Please try again.';
        }
      } else {
        throw 'User ID is not available.';
      }
    } catch (error) {
      Navigator.of(context).pop();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: error.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile?>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data found'));
        } else {
          var profile = snapshot.data!;
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _phoneController.text = profile.phone;
          _addressController.text = profile.address;
          _informationController.text = profile.infomation;

          return NormalLayout(
            headText: 'Edit Profile',

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SizedBox(
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 12.0,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 15.0,
                                  color: Color(0xFF404040),
                                ),
                              ),
                            ),
                            radius: 48.0,
                            backgroundImage: NetworkImage(
                              '$imageUrl/getimage/${profile.avatar}',
                            ),
                          ),
                        ),
                      ),
                    ),


                    InputCustom(
                      hintText: 'Enter name',
                      labelText: 'Name',
                      controller: _nameController,
                      notNull: true,
                      readOnly: true,
                      prefixIcon: Icon(Icons.text_decrease, size: 20),
                    ),

                    InputCustom(
                      hintText: 'Email read only',
                      labelText: 'Email',
                      controller: _emailController,
                      notNull: true,
                      readOnly: true,
                      prefixIcon: Icon(Icons.email, size: 20),
                    ),


                    InputCustom(
                      hintText: 'Enter phone',
                      labelText: 'Phone',
                      controller: _phoneController,
                      notNull: true,
                      readOnly: true,
                      prefixIcon: Icon(Icons.phone, size: 20),
                    ),

                    InputCustom(
                      hintText: 'Enter address',
                      labelText: 'Address',
                      controller: _addressController,
                      notNull: true,
                      readOnly: true,
                      prefixIcon: Icon(Icons.add_location_sharp, size: 20),
                    ),
                    InputCustom(
                      hintText: 'Enter information',
                      labelText: 'Information',
                      controller: _informationController,
                      notNull: true,
                      prefixIcon: Icon(Icons.info_outline_rounded, size: 20),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Profile updatedProfile = Profile(
                              name: _nameController.text,
                              email: _emailController.text,
                              phone: _phoneController.text,
                              address: _addressController.text,
                              infomation: _informationController.text,
                              avatar: profile.avatar,
                            );
                            _updateProfileData(context, updatedProfile);
                          }
                        },

                        child: Text('Update Profile'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
