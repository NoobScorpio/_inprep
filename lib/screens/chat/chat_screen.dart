import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/screens/screens/review_screen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/message.dart';
import 'package:InPrep/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:InPrep/utils/image_message.dart';
import 'package:InPrep/utils/image_upload.dart';
import 'package:InPrep/utils/message_bubble.dart';
import 'package:InPrep/utils/offer_card.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:images_picker/images_picker.dart';
import 'package:instant/instant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'date_time.dart';

class ChatScreen extends StatefulWidget {
  static final String id = 'chat_screen';
  final MyUser user;
  final cid, name, sid;
  final Chat chat;
  ChatScreen({this.cid, this.user, this.name, this.sid, this.chat});
  @override
  _ChatScreenState createState() =>
      _ChatScreenState(cid: cid, user: user, name: name);
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final GlobalKey<ScaffoldState> chatKey = new GlobalKey<ScaffoldState>();
  final ScrollController listScrollController = ScrollController();
  bool meetTime = false;
  final MyUser user;
  final cid, name;
  String rid = '';
  List<Message> messages = [];
  final messageController = TextEditingController();
  _ChatScreenState({this.user, this.cid, this.name});
  DatabaseService _databaseService = DatabaseService();
  final _firestore = FirebaseFirestore.instance;
  DateTime pickedDate;
  TimeOfDay pickedTime;
  String nameRec = '';
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    super.initState();
    // isConnectedCheck();
    getRid();
    getPref();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => checkMeet());

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloading');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(Statics.downloadCallback);
  }

  @override
  void dispose() {
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloading');
  }

  Future<List<Meeting>> getMeets() async {
    try {
      // //print('INSIDE MEETS');
      DocumentSnapshot c =
          await _databaseService.chatsCollection.doc(cid).get();
      Chat chat = Chat.fromJson(c.data());
      if (chat.acceptedOfferID != '') {
        // //print('inside chat');
        DocumentSnapshot msg = await _databaseService.chatsCollection
            .doc(cid)
            .collection('messages')
            .doc(chat.acceptedOfferID)
            .get();
        // //print('GOT MESSAGE');
        Message message = Message.fromJson(msg.data());
        // //print('GOT  MSG OBJ');
        return message.offer.meets;
      }
      // //print('DIDNOT GOT  MSG OBJ');
      return [];
    } catch (e) {
      //print(e);
      // showSnack('getMeets ERROR');
      return [];
    }
  }

  checkMeet() async {
    try {
      List<Meeting> meets = await getMeets();
      if (meets.length > 0)
        return DateTime.now().toUtc().isAfter(
              DateTime.fromMillisecondsSinceEpoch(
                (meets[0].dateTime ?? Timestamp.now()).millisecondsSinceEpoch,
                isUtc: false,
              ).toUtc(),
            );
      else
        return DateTime.now().toUtc().isAfter(
              DateTime.fromMillisecondsSinceEpoch(
                (Timestamp.now()).millisecondsSinceEpoch,
                isUtc: false,
              ).toUtc(),
            );
    } catch (e) {
      print("CHECKMEET $e");
    }
  }

  getRid() async {
    await _databaseService.chatsCollection.doc(cid).get().then((value) {
      Chat c = Chat.fromJson(value.data());
      rid = c.rid;
      if (rid == user.uid) {
        rid = c.sid;
      }
    });
    var u = await _databaseService.userCollection.doc(rid).get();
    var uu = MyUser.fromJson(u.data());
    nameRec = uu.displayName;
  }

  String msgTime() {
    String time = TimeOfDay.now().format(context);
    return time;
  }

  String msgDate() {
    var date = DateTime.now().toString();

    return date;
  }

  SharedPreferences preferences;

  getPref() async {
    preferences = await SharedPreferences.getInstance();
  }

  void setReplySeen() async {
    DocumentSnapshot chatDoc =
        await _databaseService.chatsCollection.doc(widget.cid).get();
    Chat chat = Chat.fromJson(chatDoc.data());
    if (chat.users[0] == user.uid) {
      await _databaseService.chatsCollection
          .doc(chat.cid)
          .update({'sRead': true});
    } else if (chat.users[1] == user.uid) {
      await _databaseService.chatsCollection
          .doc(chat.cid)
          .update({'rRead': true});
    }
    // //print("@USER ID ${widget.u}");
    await _databaseService.userCollection
        .doc(widget.user.uid)
        .update({'read': true});
  }

  String getTime(message) {
    DateTime dateTimeObj;
    if (message.offer.meets[0].dateTime != null)
      dateTimeObj = dateTimeToOffset(
          offset: user.uid == message.sid
              ? 0
              : (message.offer.meets[0].dateTime.toDate().timeZoneOffset ==
                      DateTime.now().timeZoneOffset
                  ? 0
                  : DateTime.now().timeZoneOffset.inHours.toDouble()),
          datetime: message.offer.meets[0].dateTime.toDate());
    else
      dateTimeObj = DateTime.now();
    // print("OBJ VALUE $dateTimeObj");
    String timeObj = dateTimeObj.toString().split(" ")[1];
    // print(
    //     "Time OBJ VALUE $timeObj ${timeObj.split(":")[1]}");
    String time = "";
    int hour = int.parse(timeObj.split(":")[0]);
    // print("HOUR $hour");
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setReplySeen();
    });
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      key: chatKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          if (!user.seeker)
            FlatButton.icon(
                onPressed: () async {
                  if (widget.chat.confirm)
                    showToast(context, "Your offer has already been accepted");
                  else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyDateTime(
                                  dark: dark,
                                  cid: cid,
                                  sid: user.uid,
                                  rid: rid,
                                  displayName: user.displayName,
                                  name: name,
                                )));
                },
                icon: Icon(
                  Icons.date_range,
                  color: Colors.white,
                ),
                label: Text('')),
        ],
        title: Text(
          name ?? '',
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            MessagesStream(),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(cid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // if (!isConnected) {
                //   return GestureDetector(
                //     onTap: () {
                //       showSnack('Refreshing');
                //       // isConnectedCheck();
                //       setState(() {});
                //     },
                //     child: Container(
                //       height: MediaQuery.of(context).size.height,
                //       width: MediaQuery.of(context).size.width,
                //       child: Center(
                //           child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Icon(Icons.wifi_off_outlined),
                //           ),
                //           Text(
                //               'You are not connected to internet. Tap icon to refresh.'),
                //         ],
                //       )),
                //     ),
                //   );
                // }
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messages = snapshot.data.docs;
                  List<Widget> msgWidgets = [];
                  for (DocumentSnapshot msg in messages) {
                    Message message = Message.fromJson(msg.data());
                    bool deleted = false;
                    //print("IDS ${widget.user.uid}   ${message.sid}");
                    if (widget.user.uid == widget.chat.sid) {
                      //print("INSIDE SENDWER ${message.sDeleted}");
                      deleted = message.sDeleted ?? false;
                    } else
                      deleted = message.rDeleted ?? false;
                    var msgWidget;
                    //print("@CHAT $deleted");
                    if (!deleted) {
                      if (message.type == 0) {
                        msgWidget = MessageBubble(
                          dark: dark,
                          type: message.type ?? 0,
                          sender: message.sender ?? "InPrep",
                          text: message.message ?? "",
                          isMe: user.uid == message.sid,
                          time: message.time,
                        );
                      } else if (message.type == 1) {
                        msgWidget = ImageMessage(
                          dark: dark ?? false,
                          sender: message.sender,
                          isMe: user.uid == message.sid,
                          time: message.time,
                          url: message.imgURL,
                        );
                      } else if (message.type == 2) {
                        List<Widget> textsList = [];
                        textsList.add(Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: (Text('Following are meeting details')),
                        ));
                        for (Meeting meet in message.offer.meets) {
                          textsList.add(Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_right_sharp),
                                Container(
                                    child: Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    Text(
                                      "${meet.date}",
                                      // style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(Icons.timer),
                                    Text(
                                      "${meet.time} ${meet.timezone ?? ""}",
                                      // style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ));
                          // //print("At ${meet.date} and ${meet.time}");
                        }
                        // print(
                        //     "TIME FROM MEET ${message.offer.meets[0].dateTime.toDate()}");

                        String time = getTime(message);

                        msgWidget = OfferCard(
                          currUser: user.uid,
                          skype: user.uid,
                          meetTime: meetTime,
                          offer: message.offer,
                          meetsObjects: message.offer.meets,
                          meets: textsList,
                          dark: dark,
                          offerCancelled: message.offer.cancel,
                          nameRec: nameRec,
                          cost: message.offer.cost,
                          meid: message.meid,
                          accepted: message.offer.accepted,
                          cid: cid,
                          sid: user.uid,
                          rid: rid,
                          displayName: user.displayName,
                          name: name,
                          seeker: user.seeker,
                          declined: message.offer.declined,
                          sender: message.sender,
                          isMe: user.uid == message.sid,
                          time: message.time,
                          appointDate: message.offer.meets[0].date,
                          appointTime: time.toString(),
                        );
                      } else {
                        msgWidget = MessageBubble(
                          dark: dark,
                          type: message.type ?? 0,
                          sender: message.sender ?? "InPrep",
                          text: message.message,
                          isMe: user.uid == message.sid,
                          time: message.time,
                          url: message.imgURL,
                        );
                      }
                    } else {
                      msgWidget = Container();
                    }
                    msgWidgets.add(msgWidget);
                  }
                  return Expanded(
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.09,
                          child: Image.asset(
                            "assets/images/bg.jpg",
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                        ListView(
                          reverse: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          children: msgWidgets,
                          controller: listScrollController,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.green)),
                  );
                }
              },
            ),

            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FlatButton.icon(
                        onPressed: () {
                          callButton();
                        },
                        icon: Icon(
                          Icons.call,
                          color: dark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        label: Text('')),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Write Message',
                          ),
                          onChanged: (val) {},
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              callBottomSheet();
                            },
                            child: Icon(
                              Icons.attach_file,
                              color: dark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            )),
                        FlatButton(
                          onPressed: () async {
                            var msg = messageController.text.toString();

                            setState(() {
                              messageController.text = '';
                            });
                            if (msg != '') {
                              listScrollController.animateTo(0.0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);

                              await _databaseService.sendMessage(
                                  cid: cid,
                                  sender: user.displayName,
                                  receiver: name,
                                  time: msgTime(),
                                  rid: rid,
                                  type: 0,
                                  sid: user.uid,
                                  msg: msg);
                              var doc = await _databaseService.userCollection
                                  .doc(rid)
                                  .get();
                              int badge = MyUser.fromJson(doc.data()).badge;
                              await _databaseService.userCollection
                                  .doc(rid)
                                  .update({"badge": badge + 1});
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: dark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (meetTime)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                        child: Text(
                      'You meeting time is active.',
                      style: TextStyle(color: Colors.white),
                    )),
                  )
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Visibility(
        visible: meetTime && user.seeker,
        child: Padding(
          padding: const EdgeInsets.only(top: 75.0),
          child: FloatingActionButton(
            onPressed: () {
              if (Platform.isIOS) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Meeting"),
                          ),
                          content: Text("Have you completed the meeting?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              onPressed: () async {
                                yesReply();
                              },
                              child: Text('Yes'),
                            ),
                            CupertinoDialogAction(
                              onPressed: () async {
                                noReply();
                              },
                              child: Text("No"),
                            )
                          ],
                        ));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("Meeting"),
                          content: Text("Have you completed the meeting?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              onPressed: () async {
                                noReply();
                              },
                            ),
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                yesReply();
                              },
                            ),
                          ],
                        ));
              }
            },
            child: Icon(Icons.info_outline),
          ),
        ),
      ),
    );
  }

  void yesReply() async {
    // //print('INSIDE YES');
    DocumentSnapshot rName = await _databaseService.userCollection
        .doc(widget.chat.sid == user.uid ? widget.chat.rid : widget.chat.sid)
        .get();
    MyUser rUser = MyUser.fromJson(rName.data());
    //print('GOT ${rUser.displayName}');
    Navigator.pop(context);
    // //print('POPPED');
    List<Meeting> meets = await getMeets();
    // //print('GOT MEETS');
    for (Meeting meet in meets) {
      await _databaseService.meetCollection
          .doc(meet.mid)
          .update({'completed': true});
    }
    //print('MEETS COMPLETED ALL');
    await _databaseService.chatsCollection.doc(cid).update({
      'acceptedOfferID': '',
      'confirm': false,
      "timestamp": Timestamp.now()
    });
    // //print('OFFER ID NULLED');
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReviewScreen(
                  giver: user.uid,
                  receiver: rid,
                  gName: user.displayName,
                  rName: rUser.displayName,
                )));
    setState(() {
      meetTime = false;
    });

    //print('YES DONE');
  }

  void noReply() async {
    Navigator.pop(context);
  }

  Future<void> uploadFile() async {
    PermissionStatus permission = await Permission.storage.request();
    if (permission.isGranted) {
      showLoader(context);
      String upload = await pickFile();

      print("RETURN URLL $upload");
      if (!(upload == null || upload == '')) {
        await _databaseService.sendMessage(
          cid: cid,
          sender: user.displayName,
          receiver: name,
          time: msgTime(),
          rid: rid,
          type: 3,
          sid: user.uid,
          msg: upload.split("\$")[1],
          image: upload.split("\$")[0],
        );
        var doc = await _databaseService.userCollection.doc(rid).get();
        int badge = MyUser.fromJson(doc.data()).badge;
        await _databaseService.userCollection
            .doc(rid)
            .update({"badge": badge + 1});
        await _databaseService.chatsCollection
            .doc(cid)
            .update({"timestamp": Timestamp.now()});
      } else {
        print('ERROR');
      }
      Navigator.pop(context);
    } else
      showToast(context, "Permission not granted");
  }

  Future<void> uploadImage(camera) async {
    PermissionStatus permission = await Permission.storage.request();
    if (permission.isGranted) {
      showLoader(context);
      String upload = await pickImage(camera);

      print("RETURN URLL $upload");
      if (!(upload == null || upload == '')) {
        await _databaseService.sendMessage(
          cid: cid,
          sender: user.displayName,
          receiver: name,
          time: msgTime(),
          rid: rid,
          type: 1,
          sid: user.uid,
          msg: 'Image',
          image: upload,
        );
        var doc = await _databaseService.userCollection.doc(rid).get();
        int badge = MyUser.fromJson(doc.data()).badge;
        await _databaseService.userCollection
            .doc(rid)
            .update({"badge": badge + 1});
        await _databaseService.chatsCollection
            .doc(cid)
            .update({"timestamp": Timestamp.now()});
      } else {
        print('ERROR');
      }
      Navigator.pop(context);
    } else
      showToast(context, 'Permission not granted');
  }

  _launchURL(userID) async {
    var link = await _databaseService.getSkype(
        uid: widget.chat.rid == userID ? widget.chat.sid : widget.chat.rid);
    try {
      if (await canLaunch('skype:$link')) {
        await launch('skype:$link');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Could not call"),
                  ),
                  content: Container(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("This can be due to following reasons",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("You do not have skype installed."),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("skype id is invalid"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "You have skype installed but not setup your id."),
                          ),
                        ],
                      )),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text('ok'),
                    )
                  ],
                ));
      }
    } catch (e) {
      print('LAUNCH_URL $e');
    }
  }

  void callBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await uploadImage(false);
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.image,
                                    color: Theme.of(context).primaryColor,
                                    size: 25,
                                  ),
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Image",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () async {
                              await uploadFile();
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    child: Icon(
                                      Icons.attach_file_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 25,
                                    ),
                                    radius: 25,
                                    backgroundColor: Colors.white),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "File",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () async {
                              await uploadImage(true);
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: 25,
                                    ),
                                    radius: 25,
                                    backgroundColor: Colors.white),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            );
          });
        });
  }

  void callButton() async {
    bool confirm = await _databaseService.getAppointment(cid: cid);
    if (!confirm)
      showToast(context, 'No meeting scheduled');
    else if (!meetTime)
      showToast(context, 'Meeting time not reached');
    else {
      _launchURL(user.uid);
    }
  }

  toDouble({TimeOfDay time}) {
    return time.hour + time.minute / 60.0;
  }
}
