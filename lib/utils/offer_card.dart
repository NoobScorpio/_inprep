import 'dart:io';
import 'dart:ui';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/models/offer.dart';
import 'package:InPrep/screens/chat/date_time.dart';
import 'package:InPrep/screens/group/invite_screen.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/payment_screen.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/order.dart';
import 'package:InPrep/models/payment.dart';
import 'package:InPrep/models/session.dart';
import 'package:InPrep/models/message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferCard extends StatelessWidget {
  final List<Meeting> meetsObjects;
  final List<Widget> meets;
  final cid;
  final currUser;
  final offerCancelled;
  final accepted;
  final sid;
  final skype;
  final meetTime;
  final rid;
  final displayName;
  final name;
  final seeker;
  final cost;
  final meid;
  final declined;
  final Offer offer;
  final nameRec;
  final dark;
  OfferCard({
    this.meetsObjects,
    this.dark,
    this.declined,
    this.nameRec,
    this.offerCancelled,
    this.sender,
    this.accepted,
    this.cost,
    this.meid,
    this.seeker,
    this.appointDate,
    this.appointTime,
    this.isMe,
    this.time,
    this.cid,
    this.displayName,
    this.name,
    this.rid,
    this.sid,
    this.meets,
    this.offer,
    this.skype,
    this.meetTime,
    this.currUser,
  });
  final String sender;
  final bool isMe;
  final String time;
  final String appointTime, appointDate;
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black54,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              // side: BorderSide(color: Colors.red)
            ),
            elevation: 6,
            child: Container(
              height: 330,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: dark ? Colors.grey[600] : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12, top: 12, bottom: 1),
                                child: Text(
                                  'Meeting',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (isMe && !offerCancelled)
                                PopupMenuButton(
                                    // color: Colors.black,
                                    child: Icon(
                                      Icons.more_vert,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 2) {
                                        DatabaseService db = DatabaseService();
                                        DocumentSnapshot msg = await db
                                            .chatsCollection
                                            .doc(cid)
                                            .collection('messages')
                                            .doc(meid)
                                            .get();
                                        Message message =
                                            Message.fromJson(msg.data());
                                        message.offer.cancel = true;
                                        await db.chatsCollection
                                            .doc(cid)
                                            .collection('messages')
                                            .doc(meid)
                                            .update(message.toJson());
                                      }
                                      if (value == 1) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyDateTime(
                                                      dark: dark,
                                                      cid: cid,
                                                      isSkype:
                                                          offer.isSkype ?? true,
                                                      sid: sid,
                                                      rid: rid,
                                                      displayName: displayName,
                                                      zoomLink: offer.link,
                                                      name: name,
                                                      edit: true,
                                                      date: appointDate,
                                                      time: appointTime,
                                                      cost: cost,
                                                      meets: meetsObjects,
                                                      oid: offer.oid,
                                                      meid: meid,
                                                    )));
                                      }
                                      if (value == 3) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InviteScreen(
                                                      currUser: currUser,
                                                      link: offer.link,
                                                      date:
                                                          meetsObjects[0].date,
                                                      time:
                                                          meetsObjects[0].time,
                                                    )));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          if (!accepted)
                                            PopupMenuItem(
                                                value: 1,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(2, 2, 8, 2),
                                                      child: Icon(
                                                        Icons.edit,
                                                      ),
                                                    ),
                                                    Text('Edit Offer')
                                                  ],
                                                )),
                                          if (accepted)
                                            PopupMenuItem(
                                                value: 3,
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(2, 2, 8, 2),
                                                      child: Icon(
                                                        Icons.share,
                                                      ),
                                                    ),
                                                    Text('Invite')
                                                  ],
                                                )),
                                          PopupMenuItem(
                                              value: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(2, 2, 8, 2),
                                                    child: Icon(
                                                      Icons.cancel,
                                                    ),
                                                  ),
                                                  Text('Cancel Offer')
                                                ],
                                              )),
                                        ]),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Divider(
                              color: Colors.black87,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Date & time for appointment',
                                style: TextStyle(
                                    // color: Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: dark
                                      ? Colors.black
                                      : Theme.of(context).primaryColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$appointDate',
                                    // 'OFFER',
                                    style: TextStyle(
                                        // color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: dark
                                      ? Colors.black
                                      : Theme.of(context).primaryColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    // '${appointTime + " " + (meetsObjects[0].timezone ?? "")}',
                                    // 'ODDER',
                                    "$appointTime",
                                    style: TextStyle(
                                        // color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: dark
                                        ? Colors.black
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '$cost',
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (accepted)
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (offer.isSkype ?? true)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          height: 35,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () async {
                                              showLoader(context);
                                              bool confirm =
                                                  await _databaseService
                                                      .getAppointment(cid: cid);
                                              Navigator.pop(context);
                                              if (!confirm)
                                                showToast(context,
                                                    'No meeting scheduled');
                                              else if (!meetTime)
                                                showToast(context,
                                                    'Kindly try again during meeting time');
                                              else {
                                                showToast(
                                                    context, 'Launching Skype');
                                                _launchURL(
                                                    context: context,
                                                    rid: rid,
                                                    sid: sid,
                                                    userID: skype);
                                              }
                                            },
                                            color: Colors.blueAccent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.skype,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Skype Call',
                                                  style: TextStyle(
                                                      color: dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!(offer.isSkype ?? true))
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Container(
                                          height: 35,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onPressed: () async {
                                              if (offer.link == "") {
                                                showToast(context,
                                                    "Zoom meeting link not added");
                                              } else {
                                                showLoader(context);
                                                bool confirm =
                                                    await _databaseService
                                                        .getAppointment(
                                                            cid: cid);
                                                Navigator.pop(context);
                                                if (!confirm)
                                                  showToast(context,
                                                      'No meeting scheduled');
                                                else if (!meetTime)
                                                  showToast(context,
                                                      'Kindly try again during meeting time');
                                                else {
                                                  showToast(context,
                                                      'Launching Zoom');
                                                  if (await canLaunch(
                                                      offer.link)) {
                                                    launch(offer.link);
                                                  }
                                                }
                                              }
                                            },
                                            color: Colors.blueAccent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.video,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'Zoom Call',
                                                  style: TextStyle(
                                                      color: dark
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Divider(
                              color: Colors.black87,
                            ),
                          ),
                          if (!accepted && !offerCancelled)
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 50,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () async {
                                            if (Platform.isIOS) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CupertinoAlertDialog(
                                                            title: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "Meeting Details"),
                                                            ),
                                                            content: Container(
                                                              height: 35.0 *
                                                                  meets.length,
                                                              child: Column(
                                                                children: meets,
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: Text(
                                                                "Meeting Details"),
                                                            content: Container(
                                                              height: 35.0 *
                                                                  meets.length,
                                                              child: Column(
                                                                children: meets,
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child:
                                                                    Text('Ok'),
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          ));
                                            }
                                          },
                                          color: Colors.orange,
                                          child: Text(
                                            'Details',
                                            style: TextStyle(
                                                color: dark
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 50,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () async {
                                            if (!accepted && !declined) {
                                              if (seeker &&
                                                  !isMe &&
                                                  !offerCancelled) {
                                                print(rid);
                                                if (Platform.isIOS) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CupertinoAlertDialog(
                                                            title: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "Meeting"),
                                                            ),
                                                            content: Container(
                                                              height: 120,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Note: Additional 5\$ will be charged for InPrep services.",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Text(
                                                                      "Do you want to accept the offer?"),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                      "Total charges: ${cost + 5}\$")
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                onPressed:
                                                                    () async {
                                                                  yes(
                                                                      context,
                                                                      'ios',
                                                                      cost);
                                                                },
                                                                child:
                                                                    Text('Yes'),
                                                              ),
                                                              CupertinoDialogAction(
                                                                onPressed:
                                                                    () async {
                                                                  no(context,
                                                                      'ios');
                                                                },
                                                                child:
                                                                    Text("No"),
                                                              )
                                                            ],
                                                          ));
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                            title:
                                                                Text("Meeting"),
                                                            content: Container(
                                                              height: 140,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Note: Thank you for using inPrep please be advised we charge a \$5.00 fee per transaction for our services in the application.",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Text(
                                                                      "Do you want to accept the offer?"),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                      "Total charges: ${cost + 5}\$")
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child:
                                                                    Text('No'),
                                                                onPressed:
                                                                    () async {
                                                                  no(context,
                                                                      'android');
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child:
                                                                    Text('Yes'),
                                                                onPressed:
                                                                    () async {
                                                                  yes(
                                                                      context,
                                                                      'android',
                                                                      cost);
                                                                },
                                                              ),
                                                            ],
                                                          ));
                                                }
                                              }
                                            } else {}
                                          },
                                          color: seeker &&
                                                  !isMe &&
                                                  !offerCancelled &&
                                                  !declined
                                              ? (accepted
                                                  ? Colors.grey
                                                  : (declined
                                                      ? Colors.red
                                                      : Colors.green))
                                              : (Colors.grey),
                                          child: Text(
                                            offerCancelled
                                                ? 'Withdrawn'
                                                : (accepted
                                                    ? 'Accepted'
                                                    : (declined
                                                        ? 'Declined'
                                                        : 'Accept')),
                                            style: TextStyle(
                                                color: dark
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (accepted)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text("Offer Accepted"),
                              ),
                            ),
                          if (offerCancelled)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text("Offer Cancelled"),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            child: Text(
              time,
              style: TextStyle(
                color: dark ? Colors.white : Colors.black54,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String msgTime(context) {
    String time = TimeOfDay.now().format(context);
    return time;
  }

  String msgDate() {
    var date = DateTime.now().toString();

    return date;
  }

  no(context, platform) async {
    DocumentSnapshot msg = await _databaseService.chatsCollection
        .doc(cid)
        .collection('messages')
        .doc(meid)
        .get();
    Message message = Message.fromJson(msg.data());
    message.offer.declined = true;
    await _databaseService.chatsCollection
        .doc(cid)
        .collection('messages')
        .doc(meid)
        .update(message.toJson());
    await _databaseService.sendMessage(
        cid: cid,
        sender: displayName,
        receiver: name,
        type: 0,
        time: msgTime(context),
        date: msgDate(),
        sid: sid,
        rid: rid,
        platform: platform,
        msg: 'This date and time is not feasible for me.');

    await _databaseService.chatsCollection.doc(cid).update({'confirm': false});
    Navigator.pop(context);
  }

  yes(context, platform, price) async {
    // print('INSIDE YES');
    var pid = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => PaymentScreen(
                cost: cost + 5,
                date: appointDate,
                time: appointTime,
                name: nameRec,
              )),
    );
    // print('RETURNED FROM PAYMENT');
    Navigator.pop(context);
    // print('POIPPED');
    // var pid = "afkjngkjg";
    if (pid != null) {
      // print(' INSIDE PID : GOT THE ID $pid');
      var time = msgTime(context);
      var date = msgDate();
      await _databaseService.sendMessage(
          cid: cid,
          sid: sid,
          sender: displayName,
          receiver: name,
          time: time,
          date: date,
          type: 0,
          rid: rid,
          platform: platform,
          msg: 'This date and time looks great. I have accepted the offer.');
      // print('UPDATING CONFIRM');
      try {
        List<String> meetsIds = [];
        for (Meeting meet in meetsObjects) {
          meetsIds.add(meet.mid);
        }
        Session session = Session(
            meets: meets.length,
            meetsIds: meetsIds,
            sessid: '',
            date: date,
            time: time,
            consId: rid,
            seekId: sid,
            users: [sid, rid],
            cid: cid,
            rating: 0.0.toString(),
            timestamp: Timestamp.now(),
            completed: false);
        var sessid = await _databaseService.createSession(session: session);

        Payment payment = Payment(
            pid: '',
            price: price.toString(),
            date: date,
            time: time,
            tid: pid,
            sid: sid,
            rid: rid,
            cid: cid,
            timestamp: Timestamp.now(),
            withdraw: false);
        var ppid = await _databaseService.createPayment(payment: payment);

        Order order = Order(
          oid: '',
          pid: pid,
          uid: rid,
          price: price.toString(),
          date: date,
          time: time,
          sid: sid,
          withdraw: false,
          timestamp: Timestamp.now(),
          pending: true,
        );

        var oid = await _databaseService.createOrder(order: order);
        // Meeting meet = Meeting(
        //     mid: '',
        //     seekId: sid,
        //     conId: rid,
        //     date: date,
        //     time: time,
        //     completed: false);
        // var meetid = await _databaseService.createMeet(meeting: meet);

        await _databaseService.chatsCollection
            .doc(cid)
            .update({'confirm': true, 'acceptedOfferID': meid});
        // print('UPDATING CONFIRM DONE');

        DocumentSnapshot msg = await _databaseService.chatsCollection
            .doc(cid)
            .collection('messages')
            .doc(meid)
            .get();
        Message message = Message.fromJson(msg.data());
        message.offer.accepted = true;

        // print('EDITED MESSAGE');
        await _databaseService.chatsCollection
            .doc(cid)
            .collection('messages')
            .doc(meid)
            .update(message.toJson());
        // print('UPDATING ACCEPpt DONE');
        //  UPDATING IDS
        await _databaseService.sessCollection.doc(sessid).update({
          'oid': oid,
        });
        await _databaseService.orderCollection.doc(oid).update({
          'sessid': sessid,
        });
        await _databaseService.paymentCollection.doc(ppid).update({
          'sessid': sessid,
        });
        // print('UPDATING IDS');
        // await _databaseService.meetCollection.document(meetid).updateData({
        //   'mid': meetid,
        // });
        // await _databaseService.chatsCollection
        //     .document(cid)
        //     .collection('messages')
        //     .document(meid)
        //     .updateData({'accepted': true});
        // print('ACCEPTED TRUE SUCCESS');
      } catch (e) {
        // print("NOT SUCCESS $e");
      }
    } else {
      // print('NO ID');
    }
  }

  _launchURL({context, sid, rid, userID}) async {
    var link = await _databaseService.getSkype(uid: rid == userID ? sid : rid);
    try {
      if (await canLaunch('skype:$link')) {
        await launch('skype:$link');
      } else {
        if (Platform.isIOS)
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Could not call"),
                    ),
                    content: Container(
                        height: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text("This can be due to following reasons"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("You do not have skype installed."),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Skpye id is inavalid"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "You have skpye installed but not setup your id."),
                            ),
                          ],
                        )),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('ok'),
                      )
                    ],
                  ));
        else
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Could not call"),
                    ),
                    content: Container(
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "This can be due to following reasons",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("You do not have skype installed."),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("skype id is invalid"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "You have skype installed but not setup your id."),
                            ),
                          ],
                        )),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('ok'),
                      )
                    ],
                  ));
      }
    } catch (e) {
      // showSnack('Wrong skype id provided');
    }
  }
}
