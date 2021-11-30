import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/group/create_group_screen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({this.currUser, this.link, this.time, this.date})
      : super();
  final String currUser, link, time, date;
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  bool isLoading = false;
  List<MyUser> users = [];
  List<MyUser> selectedUsers = [];
  int usersCount = 0;
  List<MyUser> foundUsers = [];
  Map<String, bool> usersInvite = {};
  TextEditingController searchCont = TextEditingController();
  FocusNode focus = FocusNode();
  void getUsers() async {
    List<MyUser> myUsers = await DatabaseService()
        .getSimpleSearchUser(search: "", currUser: widget.currUser);

    if (myUsers == null || myUsers.length == 0) {
      setState(() {
        users = [];
        isLoading = false;
      });
    } else {
      for (MyUser usr in myUsers) {
        usersInvite[usr.uid] = false;
      }
      setState(() {
        users = myUsers;
        foundUsers = myUsers;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text('Invite Users'),
      ),
      body: Stack(
        children: [
          background(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 45,
                        child: TextField(
                          onChanged: (value) => onSearch(value),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white24,
                              contentPadding: EdgeInsets.all(0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade500),
                              hintText: "Search users"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                      itemCount: foundUsers.length,
                      itemBuilder: (context, index) {
                        return userComponent(
                            user: foundUsers[index], dark: dark);
                      }),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: usersCount >= 2,
        child: FloatingActionButton.extended(
          onPressed: () {
            push(context, CreateGroupScreen(selectedUsers, widget.currUser));
          },
          label: Text('Add $usersCount users'),
          icon: Icon(Icons.add),
        ),
      ),
    );
  }

  userComponent({MyUser user, bool dark}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    user.photoUrl == "" || user.photoUrl == null
                        ? "https://inprepapp.com/assets/images/logo.png"
                        : user.photoUrl,
                    errorBuilder: (_, obj, err) {
                      return Container(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "https://inprepapp.com/assets/images/logo.png",
                              fit: BoxFit.cover,
                            ),
                          ));
                    },
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.displayName.toUpperCase() ?? "No Name",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              SizedBox(
                height: 5,
              ),
              Text(user.design ?? "Not available",
                  style: TextStyle(color: Colors.grey[500])),
            ])
          ]),
          GestureDetector(
            onTap: () {
              setState(() {
                usersInvite[user.uid] = !usersInvite[user.uid];
                if (usersInvite[user.uid]) {
                  selectedUsers.add(user);
                  usersCount++;
                } else {
                  selectedUsers.remove(user);
                  usersCount--;
                }
              });
            },
            child: AnimatedContainer(
                height: 35,
                width: 110,
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: usersInvite[user.uid]
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: usersInvite[user.uid]
                          ? Colors.transparent
                          : Colors.grey.shade700,
                    )),
                child: Center(
                    child: Text(
                  usersInvite[user.uid] ? 'Unselect' : 'Select',
                  style: TextStyle(color: dark ? Colors.white : Colors.black),
                ))),
          )
        ],
      ),
    );
  }

  onSearch(search) {
    setState(() {
      foundUsers = users
          .where((user) => user.displayName.toLowerCase().contains(search))
          .toList();
    });
  }

  Widget addUser(context, MyUser user) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Invite ${user.displayName}"),
                content: Text("Do you want to invite ${user.displayName}"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () async {
                          await sendInvite(
                            user: user,
                            currUser: widget.currUser,
                            link: widget.link,
                            time: widget.time,
                            date: widget.date,
                          );
                        },
                        child: Text("Yes")),
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      user.displayName == "" || user.displayName == null
                          ? "U"
                          : user.displayName.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, right: 8.0, left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.displayName.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.design == null
                            ? 'No Title'
                            : user.design.toString().toUpperCase(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendInvite({MyUser user, currUser, link, time, String date}) async {
    print("${user.uid} , $currUser , $link , $time , $date");
    var a = Jiffy("$date").yMMMMd;
    try {
      showLoader(context);
      var _databaseService = DatabaseService();
      var sender = await _databaseService.getcurrentUserData(currUser);
      //print('${sender.uid} && ${user.uid}');
      String isThere =
          await _databaseService.searchChat(sid: currUser, rid: user.uid);
      if (isThere != null) {
        print("CHAT IS THERE");
        DocumentSnapshot chatDoc =
            await _databaseService.chatsCollection.doc(isThere).get();
        Chat c = Chat.fromJson(chatDoc.data());
        await _databaseService.sendMessage(
            cid: c.cid,
            sender: sender.displayName,
            receiver: user.displayName,
            time: TimeOfDay.now().format(context),
            rid: user.uid,
            type: 4,
            sid: sender.uid,
            msg: "Hi, click the following link to connect at $time on $a.",
            image: link);

        var doc = await _databaseService.userCollection.doc(user.uid).get();
        int badge = MyUser.fromJson(doc.data()).badge;
        await _databaseService.userCollection
            .doc(user.uid)
            .update({"badge": badge + 1});
      } else {
        print("CHAT IS NOT THERE");
        var cid = await _databaseService.createChat(
            time: TimeOfDay.now().format(context),
            sender: sender.displayName,
            receiver: user.displayName,
            rid: user.uid,
            sid: sender.uid);
        if (cid != null) {
          print("CID IS THERE");
          DocumentSnapshot chatDoc =
              await _databaseService.chatsCollection.doc(cid).get();
          print("CID DOC IS THERE $cid");
          Chat c = Chat.fromJson(chatDoc.data());
          print("CHAT FROM CHAT DOC IS THERE");
          await _databaseService.sendMessage(
              cid: c.cid,
              sender: sender.displayName,
              receiver: user.displayName,
              time: TimeOfDay.now().format(context),
              rid: user.uid,
              type: 4,
              sid: sender.uid,
              msg: "Hi, click the following link to connect at $time on $date.",
              image: link);
          var doc = await _databaseService.userCollection.doc(user.uid).get();
          int badge = MyUser.fromJson(doc.data()).badge;
          await _databaseService.userCollection
              .doc(user.uid)
              .update({"badge": badge + 1});
        } else {
          print("CHAT IS NOT THERE");
        }
      }
      showToast(context, "Invitation Sent");
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e, trace) {
      Navigator.pop(context);
      print("ERROR $e , $trace");
    }
  }
}
