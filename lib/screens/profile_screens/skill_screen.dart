import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/skill_add_update.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SkillScreen extends StatefulWidget {
  const SkillScreen(this.uid) : super();
  final String uid;
  @override
  _SkillScreenState createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen> {
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
                title: Text('Skills Screen'),
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
                            'Your skills',
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
                      if (currUser.skills.length == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'You have no skills',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      if (currUser.skills.length != 0)
                        for (Skill skill in currUser.skills)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 5.0),
                                    Text(
                                      skill.name.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      flex: 5,
                                      child: LinearProgressIndicator(
                                        value: (skill.rank / 10).abs(),
                                      ),
                                    ),
                                    SizedBox(width: 20.0),
                                    InkWell(
                                        onTap: () async {
                                          showLoader(context);

                                          await _databaseService.skillCollection
                                              .doc(skill.sid)
                                              .delete();
                                          currUser.skills.remove(skill);
                                          await _databaseService.userCollection
                                              .doc(currUser.uid)
                                              .update(currUser.toJson());
                                          pop(context);
                                          showToast(context, "Skill deleted");
                                        },
                                        child: Icon(Icons.delete_outline)),
                                    SizedBox(width: 10.0),
                                    InkWell(
                                        onTap: () {
                                          push(
                                              context,
                                              AddUpdateSkill(
                                                currUser: currUser,
                                                edit: true,
                                                skill: skill,
                                              ));
                                        },
                                        child: Icon(Icons.edit_outlined)),
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
                  push(
                      context, AddUpdateSkill(currUser: currUser, edit: false));
                },
                label: Text('Add skill'),
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
