class News {
  int? id;
  String? title;
  String? content;
  String? image;
  String? createDate;

  News({this.id, this.title, this.content, this.image, this.createDate});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    createDate = json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['image'] = this.image;
    data['createDate'] = this.createDate;
    return data;
  }
}
