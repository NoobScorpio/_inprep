import 'package:InPrep/models/group_link.dart';
import 'package:InPrep/models/group_offer.dart';
import 'package:InPrep/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GroupMessage {
  String gmid;
  String message;
  MyUser sender;
  List<MyUser> receivers;
  String time;
  int type; //0 text 1 pic 2 offer 3 doc
  Timestamp timestamp;
  String url;
  GroupOffer offer;
  GroupLink link;
  GroupMessage(
      {this.gmid,
      this.link,
      this.message,
      this.sender,
      this.receivers,
      this.time,
      this.type, //0 msg 1 image 2 offer 3 link 4 left 5 doc
      this.timestamp,
      this.url,
      this.offer});

  GroupMessage.fromJson(Map<String, dynamic> json) {
    gmid = json['gmid'];
    message = json['message'];

    if (json['receivers'] != null) {
      receivers = new List<MyUser>();
      json['receivers'].forEach((v) {
        receivers.add(new MyUser.fromJson(v));
      });
    }
    time = json['time'];
    type = json['type'];
    timestamp = json['timestamp'];
    url = json['url'];
    sender =
        json['sender'] != null ? new MyUser.fromJson(json['sender']) : null;
    offer =
        json['offer'] != null ? new GroupOffer.fromJson(json['offer']) : null;
    link = json['link'] != null ? new GroupLink.fromJson(json['link']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gmid'] = this.gmid;
    data['message'] = this.message;
    data['time'] = this.time;
    data['type'] = this.type;
    data['timestamp'] = this.timestamp;
    data['url'] = this.url;
    if (this.offer != null) {
      data['offer'] = this.offer.toJson();
    }
    if (this.link != null) {
      data['link'] = this.link.toJson();
    }
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }

    if (this.receivers != null) {
      data['receivers'] = this.receivers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
