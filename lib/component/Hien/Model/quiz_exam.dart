import 'package:university/component/Hien/Model/Class_For_Subject.dart';
import 'package:university/component/Hien/Model/quiz.dart';
import 'package:university/component/Hien/Model/user.dart';

class QuizExam {
  final int id;
  final DateTime? startFromDate;
  final DateTime? closeDate;
  final DateTime? startExamTime;
  final DateTime? submitExamTime;
  final String? status;
  final User? student;
  final ClassForSubject? classForSubject;
  final Quiz? quiz;

  QuizExam({
   required this.id,
    this.startFromDate,
    this.closeDate,
    this.startExamTime,
    this.submitExamTime,
    this.status,
    this.student,
    this.classForSubject,
    this.quiz,
  });

  factory QuizExam.fromJson(Map<String, dynamic> json) {
    return QuizExam(
      id: json['id'] as int,
      startFromDate: json['startFromDate'] != null ? DateTime.tryParse(json['startFromDate']) : null,
      closeDate: json['closeDate'] != null ? DateTime.tryParse(json['closeDate']) : null,
      startExamTime: json['start_exam_time'] != null ? DateTime.tryParse(json['start_exam_time']) : null,
      submitExamTime: json['submit_exam_time'] != null ? DateTime.tryParse(json['submit_exam_time']) : null,
      status: json['status']! ,
      student: json['student'] != null ? User.fromJson(json['student']) : null,
      classForSubject: json['classForSubject'] != null ? ClassForSubject.fromJson(json['classForSubject']) : null,
      quiz: json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startFromDate': startFromDate?.toIso8601String(),
      'closeDate': closeDate?.toIso8601String(),
      'start_exam_time': startExamTime?.toIso8601String(),
      'submit_exam_time': submitExamTime?.toIso8601String(),
      'status': status,
      'student': student?.toString(),
      'classForSubject': classForSubject?.toJson(),
      'quiz': quiz?.toJson(),
    };
  }
}
