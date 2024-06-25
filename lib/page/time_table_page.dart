import 'dart:async';
import 'dart:convert';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:http/http.dart' as http;

import '../component/info_tag.dart';
import '../data_type/KeyType.dart';
import '../data_type/calendar_data.dart';
import '../layout/normal_layout.dart';
import '../model/ClassDataModel.dart';
import '../shared/common.dart';
import '../shared/shared.dart';

class TimeTablePage extends StatefulWidget {
  @override
  State<TimeTablePage> createState() => _TimeTablePage();
}

Map<String, Icon> statusIcon = {
  "attend": Icon(Icons.star),
  "absent": Icon(Icons.star_border),
  "half": Icon(Icons.star_half),
  "waiting": Icon(Icons.star),
};

class _TimeTablePage extends State<TimeTablePage> {
  late SharedPreferences prefs;
  late String jwt;
  late int id = 0;
  DateTime today = DateTime.now();

  List<CalendarData> data = [];

  void action(response){
    final List<dynamic> responseData = json.decode(response.body);
    setState(() {
      data.clear();
      responseData.forEach((json) {
        data.add(CalendarData.fromJson(json));
      });
    });
  }

  Future<void> getApi() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("id")!;
    jwt = prefs.getString("jwt")!;
    final apiUrl = '$mainURL/api/timetable/show?id=$id&day=${today.toString().substring(0, 10)}';
    final Map<String, String> header = CommonMethod.createHeader(jwt);
    final response = await http.get(Uri.parse(apiUrl), headers: header);
    await CommonMethod.handleGet(response, action, context, apiUrl);




  }

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      today = day;
      getApi();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
      headText: 'Time table',
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: TableCalendar(
                calendarStyle:CalendarStyle(
                  markerSize: 25,
                ) ,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: today,
                onDaySelected: _onDaySelected,
                rowHeight: 35,
                selectedDayPredicate: (day) => isSameDay(day, today),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            Flexible(

              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6, // Adjust the percentage according to your needs
                  child: data.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      CalendarData item = data[index];
                      Icon icon = statusIcon[item.status ?? "waiting"] ?? Icon(Icons.error);
                      return InfoTag(
                        data: [
                          KeyValue(key: "Class", value: item.className!),
                          KeyValue(key: "Subject", value: item.subjectName!),
                          KeyValue(key: "Room", value: item.room!),
                          KeyValue(
                            key: "Slot",
                            value: item.startSlot.toString() + " - " + item.endSlot.toString(),
                          ),
                        ],
                        icon: icon,
                        status: item.status,
                      );
                    },
                  )
                      : Center(
                    child: Text("No calendar for today"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

