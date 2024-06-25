class MarkTotal {
  String? className;
  String? teacherName;
  double? finalMark;
  String? subjectName;
  String? classStatus;
  int? classId;

  MarkTotal(
      {this.className,
        this.teacherName,
        this.finalMark,
        this.subjectName,
        this.classStatus,
        this.classId});

  MarkTotal.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    teacherName = json['teacherName'];
    finalMark = json['finalMark'];
    subjectName = json['subjectName'];
    classStatus = json['classStatus'];
    classId = json['classId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    data['teacherName'] = this.teacherName;
    data['finalMark'] = this.finalMark;
    data['subjectName'] = this.subjectName;
    data['classStatus'] = this.classStatus;
    data['classId'] = this.classId;
    return data;
  }
}
