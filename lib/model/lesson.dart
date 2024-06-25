class Lessons {
  int? lesson;
  String? day;
  String? status;

  Lessons({this.lesson, this.day, this.status});

  Lessons.fromJson(Map<String, dynamic> json) {
    lesson = json['lesson'];
    day = json['day'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lesson'] = this.lesson;
    data['day'] = this.day;
    data['status'] = this.status;
    return data;
  }
}