import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/groupMessage.dart';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/models/message.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/group/create_group_offer.dart';
import 'package:InPrep/screens/group/group_info_screen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/screens/group/group_link_card.dart';
import 'package:InPrep/screens/group/group_offer_card.dart';
import 'package:InPrep/utils/image_message.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/message_bubble.dart';
import 'package:InPrep/utils/offer_card.dart';
import 'package:InPrep/utils/statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:images_picker/images_picker.dart';
import 'package:instant/instant.dart';

import 'create_group_link.dart';

class GroupChatScreen extends StatefulWidget {
  final Group group;
  final MyUser currUser;
  const GroupChatScreen({this.group, this.currUser}) : super();

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  DatabaseService _databaseService = DatabaseService();
  final _firestore = FirebaseFirestore.instance;
  final messageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloading');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    FlutterDownloader.registerCallback(Statics.downloadCallbackGroup);
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    listScrollController.dispose();
  }

  bool dark;
  @override
  Widget build(BuildContext context) {
    dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
                // color: Colors.black,
                child: Icon(
                  Icons.more_vert,
                ),
                onSelected: (value) async {
                  if (value == 2) {
                    if ((widget.group.confirmed ?? false))
                      push(
                          context,
                          CreateGroupLinkScreen(
                            group: widget.group,
                            creator: widget.currUser,
                          ));
                    else {
                      showToast(context,
                          "You have not accepted every consultant's offer");
                    }
                  }
                  if (value == 1) {
                    if (widget.group.creator.uid == widget.currUser.uid)
                      showToast(context, "Group creator cannot create offer");
                    else if (widget.group.usersAccepted[widget.currUser.uid]) {
                      showToast(
                          context, "Your offer has already been accepted");
                    } else
                      push(
                          context,
                          CreateGroupOfferScreen(
                            group: widget.group,
                            creator: widget.currUser,
                          ));
                  }
                  if (value == 3)
                    push(
                        context,
                        GroupInfoScreen(
                          group: widget.group,
                          dark: dark,
                        ));
                },
                itemBuilder: (context) => [
                      if (!widget.currUser.seeker)
                        PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                  child: Icon(
                                    Icons.local_offer_outlined,
                                    color: dark ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text('Create Offer')
                              ],
                            )),
                      if (widget.currUser.seeker)
                        PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                  child: Icon(
                                    Icons.link,
                                    color: dark ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text('Create Link')
                              ],
                            )),
                      PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                child: Icon(
                                  Icons.info_outline,
                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ),
                              Text('Group Info')
                            ],
                          )),
                    ]),
          ),
        ],
        title: Text(
          widget.group.title ?? '',
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//            MessagesStream(),
            StreamBuilder<QuerySnapshot>(
              stream: _databaseService.groupsCollection
                  .doc(widget.group.gid)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messages = snapshot.data.docs;
                  List<Widget> msgWidgets = [];
                  for (DocumentSnapshot msg in messages) {
                    GroupMessage message = GroupMessage.fromJson(msg.data());
                    bool deleted = false;
                    //print("IDS ${widget.user.uid}   ${message.sid}");
                    // if (widget.currUser.uid == widget.group.creator.uid) {
                    //   //print("INSIDE SENDWER ${message.sDeleted}");
                    //   deleted = message.sDeleted ?? false;
                    // } else
                    //   deleted = message.rDeleted ?? false;
                    var msgWidget;
                    if (!deleted) {
                      if (message.type == 0) {
                        msgWidget = MessageBubble(
                          dark: dark,
                          type: message.type ?? 0,
                          sender: message.sender.displayName ?? "InPrep",
                          text: message.message ?? "",
                          isMe: widget.currUser.uid == message.sender.uid,
                          time: message.time,
                          url: message.url,
                        );
                      } else if (message.type == 1) {
                        //IMAGE
                        msgWidget = ImageMessage(
                          dark: dark ?? false,
                          sender: message.sender.uid,
                          isMe: widget.currUser.uid == message.sender.uid,
                          time: message.time,
                          url: message.url,
                        );
                      } else if (message.type == 2) {
                        //OFFER

                        msgWidget = GroupOfferCard(
                          dark: dark,
                          isMe: widget.currUser.uid == message.sender.uid,
                          currUser: widget.currUser,
                          offer: message.offer,
                          groupMessage: message,
                          group: widget.group,
                        );
                      } else if (message.type == 3) {
                        //OFFER
                        msgWidget = Text("link");
                        msgWidget = GroupLinkCard(
                          dark: dark,
                          isMe: widget.currUser.uid == message.sender.uid,
                          currUser: widget.currUser,
                          link: message.link,
                          groupMessage: message,
                          group: widget.group,
                        );
                      } else if (message.type == 4) {
                        //OFFER
                        msgWidget = Text("link");
                        msgWidget = Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${message.sender.displayName ?? "InPrep User"} left the group"),
                          ),
                        );
                      } else {
                        //FILE
                        msgWidget = MessageBubble(
                          dark: dark,
                          type: message.type ?? 0,
                          sender: message.sender.displayName ?? "InPrep",
                          text: message.message,
                          isMe: widget.currUser.uid == message.sender.uid,
                          time: message.time,
                          url: message.url,
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
                              color: Theme.of(context).primaryColor,
                            )),
                        FlatButton(
                          onPressed: () async {
                            if (messageController.text != '') {
                              var msg = messageController.text;
                              setState(() {
                                messageController.text = '';
                              });
                              await sendGroupMessage(msg, 0, "");
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
                // if (meetTime)
                //   Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: 50,
                //     color: Theme.of(context).primaryColor,
                //     child: Center(
                //         child: Text(
                //       'You meeting time is active.',
                //       style: TextStyle(color: Colors.white),
                //     )),
                //   )
              ],
            ),
          ],
        ),
      ),
    );
  }

  sendGroupMessage(String msg, int type, String url) async {
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    Group group = Group.fromJson(widget.group.toJson());
    group.lastMessage = msg;
    await _databaseService.sendGroupMessage(
        group: group,
        context: context,
        sender: widget.currUser,
        msg: msg,
        type: type,
        url: url);
    for (String usr in group.userIDS) {
      if (usr != widget.currUser.uid) {
        var doc = await _databaseService.userCollection.doc(usr).get();
        int badge = MyUser.fromJson(doc.data()).badge;
        await _databaseService.userCollection
            .doc(usr)
            .update({"badge": badge + 1});
      }
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

  Future<void> uploadFile() async {
    showLoader(context);
    String upload = await pickFile();

    print("RETURN URLL $upload");
    if (!(upload == null || upload == '')) {
      await sendGroupMessage(upload.split("\$")[1], 5, upload);
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
      await sendGroupMessage("Image", 1, upload);
    } else {
      print('ERROR');
    }
    Navigator.pop(context);
  }
}
