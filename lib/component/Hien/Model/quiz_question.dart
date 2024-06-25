import 'package:university/component/Hien/Model/quiz.dart';
import 'package:university/component/Hien/Model/quiz_answer.dart';

class QuizQuestion {
  final int id;
  final String? content;
  final double? mark;
  final String? type;



  QuizQuestion({
    required this.id,
    required this.content,
    required this.mark,
    required this.type,


  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      content: json['content'],
      mark: json['mark'].toDouble(),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'mark': mark,
      'type': type,
    };
  }
}
