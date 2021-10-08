import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/screens/home.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:InPrep/utils/darkMode.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/screens/screens/intro.dart';
import 'package:InPrep/screens/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:push_notification_permissions/push_notification_permissions.dart';

class PreIntro extends StatefulWidget {
  static String id = 'pre';
  @override
  _PreIntroState createState() => _PreIntroState();
}

class _PreIntroState extends State<PreIntro> {
  String initialRoute = '';
  SharedPreferences preferences;
  displayShowCase(context) async {
    preferences = await SharedPreferences.getInstance();
    bool show = preferences.getBool('intro');
    if (show == null) {
      preferences.setBool('intro', false);
      await preferences.setBool('noti', true);
      await toogleLightMode(context);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      displayShowCase(context).then((value) {
        if (value)
          Navigator.pushNamedAndRemoveUntil(
              context, IntroScreen.id, (_) => false);
        else {
          // final user = Provider.of<MyUser>(context);
          bool loggedIn = preferences.getBool('loggedIn');
          print("LOGGED IN VALUE $loggedIn");
          if (loggedIn == null)
            Navigator.pushNamedAndRemoveUntil(
                context, Welcome.id, (_) => false);
          else if (loggedIn == false)
            Navigator.pushNamedAndRemoveUntil(
                context, Welcome.id, (_) => false);
          else
            Navigator.pushNamedAndRemoveUntil(context, Home.id, (_) => false);
        }
      });
    });
    return Container(
      height: 60,
      width: 60,
      color: Colors.black,
      child: Center(
        child: Image(
          image: AssetImage('assets/icons/logo40.png'),
        ),
      ),
    );
  }
}
