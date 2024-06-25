class User {
  int? userId;
  String? name;
  String? avatar;
  String? role;
  String? code;

  User({this.userId, this.name, this.avatar, this.role, this.code});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
    role = json['role'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    data['code'] = this.code;
    return data;
  }
}