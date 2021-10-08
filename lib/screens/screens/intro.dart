import 'package:flutter/material.dart';
import 'package:InPrep/screens/screens/welcome.dart';
import 'package:InPrep/models/user.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  final MyUser user;
  IntroScreen({this.user});
  static String id = 'intro';
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  SharedPreferences preferences;
  bool dark;
  getPref() async {
    preferences = await SharedPreferences.getInstance();
    preferences.setBool('dark', false);
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void _onIntroEnd(context) {
    Navigator.pushNamedAndRemoveUntil(context, Welcome.id, (route) => false);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image(
        image: AssetImage('assets/intro/$assetName'),
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.black),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          pages: [
            PageViewModel(
              title: "Welcome Screen",
              body:
                  "Here you can search by categories or by keywords. At the bottom, you can see a signin/signup button",
              image: _buildImage('1.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Multiple Sign in Options",
              body:
                  "You can login via Email and Password, or use google and apple login. You can also enable biometric and PIN Authentication",
              image: _buildImage('2.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Home",
              body:
                  "This is the Home Screen. You can go and search available Consultants. You can also search the categories.",
              image: _buildImage('3.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "More Option",
              body:
                  "On the left top corner of screen is the more option button. This shows orders, sessions, reviews for consultant"
                  " and sessions, payments for seeker. This includes our settings where user can enable dark mode, pin auth"
                  ", and biometric auth.",
              image: _buildImage('4.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Profile",
              body:
                  "This is how your profile looks, you can add more information for a more professional look.",
              image: _buildImage('5.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Edit Profile",
              body: "Editing your profile the way you see fit.",
              image: _buildImage('8.jpg'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Chat",
              body: "Chat with consultants to get an offer for a meeting.",
              image: _buildImage('6.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Set a Meeting",
              body: "You can set time and date for a meeting.",
              image: _buildImage('7.png'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          onSkip: () =>
              _onIntroEnd(context), // You can override onSkip callback
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          next: const Icon(Icons.arrow_forward),
          done:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: const DotsDecorator(
            size: Size(5.0, 5.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(10.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        ),
      ),
    );
  }
}
