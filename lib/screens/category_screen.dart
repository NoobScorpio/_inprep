import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/message.dart';
import 'package:InPrep/models/review.dart';
import 'package:InPrep/screens/filterScreen.dart';
import 'package:InPrep/screens/loginWelcome.dart';
import 'package:InPrep/screens/subCatScreen.dart';
import 'package:InPrep/screens/pre_settings.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/search_screen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/loginUser.dart';

class CategoryScreen extends StatefulWidget {
  static String id = 'categroy';
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  SharedPreferences preferences;
  MyUser user;
  bool seeker = true;
  bool dark;
  bool clickable = false;
  TextEditingController controller = TextEditingController();
  getUser({secondCall}) async {
    preferences = await SharedPreferences.getInstance();
    dark = preferences.getBool('dark');
    MyUser userC = await _auth.currentUser();

    userC =
        await _databaseService.getcurrentUserData(userC.uid, loggedin: true);

    if (secondCall == null) {
      user = userC;
    } else {
      setState(() {
        user = userC;
        clickable = true;
      });
      await loginUserState(context, userC);
    }
    // setSeeker(seek: user.seeker ?? false);
  }

  @override
  void initState() {
    super.initState();

    getUser();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => getUser(secondCall: true));
    WidgetsBinding.instance.addPostFrameCallback((_) => setPrefs());
  }

  void setPrefs() async {
    preferences = await SharedPreferences.getInstance();
    bool first = preferences.getBool('firstHome');
    if (first == null) {
      await preferences.setBool('firstHome', false);

      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginWelcome()));
      // Future<PermissionStatus> permissionStatus =
      //     NotificationPermissions.getNotificationPermissionStatus();
      // Future<PermissionStatus> permissionStatus =
      //     NotificationPermissions.requestNotificationPermissions(
      //         iosSettings: NotificationSettingsIos(), openSettings: true);
    } else if (first == true) {
      await preferences.setBool('firstHome', false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginWelcome()));
    } else {
      bool welcome = preferences.getBool("welcome");
      if (welcome == null || welcome == false) {
        await preferences.setBool('welcome', true);
        // showSimpleNotification(Text("Welcome Back"),
        //     background: Theme.of(context).primaryColor,
        //     autoDismiss: true,
        //     slideDismiss: true,
        //     duration: Duration(seconds: 2),
        //     position: NotificationPosition.bottom);
        // await preferences.setBool('welcome', true);
      } else {
        await preferences.setBool('welcome', true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return clickable
        ? Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  if (clickable) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PreSettings(
                                  user: user,
                                )));
                  }
                },
                child: Icon(Icons.list),
              ),
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              title: Text("Home"),
              actions: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/icons/logo1024.png'),
                ),
              ],
            ),
            // drawerScrimColor: Colors.transparent,

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
                ListView(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, bottom: 8, top: 30),
                        child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 6,
                            child: Container(
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutofillGroup(
                                    child: TextField(
                                      autofillHints: [AutofillHints.jobTitle],
                                      controller: controller,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Search for name, email or designation',
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Search(
                                                          loggedIn: true,
                                                          search: controller
                                                                  .text
                                                                  .toString() ??
                                                              '',
                                                        )));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )))),
                    // Column(
                    //   children: makeCards(user: user, context: context),
                    // ),
                    InkWell(
                      onTap: () async {
                        showLoader(context);

                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterScreen(
                                      loggedIn: true,
                                    )));
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                          ),
                          child: Text(
                            "Advance Filtering",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    for (int i = 0; i < catList.length; i++)
                      if (i != 0)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubCatScreen(
                                          category: catList[i],
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9.0, vertical: 2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 6,
                              child: ListTile(
                                leading: Icon(
                                  iconsOptions[i - 1],
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  catList[i],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        )
                    // FutureBuilder(
                    //     future: makeCards(user: user, context: context),
                    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //       if (snapshot.hasData) {
                    //         List<Widget> list = snapshot.data;
                    //         return Column(
                    //           children: list,
                    //         );
                    //       } else {
                    //         return CircularProgressIndicator();
                    //       }
                    //     }),
                  ],
                ),
              ],
            ),

            // floatingActionButton: FloatingActionButton(
            //   child: Container(),
            //   onPressed: () async {
            //     var db = DatabaseService();
            //     QuerySnapshot users = await db.userCollection.get();
            //     for (QueryDocumentSnapshot doc in users.docs) {
            //       MyUser usr = MyUser.fromJson(doc.data());
            //       await db.userCollection.doc(usr.uid).update({"badge": 0});
            //       print("${usr.displayName} updated");
            //     }
            //   },
            // ),
          )
        : Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ));
  }
}
