import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:university/component/two_rows_text.dart';
import 'package:university/layout/normal_layout.dart';
import 'package:http/http.dart' as http;
import '../../data_type/KeyType.dart';
import '../../model/markDetail.dart';
import '../../shared/common.dart';
import '../../shared/shared.dart';

class MarkDetailPage extends StatelessWidget {
  MarkDetailPage({super.key, required this.classId});

  final int classId;

  late List<KeyValue> listShow = [];
  late DetailMark data;

  Color showColor(double num) {
    if (num <= 40) {
      return Colors.red;
    }
    if (num > 40 && num <= 65) {
      return Colors.black;
    }
    if (num > 65&& num <= 80) {
      return Colors.green;
    }
    if (num >= 80) {
      return Colors.blue;
    }

    return Colors.black;
  }

  action(response) {
    var responseData = json.decode(response.body);

    data = DetailMark.fromJson(responseData);
    listShow.clear();
    listShow.add(KeyValue(key: "Class", value: data.markTotal!.className!));
    listShow.add(KeyValue(key: "Subject", value: data.markTotal!.subjectName!));
    listShow.add(KeyValue(key: "Teacher", value: data.markTotal!.teacherName!));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getApiData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final int id = prefs.getInt("id")!;
      String useUrl = '$mainURL/api/mark/detail/${id}/${classId}';
      print(useUrl);
      final String jwt = prefs.getString("jwt")!;

      var url = Uri.parse(useUrl);
      var response = await http.get(url, headers: CommonMethod.createHeader(jwt));
      print(response.body);
      await CommonMethod.handleGet(response, action, context, url);
    }

    return NormalLayout(
        headText: "Mark details",
        child: FutureBuilder(
          future: getApiData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text("have error happen");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  size: 70,
                  color: Colors.purple,
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: blurColor,
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.15, 30, MediaQuery.of(context).size.width * 0.2, 0),
                        child: ListView.builder(
                          itemCount: listShow.length,
                          itemBuilder: (BuildContext context, int index) {
                            KeyValue item = listShow[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: TwoRowText(
                                name: item.key + ' : ',
                                value: item.value,
                              ),
                            );
                          },
                        ),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Type',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Mark',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text('Normal mark')),
                                    DataCell(Text(data.normalMark == 0.0 ? "waiting" : "${data.normalMark}")),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text('Middle mark')),
                                    DataCell(Text(data.normalMark == 0.0 ? "waiting" : "${data.middleMark}")),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text('Final mark')),
                                    DataCell(Text(data.normalMark == 0.0 ? "waiting" : "${data.fiinalMark}")),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                      'Average mark',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    )),
                                    DataCell(Text(
                                      data.normalMark == 0.0 ? "waiting" : "${data.markTotal!.finalMark}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: showColor(data.markTotal!.finalMark!)),
                                    )),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                      'rank',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    )),
                                    DataCell(Text(
                                      data.result ?? "Waiting",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: showColor(data.markTotal!.finalMark!)),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      flex:7,
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
