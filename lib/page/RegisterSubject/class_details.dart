import 'dart:convert';

import 'package:university/component/Hien/text_box.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/page/RegisterSubject/subject_register_page.dart';

import '../../component/Hien/Model/Class_For_Subject.dart';
import '../../shared/shared.dart';
import 'package:http/http.dart' as http;

class ClassDetail extends StatelessWidget{
  late ClassForSubject classDetail ;
  ClassDetail(
  {
    required this.classDetail
  }
      );
  @override
  Widget build(BuildContext context) {

    return Dialog(

      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context){
    String formatTime(String timeString) {
      final parsedTime = TimeOfDay.fromDateTime(DateTime.parse("2022-01-01 $timeString"));
      return "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}";
    }
    final FslotStart = classDetail!.slotStart.toString();
    final FslotEnd = classDetail!.slotEnd.toString();
    final classDateStart = classDetail.dateStart != null
        ? '${classDetail.dateStart!.year}/${classDetail.dateStart!.month!}/${classDetail.dateStart!.day!}'
        : 'N/A';


    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: BackgroundColor,

      ),
      height: 600,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(

          children: [
            Text(classDetail.subject!.name!,style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700
            ),),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBox(TextContent: "Class:"),

                  TextBox(TextContent:classDetail.name!),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBox(TextContent: "Teacher:"),
                  TextBox(TextContent:classDetail!.teacher!.name!),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBox(TextContent: "Start Day:"),
                  TextBox(TextContent:classDateStart),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBox(TextContent: "Day:"),
                  TextBox(TextContent:classDetail.weekDay.toString()),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBox(TextContent: "Time:"),
                  TextBox(
                    TextContent: '${classDetail.slotStart}-${classDetail.slotEnd}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
              style: FilledButton.styleFrom(
                backgroundColor: MainColor,
              ),
              onPressed: () async {
                  RegisterClass(classDetail.id.toString(),context)
                    .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())));
              },
              child: Text('REGISTER',style: TextStyle(
                fontSize: 24,
              ),),
            ),
          ],
        ),
      ),
    );
}

  Future<void> RegisterClass(String? classId, BuildContext context) async {

    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("jwt")!;

    var url = Ipv4PFT + "api/ClassRegister";
    Map<String, dynamic> requestBody = {
      "classId": classId,
      "userId": "3"
    };

    final result = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt,

      },
      body: jsonEncode(requestBody),
    );

    if (result.statusCode == 200) {
      print('successful registration');
      // Close the dialog
      Navigator.pop(context);
      // Show a success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully registered for class!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print('failed');
      // Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register for class!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}