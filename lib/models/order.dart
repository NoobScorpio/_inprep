import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String oid;
  String pid;
  String sessid;
  String sid;
  String uid;
  String gid;
  String price;
  bool withdraw;
  String date;
  String time;
  bool pending;
  Timestamp timestamp;
  Order(
      {this.oid,
      this.pid,
      this.gid,
      this.timestamp,
      this.sid,
      this.sessid,
      this.pending,
      this.uid,
      this.price,
      this.withdraw,
      this.date,
      this.time});

  Order.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    pid = json['pid'];
    uid = json['uid'];
    price = json['price'];
    withdraw = json['withdraw'];
    date = json['date'];
    time = json['time'];
    sid = json['sid'];
    timestamp = json['timestamp'];
    pending = json['pending'];
    sessid = json['sessid'];
    gid = json['gid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oid'] = this.oid;
    data['gid'] = this.gid;
    data['pid'] = this.pid;
    data['uid'] = this.uid;
    data['price'] = this.price;
    data['withdraw'] = this.withdraw;
    data['date'] = this.date;
    data['time'] = this.time;
    data['sid'] = this.sid;
    data['pending'] = this.pending;
    data['timestamp'] = this.timestamp;
    data['sessid'] = this.sessid;

    return data;
  }
}
