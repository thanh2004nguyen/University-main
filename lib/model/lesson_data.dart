import 'lesson.dart';

class LessonData {
  String? className;
  List<Lessons>? lessons;
  String? subjectName;

  LessonData({this.className, this.lessons, this.subjectName});

  LessonData.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(new Lessons.fromJson(v));
      });
    }
    subjectName = json['subjectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    if (this.lessons != null) {
      data['lessons'] = this.lessons!.map((v) => v.toJson()).toList();
    }
    data['subjectName'] = this.subjectName;
    return data;
  }
}


