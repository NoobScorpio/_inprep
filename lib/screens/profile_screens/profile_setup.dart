import 'dart:async';
import 'dart:io';
import 'package:InPrep/screens/screens/locationSelectScreen.dart';
import 'package:InPrep/screens/profile_screens/education_screen.dart';
import 'package:InPrep/screens/profile_screens/experience_screen.dart';
import 'package:InPrep/screens/profile_screens/portfolio_screen.dart';
import 'package:InPrep/screens/profile_screens/skill_screen.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/social.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/my_divider.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:images_picker/images_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetup extends StatefulWidget {
  static String id = 'ProfileSetup';
  final seeker;
  final user;
  final dark;

  ProfileSetup({this.user, this.seeker, this.dark});
  @override
  _ProfileSetupState createState() =>
      _ProfileSetupState(seeker: seeker, user: user);
}

class _ProfileSetupState extends State<ProfileSetup> {
  DatabaseService _databaseService = DatabaseService();
  var catValue = 'Select',
      subCatValue = 'Select',
      cityValue = "Select",
      stateValue = "Select",
      countryValue = "Select";
  final bool seeker;
  final MyUser user;
  _ProfileSetupState({this.seeker, this.user});
  final GlobalKey<ScaffoldState> _scaffoldProfileSetupKey =
      new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    visibleContact = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => setValues());
  }

  SharedPreferences preferences;
  final TextEditingController otherCont = TextEditingController();
  setValues() {
    displayNameController.text = user.displayName;

    if (user.profile) {
      setState(() {
        catValue = user.category.toString() ?? 'Select';
        subCatValue =
            user.subCategory ?? subs[user.category.toString() ?? 'Select'][0];
        designationController.text = user.design;
        cityValue = user.city;
        countryValue = user.country;
        descriptionController.text = user.desc;
        stateValue = user.state;
        priceFromController.text = user.priceFrom.toString();
        priceToController.text = user.priceTo.toString();
        if (user.social != null) {
          fbUnameController.text = user.social.fb;
          linkedInUnameController.text = user.social.linkedin;
          githubUnameController.text = user.social.git;
          skypeUnameController.text = user.social.skype;
          instaUnameController.text = user.social.insta;
          tiktokUnameController.text = user.social.tiktok;
        }
        if (user.contact != null) {
          contact = user.contact;
          phoneNumber = user.contact.number ?? '';
          phoneCode = user.contact.code ?? '';
          numberController.text = phoneNumber;
        }

        visibleContact = phoneCode != '' && phoneCode != null ? true : false;
        socialVisible = user.social != null ? true : false;
        uploadConf = true;
      });
    } else {
      setState(() {
        catValue = user.category.toString() ?? 'Select';
        subCatValue =
            user.subCategory ?? subs[user.category.toString() ?? 'Select'][0];
        if (user.subCategory == "Other") otherCont.text = user.other ?? "";
      });
    }
  }

//
//  CATEGORY
//
//

//                    HEADER
//
  bool uploadConf = false;
  String displayName, designation, city, country, description;
  final displayNameController = TextEditingController(
    text: "",
  );
  final designationController = TextEditingController(
    text: "",
  );

  final descriptionController = TextEditingController(
    text: "",
  );

  final priceFromController = TextEditingController(
    text: "",
  );
  final priceToController = TextEditingController(
    text: "",
  );
  final _formHeaderKey = GlobalKey<FormState>();
//
//              SOCIAL
//
  Social social;
  bool socialVisible = false;
  String fbUname,
      linkedInUname,
      githubUname,
      skypeUname,
      instaUname,
      tiktokUname;
  final fbUnameController = TextEditingController(
    text: "",
  );
  final linkedInUnameController = TextEditingController(
    text: "",
  );
  final githubUnameController = TextEditingController(
    text: "",
  );
  final skypeUnameController = TextEditingController(text: '');
  final instaUnameController = TextEditingController(text: '');
  final tiktokUnameController = TextEditingController(text: '');

