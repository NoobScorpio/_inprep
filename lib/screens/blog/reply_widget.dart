import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReplyCard extends StatelessWidget {
  final Reply reply;
  final MyUser user;
  const ReplyCard({Key key, this.reply, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileView(
                                uid: reply.uid,
                                loggedIn: true,
                              )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (reply.image == '')
                          CircleAvatar(
                            radius: 10,
                          ),
                        if (reply.image == null)
                          CircleAvatar(
                            radius: 10,
                          ),
                        if (reply.image != null && reply.image != '')
                          CircleAvatar(
                              radius: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  reply.image,
                                  errorBuilder: (context, obj, err) => Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${reply.name}",
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
                              '${reply.date}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text('${reply.time}')
                          ],
                        ),
                        if (user.uid == reply.uid)
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
                                            title: Text('Delete Reply'),
                                            content: Text(
                                                'Do you want to delete this reply?'),
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
                                                  showToast(
                                                      context, "Reply Deleted");
                                                  Navigator.pop(context);
                                                  await DatabaseService
                                                      .blogCollection
                                                      .doc(reply.bid)
                                                      .collection('comments')
                                                      .doc(reply.cid)
                                                      .update({
                                                    'replies':
                                                        FieldValue.arrayRemove(
                                                            [reply.toJson()])
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
                              },
                              itemBuilder: (context) => [
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
                                            Text('Delete Reply')
                                          ],
                                        )),
                                  ]),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  reply.body,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: dark ? Colors.grey : Colors.black45,
        ),
      ],
    );
  }
}
