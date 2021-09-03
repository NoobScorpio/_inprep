import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

showLoader(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.green,
            ),
          ));
}

void showToast(context, String msg) {
  Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

void commentNotification({Blog blog, user, Comment comm}) async {
  try {
    DocumentSnapshot usr =
        await DatabaseService().userCollection.doc(blog.uid).get();
    MyUser poster = MyUser.fromJson(usr.data());
    var message = "${user.displayName} commented on your blog \"${comm.body}\"";
    var token = "${usr.data()['pushToken']}";
    if (poster.uid != user.uid)
      await http.get(Uri.parse(
          "https://inprepapp.com/notify.php?token=$token&message=$message"));
  } catch (e) {
    print('LIKED NOTIFICATION ERROR $e');
  }
}

void commentReplyNotification({MyUser user, Reply reply}) async {
  try {
    var commDoc = await DatabaseService.blogCollection
        .doc(reply.bid)
        .collection('comments')
        .doc(reply.cid)
        .get();
    var blogDoc = await DatabaseService.blogCollection.doc(reply.bid).get();
    var blog = Blog.fromJson(blogDoc.data());
    var comm = Comment.fromJson(commDoc.data());
    DocumentSnapshot usr =
        await DatabaseService().userCollection.doc(comm.uid).get();
    MyUser poster = MyUser.fromJson(usr.data());
    var message =
        "${user.displayName} replied to your comment \n\"${comm.body}\"\non "
        "a blog posted by \n ${blog.name}";
    var token = "${usr.data()['pushToken']}";
    if (poster.uid != user.uid)
      await http.get(Uri.parse(
          "https://inprepapp.com/notify.php?token=$token&message=$message"));
  } catch (e) {
    print('LIKED NOTIFICATION ERROR $e');
  }
}

void likeNotification({blog, user}) async {
  try {
    DocumentSnapshot usr =
        await DatabaseService().userCollection.doc(blog.uid).get();
    MyUser poster = MyUser.fromJson(usr.data());
    var message = "${user.displayName} liked your blog";
    var token = "${usr.data()['pushToken']}";
    if (poster.uid != user.uid)
      await http.get(Uri.parse(
          "https://inprepapp.com/notify.php?token=$token&message=$message"));
  } catch (e) {
    print('LIKED NOTIFICATION ERROR $e');
  }
}

void likeCommNotification({Blog blog, user, Comment comment}) async {
  try {
    DocumentSnapshot usr =
        await DatabaseService().userCollection.doc(comment.uid).get();
    MyUser poster = MyUser.fromJson(usr.data());
    var message =
        "${user.displayName} liked your comment \"${comment.body}\" on a blog posted by ${blog.name}";
    var token = "${usr.data()['pushToken']}";
    if (poster.uid != user.uid)
      await http.get(Uri.parse(
          "https://inprepapp.com/notify.php?token=$token&message=$message"));
  } catch (e) {
    print('LIKED NOTIFICATION ERROR $e');
  }
}
