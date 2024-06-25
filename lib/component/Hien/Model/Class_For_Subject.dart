



import 'package:university/component/Hien/Model/subject.dart';
import 'package:university/component/Hien/Model/user.dart';

class ClassForSubject {
  final int? id;
  final String? name;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final int? slotStart;
  final int? slotEnd;
  final int? quantity;
  final String? description;
  final String? status;
  final int? weekDay;
  final User? teacher;
  final Subject? subject;

  ClassForSubject({
    this.id,
    this.name,
    this.dateStart,
    this.dateEnd,
    this.slotStart,
    this.slotEnd,
    this.quantity,
    this.description,
    this.status,
    this.weekDay,
    this.teacher,
    this.subject,
  });

  factory ClassForSubject.fromJson(Map<String, dynamic> json) {
    return ClassForSubject(
      id: json['id'] as int?,
      name: json['name'] as String?,
      dateStart: json['dateStart'] != null ? DateTime.tryParse(json['dateStart']) : null,
      dateEnd: json['dateEnd'] != null ? DateTime.tryParse(json['dateEnd']) : null,
      slotStart: json['slotStart'] as int?,
      slotEnd: json['slotEnd'] as int?,
      quantity: json['quantity'] as int?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      weekDay: json['weekDay'] as int?,
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id!,
      'name': name!,
      'dateStart': dateStart?.toIso8601String(),
      'dateEnd': dateEnd?.toIso8601String(),
      'slotStart': slotStart!,
      'slotEnd': slotEnd!,
      'quantity': quantity!,
      'description': description!,
      'status': status!,
      'weekDay': weekDay!,
      'teacher': teacher?.toString(), // Assuming User.toJson method exists
      'subject': subject?.toJson(), // Assuming Subject.toJson method exists
    };
  }
}
