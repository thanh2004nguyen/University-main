

import 'package:flutter/cupertino.dart';
import 'package:university/model/subject.dart';
import 'package:university/model/user.dart';

class ClassForSubject {
  final int id;
  final String name;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String slotStart;
  final String slotEnd;
  final int quantity;
  final String description;
  final String status;
  final String weekDay;
  final User user;
  final Subject subject;

  ClassForSubject({
    required this.id,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.slotStart,
    required this.slotEnd,
    required this.quantity,
    required this.description,
    required this.status,
    required this.weekDay,
    required this.user,
    required this.subject,
  });

  factory ClassForSubject.fromJson(Map<String, dynamic> json) {
    return ClassForSubject(
      id: json['id'],
      name: json['name'],
      dateStart: DateTime.parse(json['dateStart']),
      dateEnd: DateTime.parse(json['dateEnd']),
      slotStart: json['slotStart'],
      slotEnd: json['slotEnd'],
      quantity: json['quantity'],
      description: json['description'],
      status: json['status'],
      weekDay: json['weekDay'],
      user: User.fromJson(json['user']),
      subject: Subject.fromJson(json['subject']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'slotStart': slotStart,
      'slotEnd': slotEnd,
      'quantity': quantity,
      'description': description,
      'status': status,
      'weekDay': weekDay,
      'user': user.toString(), // Assuming User.toJson method exists
      'subject': subject.toJson(), // Assuming Subject.toJson method exists
    };
  }
}
