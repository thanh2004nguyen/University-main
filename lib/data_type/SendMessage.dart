class SendMessage {
  String? sender;
  String? content;
  int? id;
  int? roomId;
  String? type;

  SendMessage({this.sender, this.content, this.id, this.roomId, this.type});

  SendMessage.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    content = json['content'];
    id = json['id'];
    roomId = json['room_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['content'] = this.content;
    data['id'] = this.id;
    data['room_id'] = this.roomId;
    data['type'] = this.type;
    return data;
  }
}
