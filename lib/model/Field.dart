class Field {
 late int id;
 late String name;
 late int duration;
 late int level;

  Field({required this.id, required this.name, required this.duration, required this.level});

  Field.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration'] = this.duration;
    data['level'] = this.level;
    return data;
  }
}
