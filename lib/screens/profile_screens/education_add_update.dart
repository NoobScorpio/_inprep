
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/education.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AddUpdateEducation extends StatefulWidget {
  const AddUpdateEducation({this.currUser, this.edit, this.education})
      : super();
  final MyUser currUser;
  final bool edit;
  final Education education;
  @override
  _AddUpdateEducationState createState() => _AddUpdateEducationState();
}

class _AddUpdateEducationState extends State<AddUpdateEducation> {
  TextEditingController institute = TextEditingController(),
      degree = TextEditingController(),
      from = TextEditingController(),
      to = TextEditingController(),
      country = TextEditingController();
  bool current = false;
  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      institute.text = widget.education.institute;
      degree.text = widget.education.degree;
      from.text = widget.education.from;
      to.text = widget.education.to;
      country.text = widget.education.country;
      current = widget.education.current;
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
        title: Text('${widget.edit ? 'Edit' : 'Add'} Education'),
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
                    '${widget.edit ? 'Edit' : 'Add'} Education',
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
                  controller: institute,
                  padding: EdgeInsets.all(0),
                  hint: 'Enter education institute name',
                  labelText: 'Institute',
                  prefixIcon: Icon(Icons.title_outlined,
                      color:
                          dark ? Colors.white : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: degree,
                  padding: EdgeInsets.all(0),
                  hint: 'Enter education degree name',
                  labelText: 'Degree',
                  prefixIcon: Icon(Icons.grade,
                      color:
                          dark ? Colors.white : Theme.of(context).primaryColor),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: country,
                  padding: EdgeInsets.all(0),
                  hint: 'Enter education institute country',
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.place_outlined,
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
                        prefixIcon: Icon(Icons.date_range,
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
                        prefixIcon: Icon(Icons.date_range,
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
            editEducation();
          else
            addEducation();
        },
        label: Text('${widget.edit ? 'Edit' : 'Add'} experience'),
        icon: Icon(widget.edit ? Icons.edit : Icons.add),
      ),
    );
  }

  addEducation() async {
    if (institute.text != '' &&
        country.text != '' &&
        from.text != '' &&
        degree.text != '') {
      try {
        showToast(context, 'Adding Education');
        DatabaseService db = DatabaseService();
        Education education = await db.createEducation(
            education: Education(
                uid: widget.currUser.uid,
                institute: institute.text,
                to: to.text,
                degree: degree.text,
                country: country.text,
                from: from.text,
                current: current));
        MyUser user = widget.currUser;
        user.educations.add(education);
        await db.userCollection.doc(user.uid).update(user.toJson());
        pop(context);
      } catch (e) {
        showToast(context, 'Enter only digits in rank');
        print('Education ADD $e');
      }
    } else
      showToast(context, 'Enter complete information');
  }

  editEducation() async {
    if (institute.text != '' &&
        country.text != '' &&
        from.text != '' &&
        degree.text != '') {
      try {
        showToast(context, 'Editing Education');
        DatabaseService db = DatabaseService();
        Education education = widget.education;
        education.institute = institute.text;
        education.degree = degree.text;
        education.country = country.text;
        education.to = to.text;
        education.from = from.text;
        education.current = current;
        await db.educationCollection
            .doc(education.eid)
            .update(education.toJson());

        MyUser user = widget.currUser;
        for (Education edu in user.educations) {
          if (edu.eid == education.eid) {
            user.educations.remove(edu);
            user.educations.add(education);
            break;
          }
        }
        await db.userCollection.doc(user.uid).update(user.toJson());
        pop(context);
      } catch (e) {
        showToast(context, 'Enter only digits in rank');
        print('Education ADD $e');
      }
    } else
      showToast(context, 'Enter complete information');
  }
}
