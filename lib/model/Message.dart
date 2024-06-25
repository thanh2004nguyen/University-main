class Message {
  int? id;
  String? text;
  String? createAt;
  String? senderName;
  int? senderId;
  bool? teacher;
  bool?  deleted;

  Message(
      { this.id,
         this.text,
        this.deleted=false,
         this.createAt,
         this.senderName,
         this.senderId,
         this.teacher});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    deleted=false;
    createAt = json['createAt'];
    senderName = json['sender_name'];
    senderId = json['sender_id'];
    teacher = json['teacher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['createAt'] = this.createAt;
    data['sender_name'] = this.senderName;
    data['sender_id'] = this.senderId;
    data['teacher'] = this.teacher;
    return data;
  }
}

