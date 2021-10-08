import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:InPrep/screens/blog/comment_widget.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'blog_create.dart';

class BlogScreen extends StatefulWidget {
  final String bid;
  final MyUser user, blogUser;
  final int views;
  const BlogScreen({Key key, this.bid, this.user, this.views, this.blogUser})
      : super(key: key);
  @override
  _BlogScreenState createState() => _BlogScreenState(bid, user, blogUser);
}

class _BlogScreenState extends State<BlogScreen> {
  MyUser user, blogUser;
  String bid;
  _BlogScreenState(this.bid, this.user, this.blogUser);
  final cont = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    setView();
  }

  setView() async {
    int views = widget.views + 1;

    await _firestore.collection('blog').doc(bid).update({"views": views});
  }

  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: dark ? Colors.grey : Colors.white,
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
          ),
          title: Text('Blog'),
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
            StreamBuilder(
              stream: _firestore
                  .collection('blog')
                  .where('bid', isEqualTo: bid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> docs = snapshot.data.docs;
                  if (docs.length == 0) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Blog blog = Blog.fromJson(docs[0].data());
                    bool liked;
                    blog.likes.contains(user.uid)
                        ? liked = true
                        : liked = false;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (blogUser.photoUrl == '')
                                                CircleAvatar(),
                                              if (blogUser.photoUrl == null)
                                                CircleAvatar(),
                                              if (blogUser.photoUrl != null &&
                                                  blogUser.photoUrl != '')
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      blogUser.photoUrl),
                                                ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${blogUser.displayName}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '${blogUser.design}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          onTap: () async {
                                            showLoader(context);
                                            var usrDoc = await DatabaseService()
                                                .userCollection
                                                .doc(blog.uid)
                                                .get();
                                            MyUser usr =
                                                MyUser.fromJson(usrDoc.data());
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => ProfileView(
                                                          uid: usr.uid,
                                                          loggedIn: true,
                                                        )));
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${blog.date}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text('${blog.time}')
                                              ],
                                            ),
                                            if (user.uid == blog.uid)
                                              PopupMenuButton(
                                                  // color: Colors.black,
                                                  child: Icon(
                                                    Icons.more_vert,
                                                  ),
                                                  onSelected: (value) async {
                                                    if (value == 2) {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  AlertDialog(
                                                                    title: Text(
                                                                        'Delete Blog'),
                                                                    content: Text(
                                                                        'Do you want to delete this blog?'),
                                                                    actions: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text('No'),
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          await DatabaseService
                                                                              .blogCollection
                                                                              .doc(bid)
                                                                              .delete();
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text('Yes'),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ));
                                                    }
                                                    if (value == 1) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      CreateBlog(
                                                                        edit:
                                                                            true,
                                                                        blog:
                                                                            blog,
                                                                      )));
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                            value: 1,
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          2,
                                                                          2,
                                                                          8,
                                                                          2),
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                  ),
                                                                ),
                                                                Text(
                                                                    'Edit Blog')
                                                              ],
                                                            )),
                                                        // PopupMenuItem(
                                                        //     value: 2,
                                                        //     child: Row(
                                                        //       children: <Widget>[
                                                        //         Padding(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                       .fromLTRB(
                                                        //                   2,
                                                        //                   2,
                                                        //                   8,
                                                        //                   2),
                                                        //           child: Icon(
                                                        //             Icons.cancel,
                                                        //           ),
                                                        //         ),
                                                        //         Text('Delete Blog')
                                                        //       ],
                                                        //     )),
                                                      ]),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "${blog.desc}",
                                        // maxLines: 5,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Divider(
                                      color:
                                          dark ? Colors.grey : Colors.black45,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                print("PRESSED LIKE");
                                                if (liked) {
                                                  // blog.likes.remove(user.uid);
                                                  FirebaseFirestore.instance
                                                      .collection('blog')
                                                      .doc(blog.bid)
                                                      .update({
                                                    "likes":
                                                        FieldValue.arrayRemove(
                                                            [user.uid])
                                                  });
                                                  // setState(() {
                                                  //   liked = false;
                                                  // });
                                                } else {
                                                  // blog.likes.add(user.uid);
                                                  FirebaseFirestore.instance
                                                      .collection('blog')
                                                      .doc(blog.bid)
                                                      .update({
                                                    "likes":
                                                        FieldValue.arrayUnion(
                                                            [user.uid])
                                                  });
                                                  // setState(() {
                                                  //   liked = true;
                                                  // });
                                                  likeNotification(
                                                      blog: blog, user: user);
                                                }
                                              },
                                              child: Icon(
                                                liked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: liked
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('${blog.likes.length}')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.comment_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('${blog.comments}')
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.remove_red_eye_outlined),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('${blog.views}')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: dark ? Colors.grey : Colors.black45,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  StreamBuilder(
                                      stream: _firestore
                                          .collection('blog')
                                          .doc(bid)
                                          .collection('comments')
                                          .orderBy('timestamp',
                                              descending: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<QueryDocumentSnapshot> docs =
                                              snapshot.data.docs;
                                          if (docs.length == 0)
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Center(
                                                  child: Text('No Comments')),
                                            );
                                          else
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                Comment comment =
                                                    Comment.fromJson(
                                                        docs[index].data());
                                                return CommentCard(
                                                    comment: comment,
                                                    blog: blog,
                                                    liked: comment.likes
                                                        .contains(user.uid),
                                                    user: user);
                                              },
                                              itemCount: docs.length,
                                            );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: dark ? Colors.black12 : Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: cont,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Write Comment',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    onPressed: () async {
                                      if (cont.text != '') {
                                        // showLoader(context);
                                        var comm = Comment(
                                            uid: user.uid,
                                            bid: blog.bid,
                                            body: cont.text,
                                            name: user.displayName,
                                            image: user.photoUrl ?? "",
                                            date: DateTime.now()
                                                .toString()
                                                .split(" ")[0],
                                            time:
                                                "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                                            timestamp: Timestamp.now(),
                                            replies: []);
                                        var cid = await DatabaseService
                                            .blogCollection
                                            .doc(bid)
                                            .collection('comments')
                                            .add(comm.toJson());

                                        setState(() {
                                          cont.text = '';
                                          focusNode.unfocus();
                                        });
                                        await DatabaseService.blogCollection
                                            .doc(bid)
                                            .collection('comments')
                                            .doc(cid.id)
                                            .update({'cid': cid.id});
                                        await DatabaseService.blogCollection
                                            .doc(bid)
                                            .update({
                                          'comments': blog.comments + 1
                                        });
                                        commentNotification(
                                            blog: blog, user: user, comm: comm);
                                      } else {
                                        showToast(context, "Write Something");
                                      }
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
