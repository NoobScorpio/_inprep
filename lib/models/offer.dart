import 'package:cloud_firestore/cloud_firestore.dart';

import 'meeting.dart';

class Offer {
  String meid;
  String cid;
  String oid;
  double cost;
  int meetCount;
  bool cancel;
  bool accepted;
  Timestamp timestamp;
  List<Meeting> meets;
  bool declined;

  Offer(
      {this.meid,
      this.declined,
      this.cid,
      this.oid,
      this.accepted,
      this.cost,
      this.meetCount,
      this.cancel,
      this.timestamp,
      this.meets});

  Offer.fromJson(Map<String, dynamic> json) {
    meid = json['meid'];
    accepted = json['accepted'];
    declined = json['declined'];
    cost = json['cost'];
    cid = json['cid'];
    oid = json['oid'];
    meetCount = json['meetCount'];
    cancel = json['cancel'];
    timestamp = json['Timestamp'];
    if (json['meets'] != null) {
      meets = new List<Meeting>();
      json['meets'].forEach((v) {
        meets.add(new Meeting.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meid'] = this.meid;
    data['accepted'
        ''] = this.accepted;
    data['cid'] = this.cid;
    data['oid'] = this.oid;
    data['cost'] = this.cost;
    data['meetCount'] = this.meetCount;
    data['cancel'] = this.cancel;
    data['Timestamp'] = this.timestamp;
    data['declined'] = this.declined;
    if (this.meets != null) {
      data['meets'] = this.meets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
