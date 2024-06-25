
import 'package:university/component/Hien/Model/Class_For_Subject.dart';
import 'package:university/component/Hien/Model/user.dart';

class StudentSubject {
  final int? id;
  final User? student;
  final ClassForSubject? classForSubject;
  StudentSubject({this.id, this.student, this.classForSubject});

  factory StudentSubject.fromJson(Map<String, dynamic> json) {
    if (json == null) return StudentSubject(); // Handle null case gracefully

    final id = json['id'] as int?;

    // Handle student data
    final studentJson = json['student'];
    final student = studentJson != null ? User.fromJson(studentJson) : null;

    // Handle classForSubject data
    final classForSubjectJson = json['classforSubject'];
    final classForSubject = classForSubjectJson != null ? ClassForSubject.fromJson(classForSubjectJson) : null;

    return StudentSubject(
      id: id,
      student: student,
      classForSubject: classForSubject,
    );
  }
}

