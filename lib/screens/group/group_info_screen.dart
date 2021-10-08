import 'package:InPrep/models/group.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/profile_screens/profile_view.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({this.group, this.dark}) : super();
  final Group group;
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text('Group Info'),
      ),
      body: Stack(
        children: [
          background(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black,
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: CachedNetworkImage(
                      imageUrl: group.photo,
                      imageBuilder: (context, image) {
                        return Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(360)),
                              image: DecorationImage(
                                  image: image, fit: BoxFit.cover)),
                        );
                      },
                      placeholder: (context, image) {
                        return Container(
                          width: 100.0,
                          height: 100.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, image, err) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(360)),
                            color: Theme.of(context).primaryColor,
                          ),
                          width: 100.0,
                          height: 100.0,
                          child: Center(
                            child: Center(
                              child: Icon(
                                Icons.group_add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Group name",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ?? false
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    group.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Group description",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ?? false
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    group.desc,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Group Users',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: dark ?? false
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: columnUsers(context),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> columnUsers(context) {
    List<Widget> widgets = [];
    for (MyUser user in group.users) {
      widgets.add(userComponent(user: user, context: context));
    }
    return widgets;
  }

  userComponent({MyUser user, context}) {
    return InkWell(
      onTap: () async {
        push(
            context,
            ProfileView(
              uid: user.uid,
              loggedIn: true,
            ));
      },
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        user.photoUrl == "" || user.photoUrl == null
                            ? "https://inprepapp.com/assets/images/logo.png"
                            : user.photoUrl,
                        errorBuilder: (_, obj, err) {
                          return Container(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  "https://inprepapp.com/assets/images/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ));
                        },
                        fit: BoxFit.cover,
                      ),
                    )),
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      (group.creator.uid == user.uid
                              ? '${user.displayName} (CREATOR)'
                              : user.displayName) ??
                          "No Name",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user.design ?? "Not available",
                      style: TextStyle(color: Colors.grey[500])),
                ]),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
