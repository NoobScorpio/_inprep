import 'package:flutter/material.dart';
import 'package:InPrep/models/user.dart';
//import 'package:indeed_app/models/user.dart';
import 'package:InPrep/screens/screens/signin.dart';
import 'package:InPrep/screens/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
//import 'package:provider/provider.dart';

//import 'home.dart';

class SignInUp extends StatefulWidget {
  static String id = 'SignInUp';
  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {
  bool isLoading = true;
  bool loggedInUser = false;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  getUser(context) async {
    prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool("loggedIn");
    if (loggedIn == null || loggedIn == false) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        loggedInUser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser(context);
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ),
          )
        : (loggedInUser
            ? Home()
            : Scaffold(
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
                            child: Text('Sign In'),
                          ),
                          Tab(
                            child: Text('Register'),
                          ),
                        ],
                      ),
                      title: Text('Accounts'),
                    ),
                    body: TabBarView(
                      children: [
                        SignIn(),
                        SignUp(),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
