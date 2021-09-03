class Experience {
  String eid;
  String title;
  String designation;
  String to;
  String from;
  String uid;
  bool current;
  Experience(
      {this.eid,
      this.title,
      this.designation,
      this.to,
      this.from,
      this.uid,
      this.current});

  Experience.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    title = json['title'];
    designation = json['designation'];
    to = json['to'];
    from = json['from'];
    uid = json['uid'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eid'] = this.eid;
    data['title'] = this.title;
    data['designation'] = this.designation;
    data['to'] = this.to;
    data['from'] = this.from;
    data['current'] = this.current;
    data['uid'] = this.uid;
    return data;
  }
}
