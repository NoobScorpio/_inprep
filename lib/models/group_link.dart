import 'package:InPrep/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupLink {
  String glid;
  String gmid;
  MyUser creator;
  String gid;
  Timestamp timestamp;
  Timestamp meetTimestamp;
  bool completed, cancel;
  String zoom;
  String skype;
  String date;
  String time;
  String timezone;

  GroupLink(
      {this.gmid,
      this.date,
      this.time,
      this.cancel,
      this.zoom,
      this.skype,
      this.glid,
      this.timestamp,
      this.meetTimestamp,
      this.creator,
      this.completed,
      this.timezone});

  GroupLink.fromJson(Map<String, dynamic> json) {
    timezone = json['timezone'];
    meetTimestamp = json['meetTimestamp'];
    zoom = json['zoom'];
    cancel = json['cancel'];
    skype = json['skype'];
    date = json['date'];
    time = json['time'];
    gmid = json['gmid'];
    glid = json['glid'];
    creator =
        json['creator'] != null ? new MyUser.fromJson(json['creator']) : null;
    timestamp = json['Timestamp'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timezone'] = this.timezone;
    data['meetTimestamp'] = this.meetTimestamp;
    data['cancel'] = this.cancel;
    data['zoom'] = this.zoom;
    data['skype'] = this.skype;
    data['date'] = this.date;
    data['time'] = this.time;
    data['completed'] = this.completed;
    data['gmid'] = this.gmid;
    data['glid'] = this.glid;
    data['Timestamp'] = this.timestamp;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    return data;
  }
}
