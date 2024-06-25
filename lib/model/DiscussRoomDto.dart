class DiscussRoomDto {
  int? id;
  String? name;
  String? topic;
  String? expiredDate;

  DiscussRoomDto({this.id, this.name, this.topic, this.expiredDate});

  DiscussRoomDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    topic = json['topic'];
    expiredDate = json['expired_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['topic'] = this.topic;
    data['expired_date'] = this.expiredDate;
    return data;
  }
}
