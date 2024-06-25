class Token {
  String? refeshToken;
  String? accessToken;

  Token({this.refeshToken, this.accessToken});

  Token.fromJson(Map<String, dynamic> json) {
    refeshToken = json['refeshToken'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refeshToken'] = this.refeshToken;
    data['accessToken'] = this.accessToken;
    return data;
  }
}