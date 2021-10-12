import 'package:InPrep/screens/screens/filterScreen.dart';
import 'package:InPrep/screens/screens/loginWelcome.dart';
import 'package:InPrep/screens/settings/pre_settings.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/show_case_statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/loginUser.dart';
import 'package:InPrep/screens/screens/welcome.dart';

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
  bool clickable = false;
  TextEditingController controller = TextEditingController();
  getUser({secondCall}) async {
    preferences = await SharedPreferences.getInstance();
    MyUser userC = await _auth.currentUser();

    userC = await _databaseService.getcurrentUserData(userC.uid);

    if (secondCall == null) {
      user = userC;
    } else {
      if (mounted) {
        setState(() {
          user = userC;
          clickable = true;
        });
      }
      if (mounted) await loginUserState(context, userC);
    }
  }

  bool first = false;
  @override
  void initState() {
    super.initState();

    getUser();
    IntroTexts.setConfigs();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getUser(secondCall: true));
    WidgetsBinding.instance.addPostFrameCallback((_) => setPrefs());
  }

  void setPrefs() async {
    preferences = await SharedPreferences.getInstance();
    first = preferences.getBool('firstHome');
    if (first == null) {
      await preferences.setBool('firstHome', false);
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginWelcome()));

      IntroTexts.introC.start(context);
    } else if (first == true) {
      await preferences.setBool('firstHome', false);
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginWelcome()));
      IntroTexts.introC.start(context);
    } else {
      bool welcome = preferences.getBool("welcome");
      if (welcome == null || welcome == false) {
        await preferences.setBool('welcome', true);
      } else {
        await preferences.setBool('welcome', true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return clickable
        ? Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () async {
                  if (clickable) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PreSettings(
                                  user: user,
                                )));

                    bool firstBack = preferences.getBool('firstBack');
                    if (firstBack == null || firstBack == true) {
                      await preferences.setBool('firstBack', false);
                      IntroTexts.showHomeDialog(context);
                    }
                  }
                },
                child: Icon(
                  Icons.list,
                  key: IntroTexts.introC.keys[0],
                ),
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
                background(context),
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
                            "Advanced",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: dark ?? false
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10.0),
                      child: Text(
                        'Popular Categories',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: dark ?? false
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(height: 175, child: makeCategories()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 10.0),
                      child: Text(
                        'Featured Categories',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: dark ?? false
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(height: 175, child: makeFeatured()),
                    ),
                  ],
                ),
              ],
            ),

            // floatingActionButton: FloatingActionButton(
            //   child: Container(),
            //   onPressed: () async {
            //     await preferences.setBool('loggedIn', false);
            //     await _auth.signOut();
            //     Navigator.pushNamedAndRemoveUntil(
            //         context, Welcome.id, (r) => false);
            //   },
            // ),
          )
        : Center(
            child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ));
  }
}
