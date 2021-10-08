import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';

class IntroTexts {
  static String b = "Hello and welcome to inPrep. "
      "This is your home page where you are first able to navigate the application. "
      "You can start by searching for consultants or navigating through the application.";
  static String c =
      "Here you are able to see the terms of services, privacy policy, "
      "FAQ’s, your sessions, your orders, your reviews, support, and settings.";
  static String d =
      "Here you have the option to switch between a Seeker or a Consultant. "
      "If the tick is selected to right and the bar is showing red you are under a Seeker profile. "
      "This means you are interested in learning more and your profile is not searchable in categories. "
      "If the tick is selected to the left and the bar is showing grey your profile is under as a Consultant meaning you want to earn more. "
      "Your profile will be searchable through categories.";
  static String e =
      "Here you will have the back button but we also made the application very responsive for ease of use. "
      "Go to the corner of the screen and swipe right to go back.";
  static String f = "You are now back at the home screen";
  static String g =
      "Here you have messages where you will be able to communicate as a Seeker or a Consultant. "
      "You will be able to schedule meetings, send files, and complete offers for payment transactions.";
  static String h =
      "Important tip: All payment transactions are conducted through PayPal. You can pay as a guest but to receive money you will need an account.";
  static String i =
      "Here you have the inPrep blog, an open source of communication where you can discuss needs or share information. "
      "You can view recent blogs, your liked blogs, or blogs you have made.";
  static String j =
      "Here is your profile section where you can explain everything about you. "
      "As a Seeker your profile is limited due to privacy and your profile is not searchable. "
      "As a Consultant you have an extensive amount of fields to allow you to best describe yourself.";
  static String k = "This is also where you will logout if you choose.";
  static String l = "Welcome to inPrep and happy Seeking or Consulting!";
  static Intro introC = Intro(
    stepCount: 1,
    maskClosable: true,
    onHighlightWidgetTap: (introStatus) {
      print(introStatus);
    },
    widgetBuilder: StepWidgetBuilder.useDefaultTheme(
      texts: [
        IntroTexts.c,
      ],
      buttonTextBuilder: (currPage, totalPage) {
        return currPage < totalPage - 1 ? 'Next' : 'ok';
      },
    ),
  );
  static Intro introDE = Intro(
    stepCount: 2,
    maskClosable: true,
    onHighlightWidgetTap: (introStatus) {
      print(introStatus);
    },
    widgetBuilder: StepWidgetBuilder.useDefaultTheme(
      texts: [d, e],
      buttonTextBuilder: (currPage, totalPage) {
        return currPage < totalPage - 1 ? 'Next' : 'ok';
      },
    ),
  );
  static Intro introG = Intro(
    stepCount: 1,
    maskClosable: true,
    onHighlightWidgetTap: (introStatus) {
      print(introStatus);
    },
    widgetBuilder: StepWidgetBuilder.useDefaultTheme(
      texts: ["$g"],
      buttonTextBuilder: (currPage, totalPage) {
        return currPage < totalPage - 1 ? 'Next' : 'ok';
      },
    ),
  );
  static Intro introK = Intro(
    stepCount: 1,
    maskClosable: true,
    onHighlightWidgetTap: (introStatus) {
      print(introStatus);
    },
    widgetBuilder: StepWidgetBuilder.useDefaultTheme(
      texts: ["$k"],
      buttonTextBuilder: (currPage, totalPage) {
        return currPage < totalPage - 1 ? 'Next' : 'ok';
      },
    ),
  );
  // static
  static void setConfigs() {
    introC.setStepConfig(
      0,
      borderRadius: BorderRadius.circular(64),
    );
    introDE.setStepConfig(
      0,
      borderRadius: BorderRadius.circular(64),
    );
    introG.setStepConfig(
      0,
      borderRadius: BorderRadius.circular(64),
    );
  }

  static showHomeDialog(context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 80,
          child: Column(
            children: [
              Text(
                "$f \n",
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    'Click ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    ' Icon',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showProfileDialog(context) async {
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Text(
          "$j \n",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'ok',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
    introK.start(context);
  }

  static showChatDialog(context) async {
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Text(
          "$g \n$h",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'ok',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
    showBlogIconDialog(context);
  }

  static showBlogIconDialog(context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Up next is Blog section",
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    'Click on ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    ' Icon',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showBlogDialog(context) async {
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Text(
          "$i",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              'ok',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
    showProfileIconDialog(context);
  }

  static showProfileIconDialog(context) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Up next is Profile section",
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    'Click on ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    ' Icon',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
