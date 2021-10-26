import 'dart:io';

import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/groupMessage.dart';
import 'package:InPrep/models/group_offer.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader_notifications.dart';
import 'package:InPrep/utils/mytext_field_form.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instant/instant.dart';

class CreateGroupOfferScreen extends StatefulWidget {
  const CreateGroupOfferScreen({
    this.groupOffer,
    this.edit,
    this.creator,
    this.group,
  }) : super();
  final GroupOffer groupOffer;
  final MyUser creator;
  final Group group;
  final bool edit;
  @override
  _CreateGroupOfferScreenState createState() => _CreateGroupOfferScreenState();
}

class _CreateGroupOfferScreenState extends State<CreateGroupOfferScreen> {
  DatabaseService _databaseService = DatabaseService();
  TextEditingController price = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.edit != null) {
      price.text = widget.groupOffer.cost.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    price.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    bool dark = AdaptiveTheme.of(context).mode.isDark;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Offer"),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MyTextFormField(
                        controller: price,
                        padding: EdgeInsets.all(0),
                        hint: 'Enter Session Cost',
                        labelText: 'Cost',
                        prefixIcon: Icon(Icons.attach_money,
                            color: dark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        keyboardType: TextInputType.number,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context, null);
                                },
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Back',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  if (price.text.toString() != '') {
                                    double p =
                                        double.parse(price.text.toString());
                                    if (p >= 20.0) {
                                      String platform =
                                          Platform.isIOS ? 'ios' : 'android';
                                      widget.edit != null
                                          ? showToast(context, 'Updating Offer')
                                          : showToast(
                                              context, 'Creating Offer');
                                      double cost =
                                          double.parse(price.text.toString());
                                      await createUpdateOffer(context, cost);
                                    } else
                                      showToast(context,
                                          'Cost should not be less then 20\$.');
                                  } else
                                    showToast(
                                        context, 'Please enter your cost');
                                },
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Done',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  createUpdateOffer(context, cost) async {
    showLoader(context);
    if (widget.edit == null) {
      Map<String, bool> usersAccepted = {};
      for (var usr in widget.group.users) {
        if (usr.uid != widget.creator.uid) {
          usersAccepted[usr.uid] = false;
        }
      }
      await _databaseService.groupsCollection.doc(widget.group.gid).update({
        'confirmed': false,
      });
      GroupOffer offer = GroupOffer(
          gmid: "",
          goid: '',
          accepted: false,
          usersAccepted: usersAccepted,
          completed: false,
          creator: widget.creator,
          timezone: DateTime.now().timeZoneName,
          cost: cost,
          cancel: false,
          declined: false,
          timestamp: Timestamp.now());
      // var cost = price.text.toString();
      await _databaseService.sendGroupOfferMessage(
          context: context,
          sender: widget.creator,
          group: widget.group,
          groupOffer: offer,
          type: 2,
          msg: 'Offer');
      for (String usr in widget.group.userIDS) {
        if (usr != widget.creator.uid) {
          var doc = await _databaseService.userCollection.doc(usr).get();
          int badge = MyUser.fromJson(doc.data()).badge;
          await _databaseService.userCollection
              .doc(usr)
              .update({"badge": badge + 1});
        }
      }
    } else {
      try {
        var msgDOc = await _databaseService.groupsCollection
            .doc(widget.group.gid)
            .collection("messages")
            .doc(widget.groupOffer.gmid)
            .get();
        GroupMessage groupMessage = GroupMessage.fromJson(msgDOc.data());
        groupMessage.offer.timezone = DateTime.now().timeZoneName;
        groupMessage.offer.cost = cost;
        groupMessage.offer.timestamp = Timestamp.now();
        await _databaseService.groupsCollection
            .doc(widget.group.gid)
            .collection('messages')
            .doc(widget.groupOffer.gmid)
            .update(groupMessage.toJson());
      } catch (e) {
        print("@OFFER $e");
      }
    }
    pop(context);
    pop(context);
  }
}
