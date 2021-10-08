import 'dart:io';

import 'package:InPrep/screens/screens/filterScreen.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:shimmer/shimmer.dart';

class Search extends StatefulWidget {
  static String id = 'Search';
  final MyUser user;
  final bool loggedIn;
  final search;
  final title, title2;
  Search({
    this.search,
    this.user,
    this.title,
    this.loggedIn,
    this.title2,
  });
  @override
  _SearchState createState() => _SearchState(
      user: user,
      loggedIn: loggedIn,
      title: title,
      title2: title2,
      search: search);
}

class _SearchState extends State<Search> {
  final user;
  final loggedIn;
  final title, title2;
  final search;

  _SearchState(
      {this.user, this.loggedIn, this.title, this.title2, this.search});
  List<MyUser> users = [];
  List<Widget> userWidgets = [];
  List<Widget> widgets = [];
  bool isLoading = true;
  DatabaseService _databaseService = DatabaseService();
  var sortValue = 1;
  List<DropdownMenuItem<int>> sorts = [];
  bool toggle = true;
  @override
  void initState() {
    super.initState();
    getAlphabeticalUsers();
  }

  void getRatingUsers() async {
    setState(() {
      isLoading = true;
    });
    //print('GETTING getUserWidgets');
    List<MyUser> returnedUsers = await _databaseService.getSearchUser(
        search: search, title: title, title2: title2);
    //print('GETTING USERS LENGTH : ${returnedUsers.length}');
    Comparator<MyUser> usersComp =
        (a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0);
    returnedUsers.sort(usersComp);
    List<Widget> widgetMade = [];
    List<Widget> userWidgetsForward = [];
    for (MyUser usr in returnedUsers) {
      userWidgetsForward.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileView(
                        uid: usr.uid,
                        loggedIn: loggedIn,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        usr.displayName.substring(0, 1).toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, right: 8.0, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          usr.displayName.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          usr.design == null
                              ? 'No Title'
                              : usr.design.toString().toUpperCase(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    widgetMade = userWidgetsForward.reversed.toList();
    //print('SETTING RATING USERS');

    setState(() {
      userWidgets =
          (widgetMade == null || widgetMade.length == 0 || widgetMade == [])
              ? noResult
              : widgetMade;
      isLoading = false;
      widgets = userWidgets;
    });
  }

  void getAlphabeticalUsers() async {
    setState(() {
      isLoading = true;
    });
    //print('GETTING getUserWidgets');
    List<MyUser> returnedUsers = await _databaseService.getSearchUser(
        search: search, title: title, title2: title2);
    // //print('GETTING USERS LENGTH : ${returnedUsers.length}');
    List<Widget> widgetMade = [];
    List<String> chars = [];
    if (returnedUsers != null && returnedUsers.length > 0) {
      //print('GOT USERS');

      for (MyUser u in returnedUsers) {
        if (!chars.contains(u.displayName.toLowerCase()[0])) {
          chars.add(u.displayName.toLowerCase()[0]);
        }
      }
      //print('CHARATERS $chars');

      int index = 0;
      String firstChar = chars[index];
      for (MyUser user in returnedUsers) {
        if (user.displayName.toLowerCase()[0] == firstChar) {
          widgetMade.add(Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // color: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    firstChar.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ));
          index++;
          if (index < chars.length) {
            firstChar = chars[index];
          } else {
            firstChar = 'COMPLETED';
          }
        }

        widgetMade.add(addUser(user));
      }
    }
    setState(() {
      //print('INSIDE USER SET STATE LENGTH ${widgetMade.length - chars.length}');
      userWidgets =
          (widgetMade == null || widgetMade.length == 0 || widgetMade == [])
              ? noResult
              : widgetMade;
      isLoading = false;
      widgets = userWidgets;
    });
  }

  Widget addUser(user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileView(
                      uid: user.uid,
                      loggedIn: loggedIn,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      user.displayName.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, right: 8.0, left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.displayName.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.design == null
                            ? 'No Title'
                            : user.design.toString().toUpperCase(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> noResult = [
    Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'No consultant found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Platform.isIOS
              ? GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
          title: title != null ? Text('$title') : Text('Your Search'),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sort'),
                PopupMenuButton(
                    icon: Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                    onSelected: (value) {
                      if (value == 1) getAlphabeticalUsers();
                      if (value == 2) getRatingUsers();
                    },
                    itemBuilder: (context) => [
                          PopupMenuItem(value: 1, child: Text('A-Z')),
                          PopupMenuItem(value: 2, child: Text('Rating')),
                        ]),
              ],
            )
          ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLoading)
                  Expanded(
                    child: ListView(
                      children: widgets,
                    ),
                  ),
                if (isLoading)
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  )
              ],
            ),
          ],
        ));
  }
}
