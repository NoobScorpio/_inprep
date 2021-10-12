import 'dart:io';

import 'package:InPrep/models/chat.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/social.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/profile_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../chat/chat_screen.dart';

class ProfileView extends StatefulWidget {
  final uid;
  final loggedIn;
  final link;
  ProfileView({this.uid, this.loggedIn, this.link});
  @override
  _ProfileViewState createState() =>
      _ProfileViewState(uid: uid, loggedIn: loggedIn);
}

class _ProfileViewState extends State<ProfileView> {
  final uid;

  final loggedIn;
  _ProfileViewState({this.uid, this.loggedIn});
  final DatabaseService _databaseService = DatabaseService();
  MyUser user, currentUser;
  bool firstSeek;
  bool profile = false, firstProfile;
  bool seeker = true;
  bool isConnected = true;
  void isConnectedCheck() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      isConnected = true;
    } else {
      isConnected = false;
    }
  }

  @override
  void initState() {
    super.initState();
    isConnectedCheck();
    getUser(yes: false);
    getPref();
    WidgetsBinding.instance.addPostFrameCallback((_) => getUser(yes: true));
  }

  SharedPreferences preferences;
  bool dark;
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      dark = preferences.getBool('dark');
    });
    //print("GET BOOLEAN IN SESSIONS ${preferences.getBool('dark')}");
  }

  final AuthService _auth = AuthService();
  getUser({yes}) async {
    user = await _databaseService.getcurrentUserData(uid);
    currentUser = await _auth.currentUser();
    firstSeek = currentUser.seeker;
    firstProfile = currentUser.profile;
    if (yes) setSeeker();
  }

  void setSeeker() {
    setState(() {
      seeker = firstSeek != null ? firstSeek : seeker;
      profile = firstProfile != null ? firstProfile : profile;
    });
  }

  Future<MyUser> getUserData() async {
    //print('inside getUserData');
    preferences = await SharedPreferences.getInstance();
    user = await _databaseService.getCurrentUserProfile(uid,
        seeker: user.seeker, loggedin: loggedIn);
    //print('RETURNING USER');
    return user != null
        ? user
        : MyUser(
            displayName: '',
            photoUrl:
                'https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar.jpg',
            experiences: [],
            portfolio: [],
            skills: [],
            educations: [],
            social: Social(fb: '', linkedin: '', git: ''),
            contact: Contact(code: '', number: ''),
            email: '',
            profile: false,
            pass: '',
            uid: '',
            desc: '',
            design: '',
            country: '',
            city: '',
            seeker: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        leading: Platform.isIOS
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
        title: Text('Profile'),
      ),
      key: profileViewKey,
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
          FutureBuilder(
            future: getUserData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //print('INSIDE BUILDER');
              if (!isConnected) {
                return GestureDetector(
                  onTap: () {
                    showSnack('Refreshing');
                    isConnectedCheck();
                    setState(() {});
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.wifi_off_outlined),
                        ),
                        Text(
                            'You are not connected to internet. Tap icon to refresh.'),
                      ],
                    )),
                  ),
                );
              }
              //print("SNAPSHOT HAS DATA: ${snapshot.hasData}");
              if (snapshot.hasData) {
                try {
                  return RefreshIndicator(
                    onRefresh: getUserData,
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          MyUser data = snapshot.data;
                          return seeker
                              ? seekerColumn(data: data)
                              : consultantColumn(data: data);
                        }),
                  );
                } catch (e) {
                  //print(e);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Swipe down to refresh'),
                      ),
                      Center(child: Text('Error Loading profile')),
                      Text('')
                    ],
                  );
                }
              } else
                // return Shimmer.fromColors(
                //     baseColor: Colors.grey[400],
                //     highlightColor: Colors.white,
                //     child: ProfilePlaceHolder());
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

  Widget seekerColumn({data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//                        HEADER INFO
          if (data != null)
            buildHeader(context,
                dark: dark,
                uid: data.uid,
                state: data.state,
                photoUrl: data.photoUrl,
                name: data.displayName,
                subCat: data.subCategory,
                designation: data.design,
                country: data.country,
                category: data.category,
                cover: data.cover,
                city: data.city),
//                        DESCRIPTION
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Description"),
          ),
          if (data != null)
            Container(
              width: double.maxFinite,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Text(
                    '${data.desc}',
                    style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 16),
                  ),
                ),
              ),
            ),

          SizedBox(height: 20.0),
          buildTitle("Contact", dark),
          SizedBox(height: 10.0),

          Row(
            children: <Widget>[
              // Text(data.email),
              SizedBox(width: 30.0),
              Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10.0),
              Text(
                data.contact == null
                    ? 'Not Added'
                    : "${data.contact.code}-${data.contact.number}",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          if (data.social != null)
            buildSocialsRow(
                dark: dark,
                insta: data.social.insta,
                tiktok: data.social.tiktok,
                fb: data.social.fb,
                git: data.social.git,
                linkedin: data.social.linkedin),
          SizedBox(height: 20.0),
          buildTitle("Skype", dark),
          if (data.social == null) buildSkype(),
          if (data.social != null) buildSkype(uname: data.social.skype),
          Padding(
            padding:
                EdgeInsets.only(bottom: 20.0, left: 20, right: 20, top: 10),
            child: GestureDetector(
              onTap: () async {
                if (currentUser.uid != user.uid) {
                  showSnack('Setting up chat');

                  MyUser senderUid = await AuthService().currentUser();

                  var sender =
                      await _databaseService.getcurrentUserData(senderUid.uid);
                  //print('${sender.uid} && ${user.uid}');
                  String isThere = await _databaseService.searchChat(
                      sid: sender.uid, rid: user.uid);
                  if (isThere != null) {
                    DocumentSnapshot chatDoc = await _databaseService
                        .chatsCollection
                        .doc(isThere)
                        .get();
                    Chat c = Chat.fromJson(chatDoc.data());
                    //print("@CHAT $c ");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          user: sender,
                          cid: isThere,
                          chat: c,
                          name: user.displayName,
                        ),
                      ),
                    );
                  } else {
                    var cid = await _databaseService.createChat(
                        sender: sender.displayName,
                        receiver: user.displayName,
                        rid: user.uid,
                        sid: sender.uid);
                    if (cid != null) {
                      DocumentSnapshot chatDoc =
                          await _databaseService.chatsCollection.doc(cid).get();
                      Chat c = Chat.fromJson(chatDoc.data());
                      //print("@CHAT $c ${c.sid}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                    user: sender,
                                    cid: cid,
                                    chat: c,
                                    name: user.displayName,
                                  )));
                    } else {
                      showSnack('Something went wrong');
                    }
                  }
                } else
                  showSnack('Cannot Contact Yourself');
              },
              child: Container(
                color: Colors.grey.withOpacity(0.3),
                height: 50,
                child: Center(
                    child: Text(
                  'Contact',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color:
                          dark ? Colors.white : Theme.of(context).primaryColor),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget consultantColumn({data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//                        HEADER INFO
          if (data != null)
            buildHeader(context,
                dark: dark,
                state: data.state,
                uid: data.uid,
                category: data.category,
                photoUrl: data.photoUrl,
                subCat: data.subCategory,
                name: data.displayName,
                designation: data.design,
                cover: data.cover,
                country: data.country,
                city: data.city),

//                        DESCRIPTION
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("Description"),
          ),
          if (data != null)
            Container(
              width: double.maxFinite,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Text(
                    '${data.desc}',
                    style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 16),
                  ),
                ),
              ),
            ),

