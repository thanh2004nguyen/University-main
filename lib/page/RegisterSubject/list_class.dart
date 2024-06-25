
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/component/Hien/Model/Class_For_Subject.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

import '../../shared/shared.dart';
import 'class_details.dart';

class ClassList extends StatefulWidget{
  final int subjectId;
  final String subjectName;
  const ClassList({super.key, required this.subjectId, required this.subjectName});

  @override
  State<ClassList> createState() {
    return ClassApi(subjectId,subjectName);

  }
}
class ClassApi extends State<ClassList> {
  late SharedPreferences prefs;
  late  String jwt ="";
  late  int studentId ;

  late List<ClassForSubject> classSubject = [];
  final int subjectId;
  final String subjectName;
  ClassApi(this.subjectId, this.subjectName);

  @override
  void initState() {
    super.initState();
    initializeData(); // Call the method to initialize data
  }
  void initializeData() async {
    try {
      await listClass();
      setState(() {
      });
    } catch (error) {
      print('Error initializing data: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return NormalLayout(

      child: Container(
        color: BackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20), // Add space above the list
              Text(
                subjectName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // Add space below the text
              Expanded(
                child: ListView.builder(
                  itemCount: classSubject.length,
                  itemBuilder: (BuildContext context, int index) {

                    final currentClass = classSubject[index];
                    final teacherName = currentClass.teacher!.name!;
                    final className = currentClass.name;
                    final classTime = currentClass.dateStart != null
                        ? '${currentClass.dateStart!.year}/${currentClass.dateStart!.month}/${currentClass.dateStart!.day}'
                        : 'Date not available';
                    final classQuantity = currentClass.quantity.toString();
                    return GestureDetector(
                      onTap:(){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ClassDetail(classDetail: currentClass);
                          },
                        );
                      },
                      child: Container(

                        height: 150,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF6B4D12)),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0XFFD9D9D9),
                        ),
                        padding: EdgeInsets.all(8),
                      
                        child: Column(
                      
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                      
                            Text(
                              'Class Name: $className',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Teacher:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(width: 20), // Add space between "Teacher:" and teacherName
                                Text(teacherName!, style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Time:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(width: 20), // Add space between "Time:" and classTime
                                Text(classTime, style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Quantity:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(width: 40), // Add space between "Quantity:" and classQuantity
                                Text(classQuantity, style: TextStyle(fontSize: 18)),
                              ],
                            ),
                      
                          ],
                      
                        ),
                      
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ), headText: 'LIST CLASS',
    );
  }

  Future<void> listClass() async {

    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString("jwt")!;
    studentId = prefs.getInt("id")!;
    String url = Ipv4PFT+"listClass";
    Map<String, dynamic> requestBody = {
      "studentId": studentId,
      "subjectId" : subjectId
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt,
    };


    // Create a map containing the student ID
    final response = await http.post(
      Uri.parse(url),
      headers:headers,
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      var bodyData = jsonDecode(response.body) as List;
      List<ClassForSubject> data = bodyData.map((a) {
        return ClassForSubject.fromJson(a);
      }).toList(); // Extract subjects from studentSubjects

      setState(() {
        classSubject = data;
      });
    }
  }

}
