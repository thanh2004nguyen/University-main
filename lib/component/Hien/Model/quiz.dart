import 'package:university/component/Hien/Model/quiz_question.dart';
import 'package:university/component/Hien/Model/subject.dart';
import 'package:university/component/Hien/Model/user.dart';

class Quiz {
  final int? id;
  final String? name;
  final int duration;
  final String? type;
  final double? totalMark;
  final String? status;
  final Subject? subject;
  final User? teacher;


  Quiz({
     this.id,
     this.name,
    required this.duration,
     this.type,
     this.totalMark,
     this.status,
     this.subject,
     this.teacher
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      type: json['type'],
      totalMark: json['totalMark'].toDouble(),
      status: json['status'],
      subject: json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'type': type,
      'totalMark': totalMark,
      'status': status,
      'subject': subject?.toJson(),
      'teacher': teacher?.toString(),
    };
  }
}