//                       PORTFOLIO
//
//                                   buildTitle("Portfolio", dark),
//                                   SizedBox(height: 20.0),
//                                   if (data != null)
//                                     portfolioWidgets(
//                                         context, dark, data.portfolio),
//                        USER SKILLS

          buildTitle("Skills", dark),
          SizedBox(height: 10.0),
          if (data != null)
            Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: skillsWidgets(context, dark, data.skills),
                )),

//                        USER EXPERIENCES
          buildTitle("Experience", dark),
          SizedBox(height: 10.0),
          if (data != null)
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: experienceWidgets(context, dark, data.experiences),
              ),
            ),
//                       PORTFOLIO

          if (data != null) buildTitle("Portfolio", dark),
          if (data != null)
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: portfolioWidgets(context, dark, data.portfolio),
              ),
            ),
//                        USER EDUCATION
          SizedBox(height: 20.0),
          buildTitle("Education", dark),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: educationWidgets(context, dark, data.educations),
            ),
          ),
          SizedBox(height: 20.0),
          buildTitle("Contact", dark),
          SizedBox(height: 5.0),
          if (data != null)
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30.0),
                        Icon(
                          Icons.mail,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "${data.email}",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    buildContact(contact: data.contact, context: context),
                    //SOCIAL MEDIA
                    if (data.social != null)
                      buildSocialsRow(
                          dark: dark,
                          fb: data.social.fb ?? "",
                          git: data.social.git ?? "",
                          linkedin: data.social.linkedin ?? "",
                          insta: data.social.insta ?? '',
                          tiktok: data.social.tiktok ?? ""),
                    if (data.social == null)
                      buildSocialsRow(
                          dark: dark,
                          fb: '',
                          git: '',
                          insta: '',
                          tiktok: '',
                          linkedin: ''),
                  ],
                ),
              ),
            ),
          //PRICE RANGE
          SizedBox(height: 20.0),
          buildTitle("Price Range", dark),
          buildPriceRange(context, dark,
              from: data.priceFrom ?? '', to: data.priceTo ?? ''),

          SizedBox(height: 10.0),

          SizedBox(height: 20.0),
          buildTitle("Skype", dark),
          if (data.social == null) buildSkype(),
          if (data.social != null) buildSkype(uname: data.social.skype),

          //REVIEWS
          SizedBox(height: 20.0),
          buildTitle("Reviews", dark),
          SizedBox(height: 5.0),

          reviewWidgets(context, dark, data.reviews),
          SizedBox(height: 10.0),
          if (loggedIn)
            Padding(
              padding:
                  EdgeInsets.only(bottom: 20.0, left: 20, right: 20, top: 0),
              child: GestureDetector(
                onTap: () async {
                  if (currentUser.uid != user.uid) {
                    if (loggedIn) {
                      showSnack('Setting up chat');

                      MyUser senderUid = await AuthService().currentUser();
                      var sender = await _databaseService
                          .getcurrentUserData(senderUid.uid);
                      //print('${sender.uid} && ${user.uid}');
                      String isThere = await _databaseService.searchChat(
                          sid: sender.uid, rid: user.uid);
                      if (isThere != null) {
                        DocumentSnapshot chatDoc = await _databaseService
                            .chatsCollection
                            .doc(isThere)
                            .get();
                        Chat c = Chat.fromJson(chatDoc.data());
                        //print("@CHAT isTHERE $c ${c.sid}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                      user: sender,
                                      cid: isThere,
                                      chat: c,
                                      name: user.displayName,
                                    )));
                      } else {
                        var cid = await _databaseService.createChat(
                            time: msgTime(),
                            sender: sender.displayName,
                            receiver: user.displayName,
                            rid: user.uid,
                            sid: sender.uid);
                        if (cid != null) {
                          DocumentSnapshot chatDoc = await _databaseService
                              .chatsCollection
                              .doc(cid)
                              .get();
                          Chat c = Chat.fromJson(chatDoc.data());
                          //print("@CHAT CID $c ${c.sid}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                        user: sender,
                                        cid: cid,
                                        chat: c,
                                        name: user.displayName,
                                      )));
                        } else {
                          showSnack('Something went wrong');
                        }
                      }
                    } else
                      showSnack('Login or Signup to Chat');
                  } else
                    showSnack('Cannot Contact yourself');
                },
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  height: 50,
                  child: Center(
                      child: Text(
                    'Contact',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                        color: dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  )),
                ),
              ),
            ),
          if (!loggedIn)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0, top: 10),
              child: Center(
                  child: Text(
                'Login to Contact',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )),
            ),
        ],
      ),
    );
  }

  String msgTime() {
    String time = TimeOfDay.now().format(context);
    return time;
  }

  final GlobalKey<ScaffoldState> profileViewKey =
      new GlobalKey<ScaffoldState>();
  void showSnack(text) {
    profileViewKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }
}
