class Teacher {
  int? id;
  String? email;
  String? password;
  int? role;

  Teacher({this.id, this.email, this.password, this.role});

  Teacher.fromJson(Map<String, dynamic> json) {
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
