import 'dart:async';
import 'dart:io';
import 'package:InPrep/screens/locationSelectScreen.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/education.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/portfolio.dart';
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

String url;

class _ProfileSetupState extends State<ProfileSetup> {
  DatabaseService _databaseService = DatabaseService();

  var catValue = 'Select',
      subCatValue = 'Select',
      cityValue = "Select",
      stateValue = "Select",
      countryValue = "Select";
  final bool seeker;
  final MyUser user;
  bool dark = false;
  _ProfileSetupState({this.seeker, this.user});
  final GlobalKey<ScaffoldState> _scaffoldProfileSetupKey =
      new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getPrefs();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // getUser();
      // setCol();
    });

    visibleContact = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => setValues());
  }

  getPrefs() async {
    preferences = await SharedPreferences.getInstance();
    dark = preferences.getBool('dark');
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
          // //print('${user.contact}');
          contact = user.contact;
          phoneNumber = user.contact.number ?? '';
          phoneCode = user.contact.code ?? '';
          numberController.text = phoneNumber;
          //print(phoneNumber);
        }

        visibleContact = phoneCode != '' && phoneCode != null ? true : false;
        // //print("${codeController.text} IS THE CODE");
        socialVisible = user.social != null ? true : false;
        uploadConf = true;
        url = user.photoUrl;
        if (!user.seeker) {
          user.skills = user.skills == null ? [] : user.skills;
          user.experiences = user.experiences == null ? [] : user.experiences;
          user.educations = user.educations == null ? [] : user.educations;
          user.portfolio = user.portfolio == null ? [] : user.portfolio;
          skills = user.skills;
          exp = user.experiences;
          edu = user.educations;
          port = user.portfolio;
        } else {
          // //print("USER IS NOT SEEKER");
          // //print("SO SKYPE IS ${user.skype}");
        }
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
//            PORTFOLIO
//
  bool portCurr = false;
  final portfolioTitleController = TextEditingController(text: '');
  final portfolioToController = TextEditingController(text: '');
  final portfolioFromController = TextEditingController(text: '');
  List<Portfolio> port = List<Portfolio>.generate(0, (index) {
    return Portfolio();
  });
  final _formCompanyPortfolioKey = GlobalKey<FormState>();

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
//
//             SKILL
//
  List<Skill> skills = List<Skill>.generate(0, (index) {
    return Skill(name: '$index name', rank: index);
  });
  String skillName;
  int skillValue;

  final skillTextController = TextEditingController(
    text: "",
  );
  final skillNameEditController = TextEditingController(
    text: "",
  );
  final skillRankEditController = TextEditingController(
    text: "",
  );
//
//            EXPERIENCE
//
  bool expCurr = false;
  List<Experience> exp = List<Experience>.generate(0, (index) {
    return Experience(title: '$index name', from: "index");
  });
  final _formExpKey = GlobalKey<FormState>();
  String title, design, expFrom, expTo;
  final expTitleTextController = TextEditingController(
    text: "",
  );
  final expDesignTextController = TextEditingController(
    text: "",
  );
  final expToTextController = TextEditingController(
    text: "",
  );
  final expFromTextController = TextEditingController(
    text: "",
  );