//
//           CONTACT
//
  bool contactAdded = false;
  bool visibleContact;
  String phoneCode, phoneNumber;
  final _formContactKey = GlobalKey<FormState>();
  Contact contact;
  final numberController = TextEditingController(
    text: "",
  );

  @override
  void dispose() {
    fbUnameController.dispose();
    linkedInUnameController.dispose();
    githubUnameController.dispose();
    numberController.dispose();
    displayNameController.dispose();
    descriptionController.dispose();
    otherCont.dispose();
    instaUnameController.dispose();
    tiktokUnameController.dispose();
    super.dispose();
  }

  bool imageAdded = false;
  List<Media> res = List<Media>();
  List<File> files = List<File>();
  List<Widget> reviews = [];

  Widget buildTitle(String title, bool dark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 18.0,
              color: dark ? Colors.grey : Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: dark ? Colors.white60 : Colors.black38,
          ),
        ],
      ),
    );
  }

  showSnack(text) {
    _scaffoldProfileSetupKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text('$text'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    Color color = dark ? Colors.white : Theme.of(context).primaryColor;
    Color colorTxt = dark ? Colors.grey : Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text('Edit Profile'),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
      ),
      key: _scaffoldProfileSetupKey,
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//HEADER
                    SizedBox(height: 20.0),
                    Form(
                      key: _formHeaderKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      //COVER
                                      Center(
                                        child: CachedNetworkImage(
                                          imageUrl: user.cover ?? "",
                                          imageBuilder: (context, image) {
                                            return Container(
                                              height: 125,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.black,
                                                  image: DecorationImage(
                                                    image: image,
                                                    fit: BoxFit.cover,
                                                  )),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await uploadImage(
                                                        user, true);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      radius: 21,
                                                      child: CircleAvatar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          radius: 20,
                                                          child: Icon(
                                                              Icons.edit,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          placeholder: (context, image) {
                                            return Container(
                                              height: 125,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: Colors.black,
                                              ),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.green,
                                                ),
                                              ),
                                            );
                                          },
                                          errorWidget: (context, image, err) {
                                            return Container(
                                              height: 125,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/icons/logo1024.png"),
                                                  )),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await uploadImage(
                                                        user, true);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      radius: 21,
                                                      child: CircleAvatar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          radius: 20,
                                                          child: Icon(
                                                              Icons.edit,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      //PROFILE PICTURE
                                      Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 60.0),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.black,
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: user.photoUrl ?? "",
                                                  imageBuilder:
                                                      (context, image) {
                                                    return Container(
                                                      width: 100.0,
                                                      height: 100.0,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          360)),
                                                          image:
                                                              DecorationImage(
                                                                  image: image,
                                                                  fit: BoxFit
                                                                      .cover)),
                                                    );
                                                  },
                                                  placeholder:
                                                      (context, image) {
                                                    return Container(
                                                      width: 100.0,
                                                      height: 100.0,
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
                                                    if (user.photoUrl == "" ||
                                                        user.photoUrl == null)
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          360)),
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                        width: 100.0,
                                                        height: 100.0,
                                                        child: Center(
                                                          child: Center(
                                                            child: Text(
                                                              "${user.displayName == null || user.displayName == "" ? user.email[0].toUpperCase() : user.displayName[0].toUpperCase()}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 42,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    else {
                                                      return Container(
                                                        width: 100.0,
                                                        height: 100.0,
                                                        child: Center(
                                                          child: InkWell(
                                                            onTap: () {
                                                              showToast(context,
                                                                  "Error loading profile image. Re-upload to view");
                                                            },
                                                            child: Center(
                                                              child: Icon(
                                                                  Icons.error),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 55.0,
                                                            left: 12),
                                                    child: Card(
                                                      elevation: 6,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    360.0),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await uploadImage(
                                                              user, false);
                                                        },
                                                        child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MyDivider(),
//                          NAME
                              MyTextFormField(
                                controller: displayNameController,
                                validator: (text) {
                                  if (displayNameController.text.toString() ==
                                      '') {
                                    return 'Please fill this field';
                                  } else if (displayNameController.text
                                          .toString()
                                          .length <
                                      3) {
                                    return 'Name should have at least 3 characters';
                                  } else
                                    return null;
                                },
                                onChanged: (text) {
                                  displayName = displayNameController.text
                                      .toString()
                                      .toLowerCase();
                                },
                                labelText: 'Full Name',
                                prefixIcon:
                                    Icon(Icons.perm_identity, color: color),
                              ),
                              MyDivider(),
//                          DESIGNATION
                              MyTextFormField(
                                controller: designationController,
                                validator: (text) {
                                  if (designationController.text.toString() ==
                                      '') {
                                    return 'Please fill this field';
                                  } else
                                    return null;
                                },
                                onChanged: (text) {
                                  designation =
                                      designationController.text.toString();
                                },
                                labelText: 'Title',
                                prefixIcon: Icon(Icons.work, color: color),
                              ),
                              MyDivider(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: dark
                                                      ? Colors.grey
                                                      : Theme.of(context)
                                                          .primaryColor),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15.0),
                                                  child: Text(
                                                    "$countryValue, $stateValue ${(cityValue != "" && cityValue != null && cityValue != "Select") ? (", $cityValue") : ""} ",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: dark
                                                            ? Colors.grey
                                                            : Colors.black87),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          var location = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      LocationSelectScreen()));
                                          if (location != null) {
                                            setState(() {
                                              countryValue =
                                                  location['country'];
                                              stateValue = location['state'];
                                              cityValue = location['city'];
                                            });
                                          }
                                        },
                                        child: Text("Select"))
                                  ],
                                ),
                              ),

                              MyDivider(),
