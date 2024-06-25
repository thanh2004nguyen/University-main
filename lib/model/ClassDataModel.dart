class ClassDataModel {
  int? id;
  Student? student;
  Course? course;

  ClassDataModel({this.id, this.student, this.course});

  ClassDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    student =
    json['student'] != null ? new Student.fromJson(json['student']) : null;
    course =
    json['course'] != null ? new Course.fromJson(json['course']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    return data;
  }
}

class Student {
  int? id;
  String? email;
  String? password;
  int? role;

  Student({this.id, this.email, this.password, this.role});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    return data;
  }
}

class Course {
  int? id;
  int? day;
  int? startSlot;
  int? endSlot;
  Student? teacher;
  Field? field;
  Room? room;

  Course(
      {this.id,
        this.day,
        this.startSlot,
        this.endSlot,
        this.teacher,
        this.field,
        this.room});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    startSlot = json['start_slot'];
    endSlot = json['end_slot'];
    teacher =
    json['teacher'] != null ? new Student.fromJson(json['teacher']) : null;
    field = json['field'] != null ? new Field.fromJson(json['field']) : null;
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_slot'] = this.startSlot;
    data['end_slot'] = this.endSlot;
    if (this.teacher != null) {
      data['teacher'] = this.teacher!.toJson();
    }
    if (this.field != null) {
      data['field'] = this.field!.toJson();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}

class Field {
  int? id;
  String? name;
  int? duration;
  int? level;

  Field({this.id, this.name, this.duration, this.level});

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

class Room {
  int? id;
  String? name;
  String? capacity;

  Room({this.id, this.name, this.capacity});

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['capacity'] = this.capacity;
    return data;
  }
}
