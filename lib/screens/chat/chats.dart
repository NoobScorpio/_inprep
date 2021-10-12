import 'dart:async';
import 'dart:io';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/message.dart';
import 'package:InPrep/screens/group/group__chat_screen.dart';
import 'package:InPrep/screens/group/invite_screen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/show_case_statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/chat/chat_screen.dart';
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
  bool first = false;
  String userID = "";
  String sid = '';
  @override
  void initState() {
    super.initState();
    print("INIT GROUP");
    getPrefs();
    // setSeeker();
  }

  setSeeker() async {
    MyUser user = await AuthService().currentUser();
    print("USER SEEEKER ${user.seeker}");
    setState(() {
      seeker = user.seeker;
    });
  }

  getPrefs() async {
    preferences = await SharedPreferences.getInstance();
    first = preferences.getBool('firstChat');
    if (first == null || first == true) {
      await preferences.setBool('firstChat', false);
      IntroTexts.showChatDialog(context);
    } else {
      // await IntroTexts.showChatDialog(context);
      // await IntroTexts.showBlogIconDialog(context);
    }
  }

  Future<List<Chat>> getChats({sid}) async {
    List<Chat> chats = [];
    chats = await _databaseService.getChats(sid: sid);
    return chats;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool seeker = false;
  @override
  Widget build(BuildContext context) {
    sid = Provider.of<MyUser>(context).uid;
    dark = AdaptiveTheme.of(context).mode.isDark;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Platform.isIOS) badgeResetNotification(uid: sid);
      Future.delayed(Duration(milliseconds: 500), () async {
        DocumentSnapshot user =
            await _databaseService.userCollection.doc(sid).get();
        MyUser userData = MyUser.fromJson(user.data());
        if (mounted)
          setState(() {
            seeker = userData.seeker ?? false;
          });
      });
    });
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Chats'),
              ),
              Tab(
                child: Text('Groups'),
              ),
            ],
          ),
          title: Text('Inbox'),
          actions: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/icons/logo1024.png'),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            chatsTab(sid),
            groupsTab(sid),
          ],
        ),
      ),
    ));
  }

  Widget chatsTab(sid) {
    return Stack(
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
            // if (preferences != null)
            //   dark = preferences.getBool('dark') ?? false;

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
                  return noChatWidget();
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
                return noChatWidget();
            } else
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
          },
        ),
      ],
    );
  }

  Widget groupsTab(sid) {
    // print(sid);
    return Stack(
      children: [
        background(context),
        StreamBuilder<QuerySnapshot>(
          stream: _databaseService.groupsCollection
              .orderBy('Timestamp', descending: true)
              .where('userIDS', arrayContainsAny: [sid]).snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length != 0) {
                int groupDeleted = 0;
                for (int i = 0; i < snapshot.data.docs.length; i++) {
                  Group c = Group.fromJson(snapshot.data.docs[i].data());
                }
                if (groupDeleted == snapshot.data.docs.length) {
                  return noGroupWidget();
                } else {
                  return Stack(
                    children: [
                      ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Group group = Group.fromJson(
                                snapshot.data.docs[index].data());
                            // print(group.usersRead[sid]);
                            bool bold = !(group.usersRead[sid] ?? false);

                            return groupWidget(
                                bold: bold, sid: sid, group: group);
                          }),
                      Visibility(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              push(
                                  context,
                                  InviteScreen(
                                    currUser: sid,
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        visible: seeker,
                      )
                    ],
                  );
                }
              } else
                return noGroupWidget();
            } else
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              );
          },
        ),
      ],
    );
  }

  Widget noGroupWidget() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image(
              image: AssetImage('assets/images/chat.png'),
            )),
            Center(
              child: Text(
                'You have no group chats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        Visibility(
          visible: seeker ?? true,
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                push(
                    context,
                    InviteScreen(
                      currUser: sid,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget noChatWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Image(
          image: AssetImage('assets/images/chat.png'),
        )),
        Center(
          child: Text(
            'You have no group chats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
        ),
      ],
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
                    MyUser user =
                        await _databaseService.getcurrentUserData(sid);

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

  Widget groupWidget({bold, sid, Group group}) {
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
                    showLoader(context);
                    MyUser user =
                        await _databaseService.getcurrentUserData(sid);
                    group.usersRead[user.uid] = true;
                    await _databaseService.groupsCollection
                        .doc(group.gid)
                        .update(group.toJson());
                    bold = false;
                    pop(context);
                    push(
                        context,
                        GroupChatScreen(
                          group: group,
                          currUser: user,
                        ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: group.photo ?? "",
                          imageBuilder: (context, image) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage: image,
                              backgroundColor: Theme.of(context).primaryColor,
                            );
                          },
                          placeholder: (context, image) {
                            return CircleAvatar(
                              radius: 30,
                              child: Center(
                                child: Text(
                                  group.title
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
                            );
                          },
                          errorWidget: (context, image, err) {
                            return CircleAvatar(
                              radius: 30,
                              child: Center(
                                child: Text(
                                  group.title
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
                            );
                          },
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
                                group.title.toString().toUpperCase(),
                                style: TextStyle(
                                    color: dark ? Colors.white : Colors.black,
                                    fontSize: bold ? 20 : 18,
                                    fontWeight: bold
                                        ? FontWeight.w700
                                        : FontWeight.w500),
                              ),
                            ),
                            Text(
                                group.lastMessage.toString().length >= 30
                                    ? group.lastMessage
                                        .toString()
                                        .substring(0, 30)
                                    : group.lastMessage.toString() ?? '',
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
                        showLoader(context);
                        showToast(context, "Leaving group");
                        for (MyUser usr in group.users) {
                          if (usr.uid == sid) {
                            group.users.remove(usr);
                            group.usersRead.remove(sid);
                            group.usersAccepted.remove(sid);
                            group.userIDS.remove(sid);

                            await _databaseService.groupsCollection
                                .doc(group.gid)
                                .update(group.toJson());

                            group.lastMessage =
                                "${usr.displayName ?? "InPrep User"} left the group";
                            await _databaseService.sendGroupMessage(
                                group: group,
                                context: context,
                                sender: usr,
                                msg: group.lastMessage,
                                type: 4,
                                url: "");
                            for (String ussr in group.userIDS) {
                              if (ussr != usr.uid) {
                                var doc = await _databaseService.userCollection
                                    .doc(ussr)
                                    .get();
                                int badge = MyUser.fromJson(doc.data()).badge;
                                await _databaseService.userCollection
                                    .doc(ussr)
                                    .update({"badge": badge + 1});
                              }
                            }

                            break;
                          }
                        }
                        pop(context);
                      },
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.arrow_back),
                                    ),
                                    Text('Leave group')
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
