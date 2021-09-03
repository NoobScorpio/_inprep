import 'dart:async';
import 'package:InPrep/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Chats extends StatefulWidget {
  static String id = 'msg';
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  DatabaseService _databaseService = DatabaseService();
  SharedPreferences preferences;
  bool dark = false;
  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    preferences = await SharedPreferences.getInstance();
    // setState(() {
    //       dark = preferences.getBool('dark');
    //     });
  }

  Future<List<Chat>> getChats({sid}) async {
    List<Chat> chats = [];
    chats = await _databaseService.getChats(sid: sid);
    // setState(() {});
    return chats;
  }

  // Future<List<Chat>> getChatsRefresh({sid}) async {
  //   dark = preferences.getBool('dark');
  //   List<Chat> chats = [];
  //   var chatsReturned = await _databaseService.getChats(sid: sid);
  //   setState(() {
  //     chats = chatsReturned ?? [];
  //   });
  //   return chats;
  // }

  Timer timer;
  refreshRepeater() {
    Duration dur = Duration(seconds: 5);
    timer = Timer(
        dur,
        () => {
              // setState(() {})
            });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String sid = Provider.of<MyUser>(context).uid;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chats'),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
      ),
      body: Stack(
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
          StreamBuilder<QuerySnapshot>(
            stream: _databaseService.chatsCollection
                .orderBy('timestamp', descending: true)
                .where('users', arrayContains: sid)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (preferences != null) dark = preferences.getBool('dark');
              refreshRepeater();
              if (snapshot.hasData) {
                if (snapshot.data.docs.length != 0) {
                  // print("@CHAT ${snapshot.data.docs.length}");
                  int chatsDeleted = 0;
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    Chat c = Chat.fromJson(snapshot.data.docs[i].data());
                    if (sid == c.sid) {
                      if (c.sDeleted) chatsDeleted++;
                    } else if (sid == c.rid) {
                      if (c.rDeleted) chatsDeleted++;
                    }
                  }
                  if (chatsDeleted == snapshot.data.docs.length) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Image(
                          image: AssetImage('assets/images/chat.png'),
                        )),
                        Center(
                          child: Text(
                            'You have no chats',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print('THEME IS DARK: $dark');
                          Chat chat =
                              Chat.fromJson(snapshot.data.docs[index].data());
                          bool sender = false;
                          bool bold = false;
                          if (chat.users[0] == sid) {
                            sender = true;
                            // continue;
                          }
                          if (sender) if (chat.sRead == false) bold = true;
                          if (!sender) if (chat.rRead == false) bold = true;
                          bool deleted = false;
                          if (sender) {
                            // _databaseService.chatsCollection.doc(chat.cid).update({
                            //   'sDeleted': true,
                            // });
                            deleted = chat.sDeleted;
                            // setState(() {});
                          } else {
                            deleted = chat.rDeleted;
                            // setState(() {});
                          }

                          return deleted
                              ? SizedBox()
                              : chatWidget(bold: bold, sid: sid, chat: chat);
                        });
                  }
                } else
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Image(
                        image: AssetImage('assets/images/chat.png'),
                      )),
                      Center(
                        child: Text(
                          'You have no chats',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  );
              } else
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                );
            },
          ),
        ],
      ),
    );
  }

  Widget chatWidget({bold, sid, chat}) {
    return Column(
      children: [
        Container(
          height: 80,
          width: double.maxFinite,
          color: bold ? Colors.grey.withOpacity(0.3) : Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  // color: dark ? Colors.white12 : Colors.white,
                  onTap: () async {
                    // print('GETTING USER');
                    MyUser user = await _databaseService.getcurrentUserData(sid,
                        loggedin: true);

                    // setState(() {
                    bold = false;
                    // });

                    // print('GETTING USER $user');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ChatScreen(
                                  chat: chat,
                                  user: user,
                                  sid: sid,
                                  cid: chat.cid,
                                  name: chat.sid == sid
                                      ? chat.receiverName
                                      : chat.senderName,
                                )));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 30,
                          child: Center(
                            child: Text(
                              chat.sid == sid
                                  ? chat.receiverName
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase()
                                  : chat.senderName
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
//
                      ),
                      // GestureDetector(
                      //   on
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                (chat.sid == sid ?? ''
                                        ? chat.receiverName ?? ''
                                        : chat.senderName ?? '')
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: dark ? Colors.white : Colors.black,
                                    fontSize: bold ? 20 : 18,
                                    fontWeight: bold
                                        ? FontWeight.w700
                                        : FontWeight.w500),
                              ),
                            ),
                            Text(
                                chat.lastMessage.toString().length >= 30
                                    ? chat.lastMessage
                                        .toString()
                                        .substring(0, 30)
                                    : chat.lastMessage.toString() ?? '',
                                style: TextStyle(
                                    color: dark ? Colors.white : Colors.black,
                                    fontSize: bold ? 18 : 16,
                                    fontWeight: bold
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  PopupMenuButton(
                      onSelected: (value) async {
                        // print(c.users);
                        if (sid == chat.users[0]) {
                          if (chat.rDeleted) {
                            await _databaseService.chatsCollection
                                .doc(chat.cid)
                                .delete();
                          } else {
                            await _databaseService.chatsCollection
                                .doc(chat.cid)
                                .update({"sDeleted": true});
                            QuerySnapshot messages = await _databaseService
                                .chatsCollection
                                .doc(chat.cid)
                                .collection('messages')
                                .get();
                            for (var msg in messages.docs) {
                              Message m = Message.fromJson(msg.data());
                              if (m.rDeleted) {
                                await _databaseService.chatsCollection
                                    .doc(chat.cid)
                                    .collection('messages')
                                    .doc(m.meid)
                                    .delete();
                              } else
                                await _databaseService.chatsCollection
                                    .doc(chat.cid)
                                    .collection('messages')
                                    .doc(m.meid)
                                    .update({"sDeleted": true});
                            }
                          }
                        } else {
                          if (chat.sDeleted) {
                            await _databaseService.chatsCollection
                                .doc(chat.cid)
                                .delete();
                          } else {
                            await _databaseService.chatsCollection
                                .doc(chat.cid)
                                .update({"rDeleted": true});
                            QuerySnapshot messages = await _databaseService
                                .chatsCollection
                                .doc(chat.cid)
                                .collection('messages')
                                .get();
                            for (var msg in messages.docs) {
                              Message m = Message.fromJson(msg.data());
                              if (m.sDeleted) {
                                await _databaseService.chatsCollection
                                    .doc(chat.cid)
                                    .collection('messages')
                                    .doc(m.meid)
                                    .delete();
                              } else
                                await _databaseService.chatsCollection
                                    .doc(chat.cid)
                                    .collection('messages')
                                    .doc(m.meid)
                                    .update({"rDeleted": true});
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.delete),
                                    ),
                                    Text('Delete')
                                  ],
                                )),
                          ]),
                  if (bold)
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Theme.of(context).primaryColor,
                    )
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 0.4,
          color: Colors.grey,
        )
      ],
    );
  }
}
