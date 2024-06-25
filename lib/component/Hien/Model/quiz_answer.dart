class QuizAnswer {
  final int id;
  final String content;
  final bool isTrue;

  QuizAnswer({
    required this.id,
    required this.content,
    required this.isTrue,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json['id'],
      content: json['content'],
      isTrue: json['isTrue'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isTrue': isTrue ? 1 : 0,
    };
  }
}
