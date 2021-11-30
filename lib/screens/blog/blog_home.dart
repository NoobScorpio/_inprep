import 'package:InPrep/screens/blog/blog_liked.dart';
import 'package:InPrep/screens/blog/blog_my.dart';
import 'package:InPrep/screens/blog/blog_recent.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogHome extends StatefulWidget {
  const BlogHome({Key key}) : super(key: key);

  @override
  _BlogHomeState createState() => _BlogHomeState();
}

class _BlogHomeState extends State<BlogHome> {
  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    final height = MediaQuery.of(context).size.height;

    // print(user.uid);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "INPREP",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                        Text(
                          "BLOG",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Image.asset(
                      'assets/icons/logo1024.png',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.18),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: dark ? Colors.black12 : Colors.white,
                        toolbarHeight: 60,
                        bottom: TabBar(
                          indicatorWeight: 2,
                          indicatorColor: Theme.of(context).primaryColor,
                          labelColor: dark
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                          tabs: [
                            Tab(
                              child: Text('Recent'),
                            ),
                            Tab(
                              child: Text('Liked'),
                            ),
                            Tab(
                              child: Text('My Blog'),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          RecentBlog(),
                          LikedBlog(),
                          MyBlog(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
