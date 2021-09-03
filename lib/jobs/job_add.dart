// import 'package:flutter/material.dart';
// import 'package:indeed_app/models/database.dart';
// import 'package:indeed_app/models/user.dart';
// import 'package:indeed_app/utils/constants.dart';
// import 'package:indeed_app/utils/mytext_field_form.dart';
// import 'package:provider/provider.dart';
//
// class AddJob extends StatefulWidget {
//   @override
//   _AddJobState createState() => _AddJobState();
// }
//
// class _AddJobState extends State<AddJob> {
//   DatabaseService _databaseService = DatabaseService();
//   final GlobalKey<ScaffoldState> _scaffoldJobAddtKey =
//       new GlobalKey<ScaffoldState>();
//
//   var catValue = 'Bussiness';
//   void showSnack(text) {
//     _scaffoldJobAddtKey.currentState.showSnackBar(SnackBar(
//       backgroundColor: Theme.of(context).primaryColor,
//       content: Text(text),
//       duration: Duration(seconds: 2),
//     ));
//   }
//
//   final _formJobKey = GlobalKey<FormState>();
//
//   User currentUser;
//
//   String title, skill, city, country, desc;
//   int exp, salaryFrom, salaryTo;
//
//   final salaryFromController = TextEditingController();
//   final salaryToController = TextEditingController();
//   final cityController = TextEditingController();
//   final countryController = TextEditingController();
//   final descController = TextEditingController();
//   final expController = TextEditingController();
//   final titleController = TextEditingController();
//   final skillController = TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//     salaryFromController.dispose();
//     salaryToController.dispose();
//     cityController.dispose();
//     countryController.dispose();
//     descController.dispose();
//     expController.dispose();
//     titleController.dispose();
//     skillController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     currentUser = Provider.of<User>(context);
//     return Scaffold(
//       key: _scaffoldJobAddtKey,
//       appBar: AppBar(
//         title: Text('Post Job'),
//       ),
//       body: ListView(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               SizedBox(height: 20.0),
//               Form(
//                 key: _formJobKey,
//                 child: Column(
//                   children: <Widget>[
// ////           TITLE
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: MyTextFormField(
//                           controller: titleController,
//                           validator: (text) {
//                             if (cityController.text.toString() == '')
//                               return 'Required';
//                             return null;
//                           },
//                           labelText: "Title",
//                           onChanged: (text) {
//                             title = titleController.text.toString();
//                           }),
//                     ),
// //                      EXPERIENCE
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: MyTextFormField(
//                         validator: (text) {
//                           if (expController.text.toString() == '')
//                             return 'Required';
//                           return null;
//                         },
//                         controller: expController,
//                         maxLength: 2,
//                         labelText: "Experience (years)",
//                         keyboardType: TextInputType.number,
//                         onChanged: (text) {
//                           exp = int.parse(expController.text.toString());
//                         },
//                       ),
//                     ),
//                     //CATEGORY
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('Category'),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Container(
//                           padding:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//
//                           // dropdown below..
//                           child: DropdownButton<String>(
//                             icon: Icon(
//                               Icons.arrow_drop_down,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                             iconSize: 42,
//                             value: catValue,
//                             style: TextStyle(fontSize: 18, color: Colors.grey),
//                             underline: SizedBox(),
//                             items: catList.map((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: new Text('$value'),
//                               );
//                             }).toList(),
//                             onChanged: (_) {
//                               setState(() {
//                                 catValue = _;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
// //                    SKILL
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: MyTextFormField(
//                         validator: (text) {
//                           if (skillController.text.toString() == '')
//                             return 'Required';
//                           return null;
//                         },
//                         controller: skillController,
//                         hint: 'i.e flutter,python,web etc',
//                         labelText: "Skill",
//                         onChanged: (text) {
//                           skill = skillController.text.toString().toLowerCase();
//                         },
//                       ),
//                     ),
// //                    CITY, COUNTRY
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: MyTextFormField(
//                               validator: (text) {
//                                 if (cityController.text.toString() == '')
//                                   return 'Required';
//                                 if (cityController.text.toString().length < 4)
//                                   return 'Enter valid name';
//                                 return null;
//                               },
//                               controller: cityController,
//                               labelText: 'City',
//                               onChanged: (text) {
//                                 city = cityController.text
//                                     .toString()
//                                     .toLowerCase();
//                               },
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: MyTextFormField(
//                               validator: (text) {
//                                 if (countryController.text.toString() == '')
//                                   return 'Required';
//
//                                 return null;
//                               },
//                               controller: countryController,
//                               labelText: 'Country',
//                               onChanged: (text) {
//                                 country = countryController.text
//                                     .toString()
//                                     .toLowerCase();
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
// //
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 12.0),
//                             child: MyTextFormField(
//                               validator: (text) {
//                                 if (salaryFromController.text.toString() == '')
//                                   return 'Required';
//                                 return null;
//                               },
//                               controller: salaryFromController,
//                               keyboardType: TextInputType.number,
//                               labelText: 'Salaray From',
//                               prefixIcon: Icon(Icons.attach_money),
//                               onChanged: (text) {
//                                 salaryFrom = int.parse(
//                                     salaryFromController.text.toString());
//                               },
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 12.0),
//                             child: MyTextFormField(
//                               validator: (text) {
//                                 if (salaryToController.text.toString() == '')
//                                   return 'Required';
//                                 return null;
//                               },
//                               controller: salaryToController,
//                               keyboardType: TextInputType.number,
//                               labelText: 'To',
//                               prefixIcon: Icon(Icons.attach_money),
//                               onChanged: (text) {
//                                 salaryTo = int.parse(
//                                     salaryToController.text.toString());
//                                 print('$salaryTo is salary to');
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
// //                    DESCRIPTION
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: MyTextFormField(
//                         validator: (text) {
//                           if (cityController.text.toString() == '')
//                             return 'Required';
//                           return null;
//                         },
//                         maxline: 15,
//                         controller: descController,
//                         labelText: "Description",
//                         onChanged: (text) {
//                           desc = descController.text.toString();
//                         },
//                       ),
//                     ),
// //                      BUTTON
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Center(
//                         child: Container(
//                           height: 40,
//                           width: 120,
//                           color: Colors.black12,
//                           child: FlatButton.icon(
//                               onPressed: () async {
//                                 if (_formJobKey.currentState.validate()) {
//                                   currentUser = await _databaseService
//                                       .getcurrentUserData(currentUser.uid);
//                                   showSnack('Posting...');
//                                   var date = DateTime.now().toString();
//                                   List<String> split = date.split(" ");
//                                   String firstSubString = split[0];
//                                   print(firstSubString);
//                                   bool posted =
//                                       await _databaseService.createJob(
//                                           title: title.toLowerCase(),
//                                           exp: exp,
//                                           category: catValue,
//                                           skill: skill.toLowerCase(),
//                                           date: firstSubString,
//                                           city: city,
//                                           country: country,
//                                           to: salaryTo,
//                                           from: salaryFrom,
//                                           desc: desc,
//                                           uid: currentUser.uid,
//                                           compName: currentUser.displayName);
//                                   if (posted) {
//                                     showSnack('Successful...');
//                                     Future.delayed(Duration(seconds: 2)).then(
//                                         (value) => Navigator.pop(context));
//                                   } else {
//                                     showSnack('Something went wrong...');
//                                   }
//                                 }
//                               },
//                               icon: Icon(
//                                 Icons.check,
//                                 size: 35,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                               label: Text('Done')),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.0),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
