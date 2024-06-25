
import 'dart:convert';
import 'package:university/component/Hien/Model/Class_For_Subject.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../component/Hien/Model/student_subject.dart';
import '../../component/Hien/Model/subject.dart';
import '../../shared/shared.dart';
import 'class_details.dart';


class CurentRegisCLass extends StatefulWidget {
  CurentRegisCLass({Key? key}) : super(key: key);

  @override
  _CurentRegisCLassState createState() => _CurentRegisCLassState();
}

class _CurentRegisCLassState extends State<CurentRegisCLass> {
  late List<StudentSubject> data = [];

  @override
  void initState() {
    super.initState();
    fetchClassList();
  }

  Future<void> fetchClassList() async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("jwt")!;
    String url = Ipv4PFT+"api/Ongoing";
    // String url = "http://10.0.2.2:8081/listClass";
    Map<String, dynamic> requestBody = {
      "StudentId": "3"
    };
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      data.clear();
      final List<dynamic> responseData = json.decode(response.body);
      responseData.forEach((json) {
        data.add(StudentSubject.fromJson(json));
      });
    }
    else
    {
      print("Failed");
    }

  }

  Future<void> cancelRegistration(int? classId) async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("jwt")!;

    String url = Ipv4PFT+"api/cancelClass";
    Map<String, dynamic> requestBody = {
      "ClassId" : classId
    };
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt,
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200)
    {

      print("Success");
      //Navigator.pop(context, true);
    }
    else
    {
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: fetchClassList(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                size: 70,
                color: Colors.purple,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              color: BackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    // Add space above the list
                    Text(
                      "subjectName",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Add space below the text
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final currentClass = data[index];
                          final teacherName = currentClass.classForSubject!
                              .teacher!.name!;
                          final className = currentClass.classForSubject?.name;
                          final classTime = currentClass.classForSubject!
                              .dateStart != null
                              ? '${currentClass.classForSubject!.dateStart!
                              .year}/${currentClass.classForSubject!.dateStart!
                              .month}/${currentClass.classForSubject!.dateStart!
                              .day}'
                              : 'Date not available';
                          final classQuantity = currentClass.classForSubject!
                              .quantity.toString();

                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Text("data");
                                },
                              );
                            },
                            child: Container(
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Teacher:', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                      SizedBox(width: 20),
                                      // Add space between "Teacher:" and teacherName
                                      Text(teacherName!,
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Time:', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                      SizedBox(width: 20),
                                      // Add space between "Time:" and classTime
                                      Text(classTime,
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Quantity:', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                      SizedBox(width: 40),
                                      // Add space between "Quantity:" and classQuantity
                                      Text(classQuantity,
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      cancelRegistration(currentClass.id)
                                          .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) =>  CurentRegisCLass())));
                                      setState(() {
                                        data.removeAt(index);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10)),
                                      shadowColor: Colors.grey,
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 16),
                                    ),
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
            );
          }
        },
      );

  }
  }





