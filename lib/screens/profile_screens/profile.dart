import 'dart:async';
import 'package:InPrep/screens/screens/welcome.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/user_bloc/userState.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/show_case_statics.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/social.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/profile_setup.dart';
import 'package:InPrep/utils/profile_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  static final String id = "Profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences preferences;
  bool dark;
  bool first = false;
  getPref() async {
    preferences = await SharedPreferences.getInstance();
    first = preferences.getBool('firstProfile');
    if (first == null || first == true) {
      await preferences.setBool('firstProfile', false);
      await IntroTexts.showProfileDialog(context);
    }
    setState(() {
      dark = preferences.getBool('dark');
    });
  }

  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final _scaffoldKeyProfile = GlobalKey<ScaffoldState>();
  MyUser user;
  bool isConnected = true;
  @override
  void initState() {
    super.initState();
    isConnectedCheck();
    getPref();
  }

  void showSnack(text) {
    _scaffoldKeyProfile.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
  }

  void isConnectedCheck() async {
    bool result = await DataConnectionChecker().hasConnection;
    //print('CONNECTION IS $result');
    if (result == true) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // MyUser data = MyUser();
    Color color = dark == null
        ? Colors.white
        : (dark ? Colors.white : Theme.of(context).primaryColor);
    return BlocConsumer<UserCubit, UserState>(listener: (context, state) {
      if (state is UserLoadedState) {}
    }, builder: (context, state) {
      //print(state);
      if (state is UserInitialState) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ),
        );
      } else if (state is UserLoadingState)
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
          ),
        );
      else if (state is UserLoadedState) {
        if (state.user != null)
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(state.user.uid)
                // .doc("iIthApqh0nOdUrgmLe5LRZlB3hz1")
                .snapshots(),
            builder: (context, snapshot) {
              // if (!isConnected) {
              //   return GestureDetector(
              //     onTap: () {
              //       showSnack('Refreshing');
              //       // isConnectedCheck();
              //       setState(() {});
              //     },
              //     child: Container(
              //       height: MediaQuery.of(context).size.height,
              //       width: MediaQuery.of(context).size.width,
              //       child: Center(
              //           child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Icon(Icons.wifi_off_outlined),
              //           ),
              //           Text(
              //               'You are not connected to internet. Tap icon to refresh.'),
              //         ],
              //       )),
              //     ),
              //   );
              // }
              if (snapshot.hasData) {
                MyUser user = MyUser.fromJson(snapshot.data.data());
                return Scaffold(
                  key: _scaffoldKeyProfile,
                  appBar: profileAppBar(user: user),
                  body: profileColumn(
                      data: user, color: color, seeker: user.seeker),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileSetup(
                                  seeker: user.seeker,
                                  dark: dark ?? false,
                                  user: user)));

                      setState(() {});
                    },
                    child: Icon(FontAwesomeIcons.userEdit),
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
          );
        else
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          );
      } else {
        return Scaffold(
            key: _scaffoldKeyProfile,
            // appBar: profileAppBar(user: ),
            body: Center(child: Text('Error Loading profile')));
      }
    });
  }

  PreferredSizeWidget profileAppBar({MyUser user}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Profile'),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: GestureDetector(
              onTap: () async {
                if (isConnected) {
                  await preferences.setBool('loggedIn', false);

                  await preferences.setBool('welcome', false);
                  await preferences.setBool('dark', false);
                  AdaptiveTheme.of(context).setLight();
                  await _databaseService.userCollection
                      .doc(user.uid)
                      .update({"pushToken": ""});
                  await _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, Welcome.id, (r) => false);
                } else
                  showSnack('Not connected to internet.');
              },
              child: Text(
                'Logout',
                key: IntroTexts.introK.keys[0],
              )),
        )
      ],
    );
  }

  Widget profileColumn({MyUser data, color, seeker}) {
    if (data.profile)
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
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (seeker)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        HEADER INFO

                        buildHeader(context,
                            dark: dark ?? false,
                            uid: data.uid,
                            state: data.state,
                            category: data.category,
                            subCat: data.subCategory,
                            photoUrl: data.photoUrl,
                            name: data.displayName,
                            designation: data.design,
                            country: data.country,
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
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 20),
                                child: Text(
                                  '${data.desc}',
                                  style: TextStyle(
                                      color: (dark ?? false)
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),

                        SizedBox(height: 20.0),
                        buildTitle("Contact", dark ?? false),
                        SizedBox(height: 10.0),

                        Card(
                          elevation: 6,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 30.0),
                                    Icon(
                                      Icons.mail,
                                      color: color,
                                    ),
                                    SizedBox(width: 10.0),
                                    Text(
                                      "${data.email != null ? data.email : ''}",
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    if (data.verified)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        ),
                                      ),
                                    if (!data.verified)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: InkWell(
                                          onTap: () async {
                                            showLoader(context);
                                            try {
                                              User user = FirebaseAuth
                                                  .instance.currentUser;
                                              await user.reload();
                                              if (user.emailVerified) {
                                                await _databaseService
                                                    .userCollection
                                                    .doc(data.uid)
                                                    .update({"verified": true});
                                                setState(() {
                                                  data.verified = true;
                                                });
                                              } else {
                                                await user
                                                    .sendEmailVerification();
                                                showSnack(
                                                    'Check your email for verification');
                                              }
                                            } catch (e) {}
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Verify now',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                if (data.contact != null)
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 30.0),
                                      Icon(
                                        Icons.phone,
                                        color: color,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        data.contact == null
                                            ? 'Not Added'
                                            : "${data.contact.code}-${data.contact.number}",
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                if (data.contact == null)
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 30.0),
                                      Icon(
                                        Icons.phone,
                                        color: color,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "Not Added",
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                //SOCIAL MEDIA
                                if (data.social != null)
                                  buildSocialsRow(
                                      dark: dark ?? false,
                                      context: context,
                                      fb: data.social.fb,
                                      git: data.social.git,
                                      insta: data.social.tiktok,
                                      tiktok: data.social.tiktok,
                                      linkedin: data.social.linkedin),
                                if (data.social == null)
                                  buildSocialsRow(
                                      dark: dark ?? false,
                                      fb: '',
                                      context: context,
                                      git: '',
                                      insta: '',
                                      tiktok: '',
                                      linkedin: ''),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0),
                        buildTitle("Skype", dark ?? false),
                        if (data.social == null) buildSkype(),
                        if (data.social != null)
                          buildSkype(uname: data.social.skype),
                      ],
                    ),
                  ),
                if (!seeker)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        HEADER INFO
                        if (data != null)
                          buildHeader(context,
                              dark: dark ?? false,
                              state: data.state,
                              uid: data.uid,
                              category: data.category,
                              subCat: data.subCategory,
                              photoUrl: data.photoUrl,
                              name: data.displayName,
                              designation: data.design,
                              country: data.country,
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
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 20),
                                child: Text(
                                  '${data.desc}',
                                  style: TextStyle(
                                      color: (dark ?? false)
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),

//                        USER SKILLS
                        buildTitle("Skills", dark ?? false),
                        Card(
                            elevation: 6,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: skillsWidgets(
                                  context, dark ?? false, data.skills),
                            )),

