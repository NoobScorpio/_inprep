import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String rid;
  String uid; //CONSULTANT
  String gid; //SEEKER
  String gName;
  double stars;
  String date;
  String body;
  String title;
  Timestamp timestamp;
  Review(
      {this.rid,
      this.uid,
      this.gid,
      this.gName,
      this.stars,
      this.date,
      this.body,
      this.timestamp,
      this.title});

  Review.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    uid = json['uid'];
    gid = json['gid'];
    gName = json['gName'];
    stars = json['stars'];
    date = json['date'];
    body = json['body'];
    title = json['title'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rid'] = this.rid;
    data['uid'] = this.uid;
    data['gid'] = this.gid;
    data['gName'] = this.gName;
    data['stars'] = this.stars;
    data['date'] = this.date;
    data['body'] = this.body;
    data['title'] = this.title;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
