import 'dart:io';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/screens/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/auth/payment_screen.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/order.dart';
import 'package:InPrep/models/payment.dart';
import 'package:InPrep/models/session.dart';
import 'package:InPrep/models/message.dart';

class OfferCard extends StatelessWidget {
  final meetsObjects;
  final List<Widget> meets;
  final cid;
  final offerCancelled;
  final accepted;
  final sid;
  final rid;
  final displayName;
  final name;
  final seeker;
  final cost;
  final meid;
  final declined;
  final offer;
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
              height: 335,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: dark ? Colors.grey[600] : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
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
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (isMe)
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
                                            builder: (context) => MyDateTime(
                                                  dark: dark,
                                                  cid: cid,
                                                  sid: sid,
                                                  rid: rid,
                                                  displayName: displayName,
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
                                },
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 2, 8, 2),
                                                child: Icon(
                                                  Icons.edit,
                                                ),
                                              ),
                                              Text('Edit Offer')
                                            ],
                                          )),
                                      PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 2, 8, 2),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Data & time for appointment',
                          style: TextStyle(
                              // color: Colors.grey,
                              ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    '${appointTime + " " + (meetsObjects[0].timezone ?? "")}',
                                    // 'ODDER',
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
                                  Icons.monetization_on,
                                  color: dark
                                      ? Colors.black
                                      : Theme.of(context).primaryColor,
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          color: Colors.black87,
                        ),
                      ),
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
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        Text("Meeting Details"),
                                                  ),
                                                  content: Container(
                                                    height: 35.0 * meets.length,
                                                    child: Column(
                                                      children: meets,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                ));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title:
                                                      Text("Meeting Details"),
                                                  content: Container(
                                                    height: 35.0 * meets.length,
                                                    child: Column(
                                                      children: meets,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('Ok'),
                                                      onPressed: () async {
                                                        Navigator.pop(context);
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
                                                        child: Text("Meeting"),
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
                                                                  color: Theme.of(
                                                                          context)
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
                                                          onPressed: () async {
                                                            yes(context, 'ios',
                                                                cost);
                                                          },
                                                          child: Text('Yes'),
                                                        ),
                                                        CupertinoDialogAction(
                                                          onPressed: () async {
                                                            no(context, 'ios');
                                                          },
                                                          child: Text("No"),
                                                        )
                                                      ],
                                                    ));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    AlertDialog(
                                                      title: Text("Meeting"),
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
                                                                  color: Theme.of(
                                                                          context)
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
                                                          child: Text('No'),
                                                          onPressed: () async {
                                                            no(context,
                                                                'android');
                                                          },
                                                        ),
                                                        FlatButton(
                                                          child: Text('Yes'),
                                                          onPressed: () async {
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
}
