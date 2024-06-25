class CalendarData {
  String? room;
  int? startSlot;
  int? endSlot;
  String? className;
  int? weekDay;
  String? status;
  String? subjectName;

  CalendarData(
      {this.room,
        this.startSlot,
        this.endSlot,
        this.className,
        this.weekDay,
        this.status,
        this.subjectName});

  CalendarData.fromJson(Map<String, dynamic> json) {
    room = json['room'];
    startSlot = json['startSlot'];
    endSlot = json['endSlot'];
    className = json['className'];
    weekDay = json['weekDay'];
    status = json['status'];
    subjectName = json['subjectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room'] = this.room;
    data['startSlot'] = this.startSlot;
    data['endSlot'] = this.endSlot;
    data['className'] = this.className;
    data['weekDay'] = this.weekDay;
    data['status'] = this.status;
    data['subjectName'] = this.subjectName;
    return data;
  }
}
