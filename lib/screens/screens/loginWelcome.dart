import 'package:flutter/material.dart';

class LoginWelcome extends StatefulWidget {
  @override
  _LoginWelcomeState createState() => _LoginWelcomeState();
}

class _LoginWelcomeState extends State<LoginWelcome> {
  GlobalKey a = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "assets/images/welcome.png",
                ),
              ),
            ),
            Text(
              "Hello Everyone and Welcome to inPrep, \n\n"
              "Here we have a unique platform where anyone can make money based on their knowledge. "
              "You may not be an expert or have a degree in a particular field but you have some knowledge to share.\n\n"
              "Here is an example, you could have a recipe that is missing an ingredient "
              "and someone who knows that recipe can fill in the blank. The possibilities for a consultant are endless "
              "and the knowledge for a seeker to gain is in abundance. \n\nEach consultant is broken down into categories of their choosing. "
              "We have provided examples under each category to guide consultants where they will best fit.\n\n"
              "However a consultant can be searched by keywords, name, profession, filtered by reviews, and many more. "
              "Once again we welcome you to inPrep and wish you all success!",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  letterSpacing: 1,
                  fontFamily: 'arial'),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ok',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
