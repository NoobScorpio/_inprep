class Skill {
  String sid;
  String uid;
  String name;
  int rank;

  Skill({this.sid, this.uid, this.name, this.rank});

  Skill.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    uid = json['uid'];
    name = json['name'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['rank'] = this.rank;
    return data;
  }
}
