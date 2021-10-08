import 'dart:io';
import 'dart:math';

import 'package:InPrep/auth/payment_screen.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/groupMessage.dart';
import 'package:InPrep/models/group_offer.dart';
import 'package:InPrep/models/order.dart';
import 'package:InPrep/models/payment.dart';
import 'package:InPrep/models/session.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/group/create_group_offer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../utils/loader.dart';

class GroupOfferCard extends StatelessWidget {
  final MyUser currUser;
  final GroupOffer offer;
  final GroupMessage groupMessage;
  final Group group;
  final bool isMe, dark;
  GroupOfferCard(
      {this.currUser,
      this.offer,
      this.dark,
      this.isMe,
      this.group,
      this.groupMessage})
      : super();
  final _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            currUser.displayName,
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
              height: 125,
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
                                  '${currUser.subCategory} Service',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (isMe && !offer.cancel)
                                PopupMenuButton(
                                    // color: Colors.black,
                                    child: Icon(
                                      Icons.more_vert,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 2) {
                                        groupMessage.offer.cancel = true;

                                        await _databaseService.groupsCollection
                                            .doc(group.gid)
                                            .collection('messages')
                                            .doc(groupMessage.gmid)
                                            .update(groupMessage.toJson());
                                      }
                                      if (value == 1) {
                                        push(
                                            context,
                                            CreateGroupOfferScreen(
                                              group: group,
                                              creator: currUser,
                                              groupOffer: offer,
                                              edit: true,
                                            ));
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          if (!offer.accepted)
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
                                          if (!offer.cancel)
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: dark
                                          ? Colors.grey
                                          : Theme.of(context).primaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${offer.cost}',
                                        style: TextStyle(
                                          // color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (!offer.accepted && !offer.cancel)
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        onPressed: () async {
                                          if (!offer.accepted &&
                                              !offer.declined) {
                                            if (currUser.seeker &&
                                                !isMe &&
                                                !offer.cancel) {
                                              // print(rid);
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
                                                                  "Total charges: ${offer.cost + 5}\$")
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('No'),
                                                            onPressed:
                                                                () async {
                                                              no(context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text('Yes'),
                                                            onPressed:
                                                                () async {
                                                              yes(context,
                                                                  offer.cost);
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                            }
                                          } else {}
                                        },
                                        color: currUser.seeker &&
                                                !isMe &&
                                                !offer.cancel &&
                                                !offer.declined
                                            ? (offer.accepted
                                                ? Colors.grey
                                                : (offer.declined
                                                    ? Colors.red
                                                    : Colors.green))
                                            : (Colors.grey),
                                        child: Text(
                                          offer.cancel
                                              ? 'Withdrawn'
                                              : (offer.accepted
                                                  ? 'Accepted'
                                                  : (offer.declined
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
                                if (offer.accepted)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("Offer Accepted"),
                                    ),
                                  ),
                                if (offer.cancel)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("Offer Cancelled"),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
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
        ],
      ),
    );
  }

  no(context) async {
    showLoader(context);
    groupMessage.offer.declined = true;
    await _databaseService.groupsCollection
        .doc(group.gid)
        .collection('messages')
        .doc(groupMessage.gmid)
        .update(groupMessage.toJson());
    sendNotification(
        user: offer.creator,
        message:
            '${currUser.displayName} has declined your offer in group ${group.title}');
    pop(context);
  }

  String msgTime(context) {
    String time = TimeOfDay.now().format(context);
    return time;
  }

  String msgDate() {
    var date = DateTime.now().toString();

    return date;
  }

  yes(context, double cost) async {
    print('INSIDE YES');

    var pid = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => PaymentScreen(
                cost: cost + 5.0,
                // date: appointDate,
                // time: appointTime,
                name: offer.creator.displayName,
              )),
    );
    // var pid = 'TEST ${Random().nextInt(1000)}';
    Navigator.pop(context);
    if (pid != null) {
      var time = msgTime(context);
      var date = msgDate();
      await _databaseService.sendGroupMessage(
          group: group,
          context: context,
          sender: currUser.displayName,
          type: 0,
          url: '',
          msg: "I have accepted ${offer.creator.displayName}'s offer.");

      try {
        Session session = Session(
            meets: 1,
            meetsIds: [],
            sessid: '',
            date: date,
            time: time,
            consId: offer.creator.uid,
            seekId: currUser.uid,
            users: [currUser.uid, offer.creator.uid],
            cid: '',
            gid: group.gid,
            rating: 0.0.toString(),
            timestamp: Timestamp.now(),
            completed: false);
        var sessid = await _databaseService.createSession(session: session);

        Payment payment = Payment(
            pid: '',
            price: cost.toString(),
            date: date,
            time: time,
            tid: pid,
            sid: currUser.uid,
            rid: offer.creator.uid,
            cid: '',
            gid: group.gid,
            timestamp: Timestamp.now(),
            withdraw: false);
        var ppid = await _databaseService.createPayment(payment: payment);

        Order order = Order(
          gid: group.gid,
          oid: '',
          pid: pid,
          uid: offer.creator.uid,
          price: cost.toString(),
          date: date,
          time: time,
          sid: currUser.uid,
          withdraw: false,
          timestamp: Timestamp.now(),
          pending: true,
        );
        var oid = await _databaseService.createOrder(order: order);
        groupMessage.offer.accepted = true;
        group.usersAccepted[offer.creator.uid] = true;
        bool allAccepted = true;
        for (String accept in group.usersAccepted.keys) {
          if (group.usersAccepted[accept] == false) allAccepted = false;
        }
        group.confirmed = allAccepted;
        await _databaseService.groupsCollection
            .doc(group.gid)
            .update(group.toJson());
        await _databaseService.groupsCollection
            .doc(group.gid)
            .collection('messages')
            .doc(groupMessage.gmid)
            .update(groupMessage.toJson());

        await _databaseService.sessCollection.doc(sessid).update({
          'oid': oid,
        });
        await _databaseService.orderCollection.doc(oid).update({
          'sessid': sessid,
        });
        await _databaseService.paymentCollection.doc(ppid).update({
          'sessid': sessid,
        });
        sendNotification(
            user: offer.creator,
            message:
                '${currUser.displayName} has accepted your offer in group ${group.title}');
      } catch (e) {}
    } else {}
  }
}
