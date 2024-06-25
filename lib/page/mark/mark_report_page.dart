import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/component/info_tag.dart';

import '../../data_type/KeyType.dart';
import '../../layout/normal_layout.dart';
import '../../model/mark.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';
import 'detail_mark_page.dart';

class MarkReportPage extends StatefulWidget {
  @override
  State<MarkReportPage> createState() => MarkReportPageState();
}

class MarkReportPageState extends State<MarkReportPage> {
  late List<MarkTotal> data = [];

  void action(response) {
    data.clear();
    final List<dynamic> responseData = json.decode(response.body);
    responseData.forEach((json) {
      data.add(MarkTotal.fromJson(json));
    });
  }

  Future<void> getApiData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int id = prefs.getInt("id")!;
    String useUrl = '$mainURL/api/mark/$id';
    final String jwt = prefs.getString("jwt")!;

    var url = Uri.parse(useUrl);
    var response = await http.get(url, headers: CommonMethod.createHeader(jwt));
    print(response.statusCode);
    await CommonMethod.handleGet(response, action, context, url);
  }

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
        headText: 'Mark report',
        child: FutureBuilder(
            future: getApiData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                print (snapshot.error);
                return Center(child: Text("have error happen"));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    size: 70,
                    color: Colors.purple,
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox( height: 20,),
                      Container(
                        height: MediaQuery.of(context).size.height,
                  
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              MarkTotal item = data[index];
                              return InfoTag(data: [
                                KeyValue(key: "Class", value: item.className!),
                                KeyValue(key: "Subject", value: item.subjectName!),
                                KeyValue(key: "Teacher", value: item.teacherName!),
                                KeyValue(key: "Total mark", value: item.finalMark == 0.0 ? "waiting" : item.finalMark.toString()),
                              ], icon: Icon(Icons.navigate_next),
                                page: MarkDetailPage(classId: item.classId!,),
                              );
                            }),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
