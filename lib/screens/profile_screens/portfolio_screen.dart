
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/portfolio.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/portfolio_add_update.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen(this.uid) : super();
  final String uid;
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return StreamBuilder<DocumentSnapshot>(
        stream: _databaseService.userCollection.doc(widget.uid).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            MyUser currUser = MyUser.fromJson(snapshot.data.data());
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  color: Colors.white,
                ),
                title: Text('Portfolio Screen'),
              ),
              body: Stack(
                children: [
                  background(context),
                  ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Your portfolios',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: dark ?? false
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      if (currUser.portfolio.length == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'You have no portfolio',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      if (currUser.portfolio.length != 0)
                        for (Portfolio portfolio in currUser.portfolio)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                160,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  portfolio.title.toUpperCase(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${portfolio.from} - ${(portfolio.current ?? false) ? 'Present' : portfolio.to}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0),
                                            child: CachedNetworkImage(
                                              imageUrl: portfolio.image ?? "",
                                              imageBuilder: (context, image) {
                                                return Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: Colors.black,
                                                      image: DecorationImage(
                                                        image: image,
                                                        fit: BoxFit.cover,
                                                      )),
                                                );
                                              },
                                              placeholder: (context, image) {
                                                return Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Colors.black,
                                                  ),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorWidget:
                                                  (context, image, err) {
                                                return Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  child: Icon(Icons
                                                      .add_a_photo_outlined),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 10.0),
                                        InkWell(
                                            onTap: () async {
                                              showLoader(context);

                                              await _databaseService
                                                  .portfolioCollection
                                                  .doc(portfolio.pid)
                                                  .delete();
                                              currUser.portfolio
                                                  .remove(portfolio);
                                              await _databaseService
                                                  .userCollection
                                                  .doc(currUser.uid)
                                                  .update(currUser.toJson());
                                              pop(context);
                                              showToast(
                                                  context, "Portfolio deleted");
                                            },
                                            child: Icon(Icons.delete_outline)),
                                        SizedBox(width: 10.0),
                                        InkWell(
                                            onTap: () {
                                              push(
                                                  context,
                                                  AddUpdatePortfolio(
                                                    currUser: currUser,
                                                    edit: true,
                                                    portfolio: portfolio,
                                                  ));
                                            },
                                            child: Icon(Icons.edit_outlined)),
                                      ],
                                    )
                                  ],
                                ),
                                Divider()
                              ],
                            ),
                          )
                    ],
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  push(context,
                      AddUpdatePortfolio(currUser: currUser, edit: false));
                },
                label: Text('Add Portfolio'),
                icon: Icon(Icons.add),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            );
          }
        });
  }
}