//                        USER EXPERIENCES
                        buildTitle("Experience", dark ?? false),
                        Card(
                          elevation: 6,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: experienceWidgets(
                                context, dark ?? false, data.experiences),
                          ),
                        ),

//                       PORTFOLIO

                        if (data != null)
                          buildTitle("Portfolio", dark ?? false),
                        if (data != null)
                          Card(
                            elevation: 6,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: portfolioWidgets(
                                  context, dark ?? false, data.portfolio),
                            ),
                          ),

//                        USER EDUCATION
                        SizedBox(height: 20.0),
                        buildTitle("Education", dark ?? false),
                        Card(
                          elevation: 6,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: educationWidgets(
                                context, dark ?? false, data.educations),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        buildTitle("Contact", dark ?? false),
                        SizedBox(height: 5.0),
                        if (data != null)
                          Card(
                            elevation: 6,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 30.0),
                                      Icon(
                                        Icons.mail,
                                        color: color,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        "${data.email}",
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      if (data.verified)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Icon(
                                            Icons.verified,
                                            color: Colors.green,
                                          ),
                                        ),
                                      if (!data.verified)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: InkWell(
                                            onTap: () async {
                                              showLoader(context);
                                              try {
                                                User user = FirebaseAuth
                                                    .instance.currentUser;
                                                await user.reload();
                                                if (user.emailVerified) {
                                                  await _databaseService
                                                      .userCollection
                                                      .doc(data.uid)
                                                      .update(
                                                          {"verified": true});
                                                  setState(() {
                                                    data.verified = true;
                                                  });
                                                } else {
                                                  await user
                                                      .sendEmailVerification();
                                                  showSnack(
                                                      'Check your email for verification');
                                                }
                                              } catch (e) {}
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Verify now',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  buildContact(
                                      contact: data.contact, context: context),
                                  //SOCIAL MEDIA
                                  if (data.social != null)
                                    buildSocialsRow(
                                        dark: dark ?? false,
                                        fb: data.social.fb ?? "",
                                        git: data.social.git ?? "",
                                        linkedin: data.social.linkedin ?? "",
                                        insta: data.social.insta ?? '',
                                        tiktok: data.social.tiktok ?? ""),
                                  if (data.social == null)
                                    buildSocialsRow(
                                        dark: dark ?? false,
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
                        buildTitle("Price Range", dark ?? false),
                        buildPriceRange(context, dark ?? false,
                            from: data.priceFrom ?? '', to: data.priceTo ?? ''),

                        SizedBox(height: 10.0),

                        SizedBox(height: 20.0),
                        buildTitle("Skype", dark ?? false),
                        if (data.social == null) buildSkype(),
                        if (data.social != null)
                          buildSkype(uname: data.social.skype),
                        //REVIEWS
                        SizedBox(height: 20.0),
                        buildTitle("Reviews", dark ?? false),
                        SizedBox(height: 5.0),

                        reviewWidgets(context, dark ?? false, data.reviews),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    else
      return Center(
        child: Text('Make/Edit your profile'),
      );
  }

// Future<MyUser> getUserDataRefresh() {
//   setState(() {});
//   return getUserData();
// }
}
