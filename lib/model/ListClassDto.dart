class ListClassDto {
  int? id;
  String? className;
  String? subjectName;
  String? teacherName;

  ListClassDto({this.id, this.className, this.subjectName, this.teacherName});

  ListClassDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['className'];
    subjectName = json['subjectName'];
    teacherName = json['teacherName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['className'] = this.className;
    data['subjectName'] = this.subjectName;
    data['teacherName'] = this.teacherName;
    return data;
  }
}
