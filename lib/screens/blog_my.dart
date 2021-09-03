import 'package:InPrep/models/blog.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/user_bloc/userState.dart';
import 'package:InPrep/utils/blog_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/screens/blog_create.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlog extends StatefulWidget {
  const MyBlog({Key key}) : super(key: key);

  @override
  _MyBlogState createState() => _MyBlogState();
}

class _MyBlogState extends State<MyBlog> {
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
              return StreamBuilder(
                  stream: _firestore
                      .collection('blog')
                      .where('uid', isEqualTo: state.user.uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
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
                          child: Text('You do not have a Blog Yet'),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => CreateBlog()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
