import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/review.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/rating/gf_rating.dart';

class ReviewScreen extends StatefulWidget {
  final giver;
  final receiver;
  final gName;
  final rName;
  const ReviewScreen(
      {Key key, this.giver, this.receiver, this.gName, this.rName})
      : super(key: key);

  @override
  _ReviewScreenState createState() =>
      _ReviewScreenState(giver, receiver, gName, rName);
}

class _ReviewScreenState extends State<ReviewScreen> {
  double rating = 1;
  final giver;
  final receiver;
  final gName;
  final rName;

  _ReviewScreenState(this.giver, this.receiver, this.gName, this.rName);

  TextEditingController descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Give Review'),
          actions: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/icons/logo1024.png'),
            ),
          ],
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
            ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 15, bottom: 5),
                  child: Text(
                    "Review to ${rName.toString().toUpperCase()}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: MyTextFormField(
                    labelText: 'Description',
                    maxline: 7,
                    controller: descController,
                    icon: Icon(Icons.description),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Give Stars',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                Center(
                  child: GFRating(
                    value: rating,
                    onChanged: (val) {
                      setState(() {
                        rating = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var db = DatabaseService();
            showDialog(
              context: context,
              builder: (c) => Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ),
            );
            Review rev = Review(
                rid: '',
                uid: receiver, //CONSULTANT
                gid: giver, //SEEKER
                gName: gName,
                stars: rating,
                date: DateTime.now().toString(),
                body: descController.text.toString(),
                title: rName,
                timestamp: Timestamp.now());
            await db.reviewCollection.add(rev.toJson());
            DocumentSnapshot usrDoc =
                await db.userCollection.doc(receiver).get();
            MyUser usr = MyUser.fromJson(usrDoc.data());
            double usrRating = usr.rating + rating;
            try {
              await db.userCollection
                  .doc(receiver)
                  .update({"rating": usrRating});
            } catch (e) {
              print("ERROR ${usr.displayName}");
            }
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Icon(Icons.done),
        ),
      ),
    );
  }
}
