class User {
  final int? id;
  final String? email;
  final String? name;
  final String? password;
  final String? phone;

  User({
     this.id,
     this.email,
     this.name,
     this.password,
     this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      phone: json['phone'],
    );
  }
}

