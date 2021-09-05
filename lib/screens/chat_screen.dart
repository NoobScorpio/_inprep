import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/screens/review_screen.dart';
import 'package:InPrep/utils/loader.dart';
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
  // bool isConnected = true;
  // void isConnectedCheck() async {
  //   bool result = await DataConnectionChecker().hasConnection;
  //   if (result == true) {
  //     setState(() {
  //       isConnected = true;
  //     });
  //   } else {
  //     setState(() {
  //       isConnected = false;
  //     });
  //   }
  // }
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloading');
    send.send([id, status, progress]);
  }

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
    FlutterDownloader.registerCallback(downloadCallback);
    // registerNotification();
    // configLocalNotification();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // if (widget.type == 3)
    IsolateNameServer.removePortNameMapping('downloading');
  }

  void showSnack(text) {
    chatKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }

  // void confirmMessageVisibility() async {
  //   List<Meeting> meets = await getMeets();
  //   if (meets.length == 1 && meets[0].completed == false) {
  //     String date = meets[0].date;
  //     String time = meets[0].time;
  //     List dateSplit = date.split('-');
  //     List timeSplit = time.split(':');
  //     var nowDate = DateTime.now();
  //     var nowTime = toDouble(time: TimeOfDay.now());
  //     var timeAppoint = toDouble(
  //         time: TimeOfDay(
  //             hour: int.parse(timeSplit[0]),
  //             minute: int.parse(timeSplit[1].split(' ')[0])));
  //     nowDate.year >= int.parse(dateSplit[0])
  //         ? nowDate.month >= int.parse(dateSplit[1])
  //             // true
  //             ? nowDate.day >= int.parse(dateSplit[2])
  //                 // true
  //                 ? nowTime >= timeAppoint
  //                     // true
  //                     ? setState(() {
  //                         confirmMessageVisible = true;
  //                       })
  //                     // true
  //                     : //print('NO MEETING')
  //                 : //print('NO MEETING')
  //             : //print('NO MEETING')
  //         : //print('NO MEETING');
  //   } else if (meets.length > 1 && meets[0].completed == false) {
  //     String date = meets[0].date;
  //     String time = meets[0].time;
  //     List dateSplit = date.split('-');
  //     List timeSplit = time.split(':');
  //     var nowDate = DateTime.now();
  //     var nowTime = toDouble(time: TimeOfDay.now());
  //     var timeAppoint = toDouble(
  //         time: TimeOfDay(
  //             hour: int.parse(timeSplit[0]),
  //             minute: int.parse(timeSplit[1].split(' ')[0])));
  //     nowDate.year >= int.parse(dateSplit[0])
  //         ? nowDate.month >= int.parse(dateSplit[1])
  //             // true
  //             ? nowDate.day >= int.parse(dateSplit[2])
  //                 // true
  //                 ? nowTime >= timeAppoint
  //                     // true
  //                     ? setState(() {
  //                         confirmMessageVisible = true;
  //                       })
  //                     // true
  //                     : //print('NO MEETING')
  //                 : //print('NO MEETING')
  //             : //print('NO MEETING')
  //         : //print('NO MEETING');
  //   }
  // }

  Future<List<Meeting>> getMeets() async {
    try {
      // //print('INSIDE MEETS');
      DocumentSnapshot chat =
          await _databaseService.chatsCollection.doc(cid).get();
      // //print('GOT CID');
      if (chat.data()['acceptedOfferID'] != '') {
        // //print('inside chat');
        DocumentSnapshot msg = await _databaseService.chatsCollection
            .doc(cid)
            .collection('messages')
            .doc(chat.data()['acceptedOfferID'])
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
      if (meets.length > 0) {
        Meeting meet = meets[0];
        // //print('Got the meets');
        String date = meet.date;
        String time = meet.time;

        // //print('$date && $time');

        List dateSplit = date.split('-');
        List timeSplit = time.split(':');
        List timeExtSplit = timeSplit[1].split(' ');
        List origtimeSplit = [timeSplit[0], timeExtSplit[0], timeExtSplit[1]];

        // //print('TIME SPLITTED');
        // //print(dateSplit);
        // //print("${dateSplit[0]} and ${dateSplit[1]} and ${dateSplit[2]}");
        // //print('ORIG $origtimeSplit');
        // //print("${timeSplit[0]} and ${timeSplit[1]} and ${timeSplit[2]}");
        var nowDate = DateTime.now();
        var nowTime = toDouble(time: TimeOfDay.now());
        int hour = int.parse(timeSplit[0]);
        int min = int.parse(origtimeSplit[0]);
        //print(origtimeSplit[1]);

        // //print('ABOVE AM PM');
        if (timeExtSplit[1] == 'AM') {
          hour = hour - 12;
        } else if (timeExtSplit[1] == 'PM' && hour != 12) {
          hour += 12;
        }
        //print("HOUR $hour");
        var timeAppoint = toDouble(time: TimeOfDay(hour: hour, minute: min));
        //print('IS TIME BIGGER $nowTime $timeAppoint ${nowTime > timeAppoint}');
        //print('$nowDate  ,  $nowTime');

        if (nowDate.year >= int.parse(dateSplit[0])) {
          //print('INSIDR YEAR IF');
          if (nowDate.month >= int.parse(dateSplit[1])) {
            //print('INSIDR MONTH IF');
            if (nowDate.day >= int.parse(dateSplit[2])) {
              //print('INSIDR DAY IF');
              if (nowTime >= timeAppoint) {
                //print('INSIDR TIME IF');
                setState(() {
                  //print('SETTING STATE');
                  meetTime = true;
                  //print('STATE SETTED');
                });
              }
            }
          }
        }
        // //print('DONE');
        // nowDate.year >= int.parse(dateSplit[0])

        //     ? nowDate.month >= int.parse(dateSplit[1])
        //         // true
        //         ? nowDate.day >= int.parse(dateSplit[2])
        //             // true
        //             ? nowTime >= timeAppoint
        //                 // true
        //                 ? setState(() {
        //                     meetTime = true;
        //                   })
        //                 // true
        //                 : //print('NO MEETING')
        //             : //print('NO MEETING')
        //         : //print('NO MEETING')
        //     : //print('NO MEETING');
      }
    } catch (e) {
      // showSnack('CHECK MEET ERROR');
    }
  }

  getRid() async {
    await _databaseService.chatsCollection.doc(cid).get().then((value) {
      rid = value.data()['rid'];
      if (rid == user.uid) {
        rid = value.data()['sid'];
      }
    });
    var u = await _databaseService.userCollection.doc(rid).get();

    nameRec = u.data()['displayName'];
    // //print('GETTING NAME $nameRec');
  }

  String msgTime() {
    String time = TimeOfDay.now().format(context);
    return time;
  }

  String msgDate() {
    var date = DateTime.now().toString();

    return date;
  }

  // GlobalKey _detail = GlobalKey();
  // GlobalKey _calls = GlobalKey();
  // GlobalKey _date = GlobalKey();

  SharedPreferences preferences;
  bool dark;
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      dark = preferences.getBool('dark');
    });
    // //print("GET BOOLEAN IN SESSIONS ${preferences.getBool('dark')}");
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setReplySeen();
    });

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

                        msgWidget = OfferCard(
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
                          appointTime: message.offer.meets[0].time,
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
                      // MessageBubble(
                      //   dark: dark,
                      //   sender: message.sender ?? "InPrep",
                      //   text: "Message Deleted",
                      //   isMe: user.uid == message.sid,
                      //   time: message.time,
                      // );
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
                        icon: Icon(Icons.call),
                        label: Text('')),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Write Message',
                          ),
                          onChanged: (val) {
                            if (val != '' && val != null && val.length <= 1) {
                              messageController.text =
                                  messageController.text.toUpperCase();
                              messageController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: messageController.text.length));
                            }
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  builder: (context) {
                                    return StatefulBuilder(builder: (BuildContext
                                            context,
                                        StateSetter
                                            setState /*You can rename this!*/) {
                                      return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await uploadImage(
                                                            false);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            child: Icon(
                                                              Icons.image,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 25,
                                                            ),
                                                            radius: 25,
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Image",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                              child: Icon(
                                                                Icons
                                                                    .attach_file_outlined,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 25,
                                                              ),
                                                              radius: 25,
                                                              backgroundColor:
                                                                  Colors.white),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "File",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                              child: Icon(
                                                                Icons
                                                                    .camera_alt_outlined,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 25,
                                                              ),
                                                              radius: 25,
                                                              backgroundColor:
                                                                  Colors.white),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Camera",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
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
                            },
                            child: Icon(
                              Icons.attach_file,
                              color: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
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
    // //print('REVIEW RETURN');
    setState(() {
      meetTime = false;
      // confirm=false;
      // //print('MEET TIME FALSE');
    });

    //print('YES DONE');
  }

  void noReply() async {
    Navigator.pop(context);
  }

  Future<void> uploadFile() async {
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
  }

  Future<void> uploadImage(camera) async {
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
  }

  Future<String> pickImage(camera) async {
    try {
      File selected;
      if (!camera) {
        List<Media> media = await ImagesPicker.pick(
          count: 1,
          pickType: PickType.image,
          cropOpt: CropOption(
            aspectRatio: CropAspectRatio.custom,
            cropType: CropType.rect, // currently for android
          ),
        );
        selected = File(media[0].path);
      } else {
        List<Media> media = await ImagesPicker.openCamera(
          pickType: PickType.image,
          cropOpt: CropOption(
            aspectRatio: CropAspectRatio.custom,
            cropType: CropType.rect, // currently for android
          ),
        );
        selected = File(media[0].path);
      }

      // _storage.bucket = 'gs://inprep-c8711.appspot.com';
      FirebaseStorage _storage;

      UploadTask _uploadTask;
      _storage =
          FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // setState(() {
      _uploadTask =
          _storage.ref().child('images').child(fileName).putFile(selected);
      if (_uploadTask == null)
        return "";
      else {
        final snap = await _uploadTask.whenComplete(() => {});
        return await snap.ref.getDownloadURL();
      }
    } catch (e) {
      print("UPLOAD ERROR $e");
      return "";
    }
  }

  Future<String> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );
      if (result == null) {
        return "";
      } else {
        File selected = File(result.files.single.path);
        // _storage.bucket = 'gs://inprep-c8711.appspot.com';
        FirebaseStorage _storage;

        UploadTask _uploadTask;
        _storage = FirebaseStorage.instanceFor(
            bucket: 'gs://inprep-c8711.appspot.com');
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
            ".${selected.path.split('.').last}";
        // setState(() {
        _uploadTask =
            _storage.ref().child('files').child(fileName).putFile(selected);
        if (_uploadTask == null)
          return "";
        else {
          final snap = await _uploadTask.whenComplete(() => {});
          return await snap.ref.getDownloadURL() + "\$" + fileName;
        }
      }
    } catch (e) {
      print("UPLOAD ERROR $e");
      return "";
    }
  }

  _launchURL(userID) async {
    var link = await _databaseService.getSkype(
        uid: widget.chat.rid == userID ? widget.chat.sid : widget.chat.rid);
    try {
      if (await canLaunch('skype:$link')) {
        await launch('skype:$link');
      } else {
        if (Platform.isIOS)
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Couldnot call"),
                    ),
                    content: Container(
                        height: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text("This can be due to following reasons"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("You donot have skype installed."),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Skpye id is inavalid"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "You have skpye installed but not setup your id."),
                            ),
                          ],
                        )),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('ok'),
                      )
                    ],
                  ));
        else
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
                              child: Text(
                                  "This can be due to following reasons",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("You donot have skype installed."),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Skpye id is inavalid"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "You have skpye installed but not setup your id."),
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
      // showSnack('Wrong skype id provided');
    }
  }

  void callButton() async {
    bool confirm = await _databaseService.getAppointment(cid: cid);
    if (!confirm && !meetTime)
      showToast(context, "Please set a meeting");
    else {
      _launchURL(user.uid);
    }
  }

  toDouble({TimeOfDay time}) {
    return time.hour + time.minute / 60.0;
  }
}
