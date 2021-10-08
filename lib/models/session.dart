import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  String sessid;
  List<String> meetsIds;
  int meets;
  String oid;
  String date;
  String time;
  var users;
  String seekId;
  String consId;
  String gid;
  String cid;
  String rating;
  bool completed;
  Timestamp timestamp;
  Session(
      {this.sessid,
      this.oid,
      this.meetsIds,
      this.meets,
      this.date,
      this.time,
      this.users,
      this.cid,
      this.gid,
      this.rating,
      this.timestamp,
      this.seekId,
      this.consId,
      this.completed});

  Session.fromJson(Map<String, dynamic> json) {
    sessid = json['sessid'];
    gid = json['gid'];
    date = json['date'];
    time = json['time'];
    users = json['users'];
    cid = json['cid'];
    rating = json['rating'];
    completed = json['completed'];
    timestamp = json['timestamp'];
    oid = json['oid'];
    seekId = json['seekId'];
    consId = json['consId'];
    meets = json['meets'];
    meetsIds = json['meetsIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seekId'] = this.seekId;
    data['gid'] = this.gid;
    data['consId'] = this.consId;
    data['sessid'] = this.sessid;
    data['date'] = this.date;
    data['time'] = this.time;
    data['user'] = FieldValue.arrayUnion(this.users);
    data['cid'] = this.cid;
    data['rating'] = this.rating;
    data['completed'] = this.completed;
    data['timestamp'] = this.timestamp;
    data['oid'] = this.oid;

    data['meets'] = this.meets;
    data['meetsIds'] = this.meetsIds;
    return data;
  }
}
