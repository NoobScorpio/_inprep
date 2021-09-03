class Contact {
  String cid;
  String uid;
  String code;
  String number;

  Contact({this.cid, this.uid, this.code, this.number});

  Contact.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    uid = json['uid'];
    code = json['code'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['uid'] = this.uid;
    data['code'] = this.code;
    data['number'] = this.number;
    return data;
  }
}
