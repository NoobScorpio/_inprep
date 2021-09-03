// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:indeed_app/auth/auth.dart';
// import 'package:indeed_app/models/user.dart';
// import 'package:indeed_app/utils/profile_widgets.dart';
// import 'file:///D:/WORK/HASSAN/indeed_app/lib/jobs/Job_edit.dart';
//
// import '../screens/chat_screen.dart';
// import 'package:indeed_app/models/database.dart';
// import 'package:indeed_app/screens/profile_view.dart';
//
// class JobView extends StatefulWidget {
//   final job;
//   final seeker;
//   final User user;
//   JobView({this.job, this.seeker, this.user});
//   static String id = 'JobView';
//   @override
//   _JobViewState createState() =>
//       _JobViewState(job: job, seeker: seeker, user: user);
// }
//
// class _JobViewState extends State<JobView> {
//   final GlobalKey<ScaffoldState> jobViewKey = new GlobalKey<ScaffoldState>();
//   void showSnack(text) {
//     jobViewKey.currentState.showSnackBar(SnackBar(
//       backgroundColor: Theme.of(context).primaryColor,
//       content: Text(text),
//       duration: Duration(seconds: 1),
//     ));
//   }
//
//   final AuthService _auth = AuthService();
//   DatabaseService _databaseService = DatabaseService();
//   getUser({yes}) async {
//     currentUser = await _auth.currentUser();
//   }
//
//   void initState() {
//     super.initState();
//     getUser(yes: false);
//     WidgetsBinding.instance.addPostFrameCallback((_) => getUser(yes: true));
//   }
//
//   _JobViewState({this.job, this.seeker, this.user});
//
//   User currentUser;
//   User user = User();
//   final job;
//   bool loggedin = true;
//   final seeker;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: jobViewKey,
//       appBar: AppBar(),
//       body: ListView(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(top: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => ProfileView(uid: user.uid)));
//                   },
//                   child: buildHeader(context,
//                       photoUrl: user.photoUrl,
//                       name: user.displayName != null
//                           ? user.displayName
//                           : 'Unknown',
//                       designation:
//                           user.design != null ? user.design : 'Unknown',
//                       city: user.city != null ? user.city : 'Unknown',
//                       country: user.country != null ? user.country : 'Unknown'),
//                 ),
//                 SizedBox(height: 20.0),
//                 SizedBox(height: 20.0),
//                 buildTitle(job.title),
//                 SizedBox(height: 5.0),
//                 buildSalaryRow(context,
//                     salary1: job.salaryFrom.toString(),
//                     salary2: job.salaryTo.toString()),
//                 buildExpRow(context, year: job.exp.toString()),
//                 buildLocRow(context, city: job.city, country: job.country),
//                 buildCatRow(context, cat: job.category),
//                 SizedBox(height: 20.0),
//                 buildTitle("Description"),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       bottom: 20.0, left: 20, right: 20, top: 10),
//                   child: Text(
//                     job.desc,
//                     textAlign: TextAlign.justify,
//                     style: TextStyle(
//                         color: Colors.black45,
//                         fontWeight: FontWeight.w300,
//                         fontSize: 16),
//                   ),
//                 ),
//                 if (seeker)
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: 20.0, left: 20, right: 20, top: 0),
//                     child: GestureDetector(
//                       onTap: () async {
//                         print(currentUser.uid);
//                         print(job.uid);
//                         if (currentUser.uid != user.uid) {
//                           if (loggedin) {
//                             showSnack('Setting up chat');
//
//                             User senderUid = await AuthService().currentUser();
//                             var sender = await _databaseService
//                                 .getcurrentUserData(senderUid.uid);
//                             // print('${sender.uid} && ${user.uid}');
//                             String isThere = await _databaseService.searchChat(
//                                 sid: sender.uid, rid: user.uid);
//                             if (isThere != null) {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => ChatScreen(
//                                             user: sender,
//                                             cid: isThere,
//                                             name: user.displayName,
//                                           )));
//                             } else {
//                               var cid = await _databaseService.createChat(
//                                   sender: sender.displayName,
//                                   receiver: user.displayName,
//                                   rid: user.uid,
//                                   sid: sender.uid);
//                               if (cid != null) {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => ChatScreen(
//                                               user: sender,
//                                               cid: cid,
//                                               name: user.displayName,
//                                             )));
//                               } else {
//                                 showSnack('Something went wrong');
//                               }
//                             }
//                           } else
//                             showSnack('Login or Signup to Chat');
//                         } else
//                           showSnack('Cannot Contact yourself');
//                       },
//                       child: Container(
//                         color: Colors.grey.withOpacity(0.3),
//                         height: 50,
//                         child: Center(
//                             child: Text(
//                           'Contact',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 26,
//                               color: Theme.of(context).primaryColor),
//                         )),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Visibility(
//         visible: !seeker,
//         child: FloatingActionButton(
//           onPressed: () {},
//           backgroundColor: Theme.of(context).primaryColor,
//           child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => JobEdit(
//                               job: job,
//                             )));
//               },
//               child: Icon(Icons.edit)),
//         ),
//       ),
//     );
//   }
//
//   void deljob() async {
//     await _databaseService.removeJob(jid: job.jid);
//     showSnack('Job Deleted');
//   }
// }
