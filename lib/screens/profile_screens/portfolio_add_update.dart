import 'dart:io';

import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/portfolio.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

class AddUpdatePortfolio extends StatefulWidget {
  const AddUpdatePortfolio({this.currUser, this.edit, this.portfolio})
      : super();
  final MyUser currUser;
  final bool edit;
  final Portfolio portfolio;
  @override
  _AddUpdatePortfolioState createState() => _AddUpdatePortfolioState();
}

class _AddUpdatePortfolioState extends State<AddUpdatePortfolio> {
  TextEditingController title = TextEditingController(),
      from = TextEditingController(),
      to = TextEditingController();
  bool current = false;
  String url = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit) {
      title.text = widget.portfolio.title;
      from.text = widget.portfolio.from;
      to.text = widget.portfolio.to;
      current = widget.portfolio.current;
      url = widget.portfolio.image;
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
        title: Text('${widget.edit ? 'Edit' : 'Add'} Portfolio'),
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
                    '${widget.edit ? 'Edit' : 'Add'} Portfolio',
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
                  hint: 'Enter portfolio title',
                  labelText: 'Portfolio title',
                  prefixIcon: Icon(Icons.title_outlined,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    InkWell(
                      onTap: () async {
                        await uploadImage(widget.currUser);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Add Image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: dark ?? false
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl: url ?? "",
                              imageBuilder: (context, image) {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
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
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, image, err) {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Icon(Icons.add_a_photo_outlined),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (widget.edit)
            editPortfolio();
          else
            addPortfolio();
        },
        label: Text('${widget.edit ? 'Edit' : 'Add'} portfolio'),
        icon: Icon(widget.edit ? Icons.edit : Icons.add),
      ),
    );
  }

  Future<String> pickImage() async {
    try {
      File selected;
      List<Media> media = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.image,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect, // currently for android
        ),
      );
      selected = File(media[0].path);
      FirebaseStorage _storage;

      UploadTask _uploadTask;
      _storage =
          FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // setState(() {
      _uploadTask =
          _storage.ref().child('images').child(fileName).putFile(selected);
      if (_uploadTask == null)
        return "";
      else {
        final snap = await _uploadTask.whenComplete(() => {});
        return await snap.ref.getDownloadURL();
      }
    } catch (e) {
      print("UPLOAD ERROR $e");
      return "";
    }
  }

  Future<void> uploadImage(MyUser user) async {
    showLoader(context);
    String upload = await pickImage();
    setState(() {
      url = upload;
    });
    pop(context);
  }

  addPortfolio() async {
    if (title.text != '' && from.text != '' && url != '') {
      try {
        showToast(context, 'Adding Portfolio');
        DatabaseService db = DatabaseService();
        Portfolio portfolio = await db.createPortfolio(
            portfolio: Portfolio(
                uid: widget.currUser.uid,
                title: title.text,
                to: to.text,
                image: url,
                from: from.text,
                current: current));
        MyUser user = widget.currUser;
        user.portfolio.add(portfolio);
        await db.userCollection.doc(user.uid).update(user.toJson());
        pop(context);
      } catch (e) {
        showToast(context, 'Enter only digits in rank');
        print('Portfolio ADD $e');
      }
    } else
      showToast(context, 'Enter complete information');
  }

  editPortfolio() async {
    if (title.text != '' && from.text != '' && url != '') {
      try {
        showToast(context, 'Editing Portfolio');
        DatabaseService db = DatabaseService();
        Portfolio portfolio = widget.portfolio;
        portfolio.title = title.text;
        portfolio.image = url;
        portfolio.to = to.text;
        portfolio.from = from.text;
        portfolio.current = current;
        await db.portfolioCollection
            .doc(portfolio.pid)
            .update(portfolio.toJson());

        MyUser user = widget.currUser;
        for (Portfolio port in user.portfolio) {
          if (port.pid == portfolio.pid) {
            user.portfolio.remove(port);
            user.portfolio.add(portfolio);
            break;
          }
        }
        await db.userCollection.doc(user.uid).update(user.toJson());
        pop(context);
      } catch (e) {
        showToast(context, 'Enter only digits in rank');
        print('portfolio ADD $e');
      }
    } else
      showToast(context, 'Enter complete information');
  }
}
