import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:university/model/lesson_data.dart';

import '../../component/info_tag.dart';
import '../../data_type/KeyType.dart';
import '../../model/lesson.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';
import 'package:http/http.dart' as http;

class ProcessDetailPage extends StatelessWidget {
  ProcessDetailPage({super.key, required this.classId});

  late SharedPreferences prefs;
  late String jwt;
  late int id = 0;
  final int classId;
  late LessonData data;
  late int countAttend;
  late int countAbsent;
  late String status;

  action(response) {
    final Map<String, dynamic> responseData = json.decode(response.body);

    data = (LessonData.fromJson(responseData));

    if(data.lessons!.isNotEmpty){
      countAttend=0;
      countAbsent=0;
      status= countAbsent/data.lessons!.length >0.4 ?"Ban from taking a test" : "Normal";
      data.lessons?.forEach((e) {
        if(e.status=="attend"){
          countAttend++;
        }

        if(e.status =="absent"){
          countAbsent++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getApiData() async {
      prefs = await SharedPreferences.getInstance();
      id = prefs.getInt("id")!;
      String useUrl = '$mainURL/api/attendance/detail?student=$id&id=$classId';
      jwt = prefs.getString("jwt")!;
      var url = Uri.parse(useUrl);
      var response = await http.get(url, headers: CommonMethod.createHeader(jwt));

      await CommonMethod.handleGet(response, action, context, url);
    }

    print(classId);
    return NormalLayout(
        headText: "Class process",
        child: FutureBuilder(
          future: getApiData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("error"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  size: 70,
                  color: Colors.purple,
                ),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: BackgroundColor,
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(color: blurColor),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(text: 'Class : ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: data.className),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(text: 'Subject : ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: data.subjectName),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                    children:  <TextSpan>[
                                      TextSpan(text: 'Attend/absent : ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: '$countAttend / $countAbsent'),
                                    ],
                                  ),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                  children:  <TextSpan>[
                                    TextSpan(text: 'status : ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: status),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: MediaQuery.of(context).size.height - 300,
                      child: Container(
                          padding: EdgeInsets.only(top: 15),
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: MainColor,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                spreadRadius: -3.0,
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                              itemCount: data.lessons?.length,
                              itemBuilder: (context, i) {
                                Lessons item = data.lessons![i];
                                return InfoTag(

                                  data: [
                                    KeyValue(key: "Lesson", value: "${item.lesson}"),
                                    KeyValue(key: "Date", value: DateFormat('dd/MM/yyyy').format(DateTime.parse(item.day!))),

                                  ],
                                  icon: Icon(Icons.star),
                                  status: item.status ?? "waiting",
                                );
                              })),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
