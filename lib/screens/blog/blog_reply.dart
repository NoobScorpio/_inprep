import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/screens/blog/reply_widget.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogReplyScreen extends StatefulWidget {
  final Comment comm;
  final Blog blog;
  final MyUser user;

  const BlogReplyScreen({Key key, this.comm, this.user, this.blog})
      : super(key: key);
  @override
  _BlogReplyScreenState createState() => _BlogReplyScreenState();
}

class _BlogReplyScreenState extends State<BlogReplyScreen> {
  final _firestore = FirebaseFirestore.instance;

  final cont = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text('Replies'),
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
                .doc(widget.blog.bid)
                .collection('comments')
                .where('cid', isEqualTo: widget.comm.cid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> docs = snapshot.data.docs;
                if (docs.length == 0) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // doc.data()
                  Comment comment = Comment.fromJson(docs[0].data());
                  bool liked;
                  comment.likes.contains(widget.user.uid)
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ProfileView(
                                                  uid: comment.uid,
                                                  loggedIn: true,
                                                )));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (comment.image == '')
                                            CircleAvatar(
                                              radius: 20,
                                            ),
                                          if (comment.image == null)
                                            CircleAvatar(
                                              radius: 20,
                                            ),
                                          if (comment.image != null &&
                                              comment.image != '')
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundImage:
                                                  NetworkImage(comment.image),
                                            ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${comment.name}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${comment.date}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text('${comment.time}')
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5),
                                  child: Text(
                                    comment.body,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 55.0),
                                  child: Divider(
                                    color: dark ? Colors.grey : Colors.black45,
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
                                                    .doc(widget.blog.bid)
                                                    .collection('comments')
                                                    .doc(widget.comm.cid)
                                                    .update({
                                                  "likes":
                                                      FieldValue.arrayRemove(
                                                          [widget.user.uid])
                                                });
                                                // setState(() {
                                                //   liked = false;
                                                // });
                                                likeCommNotification(
                                                    blog: widget.blog,
                                                    user: widget.user,
                                                    comment: widget.comm);
                                              } else {
                                                // blog.likes.add(user.uid);
                                                FirebaseFirestore.instance
                                                    .collection('blog')
                                                    .doc(widget.blog.bid)
                                                    .collection('comments')
                                                    .doc(widget.comm.cid)
                                                    .update({
                                                  "likes":
                                                      FieldValue.arrayUnion(
                                                          [widget.user.uid])
                                                });

                                                // setState(() {
                                                //   liked = true;
                                                // });
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
                                          Text('${comment.likes.length}')
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.reply),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              comment.replies.length.toString())
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
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Reply reply = comment.replies[index];
                                    return ReplyCard(
                                      reply: reply,
                                      user: widget.user,
                                    );
                                  },
                                  itemCount: comment.replies.length,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
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
                                  // showLoader(context);
                                  Reply reply = Reply(
                                      rid: Timestamp.now().toString(),
                                      cid: widget.comm.cid,
                                      uid: widget.user.uid,
                                      bid: widget.blog.bid,
                                      body: cont.text,
                                      name: widget.user.displayName,
                                      image: widget.user.photoUrl ?? "",
                                      date: DateTime.now()
                                          .toString()
                                          .split(" ")[0],
                                      time:
                                          "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                                      timestamp: Timestamp.now(),
                                      likes: []);
                                  await DatabaseService.blogCollection
                                      .doc(widget.blog.bid)
                                      .collection('comments')
                                      .doc(widget.comm.cid)
                                      .update({
                                    'replies':
                                        FieldValue.arrayUnion([reply.toJson()])
                                  });

                                  setState(() {
                                    cont.text = '';
                                    focusNode.unfocus();
                                  });
                                  commentReplyNotification(
                                      user: widget.user, reply: reply);
                                  // Navigator.pop(context);
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
                    ],
                  );
                }
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ],
      ),
    );
  }
}
