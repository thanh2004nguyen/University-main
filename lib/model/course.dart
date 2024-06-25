

import 'ClassDataModel.dart';
import 'Teacher.dart';

class Course {
  int? id;
  int? day;
  int? startSlot;
  int? endSlot;
  DateTime? startDay;
  DateTime? endDay;
  Teacher? teacher;
  Field? field;
  Room? room;

  Course(
      {this.id,
        this.day,
        this.startSlot,
        this.endSlot,
        this.startDay,
        this.endDay,
        this.teacher,
        this.field,
        this.room});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    startSlot = json['start_slot'];
    endSlot = json['end_slot'];
    startDay = json['start_day'];
    endDay = json['end_day'];
    teacher =
    json['teacher'] != null ? new Teacher.fromJson(json['teacher']) : null;
    field = json['field'] != null ? new Field.fromJson(json['field']) : null;
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_slot'] = this.startSlot;
    data['end_slot'] = this.endSlot;
    data['start_day'] = this.startDay;
    data['end_day'] = this.endDay;
    if (this.teacher != null) {
      data['teacher'] = this.teacher!.toJson();
    }
    if (this.field != null) {
      data['field'] = this.field!.toJson();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}

