// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:indeed_app/models/Job.dart';
// import 'file:///D:/WORK/HASSAN/indeed_app/lib/jobs/job_add.dart';
// import 'file:///D:/WORK/HASSAN/indeed_app/lib/jobs/job_view.dart';
// import 'package:indeed_app/models/user.dart';
// import 'package:indeed_app/models/database.dart';
// import 'package:indeed_app/screens/search_screen.dart';
//
// class JobsFeed extends StatefulWidget {
//   static String id = 'jobs';
//   final String title;
//   final User user;
//   JobsFeed({this.title, this.user});
//   @override
//   _JobsFeedState createState() => _JobsFeedState(user: user, title: title);
// }
//
// class _JobsFeedState extends State<JobsFeed> {
//   _JobsFeedState({this.user, this.title});
//   final DatabaseService _databaseService = DatabaseService();
//   final User user;
//   final title;
//   bool seeker = true;
//
//   @override
//   void initState() {
//     super.initState();
//     print(user);
//     setSeeker();
//   }
//
//   void setSeeker() {
//     setState(() {
//       seeker = user.seeker;
//     });
//   }
//
//   Future<List<Job>> refresh() async {
//     List<Job> j = await getJobs();
//     setState(() {});
//     return j;
//   }
//
//   Future<List<Job>> getJobs() async {
//     var snapshots = await Firestore.instance
//         .collection("jobs")
//         .where('category', isEqualTo: title)
//         .orderBy('timestamp', descending: true)
//         .getDocuments();
//     var snapshotDocuments = snapshots.documents;
//     List<Job> jobs = [];
//     for (int i = 0; i < snapshotDocuments.length; i++) {
//       print('${user.seeker} is true');
//       // if (!user.seeker) {
//       // if (user.uid == snapshotDocuments[i].data['uid']) {
//       //   print('${user.seeker} is true INSIDE IFFF');
//       var job = Job(
//         jid: snapshotDocuments[i].documentID,
//         uid: snapshotDocuments[i].data['uid'] != null
//             ? snapshotDocuments[i].data['uid']
//             : '',
//         salaryTo: snapshotDocuments[i].data['to'] != null
//             ? snapshotDocuments[i].data['to']
//             : 0,
//         salaryFrom: snapshotDocuments[i].data['from'] != null
//             ? snapshotDocuments[i].data['from']
//             : 0,
//         exp: snapshotDocuments[i].data['exp'] != null
//             ? snapshotDocuments[i].data['exp']
//             : 0,
//         city: snapshotDocuments[i].data['city'] != null
//             ? snapshotDocuments[i].data['city']
//             : '',
//         country: snapshotDocuments[i].data['country'] != null
//             ? snapshotDocuments[i].data['country']
//             : '',
//         title: snapshotDocuments[i].data['title'] != null
//             ? snapshotDocuments[i].data['title']
//             : '',
//         desc: snapshotDocuments[i].data['desc'] != null
//             ? snapshotDocuments[i].data['desc']
//             : '',
//         skill: snapshotDocuments[i].data['skill'] != null
//             ? snapshotDocuments[i].data['skill']
//             : '',
//         companyName: snapshotDocuments[i].data['companyName'] != null
//             ? snapshotDocuments[i].data['companyName']
//             : '',
//         date: snapshotDocuments[i].data['date'] != null
//             ? snapshotDocuments[i].data['date']
//             : '',
//         category: snapshotDocuments[i].data['category'] != null
//             ? snapshotDocuments[i].data['category']
//             : '',
//       );
//       // print('${user.seeker} is true AFTER JOB');
//       jobs.add(job);
//       // }
//       // }
//
//     }
// //    print(jobs.length);
//     return jobs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         actions: <Widget>[
//           // Padding(
//           //   padding: EdgeInsets.all(20.0),
//           //   child: GestureDetector(
//           //     child: Icon(Icons.search),
//           //     onTap: () {
//           //       Navigator.push(
//           //         context,
//           //         MaterialPageRoute(
//           //           builder: (_) => Search(
//           //             user: user,
//           //             loggedIn: true,
//           //           ),
//           //         ),
//           //       );
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//       //appBar: AppBar(),
//       body: FutureBuilder(
//         future: getJobs(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             print(snapshot.data);
//
//             print('${snapshot.data.length} is snap length');
//             if (snapshot.data.length == 0) {
//               return RefreshIndicator(
//                 onRefresh: refresh,
//                 child: Center(
//                   child: Text('No Related Finds for $title'),
//                 ),
//               );
//             } else {
//               return RefreshIndicator(
//                 onRefresh: refresh,
//                 child: ListView.builder(
//                     itemCount: snapshot.data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return jobCard(
//                         title: snapshot.data[index].title,
//                         cname: snapshot.data[index].companyName
//                             .toString()
//                             .toUpperCase(),
//                         city:
//                             snapshot.data[index].city.toString().toUpperCase(),
//                         country: snapshot.data[index].country
//                             .toString()
//                             .toUpperCase(),
//                         salFrom: snapshot.data[index].salaryFrom,
//                         salTo: snapshot.data[index].salaryTo,
//                         desc: snapshot.data[index].desc,
//                         seeker: seeker,
//                         uid: snapshot.data[index].uid,
//                         jid: snapshot.data[index].jid,
//                         skill: snapshot.data[index].skill,
//                         exp: snapshot.data[index].exp,
//                         date: snapshot.data[index].date,
//                         category: snapshot.data[index].category,
//                       );
//                     }),
//               );
//             }
//           } else
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//         },
//       ),
//       // floatingActionButton: Visibility(
//       //     visible: !seeker,
//       //     child: FloatingActionButton(
//       //       backgroundColor: Theme.of(context).primaryColor,
//       //       onPressed: () {
//       //         Navigator.push(
//       //             context, MaterialPageRoute(builder: (context) => AddJob()));
//       //       },
//       //       child: Icon(Icons.add_box),
//       //     )),
//     );
//   }
//
//   Widget jobCard(
//       {title,
//       category,
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
//       date,
//       uid}) {
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
//                     if (!seeker && user.uid == uid)
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
// //                                  CATEGORY
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 5.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Category: ",
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16),
//                     ),
//                     Text(
//                       "$category",
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16),
//                     ),
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
//                 onTap: () async {
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
//                       category: category,
//                       uid: uid,
//                       jid: jid);
//                   var jobUser = await _databaseService.getcurrentUserData(uid);
//                   print(j.title);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => JobView(
//                           job: j,
//                           seeker: seeker,
//                           user: User(
//                               uid: jobUser.uid,
//                               displayName: jobUser.displayName,
//                               email: jobUser.email,
//                               uname: jobUser.uname,
//                               country: jobUser.country,
//                               city: jobUser.city,
//                               design: jobUser.design,
//                               photoUrl: jobUser.photoUrl),
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
