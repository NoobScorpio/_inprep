// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter_zoom_sdk/zoom_options.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
//
// class MeetingWidget extends StatefulWidget {
//   ZoomOptions zoomOptions;
//   ZoomMeetingOptions meetingOptions;
//
//   MeetingWidget({Key key, meetingId, meetingPassword}) : super(key: key) {
//     // Setting up the Zoom credentials
//     this.zoomOptions = new ZoomOptions(
//       domain: "zoom.us",
//       appKey:
//           "jJpUw8FNBZjNXOjRknNX2Pg8w5kW5ti8IwSv", // Replace with with key got from the Zoom Marketplace
//       appSecret:
//           "OwHnfiEEKkWUICUBPnfoB5Xu5j5zAkyzQ80j", // Replace with with secret got from the Zoom Marketplace
//     );
//
//     // Setting Zoom meeting options (default to false if not set)
//     this.meetingOptions = new ZoomMeetingOptions(
//         userId: 'aliadam7867@gmail.com', //pass username for join meeting only
//         meetingId: "73613590468", //pass meeting id for join meeting only
//         meetingPassword:
//             "a0s3SFZKM1R4d0tQbHFBYXNmclZ1Zz09", //pass meeting password for join meeting only
//         disableDialIn: "true",
//         disableDrive: "true",
//         disableInvite: "true",
//         disableShare: "true",
//         noAudio: "false",
//         disableTitlebar: "false", //Make it true for disabling titlebar
//         viewOptions:
//             "false", //Make it true for hiding zoom icon on meeting ui which shows meeting id and password
//         noDisconnectAudio: "false");
//   }
//
//   @override
//   _MeetingWidgetState createState() => _MeetingWidgetState();
// }
//
// class _MeetingWidgetState extends State<MeetingWidget> {
//   Timer timer;
//
//   bool _isMeetingEnded(String status) {
//     var result = false;
//
//     if (Platform.isAndroid)
//       result = status == "MEETING_STATUS_DISCONNECTING" ||
//           status == "MEETING_STATUS_FAILED";
//     else
//       result = status == "MEETING_STATUS_IDLE";
//
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Initializing meeting '),
//       ),
//       body: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: ZoomView(onViewCreated: (controller) {
//             print("Created the view");
//
//             controller.initZoom(this.widget.zoomOptions).then((results) {
//               if (results[0] == 0) {
//                 // Listening on the Zoom status stream (1)
//                 controller.zoomStatusEvents.listen((status) {
//                   print("Meeting Status Stream: " +
//                       status[0] +
//                       " - " +
//                       status[1]);
//
//                   if (_isMeetingEnded(status[0])) {
//                     Navigator.pop(context);
//                     timer?.cancel();
//                   }
//                 });
//
//                 print("listen on event channel");
//
//                 controller
//                     .joinMeeting(this.widget.meetingOptions)
//                     .then((joinMeetingResult) {
//                   // Polling the Zoom status (2)
//                   timer = Timer.periodic(new Duration(seconds: 2), (timer) {
//                     controller
//                         .meetingStatus(this.widget.meetingOptions.meetingId)
//                         .then((status) {
//                       print("Meeting Status Polling: " +
//                           status[0] +
//                           " - " +
//                           status[1]);
//                     });
//                   });
//                 });
//               }
//             }).catchError((error) {
//               print(error);
//             });
//           })),
//     );
//   }
//
//   @override
//   void dispose() {
//
//     super.dispose();
//     timer.cancel();
//   }
// }
//
// class StartMeetingWidget extends StatefulWidget {
//   ZoomOptions zoomOptions;
//   ZoomMeetingOptions loginOptions;
//
//   StartMeetingWidget({Key key, meetingId}) : super(key: key) {
//     this.zoomOptions = new ZoomOptions(
//       domain: "zoom.us",
//       appKey:
//           "jJpUw8FNBZjNXOjRknNX2Pg8w5kW5ti8IwSv", // Replace with with key got from the Zoom Marketplace
//       appSecret:
//           "OwHnfiEEKkWUICUBPnfoB5Xu5j5zAkyzQ80j", // Replace with with secret got from the Zoom Marketplace
//     );
//     this.loginOptions = new ZoomMeetingOptions(
//         userId:
//             'aliadam7867@gmail.com', // Replace with the user email or Zoom user ID of host for start meeting only.
//         meetingPassword:
//             'Asha@2341!', // Replace with the user password for your Zoom ID of host for start meeting only.
//         disableDialIn: "false",
//         disableDrive: "false",
//         disableInvite: "false",
//         disableShare: "false",
//         disableTitlebar: "false",
//         viewOptions: "false",
//         noAudio: "false",
//         noDisconnectAudio: "false");
//   }
//
//   @override
//   _StartMeetingWidgetState createState() => _StartMeetingWidgetState();
// }
//
// class _StartMeetingWidgetState extends State<StartMeetingWidget> {
//   Timer timer;
//
//   bool _isMeetingEnded(String status) {
//     var result = false;
//
//     if (Platform.isAndroid)
//       result = status == "MEETING_STATUS_DISCONNECTING" ||
//           status == "MEETING_STATUS_FAILED";
//     else
//       result = status == "MEETING_STATUS_IDLE";
//
//     return result;
//   }
//
//   bool _isLoading = true;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Loading meeting '),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             _isLoading ? CircularProgressIndicator() : Container(),
//             Expanded(
//               child: ZoomView(onViewCreated: (controller) {
//                 print("Created the view");
//
//                 controller.initZoom(this.widget.zoomOptions).then((results) {
//                   print(results);
//
//                   if (results[0] == 0) {
//                     controller.zoomStatusEvents.listen((status) {
//                       print("Meeting Status Stream: " +
//                           status[0] +
//                           " - " +
//                           status[1]);
//                       if (_isMeetingEnded(status[0])) {
//                         Navigator.pop(context);
//                         timer?.cancel();
//                       }
//                     });
//
//                     print("listen on event channel");
//
//                     controller
//                         .login(this.widget.loginOptions)
//                         .then((loginResult) {
//                       print("LoginResultBool :- " + loginResult.toString());
//                       if (loginResult) {
//                         print("LoginResult :- Logged In");
//                         setState(() {
//                           _isLoading = false;
//                         });
//                       } else {
//                         print("LoginResult :- Logged In Failed");
//                       }
//                     });
//                   }
//                 }).catchError((error) {
//                   print(error);
//                 });
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
