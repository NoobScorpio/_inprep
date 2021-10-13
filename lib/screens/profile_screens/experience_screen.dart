import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/experience_add_update.dart';
import 'package:InPrep/screens/profile_screens/skill_add_update.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen(this.uid) : super();
  final String uid;
  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
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
                title: Text('Experience Screen'),
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
                            'Your experiences',
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
                      if (currUser.experiences.length == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'You have no experience',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      if (currUser.experiences.length != 0)
                        for (Experience experience in currUser.experiences)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            experience.title.toUpperCase(),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            experience.designation
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "${experience.from} - ${(experience.current ?? false) ? 'Present' : experience.to}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
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
                                                  .experienceCollection
                                                  .doc(experience.eid)
                                                  .delete();
                                              currUser.experiences
                                                  .remove(experience);
                                              await _databaseService
                                                  .userCollection
                                                  .doc(currUser.uid)
                                                  .update(currUser.toJson());
                                              pop(context);
                                              showToast(context,
                                                  "Experience deleted");
                                            },
                                            child: Icon(Icons.delete_outline)),
                                        SizedBox(width: 10.0),
                                        InkWell(
                                            onTap: () {
                                              push(
                                                  context,
                                                  AddUpdateExperience(
                                                    currUser: currUser,
                                                    edit: true,
                                                    experience: experience,
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
                      AddUpdateExperience(currUser: currUser, edit: false));
                },
                label: Text('Add Experience'),
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
