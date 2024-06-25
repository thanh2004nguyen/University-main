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
