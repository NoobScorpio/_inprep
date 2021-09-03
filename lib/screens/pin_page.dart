import 'package:InPrep/utils/loginUser.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class PinPage extends StatefulWidget {
  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  TextEditingController pinField = TextEditingController();

  bool errView = false, errView2 = false, errView3 = false, errView4 = false;
  SharedPreferences preferences;
  MyUser user;
  final AuthService _auth = AuthService();
  @override
  void initState() {
    //
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _scaffoldKeysPin = GlobalKey<ScaffoldState>();

  Future<void> showSnack(text) {
    _scaffoldKeysPin.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeysPin,
      appBar: AppBar(
        title: Text('Pin Authentication'),
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(''),
              Column(
                children: [
                  Container(
                    width: 170,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        controller: pinField,
                        maxLength: 5,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.keyboard_hide),
                            hintText: 'Enter pin'),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: errView,
                    child: Text(
                      'Length of pin should be 5',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  Visibility(
                    visible: errView2,
                    child: Text(
                      'Pin should only have digits',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  Visibility(
                    visible: errView3,
                    child: Text(
                      'Wrong pin',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  Visibility(
                    visible: errView4,
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FlatButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          'Back',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        )),
                    FlatButton.icon(
                        onPressed: () async {
                          setState(() {
                            errView = false;
                            errView2 = false;
                            errView3 = false;
                            errView4 = false;
                          });

                          if (pinField.text.toString().trim().length < 5) {
                            setState(() {
                              errView = true;
                            });
                          }
                          //LENGTH ELSE
                          else {
                            //print("@PIN ERROR 1");
                            setState(() {
                              errView = false;
                            });
                            try {
                              showSnack('Connecting to server...');
                              //print(pinField.text);
                              int pin =
                                  int.parse(pinField.text.toString().trim());

                              setState(() {
                                errView2 = false;
                              });
                              //GET PIN
                              int getPin = preferences.getInt('pin');
                              //print(getPin);
                              //COMPARE

                              if (pin == getPin) {
                                showSnack('Logging in...');
                                // //print('EQUAL');
                                bool enable =
                                    preferences.getBool('googleSignIn');
                                bool enableApple =
                                    preferences.getBool('appleSignin');
                                //CHECK GOOGLE LOGIN
                                if (enable != null && enable == true) {
                                  MyUser user =
                                      await _auth.signInWIthGoogleCreds();
                                  //print(user);
                                  if (user != null) {
                                    // await loginUserState(context, user);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, Home.id, (route) => false);
                                    await preferences.setBool('loggedIn', true);
                                  } else {
                                    //print("@PIN ERROR 4");
                                    setState(() {
                                      errView4 = true;
                                    });
                                  }
                                } else if (enableApple != null &&
                                    enableApple == true) {
                                  MyUser user =
                                      await _auth.signInWIthAppleCreds();
                                  //print(user);
                                  if (user != null) {
                                    // await loginUserState(context, user);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, Home.id, (route) => false);
                                    await preferences.setBool('loggedIn', true);
                                  } else {
                                    setState(() {
                                      // //print("@PIN ERROR 4");
                                      errView4 = true;
                                    });
                                  }
                                }
                                //ENABLE ELSE
                                else {
                                  var email = preferences.getString('email');
                                  var password = preferences.getString('pass');
                                  if (email == null || password == null) {
                                    showSnack("Login with credentials again");
                                  } else {
                                    MyUser user =
                                        await _auth.signIn(email, password);
                                    if (user != null) {
                                      // await loginUserState(context, user);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, Home.id, (route) => false);
                                      await preferences.setBool(
                                          'loggedIn', true);
                                    } else {
                                      // //print("@PIN ERROR 4");
                                      setState(() {
                                        errView4 = true;
                                      });
                                    }
                                  }
                                }
                              }
                              //PIN COMPARE ELSE
                              else {
                                showSnack('Wrong Pin Code');
                              }
                            } catch (e) {
                              setState(() {
                                errView4 = true;
                              });
                            }
                          }
                        },
                        icon: Icon(
                          Icons.navigate_next,
                          size: 45,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text('')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
