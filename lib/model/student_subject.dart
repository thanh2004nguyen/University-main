



import 'package:university/model/subject.dart';
import 'package:university/model/user.dart';

class StudentSubject {
  final int id;
  final User user;
  final Subject subject;

  StudentSubject({required this.id, required this.user, required this.subject});

  factory StudentSubject.fromJson(Map<String, dynamic> json) {
    return StudentSubject(
      id: json['id'],
      user: User.fromJson(json['user']),
      subject: Subject.fromJson(json['subject']),
    );
  }
}