import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String bid;
  String uid;
  String date;
  String time;
  String desc;
  String name;
  String designation;
  String image;
  int views;
  List<String> likes;
  int comments;
  Timestamp timestamp;
  Blog(
      {this.bid,
      this.uid,
      this.image,
      this.date,
      this.time,
      this.desc,
      this.name,
      this.timestamp,
      this.designation,
      this.views,
      this.likes,
      this.comments});

  Blog.fromJson(Map<String, dynamic> json) {
    bid = json['bid'];
    image = json['image'];
    uid = json['uid'];
    date = json['date'];
    time = json['time'];
    desc = json['desc'];
    name = json['name'];
    timestamp = json['timestamp'];
    designation = json['designation'];
    views = json['views'];
    likes = json['likes'].cast<String>();
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bid'] = this.bid;
    data['image'] = this.image;
    data['uid'] = this.uid;
    data['date'] = this.date;
    data['time'] = this.time;
    data['desc'] = this.desc;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['views'] = this.views;
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    return data;
  }
}

class Comment {
  String uid, bid, image, cid;
  String name;
  String time;
  String date;
  String body;
  List<String> likes;
  List<Reply> replies;
  Timestamp timestamp;
  Comment(
      {this.uid,
      this.replies,
      this.likes,
      this.cid,
      this.name,
      this.time,
      this.date,
      this.body,
      this.bid,
      this.timestamp,
      this.image});

  Comment.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];

    bid = json['bid'];
    cid = json['cid'];
    image = json['image'];
    name = json['name'];
    time = json['time'];
    date = json['date'];
    body = json['body'];
    timestamp = json['timestamp'];
    likes = json['likes'] != null ? json['likes'].cast<String>() : [];
    if (json['replies'] != null) {
      replies = new List<Reply>();
      json['replies'].forEach((v) {
        replies.add(new Reply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['image'] = this.image;

    data['bid'] = this.bid;
    data['cid'] = this.cid;
    data['name'] = this.name;
    data['time'] = this.time;
    data['date'] = this.date;
    data['body'] = this.body;
    data['timestamp'] = this.timestamp;
    data['likes'] = this.likes;
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reply {
  String uid, cid, bid, rid, image;
  String name;
  String time;
  String date;
  String body;
  List<String> likes;
  Timestamp timestamp;
  Reply(
      {this.uid,
      this.likes,
      this.name,
      this.time,
      this.date,
      this.body,
      this.cid,
      this.rid,
      this.bid,
      this.timestamp,
      this.image});

  Reply.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    cid = json['cid'];
    bid = json['bid'];
    image = json['image'];
    name = json['name'];
    time = json['time'];
    date = json['date'];
    rid = json['rid'];
    body = json['body'];
    timestamp = json['timestamp'];
    likes = json['likes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['image'] = this.image;
    data['cid'] = this.cid;
    data['bid'] = this.bid;
    data['name'] = this.name;
    data['time'] = this.time;
    data['rid'] = this.rid;
    data['date'] = this.date;
    data['likes'] = this.likes;
    data['body'] = this.body;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
