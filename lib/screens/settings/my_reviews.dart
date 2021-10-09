import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/review.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/user.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:getflutter/components/rating/gf_rating.dart';

class MyReviews extends StatefulWidget {
  final MyUser user;

  const MyReviews({Key key, this.user}) : super(key: key);
  @override
  _MyReviewsState createState() => _MyReviewsState(user);
}

class _MyReviewsState extends State<MyReviews> {
  final user;
  double rating = 1;
  final _databaseService = DatabaseService();
  _MyReviewsState(this.user);

  Future<List<Review>> getReviews() async {
    List<Review> reviews = [];
    //print(" UID ${user.uid}");
    reviews = await _databaseService.getReviews(uid: user.uid);
    //print("@REVIEWS ${reviews.length}");
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('My Reviews'),
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
          FutureBuilder(
            future: getReviews(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //print('INSIDE BUILDER');
              if (snapshot.hasData) {
                //print('INSIDE HAS DATA');
                if (snapshot.data.length != 0)
                  return ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        //print(snapshot.data[index]);
                        Review review = snapshot.data[index];
                        return Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: 240,
                              width: MediaQuery.of(context).size.width - 20,
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                // color: Colors.white60,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.person,
                                            ),
                                          ),
                                          Text(
                                            '${review.gName.toString().split(' ')[0]}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.date_range,
                                            ),
                                          ),
                                          Text(
                                            '${review.date.toString().split(' ')[0]}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.rate_review_outlined,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              '${review.body}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          content: Text(
                                                            '${review.body}',
                                                          ),
                                                        ));
                                              },
                                              child: Icon(
                                                Icons.remove_red_eye,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RatingBar(
                                        initialRating: review.stars,
                                        minRating: 0,
                                        maxRating: 5.0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        ratingWidget: RatingWidget(
                                            half: Icon(
                                              Icons.star_half,
                                              color: Colors.amber,
                                            ),
                                            full: Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            empty: Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.amber,
                                            )),
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        onRatingUpdate: (val) {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      });
                else
                  return Center(
                    child: Text('You have no Reviews.'),
                  );
              } else {
                //print('INSIDE NO DATA');
                return Center(
                  child: Text('You have no Reviews.'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