//                          DESCRIPTION
                              MyTextFormField(
                                controller: descriptionController,
                                validator: (text) {
                                  if (descriptionController.text.toString() ==
                                      '') {
                                    return 'Please fill this field';
                                  } else
                                    return null;
                                },
                                onChanged: (text) {
                                  description =
                                      descriptionController.text.toString();
                                },
                                labelText: seeker
                                    ? 'Write a bit about yourself'
                                    : 'Write a bit about the Expertise',
                                maxline: 5,
                                prefixIcon: Icon(Icons.info),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    if (!seeker) SizedBox(height: 40.0),

                    SizedBox(height: 40.0),

//
//              CATEGORY
//
                    if (!seeker)
                      Column(
                        children: [
                          buildTitle('Category', dark),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),

                                // dropdown below..
                                child: DropdownButton<String>(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconSize: 42,
                                  value: catValue,
                                  underline: SizedBox(),
                                  items: catList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        '$value',
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    setState(() {
                                      catValue = _;
                                      subCatValue = subs[catValue][0];
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),

                                // dropdown below..
                                child: DropdownButton<String>(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  iconSize: 42,
                                  value: subCatValue,
                                  underline: SizedBox(),
                                  items: subs[catValue].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        '$value',
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    setState(() {
                                      subCatValue = _;
                                    });
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(
                                            'Category',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          content: Container(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Select a category for the profile and you will be found based on category'),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text('ok'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          if (subCatValue == "Other")
                            MyTextFormField(
                              labelText: 'Write Sub Category',
                              maxline: 1,
                              controller: otherCont,
                              maxLength: 50,
                              onChanged: (val) {
                                if (val != '' &&
                                    val != null &&
                                    val.length <= 1) {
                                  otherCont.text = otherCont.text.toUpperCase();
                                  otherCont.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: otherCont.text.length));
                                }
                              },
                            ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    SizedBox(height: 20.0),
//
//              PRICE RANGE
//
                    if (!seeker)
                      Column(
                        children: [
                          SizedBox(height: 20.0),
                          buildTitle('Your Price Range', dark),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: MyTextFormField(
                                  labelText: 'From',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icon(
                                    Icons.monetization_on_outlined,
                                    color: color,
                                  ),
                                  controller: priceFromController,
                                ),
                              ),
                              Expanded(
                                child: MyTextFormField(
                                  labelText: 'To',
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icon(
                                      Icons.monetization_on_outlined,
                                      color: color),
                                  controller: priceToController,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
//SKILLS
                    if (!seeker)
                      Column(children: <Widget>[
                        SizedBox(height: 20.0),
                        buildTitle("Skills (OPTIONAL)", dark),
                        InkWell(
                          onTap: () async {
                            push(context, SkillScreen(user.uid));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Add/Edit skills',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded)
                              ],
                            ),
                          ),
                        ),
                      ]),

//
//EXPERIENCE
//
                    if (!seeker)
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          buildTitle("Experience (OPTIONAL)", dark),
                          InkWell(
                            onTap: () async {
                              push(context, ExperienceScreen(user.uid));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add/Edit Experience',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
//
//EDUCATION
//
                    if (!seeker)
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          buildTitle("Education (OPTIONAL)", dark),
                          InkWell(
                            onTap: () async {
                              push(context, EducationScreen(user.uid));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add/Edit Education',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    //
//PORTFOLIO
//
                    if (!seeker)
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          buildTitle("Portfolio (OPTIONAL)", dark),
                          InkWell(
                            onTap: () async {
                              push(context, PortfolioScreen(user.uid));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add/Edit Portfolio',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    //
                    //CONTACT
                    //
                    Column(
                      children: <Widget>[
                        Form(
                          key: _formContactKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              buildTitle("Contact (Optional)", dark),
                              SizedBox(height: 5.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: RaisedButton(
                                        onPressed: () {
                                          showCountryPicker(
                                            context: context,
                                            //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                            exclude: <String>['KN', 'MF'],
                                            //Optional. Shows phone code before the country name.
                                            showPhoneCode: true,
                                            onSelect: (Country country) {
                                              setState(() {
                                                phoneCode = country.phoneCode
                                                    .toString();
                                              });
                                            },
                                          );
                                        },
                                        color: colorTxt,
                                        child: Text(
                                          phoneCode ?? 'Code',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MyTextFormField(
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      controller: numberController,
                                      validator: (code) {
                                        return null;
                                      },
                                      padding: EdgeInsets.all(8),
                                      labelText: 'Phone',
                                      onChanged: (number) {
                                        phoneNumber = numberController.text
                                            .toString()
                                            .trim();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),

//
//SOCIAL MEDIA
//
                    SizedBox(height: 20.0),
                    buildTitle("Social-Media (Optional)", dark),

                    MyTextFormField(
                      prefixIcon: Icon(
                        FontAwesomeIcons.facebookF,
                        color: color,
                      ),
                      labelText: 'Facebook Username',
                      controller: fbUnameController,
                      onChanged: (text) {
                        fbUname = fbUnameController.text.toString().trim();
                      },
                    ),
                    SizedBox(height: 20.0),
                    MyTextFormField(
                      prefixIcon: Icon(
                        FontAwesomeIcons.linkedin,
                        color: color,
                      ),
                      labelText: 'LinkedIn Username',
                      controller: linkedInUnameController,
                      onChanged: (text) {
                        linkedInUname =
                            linkedInUnameController.text.toString().trim();
                      },
                    ),
                    SizedBox(height: 20.0),
                    MyTextFormField(
                      prefixIcon: Icon(
                        FontAwesomeIcons.github,
                        color: color,
                      ),
                      labelText: 'Github Username',
                      controller: githubUnameController,
                      onChanged: (text) {
                        githubUname =
                            githubUnameController.text.toString().trim();
                      },
                    ),
                    SizedBox(height: 20.0),
                    MyTextFormField(
                      prefixIcon: Icon(
                        FontAwesomeIcons.instagram,
                        color: color,
                      ),
                      labelText: 'Instagram Username',
                      controller: instaUnameController,
                      onChanged: (text) {
                        instaUname =
                            instaUnameController.text.toString().trim();
                      },
                    ),
                    SizedBox(height: 20.0),
                    MyTextFormField(
                      prefixIcon: Icon(
                        Icons.music_note,
                        color: color,
                      ),
                      labelText: 'Tiktok Username',
                      controller: tiktokUnameController,
                      onChanged: (text) {
                        tiktokUname =
                            tiktokUnameController.text.toString().trim();
                      },
                    ),
                    SizedBox(height: 20.0),
                    MyTextFormField(
                      prefixIcon: Icon(
                        FontAwesomeIcons.skype,
                        color: color,
                      ),
                      labelText: 'Skype Username',
                      controller: skypeUnameController,
                      onChanged: (text) {
                        skypeUname =
                            skypeUnameController.text.toString().trim();
                      },
                    ),
                    SizedBox(height: 20.0),

                    SizedBox(height: 20.0),
//
//                DONE BUTTON
                    Center(
                      child: Container(
                        height: 50,
                        color: Colors.black12.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              showToast(context, 'Saving data');
                              showDialog(
                                  context: context,
                                  builder: (_) => Center(
                                        child: CircularProgressIndicator(),
                                      ));
                              if (_formHeaderKey.currentState.validate()) {
                                if (fbUnameController.text == '' &&
                                    linkedInUnameController.text == '' &&
                                    githubUnameController.text == '' &&
                                    tiktokUnameController.text == '' &&
                                    instaUnameController.text == '' &&
                                    skypeUnameController.text == '') {
                                  showSnack(
                                      "Enter at least one social username");
                                } else {
                                  MyUser currUser = await _databaseService
                                      .getcurrentUserData(user.uid);

                                  currUser.social = Social(
                                      uid: user.uid,
                                      fb: fbUnameController.text ?? '',
                                      git: githubUnameController.text ?? '',
                                      linkedin:
                                          linkedInUnameController.text ?? '',
                                      tiktok: tiktokUnameController.text ?? '',
                                      insta: instaUnameController.text ?? '',
                                      skype: skypeUnameController.text ?? '');
                                  currUser.contact = Contact(
                                      uid: user.uid,
                                      code: phoneCode,
                                      number: phoneNumber);
                                  currUser.category = catValue.toString();
                                  currUser.subCategory = subCatValue.toString();
                                  currUser.seeker = user.seeker;
                                  currUser.displayName =
                                      displayNameController.text;
                                  currUser.design = designationController.text;
                                  currUser.country = countryValue;
                                  currUser.city = cityValue;
                                  currUser.desc = descriptionController.text;
                                  currUser.state = stateValue;
                                  currUser.other = otherCont.text;
                                  currUser.email = user.email;
                                  currUser.profile = true;
                                  // CONSULTANT
                                  if (!seeker) {
                                    String priceTo =
                                        priceToController.text.toString() ?? '';
                                    String priceFrom =
                                        priceFromController.text.toString() ??
                                            '';
                                    currUser.priceFrom = priceFrom;
                                    currUser.priceTo = priceTo;
                                    bool userdata = await _databaseService
                                        .setCurrentUserProfile(user: currUser);
                                    if (userdata) {
                                      await BlocProvider.of<UserCubit>(context)
                                          .update(currUser);
                                      showSnack('Saved');
                                      Navigator.pop(context, true);
                                      Navigator.pop(context, true);
                                    } else {
                                      Navigator.pop(context);
                                      showToast(
                                          context, 'Something went wrong...');
                                    }
                                  }
//                              SEEKER
                                  else {
                                    bool userdata = await _databaseService
                                        .setCurrentUserProfile(user: currUser);
                                    if (userdata) {
                                      await BlocProvider.of<UserCubit>(context)
                                          .update(currUser);
                                      showToast(context, 'Data Saved');
                                      Navigator.pop(context, true);
                                      Navigator.pop(context, true);
                                    } else
                                      showToast(
                                          context, 'Something went wrong');
                                  }
                                }
                              }
//                            HEADER VALUES ELSE
                              else {
                                Navigator.pop(context);
                                showToast(
                                    context, 'Please fill basic information');
                              }
                            },
                            child: Text(
                              'Done',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
//
//                INFO ICON
                    Center(
                      child: FlatButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Content Saving"),
                                  content: Text(
                                      "Content with plus icon is saved on the cloud when pressed.\n\n"
                                      "Content like header information are save by pressing done"
                                      ""),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.info_outline,
                          color: color,
                        ),
                        label: Text(''),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ],
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
      if (media != null) {
        selected = File(media[0].path);
        FirebaseStorage _storage;

        UploadTask _uploadTask;
        _storage = FirebaseStorage.instanceFor(
            bucket: 'gs://inprep-c8711.appspot.com');
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
      } else
        return "";
    } catch (e) {
      print("UPLOAD ERROR $e");
      return "";
    }
  }

  Future<void> uploadImage(MyUser user, cover) async {
    showLoader(context);
    String upload = await pickImage();
    if (upload != "") {
      if (cover) {
        user.cover = upload;
        await _databaseService.userCollection
            .doc(user.uid)
            .update(user.toJson());
        setState(() {
          user.cover = upload;
        });
      } else {
        user.photoUrl = upload;
        await _databaseService.userCollection
            .doc(user.uid)
            .update(user.toJson());
        setState(() {
          user.photoUrl = upload;
        });
      }
    }
    Navigator.pop(context);
  }
}
