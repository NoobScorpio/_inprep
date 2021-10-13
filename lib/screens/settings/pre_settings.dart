import 'dart:io';

import 'package:InPrep/screens/settings/SupportScreen.dart';
import 'package:InPrep/screens/settings/faqs.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/loginUser.dart';
import 'package:InPrep/utils/show_case_statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/screens/settings/settings.dart';
import 'package:InPrep/screens/screens/welcome.dart';
import 'package:InPrep/utils/hyml.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_reviews.dart';
import 'my_orders.dart';
import 'my_payments.dart';
import 'my_sessions.dart';

class PreSettings extends StatefulWidget {
  final MyUser user;

  const PreSettings({Key key, this.user}) : super(key: key);
  @override
  _PreSettingsState createState() => _PreSettingsState(user: user);
}

class _PreSettingsState extends State<PreSettings> {
  _PreSettingsState({this.user});
  SharedPreferences preferences;
  final DatabaseService _databaseService = DatabaseService();
  final MyUser user;
  final _scaffoldKeys = GlobalKey<ScaffoldState>();
  bool first = false;
  @override
  void initState() {
    super.initState();
    firstView();
  }

  void firstView() async {
    preferences = await SharedPreferences.getInstance();
    first = preferences.getBool('firstSetting');
    if (first == null || first == true) {
      await preferences.setBool('firstSetting', false);
      IntroTexts.introDE.start(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeys,
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
          Column(
            children: [
              Expanded(
                child: ListView(
                  // shrinkWrap: true,
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Theme.of(context).primaryColor,
                              height: 175,
                              width: double.maxFinite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: BackButton(
                                        key: IntroTexts.introDE.keys[1],
                                        color: Colors.white,
                                      )),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, bottom: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(360)),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: CachedNetworkImage(
                                                imageUrl: user.photoUrl ?? "",
                                                imageBuilder: (context, image) {
                                                  return Container(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    360)),
                                                        color: Colors.grey),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Container(
                                                        width: 60.0,
                                                        height: 60.0,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            360)),
                                                            image:
                                                                DecorationImage(
                                                                    image:
                                                                        image,
                                                                    fit: BoxFit
                                                                        .cover)),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                placeholder: (context, image) {
                                                  return Container(
                                                    width: 60.0,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    360)),
                                                        color: Colors.grey),
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorWidget:
                                                    (context, image, err) {
                                                  if (user.photoUrl == "" ||
                                                      user.photoUrl == null)
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          360)),
                                                          color: Colors.grey),
                                                      width: 60.0,
                                                      height: 60.0,
                                                      child: Center(
                                                        child: Center(
                                                          child: Text(
                                                            "${user.displayName == null || user.displayName == "" ? user.email[0].toUpperCase() : user.displayName[0].toUpperCase()}",
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  else {
                                                    return Container(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      child: Center(
                                                        child: InkWell(
                                                          onTap: () {
                                                            showToast(context,
                                                                "Error loading profile image. Re-upload to view");
                                                          },
                                                          child: Center(
                                                            child: Icon(
                                                                Icons.error),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0, left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${(user.displayName ?? "").toUpperCase()}",
                                                  style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${user.design ?? ""}",
                                                  style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            )
                          ],
                        ),
                        Positioned(
                          // alignment: Alignment.bottomCenter,
                          left: 0,
                          right: 0,
                          bottom: 0,

                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 50),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                ),
                                child: SwitchListTile(
                                  key: IntroTexts.introDE.keys[0],
                                  inactiveThumbColor:
                                      Theme.of(context).primaryColor,
                                  activeColor: Theme.of(context).primaryColor,
                                  activeTrackColor:
                                      Theme.of(context).primaryColor,
                                  inactiveTrackColor: Colors.black87,
                                  title: Text('Seeker Mode',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold)),
                                  value: user == null
                                      ? true
                                      : user.seeker == null
                                          ? true
                                          : user.seeker,
                                  onChanged: (v) async {
                                    showLoader(context);
                                    await _databaseService.userCollection
                                        .doc(user.uid)
                                        .update({"seeker": v});
                                    MyUser usr = user;
                                    usr.seeker = v;
                                    await loginUserState(context, usr);
                                    Navigator.pop(context);
                                    setState(() {
                                      user.seeker = v;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              //TERMS OF SERVICES

                              MySideNavComponent(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HtmlView()));
                                },
                                icon: Icon(
                                  Icons.list,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: 'Term of Services',
                              ),

                              //PRIVACY POLICY

                              MySideNavComponent(
                                onTap: () async {
                                  var url =
                                      "https://www.iubenda.com/privacy-policy/79448906";
                                  try {
                                    if (await canLaunch(url)) {
                                      //print('yes');
                                      await launch(url);
                                    }
                                  } catch (e) {
                                    //print(e);
                                    //print('Could not launch the link');
                                  }
                                },
                                icon: Icon(
                                  Icons.description,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: 'Privacy Policy',
                              ),
                              MySideNavComponent(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FAQScreen()));
                                },
                                icon: Icon(
                                  Icons.question_answer_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: 'Frequently Asked Questions',
                              ),
                              //My Sessions

                              MySideNavComponent(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              MySessions(user: user)));
                                },
                                icon: Icon(
                                  Icons.work,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: 'My Sessions',
                              ),

                              //My Payments

                              if (user == null ? true : user.seeker)
                                MySideNavComponent(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                MyPayments(user: user)));
                                  },
                                  icon: Icon(
                                    Icons.payment,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: 'My Payments',
                                ),

                              //My Orders

                              if (user == null ? true : !user.seeker)
                                MySideNavComponent(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                MyOrders(user: user)));
                                  },
                                  icon: Icon(
                                    Icons.payment,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: 'My Orders',
                                ),

                              //My REVIEWS

                              if (user == null ? true : !user.seeker)
                                MySideNavComponent(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                MyReviews(user: user)));
                                  },
                                  icon: Icon(
                                    Icons.payment,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: 'My Reviews',
                                ),
                              MySideNavComponent(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SupportScreen()));
                                },
                                icon: Icon(
                                  Icons.contact_support_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: 'Support',
                              ),

                              //Settings

                              MySideNavComponent(
                                onTap: () {
                                  Navigator.pushNamed(context, Settings.id);
                                },
                                icon: Icon(
                                  Icons.settings,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: 'Settings',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('© InPrep LLC', style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MySideNavComponent extends StatelessWidget {
  const MySideNavComponent({
    Key key,
    this.onTap,
    this.icon,
    this.title,
  }) : super(key: key);
  final onTap;
  final icon;
  final title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: icon,
            ),
            Text(
              '$title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
