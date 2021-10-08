import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String pid;
  String sessid;
  String price;
  String date;
  String time;
  String tid;
  String sid;
  String rid;
  String cid;
  String gid;
  Timestamp timestamp;
  bool withdraw;

  Payment(
      {this.sessid,
      this.pid,
      this.gid,
      this.price,
      this.timestamp,
      this.date,
      this.time,
      this.tid,
      this.sid,
      this.rid,
      this.cid,
      this.withdraw});

  Payment.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    gid = json['gid'];
    price = json['price'];
    date = json['date'];
    time = json['time'];
    tid = json['tid'];
    sid = json['sid'];
    rid = json['rid'];
    cid = json['cid'];
    timestamp = json['timestamp'];
    withdraw = json['withdraw'];
    sessid = json['sessid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['gid'] = this.gid;
    data['price'] = this.price;
    data['date'] = this.date;
    data['time'] = this.time;
    data['tid'] = this.tid;
    data['sid'] = this.sid;
    data['rid'] = this.rid;
    data['cid'] = this.cid;
    data['withdraw'] = this.withdraw;
    data['timestamp'] = this.timestamp;

    data['sessid'] = this.sessid;
    return data;
  }
}