//
//EDUCATION
//
  final insTextController = TextEditingController(
    text: "",
  );
  final degreeTextController = TextEditingController(
    text: "",
  );
  final countryEduTextController = TextEditingController(
    text: "",
  );
  final eduTOTextController = TextEditingController(
    text: "",
  );
  final eduFromTextController = TextEditingController(
    text: "",
  );
  String institute, countryEdu, degree, eduTo, eduFrom;
  bool eduCurr = false;
  List<Education> edu = List<Education>.generate(0, (index) {
    return Education(institute: '$index name', from: "index");
  });
  final _formEduKey = GlobalKey<FormState>();

  @override
  void dispose() {
    skillTextController.dispose();
    expTitleTextController.dispose();
    expDesignTextController.dispose();
    expToTextController.dispose();
    expFromTextController.dispose();
    insTextController.dispose();
    degreeTextController.dispose();
    countryEduTextController.dispose();
    eduTOTextController.dispose();
    eduFromTextController.dispose();
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
              // color: Theme.of(context).primaryColor,
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

  // GlobalKey _uploadpic = GlobalKey();
  // GlobalKey _skill = GlobalKey();
  @override
  Widget build(BuildContext context) {
    getPrefs();
    //print("DARK IN PROFILE SETUP: $dark");
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
                                        child: Container(
                                          height: 125,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          decoration: user.cover == "" ||
                                                  user.cover == null
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.black,
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        Colors.black
                                                      ],
                                                      tileMode:
                                                          TileMode.repeated))
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Colors.black,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      user.cover,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  )),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () async {
                                                await uploadImage(user, true);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.black,
                                                  radius: 21,
                                                  child: CircleAvatar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      radius: 20,
                                                      child: Icon(Icons.edit,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                              "${user.displayName[0].toUpperCase()}",
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
                                  // FlatButton(
                                  //   color: Colors.black12.withOpacity(0.1),
                                  //   onPressed: () async {
                                  //     await uploadImage(user);
                                  //     // bool upload = await Navigator.push(
                                  //     //       context,
                                  //     //       MaterialPageRoute(
                                  //     //         builder: (context) =>
                                  //     //             ImageCapture(uid: user.uid),
                                  //     //       ),
                                  //     //     ) ??
                                  //     //     false;
                                  //     // setState(() {
                                  //     //   if (upload) uploadConf = true;
                                  //     // });
                                  //   },
                                  //   child: Text(seeker
                                  //       ? 'Upload Image'
                                  //       : 'Upload Profile Picture'),
                                  // )
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
                                                  color: Theme.of(context)
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
                                                        color: Colors.black87),
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
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          buildTitle("Skills (OPTIONAL)", dark),
                          if (skills != null)
                            Container(
                              height: 50 * (skills.length).toDouble(),
                              width: double.maxFinite,
                              child: ListView.builder(
                                itemCount: skills.length,
                                itemBuilder: (context, index) {
                                  Skill item = skills[index];
                                  String itemDesc = item.name.toUpperCase() +
                                      ' at level ${item.rank}';
                                  return Dismissible(
                                    key: Key(item.name + item.rank.toString()),
                                    direction: DismissDirection.startToEnd,
                                    child: ListTile(
                                      title: Text(
                                        itemDesc,
                                        style: TextStyle(
                                            fontSize: 18, color: colorTxt),
                                      ),
                                      trailing: Container(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                //print('$index IS THE INDEX');
                                                //print(
                                                // '${skills[index].name} IS THE ID');
                                                showSnack('Removing Skill');
                                                bool deleted =
                                                    await _databaseService
                                                        .removeSkill(
                                                            sid: skills[index]
                                                                .sid);
                                                if (deleted) {
                                                  showSnack('Deleted');
                                                  setState(() {
                                                    skills.removeAt(index);
                                                  });
                                                  // for (int i = 0;
                                                  //     i < user.skills.length;
                                                  //     i++) {
                                                  //   if (user.skills[i].sid ==
                                                  //       skills[index].sid) {
                                                  //     user.skills.removeAt(i);
                                                  //     await BlocProvider.of<
                                                  //             UserCubit>(context)
                                                  //         .update(user);
                                                  //     break;
                                                  //   }
                                                  // }
                                                } else
                                                  showSnack(
                                                      'Something went wrong');
                                              },
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: color,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      skillNameEditController
                                                              .text =
                                                          skills[index].name;
                                                      skillRankEditController
                                                              .text =
                                                          skills[index]
                                                              .rank
                                                              .toString();
                                                      return AlertDialog(
                                                        title:
                                                            Text("Edit Skill"),
                                                        content: Container(
                                                          height: 145,
                                                          child: Column(
                                                            children: [
                                                              MyTextFormField(
                                                                controller:
                                                                    skillNameEditController,
                                                                labelText:
                                                                    'Name',
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              MyTextFormField(
                                                                controller:
                                                                    skillRankEditController,
                                                                hint:
                                                                    'Between 0 and 10',
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                labelText:
                                                                    'Rank',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child:
                                                                Text('Cancel'),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text('Done'),
                                                            onPressed:
                                                                () async {
                                                              await _databaseService
                                                                  .skillCollection
                                                                  .doc(skills[
                                                                          index]
                                                                      .sid)
                                                                  .update({
                                                                'name':
                                                                    skillNameEditController
                                                                        .text
                                                                        .trim(),
                                                                'rank': int.parse(
                                                                    skillRankEditController
                                                                        .text
                                                                        .toString())
                                                              });
                                                              setState(() {
                                                                skills[index]
                                                                        .name =
                                                                    skillNameEditController
                                                                        .text
                                                                        .trim();
                                                                skills[index]
                                                                        .rank =
                                                                    int.parse(
                                                                        skillRankEditController
                                                                            .text
                                                                            .toString());
                                                              });
                                                              // for (int i = 0;
                                                              //     i <
                                                              //         user.skills
                                                              //             .length;
                                                              //     i++) {
                                                              //   if (user.skills[i]
                                                              //           .sid ==
                                                              //       skills[index]
                                                              //           .sid) {
                                                              //     user.skills[i]
                                                              //             .name =
                                                              //         skillNameEditController
                                                              //             .text
                                                              //             .trim();
                                                              //     user.skills[i]
                                                              //             .rank =
                                                              //         int.parse(
                                                              //             skillRankEditController
                                                              //                 .text
                                                              //                 .toString());
                                                              //     break;
                                                              //   }
                                                              // }
                                                              //
                                                              Navigator.pop(
                                                                  context);
                                                              // await BlocProvider.of<
                                                              //             UserCubit>(
                                                              //         context)
                                                              //     .update(user);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                                // //print('$index IS THE INDEX');
                                                // //print(
                                                //     '${skills[index].name} IS THE ID');
                                                // showSnack('Removing Skill');
                                                // bool deleted = await _databaseService
                                                //     .removeSkill(
                                                //         sid: skills[index].sid);
                                                // if (deleted) {
                                                //   showSnack('Deleted');
                                                //   setState(() {
                                                //     skills.removeAt(index);
                                                //   });
                                                // } else
                                                //   showSnack('Something went wrong');
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onDismissed: (direction) async {
                                      //print('${skills[index].sid} IS IN SETUP');
                                      showSnack('Removing Skill');
                                      bool deleted = await _databaseService
                                          .removeSkill(sid: skills[index].sid);
                                      if (deleted) {
                                        showSnack('Deleted');
                                        setState(() {
                                          skills.removeAt(index);
                                        });
                                        // for (int i = 0;
                                        //     i < user.skills.length;
                                        //     i++) {
                                        //   if (user.skills[i].sid ==
                                        //       skills[index].sid) {
                                        //     user.skills.removeAt(i);
                                        //     await BlocProvider.of<UserCubit>(
                                        //             context)
                                        //         .update(user);
                                        //     break;
                                        //   }
                                        // }
                                      } else
                                        showSnack('Something went wrong');
                                    },
                                  );
                                },
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: MyTextFormField(
                                      labelText: 'Skill',
                                      controller: skillTextController,
                                      onChanged: (text) {
                                        skillName = skillTextController.text
                                            .toLowerCase();
                                      },
                                    ),
                                  ),
                                ),
                                DropdownButton<int>(
                                  value: skillValue,
                                  items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                      .map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: new Text('$value'),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    setState(() {
                                      skillValue = _;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: FlatButton.icon(
                                onPressed: () async {
                                  showSnack('Adding Skill');
                                  if (skillTextController.text != "") {
                                    //print('${user.uid} IS THE UID IN SKILL');
                                    Skill skill =
                                        await _databaseService.createSkill(
                                            uid: user.uid,
                                            name: skillName,
                                            rank: skillValue != null
                                                ? skillValue
                                                : 1);

                                    if (skill != null) {
                                      showSnack('Added');
                                      setState(() {
                                        //print('${skill.sid} is  SKILL ADDED');
                                        skills.add(skill);
                                        skillTextController.clear();
                                      });
                                      // user.skills.add(skill);
                                      // await BlocProvider.of<UserCubit>(context)
                                      //     .update(user);
                                    } else {
                                      showSnack('Something went wrong.');
                                    }
                                  } else
                                    showSnack('Enter skill name...');
                                },
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 35,
                                  color: color,
                                ),
                                label: Text('')),
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),

//
//EXPERIENCE
//
                    if (!seeker)
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Form(
                            key: _formExpKey,
                            child: Column(
                              children: <Widget>[
                                buildTitle("Experience (OPTIONAL)", dark),
                                if (exp != null)
                                  Container(
                                    height: 50 * (exp.length).toDouble(),
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      itemCount: exp.length,
                                      itemBuilder: (context, index) {
                                        Experience item = exp[index];
                                        String expDesc =
                                            "Worked as ${item.designation} at ${item.title} from ${item.from} to ${item.to}";
                                        return Dismissible(
                                          key: Key(index.toString()),
                                          direction:
                                              DismissDirection.startToEnd,
                                          child: ListTile(
                                            title: Text(
                                              expDesc,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: colorTxt),
                                            ),
                                            trailing: Container(
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_forever,
                                                      color: color,
                                                    ),
                                                    onPressed: () async {
                                                      showSnack(
                                                          'Removing Experience');
                                                      bool deleted =
                                                          await _databaseService
                                                              .removeExperience(
                                                                  eid:
                                                                      exp[index]
                                                                          .eid);
                                                      if (deleted) {
                                                        setState(() {
                                                          showSnack('Deleted');
                                                          exp.removeAt(index);
                                                        });
                                                        // for (int i = 0;
                                                        //     i <
                                                        //         user.experiences
                                                        //             .length;
                                                        //     i++) {
                                                        //   if (user.experiences[i]
                                                        //           .eid ==
                                                        //       exp[index].eid) {
                                                        //     user.experiences
                                                        //         .removeAt(i);
                                                        //     await BlocProvider.of<
                                                        //                 UserCubit>(
                                                        //             context)
                                                        //         .update(user);
                                                        //     break;
                                                        //   }
                                                        // }
                                                        // await BlocProvider.of<
                                                        //         UserCubit>(context)
                                                        //     .update(user);
                                                      } else
                                                        showSnack(
                                                            'Something went wrong');
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              expTitleTextController
                                                                      .text =
                                                                  exp[index]
                                                                      .title;

                                                              expDesignTextController
                                                                  .text = exp[
                                                                      index]
                                                                  .designation
                                                                  .toString();
                                                              expFromTextController
                                                                  .text = exp[
                                                                      index]
                                                                  .from
                                                                  .toString();
                                                              expToTextController
                                                                  .text = exp[
                                                                      index]
                                                                  .to
                                                                  .toString();
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Edit Experience"),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .maxFinite,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        MyTextFormField(
                                                                          controller:
                                                                              expTitleTextController,
                                                                          labelText:
                                                                              'Worked At',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              expDesignTextController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          labelText:
                                                                              'Position',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              expFromTextController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          labelText:
                                                                              'From',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              expToTextController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          labelText:
                                                                              'To',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 15.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text('Current', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Switch(
                                                                                  value: exp[index].current,
                                                                                  onChanged: (val) {
                                                                                    setState(() {
                                                                                      exp[index].current = val;
                                                                                      expCurr = val;
                                                                                      exp[index].to = val ? "Present" : expToTextController.text;
                                                                                      expToTextController.text = val ? "Present" : expToTextController.text;
                                                                                    });
                                                                                  }),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'Cancel'),
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'Done'),
                                                                    onPressed:
                                                                        () async {
                                                                      await _databaseService
                                                                          .experienceCollection
                                                                          .doc(exp[index]
                                                                              .eid)
                                                                          .update({
                                                                        'title': expTitleTextController
                                                                            .text
                                                                            .trim(),
                                                                        'designation': expDesignTextController
                                                                            .text
                                                                            .toString(),
                                                                        'to': exp[index].current
                                                                            ? "Present"
                                                                            : expToTextController.text.toString(),
                                                                        'from': expFromTextController
                                                                            .text
                                                                            .toString(),
                                                                        'current':
                                                                            exp[index].current
                                                                      });

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                          });
                                                      setState(() {
                                                        expDesc =
                                                            "Worked as ${expDesignTextController.text.toString()} at ${expTitleTextController.text.trim()} from ${expFromTextController.text.toString()} to ${expToTextController.text.toString()}";
                                                        exp[index].title =
                                                            expTitleTextController
                                                                .text
                                                                .trim();
                                                        exp[index].designation =
                                                            expDesignTextController
                                                                .text
                                                                .toString();
                                                        exp[index].to =
                                                            expToTextController
                                                                .text
                                                                .toString();
                                                        exp[index].from =
                                                            expFromTextController
                                                                .text
                                                                .toString();
                                                        exp[index].current =
                                                            expCurr;
                                                      });
                                                      // for (int i = 0;
                                                      //     i <
                                                      //         user.experiences
                                                      //             .length;
                                                      //     i++) {
                                                      //   if (user.experiences[i]
                                                      //           .eid ==
                                                      //       exp[index].eid) {
                                                      //     user.experiences[i] =
                                                      //         exp[index];
                                                      //     await BlocProvider.of<
                                                      //                 UserCubit>(
                                                      //             context)
                                                      //         .update(user);
                                                      //     break;
                                                      //   }
                                                      // }
                                                      // await BlocProvider.of<
                                                      //         UserCubit>(context)
                                                      //     .update(user);
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onDismissed: (direction) async {
                                            showSnack('Removing Experience');
                                            bool deleted =
                                                await _databaseService
                                                    .removeExperience(
                                                        eid: exp[index].eid);
                                            if (deleted) {
                                              setState(() {
                                                showSnack('Deleted');
                                                exp.removeAt(index);
                                              });
                                              // for (int i = 0;
                                              //     i < user.experiences.length;
                                              //     i++) {
                                              //   if (user.experiences[i].eid ==
                                              //       exp[index].eid) {
                                              //     user.experiences.removeAt(i);
                                              //     break;
                                              //   }
                                              // }
                                              // await BlocProvider.of<UserCubit>(
                                              //         context)
                                              //     .update(user);
                                            } else
                                              showSnack('Something went wrong');
                                          },
                                        );
                                      },
                                    ),
                                  ),
//                      WORKEDAT
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: MyTextFormField(
                                      validator: (val) {
                                        if (val == '') {
                                          return 'Please fill this field';
                                        } else
                                          return null;
                                      },
                                      labelText: "Worked At",
                                      controller: expTitleTextController,
                                      onChanged: (text) {
                                        title = expTitleTextController.text
                                            .toString();
                                      }),
                                ),
//                      POSTION
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: MyTextFormField(
                                    validator: (val) {
                                      if (val == '') {
                                        return 'Please fill this field';
                                      } else
                                        return null;
                                    },
                                    labelText: "Postion",
                                    controller: expDesignTextController,
                                    onChanged: (text) {
                                      design = expDesignTextController.text
                                          .toString();
                                    },
                                  ),
                                ),
//                FROM
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MyTextFormField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 4,
                                          labelText: 'From',
                                          validator: (val) {
                                            if (val.toString() == '') {
                                              return 'Please fill this field';
                                            } else if (val.toString().length <
                                                4) {
                                              return 'Years should be in XXXX format';
                                            } else
                                              return null;
                                          },
                                          controller: expFromTextController,
                                          onChanged: (text) {
                                            expFrom = expFromTextController.text
                                                .toString();
                                          },
                                        ),
                                      ),
                                    ),
//                To

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MyTextFormField(
                                          keyboardType: TextInputType.number,
                                          validator: (val) {
                                            if (expCurr) {
                                              expToTextController.text =
                                                  'Present';
                                              expTo = 'Present';
                                              return null;
                                            } else {
                                              if (val.toString() == '') {
                                                return 'Please fill this field';
                                              } else if (val.toString().length <
                                                  4) {
                                                return 'Years should be in XXXX format';
                                              } else
                                                return null;
                                            }
                                          },
                                          labelText: 'To',
                                          maxLength: 4,
                                          controller: expToTextController,
                                          onChanged: (text) {
                                            expTo = expToTextController.text
                                                .toString();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
//CURRENT
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Row(
                                    children: [
                                      Text('Current',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Switch(
                                          value: expCurr,
                                          onChanged: (val) {
                                            setState(() {
                                              expCurr = val;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
//                      BUTTON
                                Center(
                                  child: FlatButton.icon(
                                      onPressed: () async {
                                        showSnack('Adding Experience');
                                        if (_formExpKey.currentState
                                            .validate()) {
                                          Experience experience =
                                              await _databaseService
                                                  .createExperience(
                                                      title: title,
                                                      designation: design,
                                                      to: expTo,
                                                      from: expFrom,
                                                      uid: user.uid);
                                          if (experience != null) {
                                            setState(() {
                                              showSnack('Added');

                                              exp.add(experience);
                                              expTitleTextController.clear();
                                              expDesignTextController.clear();
                                              expToTextController.clear();
                                              expFromTextController.clear();
                                            });
                                            // user.experiences.add(experience);
                                            // await BlocProvider.of<UserCubit>(
                                            //         context)
                                            //     .update(user);
                                          } else
                                            showSnack('Something went wrong');
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        size: 35,
                                        color: color,
                                      ),
                                      label: Text('')),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
//
//EDUCATION
//
                    if (!seeker)
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Form(
                            key: _formEduKey,
                            child: Column(
                              children: <Widget>[
                                buildTitle("Education (OPTIONAL)", dark),
                                SizedBox(height: 5.0),
                                if (edu != null)
                                  Container(
                                    height: 50 * (edu.length).toDouble(),
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      itemCount: edu.length,
                                      itemBuilder: (context, index) {
                                        final item = edu[index];
                                        return Dismissible(
                                          key:
                                              Key(item.institute + item.degree),
                                          direction:
                                              DismissDirection.startToEnd,
                                          child: ListTile(
                                            title: Text(
                                              "${item.degree} from ${item.institute}, ${item.country}  during ${item.from} - ${item.to}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: colorTxt),
                                            ),
                                            trailing: Container(
                                              width: 100,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_forever,
                                                      color: color,
                                                    ),
                                                    onPressed: () async {
                                                      showSnack(
                                                          'Deleting Education');
                                                      bool deleted =
                                                          await _databaseService
                                                              .removeEducation(
                                                                  eid:
                                                                      edu[index]
                                                                          .eid);
                                                      if (deleted) {
                                                        showSnack('Deleted');
                                                        setState(() {
                                                          edu.removeAt(index);
                                                        });
                                                        // for (int i = 0;
                                                        //     i <
                                                        //         user.educations
                                                        //             .length;
                                                        //     i++) {
                                                        //   if (user.educations[i]
                                                        //           .eid ==
                                                        //       edu[index].eid) {
                                                        //     user.educations
                                                        //         .removeAt(i);
                                                        //     await BlocProvider.of<
                                                        //                 UserCubit>(
                                                        //             context)
                                                        //         .update(user);
                                                        //     break;
                                                        //   }
                                                        // }
                                                        // await BlocProvider.of<
                                                        //         UserCubit>(context)
                                                        //     .update(user);
                                                      } else
                                                        showSnack(
                                                            'Something went wrong');
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              insTextController
                                                                  .text = edu[
                                                                      index]
                                                                  .institute;

                                                              degreeTextController
                                                                  .text = edu[
                                                                      index]
                                                                  .degree
                                                                  .toString();
                                                              countryEduTextController
                                                                  .text = edu[
                                                                      index]
                                                                  .country
                                                                  .toString();
                                                              eduFromTextController
                                                                  .text = edu[
                                                                      index]
                                                                  .from
                                                                  .toString();
                                                              eduTOTextController
                                                                  .text = edu[
                                                                      index]
                                                                  .to
                                                                  .toString();
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Edit Education"),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .maxFinite,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        MyTextFormField(
                                                                          controller:
                                                                              insTextController,
                                                                          labelText:
                                                                              'Institute',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              countryEduTextController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          labelText:
                                                                              'Country',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              degreeTextController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          labelText:
                                                                              'Degree/Certificate name',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              eduFromTextController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          labelText:
                                                                              'From',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        MyTextFormField(
                                                                          controller:
                                                                              eduTOTextController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          labelText:
                                                                              'To',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 15.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text('Current', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Switch(
                                                                                  value: edu[index].current,
                                                                                  onChanged: (val) {
                                                                                    setState(() {
                                                                                      eduCurr = val;
                                                                                      edu[index].current = val;
                                                                                      edu[index].to = val ? "Present" : edu[index].to;
                                                                                      eduTOTextController.text = val ? "Present" : eduTOTextController.text;
                                                                                    });
                                                                                  }),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'Cancel'),
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'Done'),
                                                                    onPressed:
                                                                        () async {
                                                                      await _databaseService
                                                                          .educationCollection
                                                                          .doc(edu[index]
                                                                              .eid)
                                                                          .update({
                                                                        'title': insTextController
                                                                            .text
                                                                            .trim(),
                                                                        'degree': degreeTextController
                                                                            .text
                                                                            .toString(),
                                                                        'to': eduTOTextController
                                                                            .text
                                                                            .toString(),
                                                                        'from': eduFromTextController
                                                                            .text
                                                                            .toString(),
                                                                        'current':
                                                                            expCurr,
                                                                        'country': countryEduTextController
                                                                            .text
                                                                            .toString(),
                                                                      });

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                          });
                                                      setState(() {
                                                        edu[index].institute =
                                                            insTextController
                                                                .text
                                                                .trim();
                                                        edu[index].country =
                                                            countryEduTextController
                                                                .text
                                                                .toString();
                                                        edu[index].degree =
                                                            degreeTextController
                                                                .text
                                                                .toString();
                                                        edu[index].from =
                                                            eduFromTextController
                                                                .text
                                                                .toString();
                                                        edu[index].to =
                                                            eduTOTextController
                                                                .text
                                                                .toString();
                                                        edu[index].current =
                                                            eduCurr;
                                                      });
                                                      // for (int i = 0;
                                                      //     i <
                                                      //         user.educations
                                                      //             .length;
                                                      //     i++) {
                                                      //   if (user.educations[i]
                                                      //           .eid ==
                                                      //       edu[index].eid) {
                                                      //     user.educations[i] =
                                                      //         edu[index];
                                                      //     await BlocProvider.of<
                                                      //                 UserCubit>(
                                                      //             context)
                                                      //         .update(user);
                                                      //     break;
                                                      //   }
                                                      // }
                                                      // await BlocProvider.of<
                                                      //         UserCubit>(context)
                                                      //     .update(user);
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onDismissed: (direction) async {
                                            showSnack('Deleting Education');
                                            bool deleted =
                                                await _databaseService
                                                    .removeEducation(
                                                        eid: edu[index].eid);
                                            if (deleted) {
                                              showSnack('Deleted');
                                              setState(() {
                                                edu.removeAt(index);
                                              });
                                              // for (int i = 0;
                                              //     i < user.educations.length;
                                              //     i++) {
                                              //   if (user.educations[i].eid ==
                                              //       edu[index].eid) {
                                              //     user.educations.removeAt(i);
                                              //     await BlocProvider.of<UserCubit>(
                                              //             context)
                                              //         .update(user);
                                              //     break;
                                              //   }
                                              // }
                                              // await BlocProvider.of<UserCubit>(
                                              //         context)
                                              //     .update(user);
                                            } else
                                              showSnack('Something went wrong');
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: MyTextFormField(
                                      validator: (val) {
                                        if (val.toString() == '') {
                                          return 'Please fill this field';
                                        } else
                                          return null;
                                      },
                                      labelText: "Institute",
                                      controller: insTextController,
                                      onChanged: (text) {
                                        institute =
                                            insTextController.text.toString();
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: MyTextFormField(
                                    validator: (val) {
                                      if (val.toString() == '') {
                                        return 'Please fill this field';
                                      } else
                                        return null;
                                    },
                                    labelText: "Country",
                                    controller: countryEduTextController,
                                    onChanged: (text) {
                                      countryEdu = countryEduTextController.text
                                          .toString();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: MyTextFormField(
                                    validator: (val) {
                                      if (val.toString() == '') {
                                        return 'Please fill this field';
                                      } else
                                        return null;
                                    },
                                    labelText: "Degree/Certificate Name",
                                    controller: degreeTextController,
                                    onChanged: (text) {
                                      degree =
                                          degreeTextController.text.toString();
                                    },
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    //                FROM
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MyTextFormField(
                                          keyboardType: TextInputType.number,
                                          maxLength: 4,
                                          labelText: 'From',
                                          validator: (val) {
                                            if (val.toString() == '') {
                                              return 'Please fill this field';
                                            } else if (val.toString().length <
                                                4) {
                                              return 'Years should be in XXXX format';
                                            } else
                                              return null;
                                          },
                                          controller: eduFromTextController,
                                          onChanged: (text) {
                                            eduFrom = eduFromTextController.text
                                                .toString();
                                          },
                                        ),
                                      ),
                                    ),
//                To

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: MyTextFormField(
                                          keyboardType: TextInputType.number,
                                          validator: (val) {
                                            if (eduCurr) {
                                              eduTOTextController.text =
                                                  'Present';
                                              eduTo = 'Present';
                                              return null;
                                            } else {
                                              if (val.toString() == '') {
                                                return 'Please fill this field';
                                              } else if (val.toString().length <
                                                  4) {
                                                return 'Years should be in XXXX format';
                                              } else
                                                return null;
                                            }
                                          },
                                          labelText: 'To',
                                          maxLength: 4,
                                          controller: eduTOTextController,
                                          onChanged: (text) {
                                            eduTo = eduTOTextController.text
                                                .toString();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //CURRENT
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Row(
                                    children: [
                                      Text('Current',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Switch(
                                          value: eduCurr,
                                          onChanged: (val) {
                                            setState(() {
                                              eduCurr = val;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: FlatButton.icon(
                                      onPressed: () async {
                                        showSnack('Adding Education');
                                        if (_formEduKey.currentState
                                            .validate()) {
                                          Education education =
                                              await _databaseService
                                                  .createEducation(
                                                      institute: institute,
                                                      country: countryEdu,
                                                      degree: degree,
                                                      to: eduTo,
                                                      from: eduFrom,
                                                      uid: user.uid,
                                                      current: eduCurr);
                                          if (education != null) {
                                            setState(() {
                                              showSnack('Added');
                                              edu.add(education);
                                              eduTOTextController.clear();
                                              eduFromTextController.clear();
                                              countryEduTextController.clear();
                                              degreeTextController.clear();
                                              insTextController.clear();
                                            });
                                            // user.educations.add(education);
                                            // await BlocProvider.of<UserCubit>(
                                            //         context)
                                            //     .update(user);
                                          } else
                                            showSnack('Something went wrong');
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        size: 35,
                                        color: color,
                                      ),
                                      label: Text('')),
                                ),
                              ],
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
                              Visibility(
                                visible: visibleContact,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '+${phoneCode ?? ''} - ${phoneNumber ?? ''}',
                                        style: TextStyle(
                                            color: colorTxt,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      FlatButton.icon(
                                        onPressed: () async {
                                          showSnack('Deleting contact...');
                                          //print('$contact IS CID');
                                          bool contactDeleted =
                                              await _databaseService
                                                  .removeContact(
                                                      cid: contact.cid);
                                          if (contactDeleted) {
                                            contactAdded = false;
                                            showSnack('Deleted');
                                            setState(() {
                                              visibleContact = false;
                                              // phoneNumber = '';
                                              // phoneCode = '';
                                            });
                                            user.contact = null;
                                            await BlocProvider.of<UserCubit>(
                                                    context)
                                                .update(user);
                                          } else {
                                            showSnack(
                                                'Something went wrong...');
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: color,
                                        ),
                                        label: Text(''),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                              var code = country.phoneCode;
                                              //print(
                                              // 'Select country: ${country.displayName} $code');
                                              setState(() {
                                                //print(country.phoneCode);
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
                                        if (numberController.text.toString() ==
                                            '')
                                          return 'Invalid';
                                        else
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
                              Center(
                                child: FlatButton.icon(
                                    onPressed: () async {
                                      if (contactAdded) {
                                        showSnack('Contact already added');
                                      } else {
                                        if (_formContactKey.currentState
                                            .validate()) {
                                          showSnack('Adding Contact...');
                                          Contact c = await _databaseService
                                              .createContact(
                                                  contact: Contact(
                                                      uid: user.uid,
                                                      code: phoneCode,
                                                      number: phoneNumber));

                                          if (c != null) {
                                            showSnack('Added');
                                            setState(() {
                                              // phoneCode = '';
                                              // numberController.text = '';
                                              visibleContact = true;
                                              contact = c;
                                              contactAdded = true;
                                            });
                                            user.contact = Contact(
                                                uid: user.uid,
                                                code: phoneCode,
                                                number: phoneNumber);
                                            await BlocProvider.of<UserCubit>(
                                                    context)
                                                .update(user);
                                          } else
                                            showSnack(
                                                'Something went wrong...');
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 35,
                                      color: color,
                                    ),
                                    label: Text('')),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),

//
//              COMPANY PORTFOLIO
//
                    if (!seeker)
                      Column(
                        children: <Widget>[
                          Form(
                            key: _formCompanyPortfolioKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                buildTitle("Portfolio (OPTIONAL)", dark),
                                if (port != null)
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      height: 50 * (port.length).toDouble(),
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemCount: port.length,
                                        itemBuilder: (context, index) {
                                          final item = port[index];
                                          return Dismissible(
                                            key: Key(item.title +
                                                item.to.toString()),
                                            direction:
                                                DismissDirection.startToEnd,
                                            child: ListTile(
                                              title: Text(
                                                "${item.title} from ${item.from} to ${item.to}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: colorTxt),
                                              ),
                                              trailing: Container(
                                                width: 100,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.delete_forever,
                                                        color: color,
                                                      ),
                                                      onPressed: () async {
                                                        showSnack(
                                                            'Deleting portfolio from cloud..,');
                                                        bool deletedPort =
                                                            await _databaseService
                                                                .removePortfolio(
                                                                    pid: port[
                                                                            index]
                                                                        .pid);
                                                        if (deletedPort) {
                                                          setState(() {
                                                            // port.removeAt(index);
                                                          });
                                                          for (int i = 0;
                                                              i <
                                                                  user.portfolio
                                                                      .length;
                                                              i++) {
                                                            if (user
                                                                    .portfolio[
                                                                        i]
                                                                    .pid ==
                                                                port[index]
                                                                    .pid) {
                                                              user.portfolio
                                                                  .removeAt(i);
                                                              break;
                                                            }
                                                          }
                                                          // await BlocProvider.of<
                                                          //             UserCubit>(
                                                          //         context)
                                                          //     .update(user);
                                                        } else
                                                          showSnack(
                                                              'Something went wrong...');
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              // PORTTFOLIO EDIT
                                                              bool
                                                                  selectedImage =
                                                                      false,
                                                                  netImag =
                                                                      false;
                                                              List<Media>
                                                                  selectedRes =
                                                                  [];

                                                              return StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                if (port[index]
                                                                            .image !=
                                                                        null &&
                                                                    port[index]
                                                                            .image !=
                                                                        '') {
                                                                  setState(() {
                                                                    netImag =
                                                                        true;
                                                                  });
                                                                }

                                                                portfolioTitleController
                                                                        .text =
                                                                    port[index]
                                                                        .title;

                                                                portfolioFromController
                                                                        .text =
                                                                    port[index]
                                                                        .from;
                                                                portfolioToController
                                                                        .text =
                                                                    port[index]
                                                                        .to;
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      "Edit Portfolio"),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .maxFinite,
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          MyTextFormField(
                                                                            controller:
                                                                                portfolioTitleController,
                                                                            labelText:
                                                                                'Project Title',
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          MyTextFormField(
                                                                            controller:
                                                                                portfolioFromController,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            labelText:
                                                                                'From',
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          MyTextFormField(
                                                                            controller:
                                                                                portfolioToController,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            labelText:
                                                                                'To',
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 15.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Text('Current', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Switch(
                                                                                    value: port[index].current,
                                                                                    onChanged: (val) {
                                                                                      setState(() {
                                                                                        portCurr = val;
                                                                                        port[index].current = val;
                                                                                      });
                                                                                    }),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 15.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                if (netImag)
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(
                                                                                        width: 1.0,
                                                                                      ),
                                                                                      image: DecorationImage(
                                                                                        image: NetworkImage(port[index].image),
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                  ),
                                                                                if (selectedImage)
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Icon(Icons.arrow_forward_outlined),
                                                                                  ),
                                                                                if (selectedImage)
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(
                                                                                        width: 1.0,
                                                                                      ),
                                                                                      image: DecorationImage(image: FileImage(File(selectedRes[0].path))),
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    height: 40,
                                                                                    width: 40,
                                                                                  ),
                                                                                SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                GestureDetector(
                                                                                    onTap: () async {
                                                                                      selectedRes = await ImagesPicker.pick(
                                                                                        count: 1,
                                                                                        cropOpt: CropOption(
                                                                                          aspectRatio: CropAspectRatio.custom,
                                                                                          cropType: CropType.rect, // currently for android
                                                                                        ),
                                                                                      );
                                                                                      if (selectedRes != [] && selectedRes.length != 0) {
                                                                                        setState(() {
                                                                                          netImag = false;
                                                                                          selectedImage = true;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Text('Add Image')),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      child: Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      child: Text(
                                                                          'Done'),
                                                                      onPressed:
                                                                          () async {
                                                                        String
                                                                            editImgURL =
                                                                            port[index].image;
                                                                        if (netImag) {
                                                                          editImgURL =
                                                                              port[index].image;
                                                                          await _databaseService
                                                                              .portfolioCollection
                                                                              .doc(port[index].pid)
                                                                              .update({
                                                                            'title':
                                                                                portfolioTitleController.text.trim(),
                                                                            'to':
                                                                                portfolioToController.text.toString(),
                                                                            'from':
                                                                                portfolioFromController.text.toString(),
                                                                            'current':
                                                                                portCurr,
                                                                            'image':
                                                                                editImgURL
                                                                          });
                                                                          // setState(() {
                                                                          port[index].title = portfolioTitleController
                                                                              .text
                                                                              .trim();

                                                                          port[index].to =
                                                                              portfolioToController.text;
                                                                          port[index].from =
                                                                              portfolioFromController.text;
                                                                          port[index].current =
                                                                              portCurr;
                                                                          // });
                                                                          for (int i = 0;
                                                                              i < user.portfolio.length;
                                                                              i++) {
                                                                            if (user.portfolio[i].pid ==
                                                                                port[index].pid) {
                                                                              user.portfolio[i] = port[index];
                                                                              break;
                                                                            }
                                                                          }
                                                                          await BlocProvider.of<UserCubit>(context)
                                                                              .update(user);
                                                                        }
                                                                        if (selectedRes !=
                                                                                [] &&
                                                                            selectedRes.length !=
                                                                                0) {
                                                                          final FirebaseStorage
                                                                              _storage =
                                                                              FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
                                                                          String
                                                                              fileName =
                                                                              DateTime.now().millisecondsSinceEpoch.toString();
                                                                          UploadTask
                                                                              uploadTask;

                                                                          uploadTask = _storage
                                                                              .ref()
                                                                              .child('images')
                                                                              .child(fileName)
                                                                              .putFile(File(selectedRes[0].path));
                                                                          TaskSnapshot
                                                                              ts =
                                                                              uploadTask.snapshot;
                                                                          uploadTask.then((TaskSnapshot
                                                                              taskSnapshot) {
                                                                            taskSnapshot.ref.getDownloadURL().then((value) async {
                                                                              editImgURL = value;
                                                                              await _databaseService.portfolioCollection.doc(port[index].pid).update({
                                                                                'title': portfolioTitleController.text.trim(),
                                                                                'to': portfolioToController.text.toString(),
                                                                                'from': portfolioFromController.text.toString(),
                                                                                'current': portCurr,
                                                                                'image': editImgURL
                                                                              });
                                                                            });
                                                                          });
                                                                        }
                                                                        // setState(() {
                                                                        port[index].title = portfolioTitleController
                                                                            .text
                                                                            .trim();

                                                                        port[index].to =
                                                                            portfolioToController.text;
                                                                        port[index].from =
                                                                            portfolioFromController.text;
                                                                        port[index].current =
                                                                            portCurr;
                                                                        // });
                                                                        for (int i =
                                                                                0;
                                                                            i < user.portfolio.length;
                                                                            i++) {
                                                                          if (user.portfolio[i].pid ==
                                                                              port[index].pid) {
                                                                            user.portfolio[i] =
                                                                                port[index];
                                                                            break;
                                                                          }
                                                                        }
                                                                        await BlocProvider.of<UserCubit>(context)
                                                                            .update(user);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                            });
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onDismissed: (direction) {
                                              setState(() async {
                                                showSnack(
                                                    'Deleting portfolio from cloud..,');
                                                bool deletedPort =
                                                    await _databaseService
                                                        .removePortfolio(
                                                            pid: port[index]
                                                                .pid);
                                                if (deletedPort) {
                                                  setState(() {
                                                    port.removeAt(index);
                                                  });
                                                  for (int i = 0;
                                                      i < user.portfolio.length;
                                                      i++) {
                                                    if (user.portfolio[i].pid ==
                                                        port[index].pid) {
                                                      user.portfolio
                                                          .removeAt(i);
                                                      break;
                                                    }
                                                  }
                                                  // await BlocProvider.of<UserCubit>(
                                                  //         context)
                                                  //     .update(user);
                                                } else
                                                  showSnack(
                                                      'Something went wrong...');
                                                port.removeAt(index);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                MyTextFormField(
                                  controller: portfolioTitleController,
                                  labelText: 'Project Title',
                                  validator: (text) {
                                    if (text.toString().length < 3)
                                      return 'Ritle should have atleast 3 characters';
                                    else
                                      return null;
                                  },
                                  onChanged: (text) {},
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: MyTextFormField(
                                      controller: portfolioFromController,
                                      labelText: 'From',
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val.toString() == '') {
                                          return 'Please fill this field';
                                        } else if (val.toString().length < 4) {
                                          return 'Years should be in XXXX format';
                                        } else
                                          return null;
                                      },
                                      onChanged: (text) {},
                                    )),
                                    Expanded(
                                        child: MyTextFormField(
                                      controller: portfolioToController,
                                      labelText: 'To',
                                      maxLength: 4,
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (portCurr) {
                                          portfolioToController.text =
                                              'Present';
                                          return null;
                                        } else {
                                          if (val.toString() == '') {
                                            return 'Please fill this field';
                                          } else if (val.toString().length <
                                              4) {
                                            return 'Years should be in XXXX format';
                                          } else
                                            return null;
                                        }
                                      },
                                      onChanged: (text) {},
                                    )),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                //CURRENT
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Current',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Switch(
                                              value: portCurr,
                                              onChanged: (val) {
                                                setState(() {
                                                  portCurr = val;
                                                });
                                              }),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (imageAdded)
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(
                                                      File(res[0].path)),
                                                ),
                                                border: Border.all(
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              width: 40,
                                            ),
                                          if (!imageAdded)
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              width: 40,
                                              child: Icon(Icons.image_outlined),
                                            ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                              onTap: () async {
                                                res = await ImagesPicker.pick(
                                                  count: 1,
                                                  cropOpt: CropOption(
                                                    aspectRatio:
                                                        CropAspectRatio.custom,
                                                    cropType: CropType
                                                        .rect, // currently for android
                                                  ),
                                                );
                                                if (res != [] &&
                                                    res.length != 0) {
                                                  setState(() {
                                                    imageAdded = true;
                                                  });
                                                }
                                              },
                                              child: Text('Add Image')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: FlatButton.icon(
                                      onPressed: () async {
                                        if (_formCompanyPortfolioKey
                                            .currentState
                                            .validate()) {
                                          showSnack(
                                              'Adding portfolio to Cloud...');
                                          String portURL = '';
                                          if (res != [] && res.length != 0) {
                                            final FirebaseStorage _storage =
                                                FirebaseStorage.instanceFor(
                                                    bucket:
                                                        'gs://inprep-c8711.appspot.com');
                                            String fileName = DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString();
                                            UploadTask uploadTask;

                                            uploadTask = _storage
                                                .ref()
                                                .child('images')
                                                .child(fileName)
                                                .putFile(File(res[0].path));
                                            TaskSnapshot ts =
                                                uploadTask.snapshot;
                                            uploadTask.then(
                                                (TaskSnapshot taskSnapshot) {
                                              taskSnapshot.ref
                                                  .getDownloadURL()
                                                  .then((value) async {
                                                print("URL 1 $value");
                                                portURL = value;
                                                print("URL 2 $portURL");
                                                Portfolio p = await _databaseService
                                                    .createPortfolio(
                                                        image: portURL,
                                                        title:
                                                            portfolioTitleController.text
                                                                .toString()
                                                                .toLowerCase(),
                                                        from: portfolioFromController
                                                            .text
                                                            .toString(),
                                                        to: portfolioToController
                                                            .text
                                                            .toString(),
                                                        uid: user.uid);
                                                if (p != null) {
                                                  setState(() {
                                                    showSnack('Added');
                                                    // port.add(p);
                                                  });

                                                  user.portfolio.add(p);

                                                  // await BlocProvider.of<UserCubit>(
                                                  //         context)
                                                  //     .update(user);
                                                } else
                                                  showSnack(
                                                      'Something went wrong...');
                                              });
                                            });
                                            // portURL = await ts.ref.getDownloadURL();
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        size: 35,
                                        color: color,
                                      ),
                                      label: Text('')),
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
//
//SOCIAL MEDIA
//
                    SizedBox(height: 20.0),
                    buildTitle("Social-Media (Optional)", dark),
                    Visibility(
                      visible: socialVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 15),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                'Social Information is Saved',
                                style: TextStyle(color: colorTxt),
                              )),
                              FlatButton.icon(
                                  onPressed: () async {
                                    bool deleted = await _databaseService
                                        .removeSocial(sid: social.sid);
                                    if (deleted) {
                                      setState(() {
                                        showSnack('Social Information deleted');
                                        fbUnameController.text = '';
                                        linkedInUnameController.text = '';
                                        githubUnameController.text = '';
                                        instaUnameController.text = '';
                                        tiktokUnameController.text = '';
                                        socialVisible = false;
                                      });
                                      user.social = null;
                                      await BlocProvider.of<UserCubit>(context)
                                          .update(user);
                                    } else
                                      showSnack('Something went wrong');
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: color,
                                  ),
                                  label: Text('')),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                    Center(
                      child: FlatButton.icon(
                          onPressed: () async {
                            showSnack('Adding Social Information');
                            if (fbUnameController.text == '' &&
                                linkedInUnameController.text == '' &&
                                githubUnameController.text == '' &&
                                tiktokUnameController.text == '' &&
                                instaUnameController.text == '' &&
                                skypeUnameController.text == '') {
                              showSnack(
                                  "Enter at least one social Information");
                            } else {
                              social = await _databaseService.createSocial(
                                  uid: user.uid,
                                  fb: fbUnameController.text.toString() ?? '',
                                  git: githubUnameController.text.toString() ??
                                      '',
                                  linkedin:
                                      linkedInUnameController.text.toString() ??
                                          '',
                                  tiktok:
                                      tiktokUnameController.text.toString() ??
                                          '',
                                  insta: instaUnameController.text.toString() ??
                                      '',
                                  skype: skypeUnameController.text.toString() ??
                                      '');
                              if (social != null) {
                                setState(() {
                                  socialVisible = true;
                                });
                                user.social = social;
                                await BlocProvider.of<UserCubit>(context)
                                    .update(user);
                                showSnack('Social Information Added...');
                              } else
                                showSnack('Something went wrong.');
                            }
                          },
                          icon: Icon(
                            Icons.add_circle,
                            size: 35,
                            color: color,
                          ),
                          label: Text('')),
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
                              showSnack('Saving data to Cloud...');
                              showDialog(
                                  context: context,
                                  builder: (_) => Center(
                                        child: CircularProgressIndicator(),
                                      ));
                              if (_formHeaderKey.currentState.validate()) {
                                // CONSULTANT
                                if (!seeker) {
                                  String priceTo =
                                      priceToController.text.toString() ?? '';
                                  String priceFrom =
                                      priceFromController.text.toString() ?? '';
                                  bool userdata = await _databaseService
                                      .setCurrentUserProfile(
                                          category: catValue.toString(),
                                          subCat: subCatValue.toString(),
                                          uid: user.uid,
                                          priceFrom: priceFrom,
                                          seeker: user.seeker,
                                          priceTo: priceTo,
                                          displayName:
                                              displayNameController.text,
                                          design: designationController.text,
                                          country: countryValue,
                                          city: cityValue,
                                          desc: descriptionController.text,
                                          state: stateValue,
                                          photoUrl: url,
                                          other: otherCont.text);
                                  if (userdata) {
                                    user.displayName =
                                        displayNameController.text;
                                    user.design = designationController.text;
                                    user.country = countryValue;
                                    user.city = cityValue;
                                    user.desc = descriptionController.text;
                                    user.photoUrl = url;
                                    user.state = stateValue;
                                    user.priceTo = priceTo;
                                    user.priceFrom = priceFrom;
                                    user.category = catValue.toString();
                                    user.subCategory = subCatValue.toString();
                                    user.profile = true;
                                    user.other = otherCont.text;
                                    await BlocProvider.of<UserCubit>(context)
                                        .update(user);
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
                                      .setCurrentUserProfile(
                                    uid: user.uid,
                                    state: stateValue,
                                    seeker: user.seeker,
                                    email: user.email,
                                    category: catValue.toString(),
                                    subCat: subCatValue.toString(),
                                    displayName: displayNameController.text,
                                    design: designationController.text,
                                    country: countryValue,
                                    city: cityValue,
                                    desc: descriptionController.text,
                                    other: otherCont.text,
                                    photoUrl: url != null ? url : user.photoUrl,
                                  );
                                  if (userdata) {
                                    user.displayName =
                                        displayNameController.text;
                                    user.design = designationController.text;
                                    user.country = countryValue;
                                    user.city = cityValue;
                                    user.desc = descriptionController.text;
                                    user.photoUrl = url;
                                    user.state = stateValue;
                                    user.category = catValue.toString();
                                    user.subCategory = subCatValue.toString();
                                    user.profile = true;
                                    user.other = otherCont.text;
                                    await BlocProvider.of<UserCubit>(context)
                                        .update(user);
                                    showToast(context, 'Data Saved');
                                    Navigator.pop(context, true);
                                    Navigator.pop(context, true);
                                  } else
                                    showToast(context, 'Something went wrong');
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

  Future<void> uploadImage(MyUser user, cover) async {
    showLoader(context);
    String upload = await pickImage();
    if (cover) {
      user.cover = upload;
      await _databaseService.userCollection.doc(user.uid).update(user.toJson());
      setState(() {
        user.cover = upload;
        // url = upload;
      });
    } else {
      user.photoUrl = upload;
      await _databaseService.userCollection.doc(user.uid).update(user.toJson());
      setState(() {
        user.photoUrl = upload;
        // url = upload;
      });
    }
    Navigator.pop(context);
  }
}

class ImageCapture extends StatefulWidget {
  final uid;
  ImageCapture({this.uid});
  @override
  _ImageCaptureState createState() => _ImageCaptureState(uid: uid);
}

class _ImageCaptureState extends State<ImageCapture> {
  final uid;
  _ImageCaptureState({this.uid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                  height: 400,
                  width: double.maxFinite,
                  child: Image.file(_imageFile)),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FlatButton(
                child: Icon(Icons.refresh),
                onPressed: _clear,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Uploader(file: _imageFile, uid: uid),
            )
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImage(),
        child: Icon(Icons.photo_library),
      ),
    );
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  File _imageFile;
  Future<void> _pickImage() async {
    List<Media> media = await ImagesPicker.pick(
      count: 1,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
        cropType: CropType.rect, // currently for android
      ),
    );
    File selected = File(media[0].path);
    setState(() {
      _imageFile = selected;
    });
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final uid;
  Uploader({this.uid, this.file});
  @override
  _UploaderState createState() => _UploaderState(uid: uid);
}

class _UploaderState extends State<Uploader> {
  _UploaderState({this.uid});
  final uid;
  FirebaseStorage _storage;

  UploadTask _uploadTask;
  _startUpload() async {
    String filePath = 'images/${widget.file.path}';
    _storage =
        FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    setState(() {
      _uploadTask =
          _storage.ref().child('images').child(fileName).putFile(widget.file);
    });
    TaskSnapshot ts = _uploadTask.snapshot;
    _uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((value) {
        url = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: _uploadTask.snapshotEvents,
        builder: (context, snapshot) {
          var event = snapshot?.data;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalBytes : 0;

          return Column(
            children: <Widget>[
              if (_uploadTask.snapshot.state.index == 2) Text('Completed'),
              LinearProgressIndicator(
                value: progressPercent,
              ),
              if (_uploadTask.snapshot.state.index == 2)
                FlatButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Go Back'))
            ],
          );
        },
      );
    } else {
      return GestureDetector(
        onTap: () {
          _startUpload();
        },
        child: Icon(
          Icons.send,
          size: 30,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
  }
}
