// import 'package:flutter/material.dart';
// import 'package:indeed_app/models/Job.dart';
// import 'package:indeed_app/models/database.dart';
// import 'package:indeed_app/models/user.dart';
// import 'package:indeed_app/screens/job_view.dart';
//
// class JobCard extends StatelessWidget {
//   final DatabaseService _databaseService = DatabaseService();
//   final title,
//       seeker,
//       jid,
//       cname,
//       city,
//       country,
//       salTo,
//       salFrom,
//       desc,
//       skill,
//       exp,
//       user,
//       date,
//       uid;
//
//   JobCard(
//       {Key key,
//       this.title,
//       this.seeker,
//       this.jid,
//       this.cname,
//       this.city,
//       this.country,
//       this.salTo,
//       this.salFrom,
//       this.desc,
//       this.skill,
//       this.exp,
//       this.user,
//       this.date,
//       this.uid})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//       child: Container(
//         width: double.maxFinite,
//         child: Card(
//           elevation: 6,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
// //                                  TITLE
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 15.0,
//                   left: 15,
//                 ),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 22),
//                       ),
//                     ),
//                     if (!seeker)
//                       FlatButton.icon(
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: Text("Delete Job"),
//                                     content: Text("Are you sure?"),
//                                     actions: <Widget>[
//                                       FlatButton(
//                                         child: Text("No"),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                       FlatButton(
//                                         child: Text("Yes"),
//                                         onPressed: () async {
//                                           bool deleted = await _databaseService
//                                               .removeJob(jid: jid);
//                                           if (deleted) {
//                                             setState(() {
//                                               getJobs();
//                                             });
//                                           } else
//                                             print('not deleted');
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 });
//                           },
//                           icon: Icon(
//                             Icons.delete_outline,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           label: Text('')),
//                   ],
//                 ),
//               ),
// //                                  COMPANY NAME
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 5.0),
//                 child: Text(
//                   "$cname",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16),
//                 ),
//               ),
// //                                  CITY,COUNTRY
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 5.0),
//                 child: Text(
//                   "$city, $country",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16),
//                 ),
//               ),
// //                                  SALARY FROM TO
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 5.0, bottom: 15),
//                 child: Text(
//                   '\$$salFrom- \$$salTo',
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w300,
//                       fontSize: 14),
//                 ),
//               ),
// //                                  DESCRIPTION OF JOB
//               Container(
//                 height: 240,
//                 width: double.maxFinite,
//                 child: ListView(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           '$desc',
//                           style: TextStyle(
//                               color: Colors.black45,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Job j = Job(
//                       title: title,
//                       city: city,
//                       country: country,
//                       salaryFrom: salFrom,
//                       salaryTo: salTo,
//                       skill: skill,
//                       exp: exp,
//                       desc: desc,
//                       companyName: cname,
//                       uid: uid,
//                       jid: jid);
//                   print(j.title);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => JobView(
//                           job: j,
//                           seeker: seeker,
//                           user: User(
//                               uid: user.uid,
//                               displayName: user.displayName,
//                               email: user.email,
//                               uname: user.uname,
//                               country: user.country,
//                               city: user.city,
//                               design: user.design,
//                               photoUrl: user.photoUrl),
//                         ),
//                       ));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         flex: 2,
//                         child: Padding(
//                             padding: const EdgeInsets.only(left: 10, top: 5.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 8.0),
//                                   child: Text(
//                                     'Posted on $date',
//                                     style: TextStyle(
//                                         color: Theme.of(context).primaryColor,
//                                         fontWeight: FontWeight.w300,
//                                         fontSize: 12),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(),
//                         child: Text(
//                           'Details',
//                           style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontWeight: FontWeight.w300,
//                               fontSize: 12),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 2.0),
//                         child: Icon(Icons.arrow_forward,
//                             color: Theme.of(context).primaryColor),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
