import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AddUpdateSkill extends StatefulWidget {
  const AddUpdateSkill({this.currUser, this.edit, this.skill}) : super();
  final MyUser currUser;
  final bool edit;
  final Skill skill;
  @override
  _AddUpdateSkillState createState() => _AddUpdateSkillState();
}

class _AddUpdateSkillState extends State<AddUpdateSkill> {
  TextEditingController name = TextEditingController(),
      rank = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit) {
      name.text = widget.skill.name;
      rank.text = widget.skill.rank.toString();
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
        title: Text('${widget.edit ? 'Edit' : 'Add'} Skill'),
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
                    '${widget.edit ? 'Edit' : 'Add'} Skill',
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
                  controller: name,
                  padding: EdgeInsets.all(0),
                  hint: 'Enter skill name',
                  labelText: 'Skill name',
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
                  hint: 'Rank your skill on scale of 10 (Digits only)',
                  labelText: 'Rank',
                  prefixIcon: Icon(Icons.star_rate_outlined,
                      color:
                          dark ? Colors.white : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (widget.edit)
            editSkill();
          else
            addSkill();
        },
        label: Text('${widget.edit ? 'Edit' : 'Add'} skill'),
        icon: Icon(widget.edit ? Icons.edit : Icons.add),
      ),
    );
  }

  addSkill() async {
    if (name.text != '') {
      if (double.tryParse(rank.text ?? '') != null) {
        try {
          showToast(context, 'Adding Skill');
          DatabaseService db = DatabaseService();
          Skill skill = await db.createSkill(
              skill: Skill(
                  uid: widget.currUser.uid,
                  name: name.text,
                  rank: int.parse(rank.text) ?? 0));
          MyUser user = widget.currUser;
          user.skills.add(skill);
          await db.userCollection.doc(user.uid).update(user.toJson());
          pop(context);
        } catch (e) {
          showToast(context, 'Enter only digits in rank');
          print('SKILL ADD $e');
        }
      } else
        showToast(context, 'Enter only digits in rank');
    } else
      showToast(context, 'Enter skill name');
  }

  editSkill() async {
    if (name.text != '') {
      if (double.tryParse(rank.text ?? '') != null) {
        try {
          showToast(context, 'Editing Skill');
          DatabaseService db = DatabaseService();
          Skill skill = widget.skill;
          skill.name = name.text;
          skill.rank = int.parse(rank.text) ?? 0;
          await db.skillCollection.doc(skill.sid).update(skill.toJson());

          MyUser user = widget.currUser;
          for (Skill skl in user.skills) {
            if (skl.sid == skill.sid) {
              user.skills.remove(skl);
              user.skills.add(skill);
              break;
            }
          }
          await db.userCollection.doc(user.uid).update(user.toJson());
          pop(context);
        } catch (e) {
          showToast(context, 'Enter only digits in rank');
          print('SKILL ADD $e');
        }
      } else
        showToast(context, 'Enter only digits in rank');
    } else
      showToast(context, 'Enter skill name');
  }
}
