import 'package:InPrep/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GroupOffer {
  String gmid;
  String goid;
  double cost;
  MyUser creator;
  String gid;
  bool cancel;
  bool accepted;
  Timestamp timestamp;
  bool declined;
  bool completed;
  String timezone;
  Map<String, bool> usersAccepted = {};
  GroupOffer(
      {this.gmid,
      this.declined,
      this.usersAccepted,
      this.goid,
      this.gid,
      this.accepted,
      this.cost,
      this.cancel,
      this.timestamp,
      this.creator,
      this.completed,
      this.timezone});

  GroupOffer.fromJson(Map<String, dynamic> json) {
    timezone = json['timezone'];
    gmid = json['gmid'];
    accepted = json['accepted'];
    declined = json['declined'];
    cost = json['cost'];
    goid = json['goid'];
    creator =
        json['creator'] != null ? new MyUser.fromJson(json['creator']) : null;
    cancel = json['cancel'];
    timestamp = json['Timestamp'];
    if (json['usersAccepted'] != null) {
      Map<String, dynamic> map = json['usersAccepted'];
      for (var usr in map.keys) {
        usersAccepted[usr] = map[usr];
      }
    }
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timezone'] = this.timezone;
    data['completed'] = this.completed;
    data['usersAccepted'] = this.usersAccepted ?? {};
    data['gmid'] = this.gmid;
    data['accepted'] = this.accepted;
    data['goid'] = this.goid;
    data['cost'] = this.cost;
    data['cancel'] = this.cancel;
    data['Timestamp'] = this.timestamp;
    data['declined'] = this.declined;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    return data;
  }
}
