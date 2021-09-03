import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyPinDialog extends StatefulWidget {
  @override
  _MyPinDialogState createState() => new _MyPinDialogState();
}

class _MyPinDialogState extends State<MyPinDialog> {
  bool pinAuth = false;
  bool waitPass = false;
  SharedPreferences preferences;
  TextEditingController pinField = TextEditingController();
  bool errView = false;

  bool errView2 = false;
  @override
  void initState() {
    super.initState();
    startPref();
  }

  startPref() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              'Enable Pin Auth',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      autofillHints: ['Enter 5 digits'],
                      controller: pinField,
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      // decoration: InputDecoration(
                      //     suffixIcon: Icon(Icons.keyboard_hide),
                      //     hintText: 'Enter 5 digit pin'),
                    ),
                  ),
                  // Divider(
                  //   height: 25,
                  // ),
                  Visibility(
                    visible: errView,
                    child: Text(
                      'Pin should have 5 digits',
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
                  // Divider(

                  //   height: 25,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enter 5 digits pin.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    'Would you like to enable pin authentication?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Text('No'),
                onPressed: () {
                  setState(() {
                    errView = false;
                    errView2 = true;
                  });
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoButton(
                child: Text('Yes'),
                onPressed: () async {
                  if (pinField.text.toString().trim().length < 5) {
                    setState(() {
                      errView = true;
                    });
                  } else {
                    setState(() {
                      errView = false;
                    });
                    try {
                      int pin = int.parse(pinField.text.toString().trim());
                      // print(pin);
                      setState(() {
                        errView2 = false;
                      });
                      // print('SETTING PIN');
                      await preferences.setInt('pin', pin);
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      setState(() {
                        errView2 = true;
                      });
                    }
                  }
                },
              ),
            ],
          )
        : AlertDialog(
            title: Text(
              'Enable Pin Auth',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: pinField,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.keyboard_hide),
                        hintText: 'Enter 5 digit pin'),
                  ),
                  Divider(
                    height: 25,
                  ),
                  Visibility(
                    visible: errView,
                    child: Text(
                      'Pin should have 5 digits',
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
                  Divider(
                    height: 25,
                  ),
                  Text(
                    'Would you like to enable pin authentication?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  setState(() {
                    errView = false;
                    errView2 = true;
                  });
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  if (pinField.text.toString().trim().length < 5) {
                    setState(() {
                      errView = true;
                    });
                  } else {
                    setState(() {
                      errView = false;
                    });
                    try {
                      int pin = int.parse(pinField.text.toString().trim());
                      // print(pin);
                      setState(() {
                        errView2 = false;
                      });
                      // print('SETTING PIN');
                      await preferences.setInt('pin', pin);
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      setState(() {
                        errView2 = true;
                      });
                    }
                  }
                },
              ),
            ],
          );
  }
}
