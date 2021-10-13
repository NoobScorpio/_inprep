import 'dart:io';
import 'dart:ui';

import 'package:InPrep/models/database.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/loginUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/screens/pin_page.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/my_button.dart';
import 'package:InPrep/utils/my_divider.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/auth_strings.dart';
import 'home.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  static String id = 'SignIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email, pass, resetEmail;
  bool seeker = true, remember = false;
  Seeker seek = Seeker.yes;
  bool _obscureText = true;
  var subscription;
  var catValue = 'Select';
  var subCatValue;
  final _formKeySignIn = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController otherCont = TextEditingController();
  void showSnack(text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  SharedPreferences preferences;
  bool dark = false;
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      dark = preferences.getBool('dark');
    });
    //print("GET BOOLEAN IN SESSIONS ${preferences.getBool('dark')}");
  }

  @override
  void initState() {
    super.initState();
    subCatValue = subs[catValue][0];
    getPref();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => getBioAuth());
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final LocalAuthentication auth = LocalAuthentication();

  bool canCheckBiometrics = false;
  bool bioAuth = false;
  String noInternet = 'Not connected to internet';
  getBioAuth() async {
    preferences = await SharedPreferences.getInstance();
    bool show = preferences.getBool('bioAuth');
    if (show == null) {
      preferences.setBool('bioAuth', false);
      setState(() {
        bioAuth = false;
      });
    } else {
      setState(() {
        bioAuth = show;
      });
    }
  }

  Future<bool> checkBiometric() async {
    bool authenticated = false;
    if (bioAuth == null || bioAuth == false) {
      showSnack('Biometrics not Enabled');
      return false;
    } else {
      try {
        canCheckBiometrics = await auth.canCheckBiometrics;
        if (!mounted) return false;
        List<BiometricType> availableBiometrics;
        availableBiometrics = await auth.getAvailableBiometrics();

        if (Platform.isIOS) {
          const iosStrings = const IOSAuthMessages(
              cancelButton: 'cancel',
              goToSettingsButton: 'settings',
              goToSettingsDescription: 'Please set up your Touch ID.',
              lockOut: 'Please re-enable your Touch ID');
          if (availableBiometrics.contains(BiometricType.face) ||
              availableBiometrics.contains(BiometricType.fingerprint)) {
            authenticated = await auth.authenticate(
              localizedReason: "Please authenticate to login",
              useErrorDialogs: true,
              iOSAuthStrings: iosStrings,
              stickyAuth: true,
            );
          } else
            authenticated = false;

          return authenticated;
        } else {
          authenticated = await auth.authenticate(
            localizedReason: 'Touch your finger on the sensor to login',
            useErrorDialogs: false,
            stickyAuth: false,
          );
          return authenticated;
        }
      } catch (e) {
        showSnack("error using biometric auth: $e");
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mainCol = Theme.of(context).primaryColor;
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Opacity(
              opacity: 0.09,
              child: Image.asset(
                "assets/images/bg.jpg",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Form(
                key: _formKeySignIn,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0, bottom: 60),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/icons/logo1024.png'),
                          ),
                        ],
                      ),
                    ),

//              EMAIL OR USERNAME
                    MyTextFormField(
                      labelText: 'Email',
                      validator: (text) {
                        if (text.toString().length == 0) {
                          email = text;
                          return 'Enter a valid Email';
                        } else {
                          if (text.toString().length < 12) {
                            return 'Enter a valid Email';
                          } else {
                            email = text;
                            return null;
                          }
                        }
                      },
                      onChanged: (val) {
                        email = val.toString().trim().toLowerCase();
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    MyDivider(),
//              PASSWORD
                    MyTextFormField(
                      labelText: 'Password',
                      icon: GestureDetector(
                        onTap: _toggle,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5),
                            child: const Icon(Icons.remove_red_eye)),
                      ),
                      obscureText: _obscureText,
                      validator: (text) {
                        if (text.toString().length == 0) {
                          pass = text;
                          return 'Enter password.';
                        } else if (text.toString().length < 8) {
                          pass = text;
                          return 'Password has to 8 character long. ';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (text) {
                        pass = text.toString().trim();
                      },
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
                        child: Row(
                          children: [
                            Checkbox(
                                value: remember,
                                onChanged: (val) {
                                  setState(() {
                                    remember = val;
                                  });
                                }),
                            Text(
                              'Remember me',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter
                                          setState /*You can rename this!*/) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        bottom:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    child: Container(
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              child: MyTextFormField(
                                                labelText: 'Email',
                                                onChanged: (val) {
                                                  resetEmail = val
                                                      .toString()
                                                      .trim()
                                                      .toLowerCase();
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: MyButton(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Text('Send'),
                                                  onPressed: () async {
                                                    if (resetEmail != '' &&
                                                        resetEmail != null) {
                                                      showLoader(context);
                                                      bool reset = await _auth
                                                          .resetPassword(
                                                              resetEmail,
                                                              context);
                                                      Navigator.pop(context);
                                                      if (reset) {
                                                        Navigator.pop(context);
                                                      }
                                                    } else
                                                      showToast(context,
                                                          "Kindly write your email address");
                                                  },
                                                  textColor: Colors.white),
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              });
                            });
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, bottom: 20.0),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    // SIGNIN BUTTON
                    MyButton(
                      child: Text('Sign in'),
                      height: 50.0,
                      minWidth: 250.0,
                      color: mainCol,
                      textColor: Colors.white,
                      onPressed: () async {
                        showLoader(context);
                        if (await DataConnectionChecker().hasConnection) {
                          if (_formKeySignIn.currentState.validate()) {
                            // showSnack('Waiting for response from server.');
                            var result = await _auth.signIn(
                                email.trim().toLowerCase(), pass);
                            //print("YES THE RES IS $result");
                            if (result != null && result != 'NOUSER') {
                              Navigator.pop(context);
                              await preferences.setBool('googleSignIn', false);
                              await preferences.setBool('appleSignin', false);
                              await preferences.setBool('loggedIn', true);
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Home.id, (route) => false);

                              // print(
                              //     "LOGGED IN VALUE ${preferences.getBool("loggedIn")}");
                              // //print(
                              //     "@USER BEFORE BLOC $context and ${_scaffoldKey.currentContext}");
                              // bool bloc = await loginUserState(
                              //     _scaffoldKey.currentContext ?? context,
                              //     result);
                              // //print("@USER AFTER BLOC $bloc");
                              // if (bloc)
                              // Navigator.pushNamedAndRemoveUntil(
                              //     context, Home.id, (route) => false);
                              // else
                              //   showSnack("Nothing");
                            } else if (result.toString().contains('NOUSER')) {
                              Navigator.pop(context);
                              showSnack('No Such Email exists...');
                            } else {
                              Navigator.pop(context);
                              showSnack('Wrong Email or Password');
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        } else {
                          Navigator.pop(context);
                          showSnack(noInternet);
                        }
                      },
                    ),
                    MyDivider(
                      height: 30.0,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Or choose an option',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(
                                        'Login Via Google/Apple',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      content: Container(
                                        height: 60,
                                        child: Column(
                                          children: [
                                            Text(
                                                'While signing through here remember to select your account type.'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text('ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(
                                Icons.info_outline,
                                size: 20,
                                color: mainCol,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MyDivider(
                      height: 10.0,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text('Select account type'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Seeker',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Radio(
                              value: Seeker.yes,
                              groupValue: seek,
                              onChanged: (value) {
                                setState(() {
                                  seek = value;
                                  seeker = true;
                                });
                              },
                            ),
                            Text(
                              'Consultant',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                              ),
                            ),
                            Radio(
                              value: Seeker.no,
                              groupValue: seek,
                              onChanged: (value) {
                                setState(() {
                                  seek = value;
                                  seeker = false;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (!seeker) Text('Select a category'),
                        if (!seeker)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),

                                // dropdown below..
                                child: DropdownButton<String>(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconSize: 42,
                                  value: catValue,
                                  underline: SizedBox(),
                                  items: catList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text('$value'),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    setState(() {
                                      catValue = _;
                                      subCatValue = subs[catValue][0];
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),

                                // dropdown below..
                                child: DropdownButton<String>(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconSize: 42,
                                  value: subCatValue,
                                  underline: SizedBox(),
                                  items: subs[catValue].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text('$value'),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    setState(() {
                                      subCatValue = _;
                                    });
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                            'Category',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          content: Container(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Text(categoryString),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text('ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: mainCol,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!seeker)
                          SizedBox(
                            height: 15,
                          ),
                        if (subCatValue == "Other")
                          MyTextFormField(
                            labelText: 'Write Sub Category',
                            maxline: 1,
                            controller: otherCont,
                            maxLength: 50,
                            onChanged: (val) {
                              if (val != '' && val != null && val.length <= 1) {
                                otherCont.text = otherCont.text.toUpperCase();
                                otherCont.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: otherCont.text.length));
                              }
                            },
                          ),
                        SizedBox(
                          height: 15,
                        ),
                        // GOOGLE SIGNIN
                        Container(
                          height: 60,
                          width: 250,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              // side: BorderSide(color: Colors.red)
                            ),
                            color: Colors.red,
                            onPressed: () async {
                              if (await DataConnectionChecker().hasConnection) {
                                if ((seeker == null || seeker == false) &&
                                    subCatValue == "Other") {
                                  if (otherCont.text == null ||
                                      otherCont.text == "")
                                    showToast(
                                        context, "Please write sub category");
                                  else {
                                    signInWithGoogle(otherCont.text);
                                  }
                                } else {
                                  signInWithGoogle("");
                                }
                              } else
                                showSnack('Not connect to internet.');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: Image(
                                    image:
                                        AssetImage('assets/icons/fb_icon.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 15,
                        ),
// APPLE SIGNIN
                        Container(
                          height: 60,
                          width: 250,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              // side: BorderSide(color: Colors.red)
                            ),
                            color: Colors.black87,
                            textColor: Colors.white,
                            onPressed: () async {
                              if (await DataConnectionChecker().hasConnection) {
                                if (!seeker && subCatValue == "Other") {
                                  if (otherCont.text == null ||
                                      otherCont.text == "")
                                    showToast(
                                        context, "Please write sub category");
                                  else {
                                    signInWithApple(otherCont.text);
                                  }
                                } else {
                                  signInWithApple("");
                                }
                              } else
                                showSnack(noInternet);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.apple,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sign in with Apple',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        MyDivider(
                          height: 20.0,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login via',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                            'Biometric/PIN Authentication',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          content: Container(
                                            height: 120,
                                            child: Column(
                                              children: [
                                                Text(
                                                    'You need to Login via google or register to use these settings'),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Biometric and PIN Authentication can be enabled from the settings'),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text('ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: mainCol,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //BIO
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // side: BorderSide(color: Colors.red)
                                ),
                                onPressed: () {
                                  bool enable = preferences.getBool('bioAuth');
                                  if (enable == null || enable == false) {
                                    showSnack('Biometric Auth not Enabled...');
                                  } else {
                                    biometricLogin(
                                        context: context, mainCol: mainCol);
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.fingerprint,
                                        color: Colors.white,
                                      ),
                                      Icon(
                                        Icons.face,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              //PIN
                              FlatButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  // side: BorderSide(color: Colors.red)
                                ),
                                onPressed: () async {
                                  bool enabled = preferences.get('pinAuth');
                                  if (enabled == null || enabled == false) {
                                    showSnack('Pin auth not enabled.');
                                  } else {
                                    if (await DataConnectionChecker()
                                        .hasConnection) {
                                      bool enable =
                                          preferences.getBool('pinAuth');
                                      if (enable == null) {
                                        showSnack('Pin Auth not Enabled');
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => PinPage()));
                                      }
                                    } else
                                      showSnack(noInternet);
                                  }
                                },
                                child: Icon(
                                  Icons.keyboard,
                                  color: Colors.white,
                                ),
                              ),
                            ]),
                      ],
                    ),
                    MyDivider(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void signInWithApple(other) async {
    showLoader(context);

    dynamic user = await _auth.signInWithApple(
        seeker: seeker,
        subCat: subCatValue,
        other: other,
        category: catValue.toString().trim().toLowerCase());
    if (user.runtimeType == String) {
      if (user == 'Category') {
        showToast(context, "Please select a category");
        Navigator.pop(context);
      }
      if (user == 'Sub') {
        showToast(context, "Please select a sub category");
        Navigator.pop(context);
      }
    } else {
      if (user != null) {
        await preferences.setBool('loggedIn', true);
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
      } else {
        Navigator.pop(context);
      }
    }
  }

  void signInWithGoogle(other) async {
    showLoader(context);
    print("INSIDE METHOD");
    try {
      dynamic user = await _auth.signInWithGoogle(
          seeker: seeker,
          other: other,
          subCat: subCatValue,
          category: catValue.toString().trim().toLowerCase());
      if (user.runtimeType == String) {
        if (user == 'Category') {
          showToast(context, "Please select a category");
          Navigator.pop(context);
        }
        if (user == 'Sub') {
          showToast(context, "Please select a sub category");
          Navigator.pop(context);
        }
      } else {
        if (user != null) {
          await preferences.setBool('loggedIn', true);
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void biometricLogin({context, mainCol}) async {
    bool authenticated = await checkBiometric();

    if (authenticated == null || authenticated == false) {
      showSnack('InPrep could not authenticate the user');
    } else {
      bool isGoogle = preferences.getBool('googleSignIn');
      bool isApple = preferences.getBool('appleSignin');
      if (isGoogle != null && isGoogle == true) {
        showSnack('Logging in...');
        MyUser user = await _auth.signInWIthGoogleCreds();

        //print(user);
        if (user == null) {
          showSnack('Login with Google again');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
          await preferences.setBool('loggedIn', true);

          // await loginUserState(_scaffoldKey.currentContext, user);
        }
      } else if (isApple != null && isApple == true) {
        showSnack('Logging in...');
        MyUser user = await _auth.signInWIthAppleCreds();
        //print(user);
        if (user == null) {
          showSnack('Login with Apple again');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
          await preferences.setBool('loggedIn', true);
          // Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
          // await loginUserState(_scaffoldKey.currentContext, user);
        }
      } else {
        MyUser user;
        showSnack('Logging in...');
        var email = preferences.getString('email');
        var password = preferences.getString('pass');
        if (email == null || password == null) {
          showSnack('Login with credentials again');
        } else {
          user = await _auth.signIn(email, password);
          if (user != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, Home.id, (route) => false);
            await preferences.setBool('loggedIn', true);
            // Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
            // await loginUserState(_scaffoldKey.currentContext, user);
          } else {
            showSnack('Something went wrong');
          }
        }
      }
    }
  }
}

enum Seeker { yes, no }
