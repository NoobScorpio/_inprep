import 'dart:io';
import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/models/offer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instant/instant.dart';

class MyDateTime extends StatefulWidget {
  final cid;
  final sid;
  final rid;
  final dark;
  final displayName;
  final name, zoomLink, skypeLink;
  final edit, date, time, cost, meets, oid, meid;
  static String id = 'MyDateTime';
  MyDateTime(
      {this.cid,
      this.dark,
      this.zoomLink,
      this.displayName,
      this.name,
      this.rid,
      this.sid,
      this.edit,
      this.date,
      this.time,
      this.cost,
      this.meets,
      this.oid,
      this.meid,
      this.skypeLink});
  @override
  _MyDateTimeState createState() => _MyDateTimeState(
      dark: dark,
      cid: cid,
      sid: sid,
      rid: rid,
      displayName: displayName,
      name: name);
}

class _MyDateTimeState extends State<MyDateTime> {
  final cid;
  final sid;
  final rid;
  final displayName;
  final dark;
  final name;
  _MyDateTimeState(
      {this.cid, this.dark, this.displayName, this.name, this.rid, this.sid});
  String _date = 'Not Set';
  String _time = "Not Set";
  List<Meeting> meets = [];
  DatabaseService _databaseService = DatabaseService();
  TextEditingController price = TextEditingController();
  TextEditingController zoomCont = TextEditingController();
  TextEditingController skypeCont = TextEditingController();
  final GlobalKey<ScaffoldState> dateTimeKey = new GlobalKey<ScaffoldState>();
  DateTime date = DateTime.now();
  @override
  void initState() {
    super.initState();
    if (widget.edit != null) {
      _date = widget.date;
      _time = widget.time;
      price.text = widget.cost.toString();
      meets = widget.meets;
      zoomCont.text = widget.zoomLink ?? "";
      skypeCont.text = widget.skypeLink ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    price.dispose();
    zoomCont.dispose();
    skypeCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = dark ? Colors.black : Theme.of(context).primaryColor;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: dateTimeKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Pick Date and Time'),
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
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        MyTextFormField(
                          controller: price,
                          padding: EdgeInsets.all(0),
                          hint: 'Enter Session Cost',
                          labelText: 'Cost',
                          prefixIcon: Icon(Icons.attach_money,
                              color: dark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor),
                          keyboardType: TextInputType.number,
                        ),
                        Container(
                          height: 50 * (meets.length).toDouble(),
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: meets.length,
                            itemBuilder: (context, index) {
                              final item = meets[index];
                              return Dismissible(
                                key: Key(item.mid),
                                direction: DismissDirection.startToEnd,
                                child: ListTile(
                                  title: Text(
                                    "Meet on ${item.date} at ${item.time}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: dark
                                            ? Colors.white
                                            : Theme.of(context).primaryColor),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: dark
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        meets.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                                onDismissed: (direction) async {
                                  setState(() {
                                    meets.removeAt(index);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: FlatButton.icon(
                                onPressed: () async {
                                  showToast(context, 'Adding Meeting');
                                  if (_date != 'Not Set' &&
                                      _time != "Not Set") {
                                    Meeting meet = Meeting(
                                        mid: '',
                                        seekId: rid,
                                        conId: sid,
                                        time: _time,
                                        date: _date,
                                        dateTime: Timestamp.now(),
                                        timezone: DateTime.now().timeZoneName,
                                        completed: false);
                                    setState(() {
                                      meets.add(meet);
                                    });
                                  } else {
                                    showToast(
                                        context, 'Please fill the fields');
                                  }
                                },
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 35,
                                  color: dark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                                label: Text('')),
                          ),
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
                                    if (meets.length != 0) {
                                      if (price.text.toString() != '') {
                                        double p =
                                            double.parse(price.text.toString());
                                        // showSnack("PRICE IS $p");
                                        if (p >= 20.0) {
                                          String platform = Platform.isIOS
                                              ? 'ios'
                                              : 'android';
                                          (widget.edit ?? false)
                                              ? showToast(
                                                  context, 'Updating Offer')
                                              : showToast(
                                                  context, 'Creating Offer');
                                          for (int i = 0;
                                              i < meets.length;
                                              i++) {
                                            meets[i].mid =
                                                await _databaseService
                                                    .createMeet(
                                                        meeting: meets[i]);
                                          }

                                          await _databaseService.chatsCollection
                                              .doc(cid)
                                              .update({
                                            'confirm': false,
                                            'appointDate': _date,
                                            'appointTime': _time,
                                            'platform': platform
                                          });
                                          if (widget.edit == null) {
                                            // //print('NOT EDIT');
                                            Offer offer = Offer(
                                                meid: '',
                                                cid: cid,
                                                link: zoomCont.text ?? "",
                                                oid: '',
                                                accepted: false,
                                                cost: double.parse(
                                                    price.text.toString()),
                                                cancel: false,
                                                declined: false,
                                                meets: meets,
                                                meetCount: meets.length,
                                                timestamp: Timestamp.now());
                                            // var cost = price.text.toString();
                                            await _databaseService.sendMessage(
                                                cid: cid,
                                                accepted: false,
                                                sender: displayName,
                                                receiver: name,
                                                time: msgTime(),
                                                date: msgDate(),
                                                appointDate: _date,
                                                appointTime: _time,
                                                sid: sid,
                                                rid: rid,
                                                offer: offer,
                                                type: 2,
                                                platform: platform,
                                                msg: 'Offer');
                                            var doc = await _databaseService
                                                .userCollection
                                                .doc(rid)
                                                .get();
                                            int badge =
                                                MyUser.fromJson(doc.data())
                                                    .badge;
                                            await _databaseService
                                                .userCollection
                                                .doc(rid)
                                                .update({"badge": badge + 1});
                                            Navigator.pop(context);
                                          } else {
                                            // //print('@OFFER EDIT');
                                            Offer offer = Offer(
                                                meid: widget.meid,
                                                cid: cid,
                                                oid: '',
                                                accepted: false,
                                                link: zoomCont.text ?? "",
                                                cost: double.parse(
                                                    price.text.toString()),
                                                cancel: false,
                                                declined: false,
                                                meets: meets,
                                                meetCount: meets.length,
                                                timestamp: Timestamp.now());
                                            // //print("@OFFER ${offer.meets[0].time}");
                                            try {
                                              await _databaseService
                                                  .chatsCollection
                                                  .doc(cid)
                                                  .collection('messages')
                                                  .doc(widget.meid)
                                                  .update({
                                                'meid': widget.meid,
                                                'timestamp': Timestamp.now(),
                                                'offer': offer.toJson()
                                              });
                                              // //print("@OFFER CHAT UPDATED");
                                              DocumentSnapshot chatDoc =
                                                  await _databaseService
                                                      .chatsCollection
                                                      .doc(cid)
                                                      .get();
                                              Chat chat =
                                                  Chat.fromJson(chatDoc.data());
                                              // //print(
                                              //     "@OFFER GOT CHAT ${chat.lastMessage}");
                                              if (chat.users[0] == sid) {
                                                // //print("@OFFER USER IS SENDER");
                                                await _databaseService
                                                    .chatsCollection
                                                    .doc(cid)
                                                    .update({
                                                  'lastMessage': 'offer',
                                                  'rRead': false,
                                                  'rDeleted': false
                                                });
                                              } else if (chat.users[1] == sid) {
                                                // //print("@OFFER USER IS RECEIVER");
                                                await _databaseService
                                                    .chatsCollection
                                                    .doc(cid)
                                                    .update({
                                                  'lastMessage': 'offer',
                                                  'sRead': false,
                                                  'sDeleted': false,
                                                  "timestamp": Timestamp.now()
                                                });
                                              }

                                              // //print("@OFFER POPPING");
                                              Navigator.pop(context);
                                            } catch (e) {
                                              //print("@OFFER $e");
                                            }
                                          }
                                        } else
                                          showToast(context,
                                              'Cost should not be less then 20\$.');
                                      } else
                                        showToast(
                                            context, 'Please enter your cost');
                                    } else
                                      showToast(
                                          context, 'Please add a meeting');
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     print("START");
        //     QuerySnapshot meets = await _databaseService.meetCollection.get();
        //     for (QueryDocumentSnapshot meet in meets.docs) {
        //       Meeting meeting = Meeting.fromJson(meet.data());
        //       print(meeting.mid);
        //       if (meeting.mid != null) {
        //         meeting.dateTime = Timestamp.fromDate(DateTime.now());
        //         await _databaseService.meetCollection
        //             .doc(meeting.mid)
        //             .update(meeting.toJson());
        //       }
        //     }
        //     print("END");
        //   },
        // ),
      ),
    );
  }

  String msgTime() {
    String time = TimeOfDay.now().format(context);
    return time;
  }

  String msgDate() {
    var date = DateTime.now().toString().split(' ')[0];

    return date;
  }
}
