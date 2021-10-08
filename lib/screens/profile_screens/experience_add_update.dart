import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AddUpdateExperience extends StatefulWidget {
  const AddUpdateExperience({this.currUser, this.edit, this.experience})
      : super();
  final MyUser currUser;
  final bool edit;
  final Experience experience;
  @override
  _AddUpdateExperienceState createState() => _AddUpdateExperienceState();
}

class _AddUpdateExperienceState extends State<AddUpdateExperience> {
  TextEditingController title = TextEditingController(),
      rank = TextEditingController(),
      from = TextEditingController(),
      to = TextEditingController();
  bool current = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit) {
      title.text = widget.experience.title;
      rank.text = widget.experience.designation;
      from.text = widget.experience.from;
      to.text = widget.experience.to;
      current = widget.experience.current;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text('${widget.edit ? 'Edit' : 'Add'} Experience'),
      ),
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${widget.edit ? 'Edit' : 'Add'} Experience',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: dark ?? false
                            ? Colors.grey
                            : Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: title,
                  padding: EdgeInsets.all(0),
                  hint: 'Enter experience title',
                  labelText: 'Experience title',
                  prefixIcon: Icon(Icons.title_outlined,
                      color:
                          dark ? Colors.white : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: rank,
                  padding: EdgeInsets.all(0),
                  hint: 'Enter experience position',
                  labelText: 'Position',
                  prefixIcon: Icon(Icons.star_rate_outlined,
                      color:
                          dark ? Colors.white : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormField(
                        controller: from,
                        padding: EdgeInsets.all(0),
                        hint: 'Enter starting year',
                        labelText: 'Year From',
                        prefixIcon: Icon(Icons.star_rate_outlined,
                            color: dark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MyTextFormField(
                        controller: to,
                        padding: EdgeInsets.all(0),
                        hint: 'Enter ending year',
                        labelText: 'Year To',
                        prefixIcon: Icon(Icons.star_rate_outlined,
                            color: dark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        'Current',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: dark ?? false
                                ? Colors.grey
                                : Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Switch(
                          value: current,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (val) {
                            setState(() {
                              current = !current;
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (widget.edit)
            editExperience();
          else
            addExperience();
        },
        label: Text('${widget.edit ? 'Edit' : 'Add'} experience'),
        icon: Icon(widget.edit ? Icons.edit : Icons.add),
      ),
    );
  }

  addExperience() async {
    if (title.text != '' && rank.text != '' && from.text != '') {
      try {
        showToast(context, 'Adding Experience');
        DatabaseService db = DatabaseService();
        Experience experience = await db.createExperience(
            experience: Experience(
                uid: widget.currUser.uid,
                title: title.text,
                to: to.text,
                designation: rank.text,
                from: from.text,
                current: current));
        MyUser user = widget.currUser;
        user.experiences.add(experience);
        await db.userCollection.doc(user.uid).update(user.toJson());
        pop(context);
      } catch (e) {
        showToast(context, 'Enter only digits in rank');
        print('Experience ADD $e');
      }
    } else
      showToast(context, 'Enter complete information');
  }

  editExperience() async {
    if (title.text != '' && rank.text != '' && from.text != '') {
      try {
        showToast(context, 'Editing Experience');
        DatabaseService db = DatabaseService();
        Experience experience = widget.experience;
        experience.title = title.text;
        experience.designation = rank.text;
        experience.to = to.text;
        experience.from = from.text;
        experience.current = current;
        await db.experienceCollection
            .doc(experience.eid)
            .update(experience.toJson());

        MyUser user = widget.currUser;
        for (Experience exp in user.experiences) {
          if (exp.eid == experience.eid) {
            user.experiences.remove(exp);
            user.experiences.add(experience);
            break;
          }
        }
        await db.userCollection.doc(user.uid).update(user.toJson());
        pop(context);
      } catch (e) {
        showToast(context, 'Enter only digits in rank');
        print('EXPERIENCE ADD $e');
      }
    } else
      showToast(context, 'Enter complete information');
  }
}
