import 'mark.dart';

class DetailMark {
  MarkTotal? markTotal;
  double? normalMark;
  double? middleMark;
  double? fiinalMark;
  String? result;

  DetailMark(
      {this.markTotal,
        this.normalMark,
        this.middleMark,
        this.fiinalMark,
        this.result});

  DetailMark.fromJson(Map<String, dynamic> json) {
    markTotal = json['markTotal'] != null
        ? new MarkTotal.fromJson(json['markTotal'])
        : null;
    normalMark = json['normalMark'];
    middleMark = json['middleMark'];
    fiinalMark = json['fiinalMark'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.markTotal != null) {
      data['markTotal'] = this.markTotal!.toJson();
    }
    data['normalMark'] = this.normalMark;
    data['middleMark'] = this.middleMark;
    data['fiinalMark'] = this.fiinalMark;
    data['result'] = this.result;
    return data;
  }
}

