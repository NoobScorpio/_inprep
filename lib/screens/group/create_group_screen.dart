import 'dart:io';

import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/group/group__chat_screen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen(this.users, this.currUser) : super();
  final List<MyUser> users;
  final String currUser;
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String groupImage = "";
  List<MyUser> users;
  TextEditingController titleCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  @override
  void initState() {
    super.initState();
    users = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text('Create group'),
      ),
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black,
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: groupImage,
                          imageBuilder: (context, image) {
                            return Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(360)),
                                  image: DecorationImage(
                                      image: image, fit: BoxFit.cover)),
                            );
                          },
                          placeholder: (context, image) {
                            return Container(
                              width: 100.0,
                              height: 100.0,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, image, err) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 100.0,
                              height: 100.0,
                              child: Center(
                                child: Center(
                                  child: Icon(
                                    Icons.group_add,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 50.0,
                            ),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(360.0),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  await uploadImage();
                                },
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child:
                                        Icon(Icons.edit, color: Colors.black)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: titleCont,
                  padding: EdgeInsets.all(0),
                  // maxline: 5,
                  hint: "Enter your group title",
                  labelText: 'Group Title',
                  prefixIcon: Icon(Icons.group,
                      color:
                          dark ? Colors.grey : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: descCont,
                  padding: EdgeInsets.all(0),
                  // maxline: 5,
                  hint: "Enter your group description",
                  labelText: 'Group Description',
                  maxline: 5,
                  prefixIcon: Icon(Icons.description,
                      color:
                          dark ? Colors.grey : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Selected Users',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ?? false
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: columnUsers(),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => createGroup(),
        label: Text('Create group'),
        icon: Icon(Icons.group),
      ),
    );
  }

  void createGroup() async {
    if (titleCont.text != "") {
      List<String> userIDS = [];
      showLoader(context);
      DatabaseService _databaseService = DatabaseService();
      DocumentSnapshot userDoc =
          await _databaseService.userCollection.doc(widget.currUser).get();
      MyUser user = MyUser.fromJson(userDoc.data());
      users.add(user);
      for (MyUser usr in users) {
        userIDS.add(usr.uid);
      }
      showToast(context, "Creating group");
      Map<String, bool> usersAccepted = {}, usersSeen = {};
      for (var usr in users) {
        if (usr.uid != user.uid) {
          usersAccepted[usr.uid] = false;
          usersSeen[usr.uid] = false;
        }
      }
      Group group = await _databaseService.createGroup(
          group: Group(
              title: titleCont.text,
              desc: descCont.text ?? "",
              photo: groupImage ?? "",
              creator: user,
              confirmed: false,
              usersAccepted: usersAccepted,
              usersRead: usersSeen,
              lastMessage: "Hello Consultants !!",
              timestamp: Timestamp.now(),
              userIDS: userIDS,
              users: users),
          sender: user,
          context: context);
      if (group != null) {
        showToast(context, "Group Created");
        pop(context);
        pop(context);
        pop(context);
        push(
            context,
            GroupChatScreen(
              group: group,
              currUser: user,
            ));
      } else {
        showToast(context, "Could not create group");
      }
    } else
      showToast(context, "Please enter group title");
  }

  List<Widget> columnUsers() {
    List<Widget> widgets = [];
    for (MyUser user in users) {
      widgets.add(userComponent(user: user));
    }
    return widgets;
  }

  userComponent({MyUser user}) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                Text(user.displayName ?? "No Name",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                SizedBox(
                  height: 5,
                ),
                Text(user.design ?? "Not available",
                    style: TextStyle(color: Colors.grey[500])),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Future<void> uploadImage() async {
    showLoader(context);
    String upload = await pickImage();
    setState(() {
      groupImage = upload;
    });
    pop(context);
    showToast(context, "Uploaded");
  }

  Future<String> pickImage() async {
    try {
      File selected;
      List<Media> media = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.image,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect, // currently for android
        ),
      );
      selected = File(media[0].path);
      showToast(context, "Uploading");
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
}
