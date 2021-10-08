import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/blog/blog_create.dart';
import 'package:InPrep/screens/blog/blog_screen.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/loader.dart';

class BlogCard extends StatelessWidget {
  final image,
      bid,
      name,
      designation,
      date,
      time,
      blog,
      user,
      desc,
      likes,
      comments,
      views,
      uid,
      liked;
  final List<String> likesArr;
  const BlogCard(
      {Key key,
      this.image,
      this.name,
      this.designation,
      this.date,
      this.time,
      this.desc,
      this.likes,
      this.comments,
      this.views,
      this.bid,
      this.liked,
      this.uid,
      this.likesArr,
      this.blog,
      this.user})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return GestureDetector(
      onTap: () async {
        showLoader(context);
        var usrDoc = await DatabaseService().userCollection.doc(blog.uid).get();
        MyUser usr = MyUser.fromJson(usrDoc.data());
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BlogScreen(
                      bid: bid,
                      blogUser: usr,
                      user: user,
                      views: views,
                    )));
      },
      child: Container(
          // height: 150,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 6, 5, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              showLoader(context);
                              var usrDoc = await DatabaseService()
                                  .userCollection
                                  .doc(blog.uid)
                                  .get();
                              MyUser usr = MyUser.fromJson(usrDoc.data());
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProfileView(
                                            uid: usr.uid,
                                            loggedIn: true,
                                          )));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (image == '') CircleAvatar(),
                                if (image == null) CircleAvatar(),
                                if (image != null && image != '')
                                  CircleAvatar(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      image,
                                      errorBuilder: (context, obj, err) =>
                                          Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  )),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$name",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '$designation',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$date',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '$time',
                                    overflow: TextOverflow.ellipsis,
                                  )
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
                                            builder: (context) => AlertDialog(
                                                  title: Text('Delete Blog'),
                                                  content: Text(
                                                      'Do you want to delete this blog?'),
                                                  actions: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('No'),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        showToast(context,
                                                            "Blog Deleted");
                                                        Navigator.pop(context);
                                                        await DatabaseService
                                                            .blogCollection
                                                            .doc(bid)
                                                            .delete();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text('Yes'),
                                                      ),
                                                    )
                                                  ],
                                                ));
                                      }
                                      if (value == 1) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateBlog(
                                                      edit: true,
                                                      blog: blog,
                                                    )));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 1,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 2, 8, 2),
                                                    child: Icon(
                                                      Icons.edit,
                                                    ),
                                                  ),
                                                  Text('Edit Blog')
                                                ],
                                              )),
                                          PopupMenuItem(
                                              value: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 2, 8, 2),
                                                    child: Icon(
                                                      Icons.cancel,
                                                    ),
                                                  ),
                                                  Text('Delete Blog')
                                                ],
                                              )),
                                        ]),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "$desc",
                          maxLines: 5,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Divider(
                        color: dark ? Colors.grey : Colors.black45,
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
                                          .update({
                                        "likes":
                                            FieldValue.arrayRemove([user.uid])
                                      });
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('blog')
                                          .doc(blog.bid)
                                          .update({
                                        "likes":
                                            FieldValue.arrayUnion([user.uid])
                                      });
                                      likeNotification(blog: blog, user: user);
                                    }
                                  },
                                  child: Icon(
                                    liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: liked ? Colors.red : Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('$likes')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.comment_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('$comments')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.remove_red_eye_outlined),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('$views')
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: dark ? Colors.grey : Colors.black45,
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
