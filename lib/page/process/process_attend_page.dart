import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/page/process/process_detail_page.dart';

import '../../component/info_tag.dart';
import '../../data_type/KeyType.dart';
import '../../layout/normal_layout.dart';
import '../../model/ListClassDto.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';
import '../discuss/ListDiscuss_page.dart';

class ProcessAttendPage extends StatelessWidget {
  ProcessAttendPage({Key? key}) : super(key: key); // Modified

  late SharedPreferences prefs;
  late String jwt;
  late int id = 0;

  List<ListClassDto> data = [];

  void action(response){
    data.clear( );
    final List<dynamic> responseData = json.decode(response.body);
    responseData.forEach((json) {
      data.add(ListClassDto.fromJson(json));
    });
  }

  @override
  Widget build(BuildContext context) {

    Future<void> getApiData() async {
      prefs = await SharedPreferences.getInstance();
      id = prefs.getInt("id")!;
      String useUrl = '$mainURL/api/class/list/$id';
      jwt = prefs.getString("jwt")!;

      var url = Uri.parse(useUrl);
      var response = await http.get(url, headers: CommonMethod.createHeader(jwt));
      await CommonMethod.handleGet(response, action, context, url);
    }

    return NormalLayout(
      headText: "Class Attend",
      child: FutureBuilder<void>(
        future: getApiData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Modified
            return Center(
              child: LoadingAnimationWidget.discreteCircle(
                size: 70,
                color: Colors.purple,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: data.length, // Modified
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InfoTag(
                    data: [
                      KeyValue(key: "Class", value: data[index].className!),
                      KeyValue(key: "Subject", value: data[index].subjectName!),
                      KeyValue(key: "Teacher", value: data[index].teacherName!)
                    ],
                    icon: Icon(Icons.navigate_next),
                    page: ProcessDetailPage(classId: data[index].id!,), // Modified
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
