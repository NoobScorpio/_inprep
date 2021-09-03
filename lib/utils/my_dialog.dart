import 'package:flutter/material.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool bioAuth = false;
  bool waitPass = false;
  SharedPreferences preferences;
  TextEditingController passField = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _auth = AuthService();
  bool errView = false;
  @override
  void initState() {
    //
    super.initState();
    startPref();
  }

  startPref() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enable Biometric Auth'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Enter your password'),
            TextField(
              controller: passField,
              obscureText: true,
            ),
            Divider(
              height: 25,
            ),
            Visibility(
              visible: errView,
              child: Text(
                'Wrong password',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Divider(
              height: 25,
            ),
            Text('Would you like to enable biometric authentication?'),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Visibility(
            visible: waitPass,
            child: Text(
              'Please wait',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            setState(() {
              errView = false;
            });
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () async {
            yesBtn();
          },
        ),
      ],
    );
  }

  void yesBtn() async {
    setState(() {
      waitPass = true;
    });
    MyUser fBUser = await _auth.currentUser();
    fBUser = await _databaseService.getcurrentUserData(fBUser.uid);
    // debugPrint("${fBUser.pass}");
    if (passField.text.toString().trimRight().trimLeft() ==
        fBUser.pass.toString().trimRight().trimLeft()) {
      setState(() {
        errView = false;
        waitPass = false;
      });
      await preferences.setBool('bioAuth', true);
      await preferences.setString(
          'email', fBUser.email.toString().trimRight().trimLeft());
      await preferences.setString(
          'pass', fBUser.pass.toString().trimRight().trimLeft());
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        errView = true;
        waitPass = false;
      });
    }
  }
}
