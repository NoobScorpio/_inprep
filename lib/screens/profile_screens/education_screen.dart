import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/education.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/education_add_update.dart';
import 'package:InPrep/screens/profile_screens/experience_add_update.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen(this.uid) : super();
  final String uid;
  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
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
                title: Text('Education Screen'),
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
                            'Your educations',
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
                      if (currUser.educations.length == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'You have no education',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      if (currUser.educations.length != 0)
                        for (Education education in currUser.educations)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          education.institute.toUpperCase() +
                                              ", ${education.country}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          education.degree.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${education.from} - ${(education.current) ? 'Present' : education.to}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 10.0),
                                        InkWell(
                                            onTap: () async {
                                              showLoader(context);

                                              await _databaseService
                                                  .educationCollection
                                                  .doc(education.eid)
                                                  .delete();
                                              currUser.educations
                                                  .remove(education);
                                              await _databaseService
                                                  .userCollection
                                                  .doc(currUser.uid)
                                                  .update(currUser.toJson());
                                              pop(context);
                                              showToast(
                                                  context, "Education deleted");
                                            },
                                            child: Icon(Icons.delete_outline)),
                                        SizedBox(width: 10.0),
                                        InkWell(
                                            onTap: () {
                                              push(
                                                  context,
                                                  AddUpdateEducation(
                                                    currUser: currUser,
                                                    edit: true,
                                                    education: education,
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
                      AddUpdateEducation(currUser: currUser, edit: false));
                },
                label: Text('Add Education'),
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
