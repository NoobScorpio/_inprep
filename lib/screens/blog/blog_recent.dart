import 'package:InPrep/models/blog.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/user_bloc/userState.dart';
import 'package:InPrep/screens/blog/blog_widget.dart';
import 'package:InPrep/utils/show_case_statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentBlog extends StatefulWidget {
  const RecentBlog({Key key}) : super(key: key);

  @override
  _RecentBlogState createState() => _RecentBlogState();
}

class _RecentBlogState extends State<RecentBlog> {
  SharedPreferences preferences;
  bool first = false;
  getPrefs() async {
    preferences = await SharedPreferences.getInstance();
    first = preferences.getBool('firstBlog');
    if (first == null || first == true) {
      await preferences.setBool('firstBlog', false);
      IntroTexts.showBlogDialog(context);
    } else {
      // IntroTexts.showBlogDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    return Scaffold(
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
          BlocBuilder<UserCubit, UserState>(builder: (context, state) {
            if (state is UserLoadedState && state.user != null) {
              // print("@BLOG LOADED STATE");
              return StreamBuilder(
                  stream: _firestore
                      .collection('blog')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print("@BLOG HAS DATA STATE");
                      List<QueryDocumentSnapshot> docs = snapshot.data.docs;

                      if (docs.length > 0) {
                        // print(docs[0].data());
                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            Blog blog = Blog.fromJson(docs[index].data());

                            return BlogCard(
                              blog: blog,
                              user: state.user,
                              image: blog.image,
                              name: blog.name,
                              desc: blog.desc,
                              bid: blog.bid,
                              designation: blog.designation,
                              date: blog.date,
                              time: blog.time,
                              comments: blog.comments,
                              likes: blog.likes.length,
                              views: blog.views,
                              uid: state.user.uid,
                              likesArr: blog.likes,
                              liked: blog.likes.contains(state.user.uid),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text('There is not blog posted yet.'),
                        );
                      }
                    } else {
                      // print("@BLOG HAS NO DATA STATE");
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            } else {
              // print("@BLOG LOADING STATE");
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ],
      ),
    );
  }
}
