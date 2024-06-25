

import '../../../model/category.dart';

class Subject {
  int? id;
  String? name;
  Category? subjectlevel;

  Subject({this.id, this.name, this.subjectlevel});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subjectlevel = json['subjectlevel'] != null
        ? new Category.fromJson(json['subjectlevel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    final category = this.subjectlevel;
    if (category != null) {
      data['subjectlevel'] = subjectlevel?.toJson();
    }
    return data;
  }
}
