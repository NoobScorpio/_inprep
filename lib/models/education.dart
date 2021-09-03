class Education {
  String eid;
  String institute;
  String country;
  String degree;
  String to;
  String from;
  String uid;
  bool current;

  Education(
      {this.eid,
      this.institute,
      this.country,
      this.degree,
      this.to,
      this.from,
      this.uid,
      this.current});

  Education.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    institute = json['institute'];
    country = json['country'];
    degree = json['degree'];
    to = json['to'];
    from = json['from'];
    uid = json['uid'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eid'] = this.eid;
    data['institute'] = this.institute;
    data['country'] = this.country;
    data['degree'] = this.degree;
    data['to'] = this.to;
    data['from'] = this.from;
    data['uid'] = this.uid;
    data['current'] = this.current;
    return data;
  }
}
