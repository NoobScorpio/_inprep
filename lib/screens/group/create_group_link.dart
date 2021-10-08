import 'dart:io';

import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/groupMessage.dart';
import 'package:InPrep/models/group_link.dart';
import 'package:InPrep/models/group_offer.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant/instant.dart';

class CreateGroupLinkScreen extends StatefulWidget {
  const CreateGroupLinkScreen({
    this.groupLink,
    this.edit,
    this.creator,
    this.group,
    this.zoomLink,
    this.skypeLink,
  }) : super();
  final GroupLink groupLink;
  final MyUser creator;
  final Group group;
  final bool edit;
  final String zoomLink, skypeLink;
  @override
  _CreateGroupLinkScreenState createState() => _CreateGroupLinkScreenState();
}

class _CreateGroupLinkScreenState extends State<CreateGroupLinkScreen> {
  String _date = 'Not Set';
  String _time = "Not Set";
  DateTime date = DateTime.now();
  TimeOfDay timeOBJ;
  DatabaseService _databaseService = DatabaseService();
  TextEditingController zoomCont = TextEditingController();
  TextEditingController skypeCont = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.edit != null) {
      _date = widget.groupLink.date;
      _time = widget.groupLink.time;
      zoomCont.text = widget.zoomLink ?? "";
      skypeCont.text = widget.skypeLink ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    zoomCont.dispose();
    skypeCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Meeting Link"),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () async {
                          date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2030, 1, 1));

                          setState(() {
                            _date = date.toString().split(' ')[0];
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          " $_date",
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "  Change",
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () async {
                          TimeOfDay time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          TimeOfDay nowTime = TimeOfDay.now();
                          DateTime nowDate = DateTime.now();
                          timeOBJ = time;
                          bool past = false;
                          if (nowDate.year == date.year &&
                              nowDate.month == date.month &&
                              nowDate.day == date.day) {
                            if (time.hour < nowTime.hour) {
                              past = true;
                            } else if (time.hour == nowDate.hour) {
                              if (time.minute < nowDate.minute) past = true;
                            }
                          }
                          if (!past) {
                            int hour;
                            String minute;
                            hour = time.hour;
                            minute = time.minute.toString();
                            if (int.parse(minute) < 10) {
                              minute = '0' + minute;
                            }
                            if (hour > 12) {
                              _time = '${time.hour - 12}:$minute PM';
                            } else if (hour == 12) {
                              _time = '12:$minute PM';
                            } else if (hour == 0) {
                              _time = '12:$minute AM';
                            } else {
                              _time = '${time.hour}:$minute AM';
                            }
                            setState(() {});
                          } else {
                            {
                              showToast(context, "Time cannot be past time");
                              setState(() {
                                _time = "Not Set";
                              });
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 18.0,
                                          color: Colors.black54,
                                        ),
                                        Text(
                                          " $_time",
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "  Change",
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      MyTextFormField(
                        controller: zoomCont,
                        padding: EdgeInsets.all(0),
                        // maxline: 5,
                        hint: "Copy and paste zoom meeting invite link\n \n",
                        labelText: 'Zoom Meeting Link',
                        prefixIcon: Icon(Icons.link,
                            color: dark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      MyTextFormField(
                        controller: skypeCont,
                        padding: EdgeInsets.all(0),
                        // maxline: 5,
                        hint: "Copy and paste skype meeting invite link\n \n",
                        labelText: 'Skype Meeting Link',
                        prefixIcon: Icon(Icons.link,
                            color: dark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context, null);
                                },
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Back',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  String platform =
                                      Platform.isIOS ? 'ios' : 'android';
                                  widget.edit != null
                                      ? showToast(context, 'Updating Offer')
                                      : showToast(context, 'Creating Offer');
                                  await createUpdateLink(context);
                                },
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Done',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Timestamp getMeetTimestamp() {
    List<String> dates = _date.split("-");
    DateTime currentPhoneDate = DateTime(
        int.parse(dates[0]),
        int.parse(dates[1]),
        int.parse(dates[2]),
        timeOBJ.hour,
        timeOBJ.minute); //DateTime

    return Timestamp.fromDate(currentPhoneDate);
  }

  createUpdateLink(context) async {
    showLoader(context);
    if (widget.edit == null) {
      if (zoomCont.text == "" && skypeCont.text == "") {
        showToast(context, "Enter at least 1 link");
      } else {
        await _databaseService.groupsCollection.doc(widget.group.gid).update({
          'confirmed': false,
        });

        GroupLink link = GroupLink(
            gmid: "",
            glid: '',
            cancel: false,
            zoom: zoomCont.text ?? "",
            skype: skypeCont.text ?? "",
            completed: false,
            creator: widget.creator,
            timezone: DateTime.now().timeZoneName,
            meetTimestamp: getMeetTimestamp(),
            date: _date,
            time: _time,
            timestamp: Timestamp.now());
        // var cost = price.text.toString();

        await _databaseService.sendGroupLinkMessage(
            context: context,
            sender: widget.creator,
            group: widget.group,
            groupLink: link,
            type: 3,
            msg: 'Group Link');
        for (String usr in widget.group.userIDS) {
          if (usr != widget.creator.uid) {
            var doc = await _databaseService.userCollection.doc(usr).get();
            int badge = MyUser.fromJson(doc.data()).badge;
            await _databaseService.userCollection
                .doc(usr)
                .update({"badge": badge + 1});
          }
        }
      }
    } else {
      if (zoomCont.text == "" && skypeCont.text == "") {
        showToast(context, "Enter at least 1 link");
      } else {
        try {
          var msgDOc = await _databaseService.groupsCollection
              .doc(widget.group.gid)
              .collection("messages")
              .doc(widget.groupLink.gmid)
              .get();
          GroupMessage groupMessage = GroupMessage.fromJson(msgDOc.data());
          groupMessage.link.timezone = DateTime.now().timeZoneName;
          groupMessage.link.meetTimestamp = getMeetTimestamp();
          groupMessage.link.time = _time;
          groupMessage.link.date = _date;
          groupMessage.link.timestamp = Timestamp.now();
          groupMessage.link.cancel = false;
          await _databaseService.groupsCollection
              .doc(widget.group.gid)
              .collection('messages')
              .doc(widget.groupLink.gmid)
              .update(groupMessage.toJson());
        } catch (e) {
          print("@OFFER $e");
        }
      }
    }
    pop(context);
    pop(context);
  }
}
