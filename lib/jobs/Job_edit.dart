// import 'package:flutter/material.dart';
// import 'package:indeed_app/models/database.dart';
// import 'package:indeed_app/models/user.dart';
// import 'package:indeed_app/utils/constants.dart';
// import 'package:indeed_app/utils/mytext_field_form.dart';
// import 'package:provider/provider.dart';
// import 'package:indeed_app/models/Job.dart';
//
// class JobEdit extends StatefulWidget {
//   final String title;
//   final Job job;
//   JobEdit({this.title, this.job});
//   static String id = 'JobEdit';
//   @override
//   _JobEditState createState() => _JobEditState(job: job, titleBar: title);
// }
//
// class _JobEditState extends State<JobEdit> {
//   final GlobalKey<ScaffoldState> _scaffoldJobEditKey =
//       new GlobalKey<ScaffoldState>();
//
//   User currentUser;
//   var catValue = 'Bussiness';
//   DatabaseService _databaseService = DatabaseService();
//
//   @override
//   void initState() {
//     super.initState();
//
//     salaryFromController.text = job.salaryFrom.toString();
//     salaryToController.text = job.salaryTo.toString();
//     cityController.text = job.city;
//     countryController.text = job.country;
//     descController.text = job.desc;
//     expController.text = job.exp.toString();
//     titleController.text = job.title;
//     skillController.text = job.skill;
//   }
//
//   final Job job;
//   String titleBar;
//   _JobEditState({this.job, this.titleBar});
//
//   final _formJobKey = GlobalKey<FormState>();
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
//       key: _scaffoldJobEditKey,
//       appBar: AppBar(
//         title: Text(titleBar != null ? titleBar + ' Job' : 'Job'),
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
//                           onChanged: (text) {}),
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
//                         onChanged: (text) {},
//                       ),
//                     ),
// //                CATEGORY
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
//                         onChanged: (text) {},
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
//                               onChanged: (text) {},
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
//                               onChanged: (text) {},
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
//                               onChanged: (text) {},
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
//                               onChanged: (text) {},
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
//                         keyboardType: TextInputType.number,
//                         onChanged: (text) {},
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
//                                   _scaffoldJobEditKey.currentState
//                                       .showSnackBar(SnackBar(
//                                     backgroundColor:
//                                         Theme.of(context).primaryColor,
//                                     content: Text('Editing...'),
//                                     duration: Duration(seconds: 2),
//                                   ));
//                                   var date = DateTime.now().toString();
//                                   List<String> split = date.split(" ");
//                                   String firstSubString = split[0];
//                                   print(firstSubString);
//                                   bool posted =
//                                       await _databaseService.updateJob(
//                                     title: titleController.text
//                                         .toString()
//                                         .toLowerCase(),
//                                     exp: int.parse(
//                                         expController.text.toString()),
//                                     skill: skillController.text
//                                         .toString()
//                                         .toLowerCase(),
//                                     date: firstSubString,
//                                     city: cityController.text
//                                         .toString()
//                                         .toLowerCase(),
//                                     country: countryController.text
//                                         .toString()
//                                         .toLowerCase(),
//                                     to: int.parse(
//                                         salaryToController.text.toString()),
//                                     from: int.parse(
//                                         salaryFromController.text.toString()),
//                                     desc: descController.text.toString(),
//                                     uid: currentUser.uid,
//                                     compName: currentUser.displayName,
//                                     jid: job.jid,
//                                   );
//                                   if (posted) {
//                                     _scaffoldJobEditKey.currentState
//                                         .showSnackBar(SnackBar(
//                                       backgroundColor:
//                                           Theme.of(context).primaryColor,
//                                       content: Text('Successful...'),
//                                       duration: Duration(seconds: 2),
//                                     ));
//                                     Future.delayed(Duration(seconds: 2)).then(
//                                         (value) => Navigator.pop(context));
//                                   } else {
//                                     _scaffoldJobEditKey.currentState
//                                         .showSnackBar(SnackBar(
//                                       backgroundColor:
//                                           Theme.of(context).primaryColor,
//                                       content: Text('Something went wrong...'),
//                                       duration: Duration(seconds: 2),
//                                     ));
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
