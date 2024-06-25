class ReciveMessage {
  String? type;
  int? id;
  String? text;
  String? createAt;
  int? senderId;
  String? senderName;
  int? discussRoomId;

  ReciveMessage(
      {this.type,
        this.id,
        this.text,
        this.createAt,
        this.senderId,
        this.senderName,
        this.discussRoomId});

  ReciveMessage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    text = json['text'];
    createAt = json['createAt'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    discussRoomId = json['discussRoomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['text'] = this.text;
    data['createAt'] = this.createAt;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['discussRoomId'] = this.discussRoomId;
    return data;
  }
}
