import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/loginUser.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/screens/screens/home.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/my_button.dart';
import 'package:InPrep/utils/my_divider.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Seeker { yes, no }

class SignUp extends StatefulWidget {
  static String id = 'SignUp';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  String email = '', pass = '', uname = '';
  String confirmPass = '';
  bool seeker = true;
  bool _obscureText = true, _obscureText2 = true;
  String catValue = 'Select';
  var subCatValue;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKeySignUp = GlobalKey<ScaffoldState>();
  final TextEditingController otherCont = TextEditingController();
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Seeker seek = Seeker.yes;

  SharedPreferences preferences;
  bool dark = false;
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      dark = preferences.getBool('dark');
    });
    //print("GET BOOLEAN IN SESSIONS ${preferences.getBool('dark')}");
  }

  void showSnack(text) {
    _scaffoldKeySignUp.currentState.showSnackBar(SnackBar(
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

  @override
  void initState() {
    super.initState();
    subCatValue = subs[catValue][0];
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeySignUp,
      body: Stack(children: [
        Opacity(
          opacity: 0.09,
          child: Image.asset(
            "assets/images/bg.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 60),
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'xyz',
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/icons/logo1024.png'),
                      ),
                    ),
                  ],
                ),
              ),

//              USERNAME
              MyTextFormField(
                labelText: 'Full Name',
                onChanged: (val) {
                  uname = val.toString().trim().toLowerCase();
                },
                validator: (val) {
                  if (val.toString().trim().isEmpty) {
                    return 'Enter a Name';
                  } else if (val.toString().length < 6) {
                    return 'Name should have atleast 6 characters';
                  } else
                    return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              MyDivider(),
//              EMAIL
              MyTextFormField(
                labelText: 'Email',
                validator: (val) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)'
                      r'|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]'
                      r'{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (regex.hasMatch(val.trim().toString().toLowerCase())) {
                    email = val;
                    return null;
                  } else {
                    email = val;
                    return 'Enter a valid Email';
                  }
                },
                onChanged: (val) {
                  email = val
                      .trim()
                      .toString()
                      .toLowerCase()
                      .trim()
                      .trimRight()
                      .trimLeft();
                  //print(email);
                  //print(email.length);
                },
              ),
              MyDivider(),
//              PASSWORD
              MyTextFormField(
                labelText: 'Password',
                validator: (text) {
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  if (regExp.hasMatch(text)) {
                    pass = text;
                    return null;
                  } else {
                    if (text.toString().length == 0) {
                      pass = text.toString();
                      return 'Enter password';
                    } else {
                      pass = text.toString();
                      return 'Enter atleast 8 characters, 1 Upper,1 Lower, 1 Numeric, 1 Special character minimum.';
                    }
                  }
                },
                obscureText: _obscureText,
                icon: GestureDetector(
                  onTap: _toggle,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5),
                      child: const Icon(Icons.remove_red_eye)),
                ),
                onChanged: (text) {
                  pass = text.toString();
                },
              ),
              MyDivider(),
//              CONFIRM PASSWORD
              MyTextFormField(
                labelText: 'Confirm Password',
                validator: (text) {
                  if (pass == confirmPass) {
                    confirmPass = text.toString();
                    return null;
                  } else {
                    confirmPass = text.toString();
                    return 'Passwords don\'t match.';
                  }
                },
                obscureText: _obscureText2,
                icon: GestureDetector(
                  onTap: _toggle2,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5),
                      child: const Icon(Icons.remove_red_eye)),
                ),
                onChanged: (text) {
                  confirmPass = text.toString();
                },
              ),
              MyDivider(
                height: 5.0,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select account type'),
              )),
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
              MyDivider(
                height: 5.0,
              ),
              if (!seeker)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Select a category'),
                  ),
                ),
              if (!seeker)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),

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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),

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
                            print(subCatValue);
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
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              MyDivider(
                height: 5.0,
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
                      otherCont.selection = TextSelection.fromPosition(
                          TextPosition(offset: otherCont.text.length));
                    }
                  },
                ),
              MyDivider(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  child: Text('Create'),
                  height: 50.0,
                  minWidth: 250.0,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (await DataConnectionChecker().hasConnection) {
                      dynamic result;

                      if (_formKey.currentState.validate()) {
                        if (catValue == 'Select' && seeker == false)
                          showToast(context, 'Please select a category');
                        else if (subCatValue == 'Select' && seeker == false)
                          showToast(context, 'Please select a sub category');
                        else {
                          if (subCatValue == 'Other') {
                            if (otherCont.text == null ||
                                otherCont.text == "") {
                              showToast(context, "Please enter sub category");
                            } else {
                              showLoader(context);
                              result = await _auth.register(
                                  email: email.trim().trimRight().trimLeft(),
                                  password: pass,
                                  uname: uname,
                                  seeker: seeker,
                                  category: seeker ? "Business" : catValue,
                                  subCat: seeker ? "Accounting" : subCatValue,
                                  other: otherCont.text);
                              if (result
                                  .toString()
                                  .contains('ERROR_EMAIL_ALREADY_IN_USE')) {
                                Navigator.pop(context);
                                showToast(context, "Email already in use");
                              } else {
                                if (result != null) {
                                  // SharedPreferences preferences;

                                  // await loginUserState(context, result);
                                  await preferences.setBool(
                                      'googleSignIn', false);
                                  await preferences.setBool(
                                      'appleSignin', false);
                                  await preferences.setBool('loggedIn', true);
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Home.id, (route) => false);
                                } else {
                                  Navigator.pop(context);
                                  showToast(context, "Server not responding");
                                }
                              }
                            }
                          } else {
                            showLoader(context);
                            result = await _auth.register(
                                email: email.trim().trimRight().trimLeft(),
                                password: pass,
                                uname: uname,
                                seeker: seeker,
                                category: seeker ? "Business" : catValue,
                                subCat: seeker ? "Accounting" : subCatValue,
                                other: "");
                            if (result
                                .toString()
                                .contains('ERROR_EMAIL_ALREADY_IN_USE')) {
                              Navigator.pop(context);
                              showToast(context, "Email already in use");
                            } else {
                              if (result != null) {
                                // SharedPreferences preferences;

                                // await loginUserState(context, result);
                                await preferences.setBool(
                                    'googleSignIn', false);
                                await preferences.setBool('appleSignin', false);
                                await preferences.setBool('loggedIn', true);
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, Home.id, (route) => false);
                              } else {
                                Navigator.pop(context);
                                showToast(context, "Server not responding");
                              }
                            }
                          }
                        }
                      }
                    } else {
                      showSnack('Not connected to internet.');
                    }
                  },
                ),
              ),
              MyDivider(
                height: 60.0,
              ),
            ],
          ),
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     AdaptiveTheme.of(context).setLight();
      //   },
      // ),
    );
  }
}
