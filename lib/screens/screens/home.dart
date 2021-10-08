import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:InPrep/models/chat.dart';
import 'package:InPrep/screens/blog/blog_home.dart';
import 'package:InPrep/utils/dynamic_link.dart';
import 'package:InPrep/utils/loginUser.dart';
import 'package:InPrep/utils/show_case_statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:InPrep/models/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/screens/screens/category_screen.dart';
import 'package:InPrep/screens/screens/chats.dart';
import 'package:InPrep/screens/profile_screens/profile.dart';
import 'package:InPrep/screens/screens/signin_signup.dart';
import 'package:InPrep/models/user.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class Item {
  Item({this.name, this.icon});
  String name;
  Icon icon;
}

class _HomeState extends State<Home> {
  SharedPreferences preferences;

  setCol() async {
    var ndark = await SharedPreferences.getInstance()
        .then((value) => value.getBool('dark'));
    //print('DARK MODE : $ndark');
    setState(() {
      dark = ndark;
    });
  }

  @override
  void initState() {
    super.initState();

    getPref();
    registerNotification();
    configLocalNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  bool read = true;
  Timer timer;
  int _selectedIndex = 0;
  String sid;
  static var messages = Chats();
  static var category = CategoryScreen();
  static var profile = Profile();
  static var blog = BlogHome();
  List<Widget> _widgetOptions = <Widget>[
    category,
    messages,
    blog,
    profile,
  ];

  //
  //NOTIFICATIONS
  //

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void registerNotification() async {
    var user = await _auth.currentUser();
    var apnToken = await firebaseMessaging.getAPNSToken();
    var token = await firebaseMessaging.getToken();
    print("@TOKEN $token");
    bool noti = preferences.getBool('noti');
    if (noti == null) {
      await _databaseService.userCollection.doc(user.uid).update({
        'pushToken': token,
        'isIos': Platform.isIOS ? true : false,
        'badge': 0
      });
    } else if (noti == false) {
      await _databaseService.userCollection.doc(user.uid).update({
        'pushToken': 'token',
        'isIos': Platform.isIOS ? true : false,
        'badge': 0
      });
    } else {
      await _databaseService.userCollection.doc(user.uid).update({
        'pushToken': token,
        'isIos': Platform.isIOS ? true : false,
        'badge': 0
      });
    }
    if (mounted) await loginUserState(context, user);
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      // provisional: true,
      sound: true,
    );
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo1024');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onDidReceiveLocalNotification);
  }

  void showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    //print('Channel : $channel');
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'com.inprep.inprep',
      'InPrep',
      '',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    if (message.notification == null) {
      print("NULL NOTIFICATION");
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification.title,
        message.notification.body,
        platformChannelSpecifics,
      );
    }
  }

  Future onDidReceiveLocalNotification(String payload) async {
    var newPay = jsonDecode(payload);
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Message'),
        content: Text('$newPay'),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  bool dark;
  getPref() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      dark = preferences.getBool('dark');
    });
    bool loggedIn = preferences.getBool('loggedIn');
    if (loggedIn == null || loggedIn == false)
      DynamicLinkClass.initDynamicLinks(context, false);
    else
      DynamicLinkClass.initDynamicLinks(context, true);
  }

  final _firestore = FirebaseFirestore.instance;
  var title = 'Home';
  @override
  Widget build(BuildContext context) {
    // int i = 0;
    final user = Provider.of<MyUser>(context);

    bool dark = AdaptiveTheme.of(context).mode.isDark;
    sid = Provider.of<MyUser>(context) == null
        ? ""
        : Provider.of<MyUser>(context).uid;

    return user == null
        ? SignInUp()
        : Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: _firestore.collection('user').doc(sid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data.data() != null) {
                      MyUser streamUser = MyUser.fromJson(snapshot.data.data());
                      read = streamUser.read ?? true;
                      return SalomonBottomBar(
                          items: [
                            SalomonBottomBarItem(
                              icon: Icon(Icons.search),
                              title: Text('Find'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SalomonBottomBarItem(
                              icon: Icon(read
                                  ? Icons.chat_bubble_outline_outlined
                                  : Icons.mark_chat_unread_rounded),
                              title: Text('Chat'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SalomonBottomBarItem(
                              icon: Icon(Icons.bookmark_border_outlined),
                              title: Text('Blog'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SalomonBottomBarItem(
                              icon: Icon(Icons.person_outline_outlined),
                              title: Text('Profile'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            )
                          ],
                          currentIndex: _selectedIndex,
                          onTap: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          });
                    } else {
                      return SalomonBottomBar(
                          items: [
                            SalomonBottomBarItem(
                              icon: Icon(Icons.search),
                              title: Text('Find'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SalomonBottomBarItem(
                              icon: Icon(
                                Icons.chat_bubble_outline_outlined,
                                // key: IntroTexts.introFG.keys[0],
                              ),
                              title: Text('Chat'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SalomonBottomBarItem(
                              icon: Icon(Icons.bookmark_border_outlined),
                              title: Text('Blog'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SalomonBottomBarItem(
                              icon: Icon(Icons.person_outline_outlined),
                              title: Text('Profile'),
                              selectedColor: dark
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            )
                          ],
                          currentIndex: _selectedIndex,
                          onTap: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          });
                    }
                  }),
            ),
          );
  }
}
