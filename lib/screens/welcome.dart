import 'package:InPrep/screens/filterScreen.dart';
import 'package:InPrep/utils/darkMode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/signin_signup.dart';
import 'package:InPrep/utils/constants.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'search_screen.dart';

class Welcome extends StatefulWidget {
  static String id = 'welcome';

  Welcome();
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final searchCont = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchCont.dispose();
  }

  @override
  void initState() {
    super.initState();

    getPref();
  }

  SharedPreferences preferences;
  bool dark, loggedIn = false;
  getPref() async {
    preferences = await SharedPreferences.getInstance();
    bool log = preferences.getBool('loggedIn');
    if (log == null || log == false) {
      await toogleLightMode(context);
      setState(() {
        loggedIn = false;
      });
    } else {
      setState(() {
        loggedIn = true;
      });
    }
    setState(() {
      dark = preferences.getBool('dark');
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<MyUser>(context);
    //print("GOT USER FROM CONTEXT $user");
    // final _database = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/icons/logo1024.png'),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, SignInUp.id);
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Log in',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Opacity(
            opacity: 0.08,
            child: Image.asset(
              "assets/images/welcomeBG.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 25, top: 25),
                  child: Material(
                      elevation: 6,
                      child: Container(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutofillGroup(
                              child: TextField(
                                autofillHints: [AutofillHints.jobTitle],
                                controller: searchCont,
                                decoration: InputDecoration(
                                  hintText: 'Search services',
                                  suffixIcon: IconButton(
                                    color: Theme.of(context).primaryColor,
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Search(
                                                    loggedIn: false,
                                                    search: searchCont.text
                                                            .toString() ??
                                                        '',
                                                  )));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )))),
              InkWell(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterScreen(
                                loggedIn: false,
                              )));
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Text(
                      "Advance Filtering",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10.0),
                child: Text(
                  'Popular Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ?? false
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(height: 175, child: makeCategories()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10.0),
                child: Text(
                  'Featured Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ?? false
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(height: 175, child: makeFeatured()),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget makeCategories() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container();
        } else
          return Padding(
            padding: index == 1
                ? const EdgeInsets.only(left: 15, right: 5)
                : const EdgeInsets.only(left: 5, right: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Search(
                              loggedIn: false,
                              title: catList[index],
                            )));
              },
              child: Card(
                elevation: 4,
                color: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  height: 175,
                  width: 175,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: catListImages[index],
                        imageBuilder: (context, image) {
                          return Container(
                            height: 125,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(catListImages[index]),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                        placeholder: (context, place) {
                          return Container(
                            height: 125,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, err, err2) {
                          return Container(
                            height: 125,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/icons/logo1024.png'),
                                  fit: BoxFit.contain),
                            ),
                          );
                        },
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              catList[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
      },
      itemCount: catList.length,
    );
  }

  Widget makeFeatured() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container();
        } else
          return Padding(
            padding: index == 1
                ? const EdgeInsets.only(left: 15, right: 5)
                : const EdgeInsets.only(left: 5, right: 5),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Search(
                              loggedIn: false,
                              title: catList[index],
                              title2: featuredList[index],
                            )));
              },
              child: Card(
                color: Theme.of(context).primaryColor,
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  height: 175,
                  width: 175,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: featuredListImages[index],
                        imageBuilder: (context, image) {
                          return Container(
                            height: 125,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image:
                                      NetworkImage(featuredListImages[index]),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                        placeholder: (context, place) {
                          return Container(
                            height: 125,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, err, err2) {
                          return Container(
                            height: 125,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/icons/logo1024.png'),
                                  fit: BoxFit.contain),
                            ),
                          );
                        },
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              featuredList[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
      },
      itemCount: catList.length,
    );
  }
}
