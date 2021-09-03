class Social {
  String sid;
  String uid;
  String fb;
  String git;
  String linkedin;
  String insta;
  String tiktok;
  String skype;

  Social(
      {this.sid,
      this.uid,
      this.fb,
      this.git,
      this.linkedin,
      this.insta,
      this.tiktok,
      this.skype});

  Social.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    uid = json['uid'];
    fb = json['fb'];
    git = json['git'];
    linkedin = json['linkedin'];
    insta = json['insta'];
    tiktok = json['tiktok'];
    skype = json['skype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['uid'] = this.uid;
    data['fb'] = this.fb;
    data['git'] = this.git;
    data['linkedin'] = this.linkedin;
    data['insta'] = this.insta;
    data['tiktok'] = this.tiktok;
    data['skype'] = this.skype;
    return data;
  }
}
