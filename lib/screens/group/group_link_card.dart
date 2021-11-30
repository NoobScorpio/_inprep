

import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/groupMessage.dart';
import 'package:InPrep/models/group_link.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/group/create_group_link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant/instant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart';
import '../../utils/loader_notifications.dart';

class GroupLinkCard extends StatelessWidget {
  final MyUser currUser;
  final GroupLink link;
  final GroupMessage groupMessage;
  final Group group;
  final bool isMe, dark;
  GroupLinkCard(
      {this.currUser,
      this.link,
      this.dark,
      this.isMe,
      this.group,
      this.groupMessage})
      : super();
  final _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            currUser.displayName,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black54,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              // side: BorderSide(color: Colors.red)
            ),
            elevation: 6,
            child: Container(
              // height: 125,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: dark ? Colors.grey[600] : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12, top: 12, bottom: 1),
                                child: Text(
                                  'Meeting Links',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (isMe && !link.completed)
                                PopupMenuButton(
                                    // color: Colors.black,
                                    child: Icon(
                                      Icons.more_vert,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 2) {
                                        groupMessage.link.cancel = true;

                                        await _databaseService.groupsCollection
                                            .doc(group.gid)
                                            .collection('messages')
                                            .doc(groupMessage.gmid)
                                            .update(groupMessage.toJson());
                                      }
                                      if (value == 1) {
                                        push(
                                            context,
                                            CreateGroupLinkScreen(
                                              group: group,
                                              creator: currUser,
                                              groupLink: link,
                                              edit: true,
                                            ));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          if (!link.completed)
                                            PopupMenuItem(
                                                value: 1,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(2, 2, 8, 2),
                                                      child: Icon(
                                                        Icons.edit,
                                                      ),
                                                    ),
                                                    Text('Edit Offer')
                                                  ],
                                                )),
                                          if (!link.completed)
                                            PopupMenuItem(
                                                value: 2,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(2, 2, 8, 2),
                                                      child: Icon(
                                                        Icons.cancel,
                                                      ),
                                                    ),
                                                    Text('Cancel Offer')
                                                  ],
                                                )),
                                        ]),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Divider(
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: dark
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${link.date}',
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: dark
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${getTime(groupMessage, currUser)}',
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (checkMeet()) {
                                      if (link.skype == "") {
                                        showToast(context,
                                            "Skype meeting link not added");
                                      } else {
                                        print(link.skype);
                                        if (await canLaunch(link.skype)) {
                                          showToast(context, 'Launching Skype');
                                          try {
                                            await launch(link.skype,
                                                forceSafariVC: false);
                                          } catch (e) {
                                            print(e);
                                          }
                                        } else {
                                          showToast(
                                              context, 'Cannot launch Skype');
                                        }
                                      }
                                    } else {
                                      showToast(context,
                                          'This is not the meeting time');
                                    }
                                  },
                                  child: Chip(
                                    elevation: 4,
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Skype",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.lightBlueAccent,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (checkMeet()) {
                                      if (link.zoom == "") {
                                        showToast(context,
                                            "Zoom meeting link not added");
                                      } else {
                                        showToast(context, 'Launching Zoom');
                                        if (await canLaunch(link.zoom)) {
                                          launch(link.zoom);
                                        }
                                      }
                                    } else {
                                      showToast(context,
                                          'This is not the meeting time');
                                    }
                                  },
                                  child: Chip(
                                    elevation: 4,
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Zoom",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.lightBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  toDouble({TimeOfDay time}) {
    return time.hour + time.minute / 60.0;
  }

  bool checkMeet() {
    return DateTime.now().toUtc().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
            (link.meetTimestamp ?? Timestamp.now()).millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }

  String getTime(GroupMessage message, MyUser user) {
    DateTime dateTimeObj;
    if (message.link.meetTimestamp != null)
      dateTimeObj = dateTimeToOffset(
          offset: user.uid == message.sender.uid
              ? 0
              : (message.link.meetTimestamp.toDate().timeZoneOffset ==
                      DateTime.now().timeZoneOffset
                  ? 0
                  : DateTime.now().timeZoneOffset.inHours.toDouble()),
          datetime: message.link.meetTimestamp.toDate());
    else
      dateTimeObj = DateTime.now();

    String timeObj = dateTimeObj.toString().split(" ")[1];
    String time = "";
    int hour = int.parse(timeObj.split(":")[0]);
    int minute = int.parse(timeObj.split(":")[1].split(".")[0]);
    if (hour >= 12) {
      if (hour == 12) {
        time = hour.toString() + ":" + minute.toString() + " PM";
      }
      if (hour > 12) {
        time = (hour - 12).toString() + ":" + minute.toString() + " PM";
      }
    } else {
      time = hour.toString() + ":" + minute.toString() + " AM";
    }
    return time;
  }
}
