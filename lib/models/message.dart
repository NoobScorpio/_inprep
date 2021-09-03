import 'package:cloud_firestore/cloud_firestore.dart';

import 'offer.dart';

class Message {
  String meid;
  String message;
  String sender;
  String receiver;
  bool sDeleted, rDeleted;
  String time;
  String sid;
  String rid;
  int type; //0 text 1 pic 2 offer
  Timestamp timestamp;
  String imgURL;
  Offer offer;

  Message(
      {this.meid,
      this.sDeleted,
      this.rDeleted,
      this.message,
      this.sender,
      this.receiver,
      this.time,
      this.sid,
      this.rid,
      this.type,
      this.timestamp,
      this.imgURL,
      this.offer});

  Message.fromJson(Map<String, dynamic> json) {
    sDeleted = json['sDeleted'];
    rDeleted = json['rDeleted'];
    meid = json['meid'];
    message = json['message'];
    sender = json['sender'];
    receiver = json['receiver'];
    time = json['time'];
    sid = json['sid'];
    rid = json['rid'];
    type = json['type'];
    timestamp = json['timestamp'];
    imgURL = json['imgURL'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sDeleted'] = this.sDeleted;
    data['rDeleted'] = this.rDeleted;
    data['meid'] = this.meid;
    data['message'] = this.message;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['time'] = this.time;
    data['sid'] = this.sid;
    data['rid'] = this.rid;
    data['type'] = this.type;
    data['timestamp'] = this.timestamp;
    data['imgURL'] = this.imgURL;
    if (this.offer != null) {
      data['offer'] = this.offer.toJson();
    }
    return data;
  }
}
