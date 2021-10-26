import 'package:InPrep/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String gid;
  String title;
  String desc;
  String photo;
  MyUser creator;
  String lastMessage;
  Timestamp timestamp;
  List<MyUser> users;
  List<String> userIDS;
  Map<String, bool> usersRead = {};
  bool confirmed;
  bool offerSent;
  Group(
      {this.gid,
      this.offerSent,
      this.confirmed,
      this.lastMessage,
      this.usersRead,
      this.creator,
      this.title,
      this.desc,
      this.photo,
      this.timestamp,
      this.userIDS,
      this.users});

  Group.fromJson(Map<String, dynamic> json) {
    gid = json['gid'];
    confirmed = json['confirmed'];
    offerSent = json['offerSent'];
    lastMessage = json['lastMessage'];
    creator =
        json['creator'] != null ? new MyUser.fromJson(json['creator']) : null;

    title = json['title'];
    desc = json['desc'];
    photo = json['photo'];
    timestamp = json['Timestamp'];
    userIDS = json['userIDS'].cast<String>();

    if (json['usersRead'] != null) {
      Map<String, dynamic> map = json['usersRead'];
      for (var usr in map.keys) {
        usersRead[usr] = map[usr];
      }
    }
    if (json['users'] != null) {
      users = new List<MyUser>();
      json['users'].forEach((v) {
        users.add(new MyUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gid'] = this.gid;
    data['confirmed'] = this.confirmed;
    data['offerSent'] = this.offerSent;
    data['lastMessage'] = this.lastMessage;

    data['usersRead'] = this.usersRead ?? {};
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    data['userIDS'] = this.userIDS;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['photo'] = this.photo;
    data['Timestamp'] = this.timestamp;

    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
