class Meeting {
  String mid;
  String seekId;
  String conId;
  String time;
  String date;
  bool completed;
  String timezone;
  Meeting(
      {this.mid,
      this.seekId,
      this.conId,
      this.time,
      this.date,
      this.timezone,
      this.completed});

  Meeting.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    timezone = json['timezone'];
    seekId = json['seekId'];
    conId = json['conId'];
    time = json['time'];
    date = json['date'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mid'] = this.mid;
    data['timezone'] = this.timezone;
    data['seekId'] = this.seekId;
    data['conId'] = this.conId;
    data['time'] = this.time;
    data['date'] = this.date;
    data['completed'] = this.completed;
    return data;
  }
}
