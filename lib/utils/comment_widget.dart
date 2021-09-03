import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/blog_reply.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final bool liked;
  final MyUser user;
  final Blog blog;
  const CommentCard({Key key, this.comment, this.liked, this.user, this.blog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BlogReplyScreen(
                      comm: comment,
                      user: user,
                      blog: blog,
                    )));
      },
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (comment.image == '')
                          CircleAvatar(
                            radius: 10,
                          ),
                        if (comment.image == null)
                          CircleAvatar(
                            radius: 10,
                          ),
                        if (comment.image != null && comment.image != '')
                          CircleAvatar(
                              radius: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  comment.image,
                                  errorBuilder: (context, obj, err) => Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${comment.name}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${comment.date}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text('${comment.time}')
                          ],
                        ),
                        if (user.uid == comment.uid)
                          PopupMenuButton(
                              // color: Colors.black,
                              child: Icon(
                                Icons.more_vert,
                              ),
                              onSelected: (value) async {
                                if (value == 2) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Delete Comment'),
                                            content: Text(
                                                'Do you want to delete this comment?'),
                                            actions: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('No'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  showToast(context,
                                                      "Comment Deleted");
                                                  await DatabaseService
                                                      .blogCollection
                                                      .doc(blog.bid)
                                                      .collection('comments')
                                                      .doc(comment.cid)
                                                      .delete();

                                                  await DatabaseService
                                                      .blogCollection
                                                      .doc(blog.bid)
                                                      .update({
                                                    'comments':
                                                        blog.comments - 1
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Yes'),
                                                ),
                                              )
                                            ],
                                          ));
                                }
                                // if (value == 1) {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               CreateBlog(
                                //                 edit: true,
                                //                 blog: blog,
                                //               )));
                                // }
                              },
                              itemBuilder: (context) => [
                                    // PopupMenuItem(
                                    //     value: 1,
                                    //     child: Row(
                                    //       children: <Widget>[
                                    //         Padding(
                                    //           padding: const EdgeInsets
                                    //               .fromLTRB(2, 2, 8, 2),
                                    //           child: Icon(
                                    //             Icons.edit,
                                    //           ),
                                    //         ),
                                    //         Text('Edit Blog')
                                    //       ],
                                    //     )),
                                    PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      2, 2, 8, 2),
                                              child: Icon(
                                                Icons.cancel,
                                              ),
                                            ),
                                            Text('Delete Comment'),
                                          ],
                                        )),
                                  ]),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    comment.body,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                  child: Divider(
                    color: dark ? Colors.grey : Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              print("PRESSED LIKE");
                              if (liked) {
                                FirebaseFirestore.instance
                                    .collection('blog')
                                    .doc(blog.bid)
                                    .collection('comments')
                                    .doc(comment.cid)
                                    .update({
                                  "likes": FieldValue.arrayRemove([user.uid])
                                });
                              } else {
                                FirebaseFirestore.instance
                                    .collection('blog')
                                    .doc(blog.bid)
                                    .collection('comments')
                                    .doc(comment.cid)
                                    .update({
                                  "likes": FieldValue.arrayUnion([user.uid])
                                });
                                likeCommNotification(
                                    blog: blog, user: user, comment: comment);
                              }
                            },
                            child: Icon(
                              liked ? Icons.favorite : Icons.favorite_border,
                              color: liked ? Colors.red : Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(comment.likes.length.toString())
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.reply),
                          SizedBox(
                            width: 5,
                          ),
                          Text(comment.replies.length.toString())
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: dark ? Colors.grey : Colors.black45,
          ),
        ],
      ),
    );
  }
}
