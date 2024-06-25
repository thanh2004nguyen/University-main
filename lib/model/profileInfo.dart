class Profile {
  final String name;
  final String email;
  final String phone;
  final String infomation;
  final String address;
  final String avatar;
  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.infomation,
    required this.address,
    required this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      infomation: json['infomation'],
      address: json['address'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'infomation': infomation,
      'address': address,
      'avatar': avatar,
    };
  }
}
