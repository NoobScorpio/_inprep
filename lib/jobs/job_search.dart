import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';

import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/profile_widgets.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import '../screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';

class JobSearch extends StatefulWidget {
  final job, uid;
  JobSearch({this.job, this.uid});
  static String id = 'JobSearch';
  @override
  _JobSearchState createState() => _JobSearchState(job: job, uid: uid);
}

class _JobSearchState extends State<JobSearch> {
  final job;
  final GlobalKey<ScaffoldState> jobViewKey2 = new GlobalKey<ScaffoldState>();
  void showSnack(text) {
    jobViewKey2.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }

  final uid;
  _JobSearchState({this.job, this.uid});

  DatabaseService _databaseService = DatabaseService();

  getUser({yes}) async {
    // MyUser getuser = await _databaseService.getcurrentUserData(uid);
    if (yes)
      setState(() {
        // user = getuser;
      });
  }

  void initState() {
    super.initState();
    getUser(yes: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => getUser(yes: true));
  }

  MyUser u;
  MyUser user = MyUser();

  bool loggedin = true;
  bool seeker;

  @override
  Widget build(BuildContext context) {
    final userLog = Provider.of<MyUser>(context);
    print('$userLog IS THE LOGGED IN USER');
    if (userLog == null)
      loggedin = false;
    else
      loggedin = true;
    print('$loggedin is th LOG');
    return Scaffold(
      key: jobViewKey2,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileView(uid: user.uid)));
                  },
                  child: buildHeader(context,
                      photoUrl: user.photoUrl,
                      name: user.displayName != null
                          ? user.displayName
                          : 'Unknown',
                      designation:
                          user.design != null ? user.design : 'Unknown',
                      city: user.city != null ? user.city : 'Unknown',
                      country: user.country != null ? user.country : 'Unknown'),
                ),
                SizedBox(height: 20.0),
                SizedBox(height: 20.0),
                // buildTitle(job.title,dark),
                SizedBox(height: 5.0),
                buildSalaryRow(context,
                    salary1: job.salaryFrom.toString(),
                    salary2: job.salaryTo.toString()),
                // buildExpRow(context, year: job.exp.toString()),
                buildLocRow(context, city: job.city, country: job.country),
                SizedBox(height: 20.0),
                // buildTitle("Description"),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, left: 20, right: 20, top: 10),
                  child: Text(
                    job.desc,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 20.0, left: 20, right: 20, top: 0),
                  child: GestureDetector(
                    onTap: () async {
                      if (loggedin) {
                        showSnack('Setting up chat');

                        MyUser senderUid = await AuthService().currentUser();
                        var sender = await _databaseService
                            .getcurrentUserData(senderUid.uid);
                        print('${sender.uid} && ${user.uid}');
                        String isThere = await _databaseService.searchChat(
                            sid: sender.uid, rid: user.uid);
                        if (isThere != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                        // user: sender,
                                        cid: isThere,
                                        name: user.displayName,
                                      )));
                        } else {
                          var cid = await _databaseService.createChat(
                              sender: sender.displayName,
                              receiver: user.displayName,
                              rid: user.uid,
                              sid: sender.uid);
                          if (cid != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                          // user: sender,
                                          cid: cid,
                                          name: user.displayName,
                                        )));
                          } else {
                            showSnack('Something went wrong');
                          }
                        }
                      } else
                        showSnack('Login or Signup to contact');
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
                            color: Theme.of(context).primaryColor),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
