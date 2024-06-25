import 'category.dart';

class Subject {
  int? id;
  String? name;
  String? admin;
  Category? category;

  Subject({this.id, this.name, this.admin, this.category});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    admin = json['admin'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['admin'] = this.admin;
    final category = this.category;
    if (category != null) {
      data['category'] = category.toJson();
    }
    return data;
  }
}
