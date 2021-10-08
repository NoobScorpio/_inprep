import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/session.dart';
import 'package:InPrep/models/user.dart';
import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySessions extends StatefulWidget {
  final user;

  const MySessions({Key key, this.user}) : super(key: key);

  @override
  _MySessionsState createState() => _MySessionsState(user: user);
}

class _MySessionsState extends State<MySessions> {
  final _databaseService = DatabaseService();
  SharedPreferences preferences;
  bool dark;
  bool isLoading = true;
  final MyUser user;
  double rating = 1.0;
  TextEditingController reviewController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int nses = 0, cses = 0, pses = 0;
  Future<List<Session>> getSessions() async {
    setState(() {
      nses = 0;
      cses = 0;
      pses = 0;
    });
    List<Session> sessions = [];
    print(" UID ${user.uid}");
    sessions = await _databaseService.getSessions(uid: user.uid);
    print(sessions.length);
    var nnses = 0, ccses = 0, ppses = 0;
    for (var ses in sessions) {
      nnses += 1;
      if (ses.completed)
        ccses += 1;
      else
        ppses += 1;
    }
    // setState(() {
    nses = nnses;
    cses = ccses;
    pses = ppses;

    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    return sessions;
  }

  TextEditingController controller = TextEditingController();
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      dark = preferences.getBool('dark');
    });
    print("GET BOOLEAN IN SESSIONS ${preferences.getBool('dark')}");
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void showSnack(text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
  }

  _MySessionsState({this.user});
  @override
  Widget build(BuildContext context) {
    // print(user);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('My Sessions'),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.09,
            child: Image.asset(
              "assets/images/bg.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularPercentIndicator(
                                radius: 110.0,
                                lineWidth: 2.5,
                                animation: true,
                                percent: 1,
                                center: new Text(
                                  "$nses",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: new Text(
                                  "Sessions",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularPercentIndicator(
                                radius: 110.0,
                                lineWidth: 2.5,
                                animation: true,
                                percent: nses == 0
                                    ? 1
                                    : (cses == nses ? 1 : cses / nses),
                                center: new Text(
                                  "$cses",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: new Text(
                                  "Completed",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularPercentIndicator(
                                radius: 110.0,
                                lineWidth: 2.5,
                                animation: true,
                                percent: nses == 0 ? 1 : cses / nses,
                                center: new Text(
                                  "$pses",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: new Text(
                                  "Pending",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 300,
                child: FutureBuilder(
                  future: getSessions(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print('INSIDE BUILDER');
                    if (snapshot.hasData) {
                      print('INSIDE HAS DATA');
                      if (snapshot.data.length != 0) {
                        if (!isLoading)
                          return ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length ?? 1,
                              itemBuilder: (BuildContext context, int index) {
                                bool completed = snapshot.data[index].completed;
                                var sessid = snapshot.data[index].sessid;
                                var color =
                                    completed ? Colors.green : Colors.black12;
                                var oid = snapshot.data[index].oid;
                                Session session = snapshot.data[index];
                                String text = completed
                                    ? "Session completed"
                                    : "Mark as Completed";
                                String cText = completed
                                    ? "Session completed"
                                    : "Session in progress";
                                print('INSIDE BUILDER');

                                return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      height: user.seeker
                                          ? (completed ? 300 : 300)
                                          : 300,
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 6,
                                        // color: Colors.white60,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Session ID: ',
                                                    style: TextStyle(
                                                        color: dark
                                                            ? Colors.white
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '$sessid',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              thickness: 2,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Icons.date_range,
                                                      color: dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index].date.toString().split(' ')[0]}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Icons.access_time,
                                                      color: dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${snapshot.data[index].time}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Icon(
                                                      Icons.report,
                                                      color: dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.seeker
                                                        ? '$text'
                                                        : '$cText',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (completed)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GFRating(
                                                  color: Colors.yellow,
                                                  value: double.parse(snapshot
                                                      .data[index].rating),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      // rating = val;
                                                    });
                                                  },
                                                ),
                                              ),
                                            if (user.seeker && !completed)
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 50,
                                                    color: completed
                                                        ? Colors.green
                                                        : Colors.black12,
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        if (completed) {
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                    title: Text(
                                                                        "Complete"),
                                                                    content:
                                                                        Container(
                                                                      height:
                                                                          155,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                              "Kindly leave a stars out of 5"),
                                                                          Expanded(
                                                                            child:
                                                                                TextFormField(
                                                                              controller: controller,
                                                                              autofillHints: [
                                                                                'Between 0 and 5'
                                                                              ],
                                                                              validator: (val) {
                                                                                if (double.parse(val.toString()) > 5 || double.parse(val.toString()) < 0) {
                                                                                  return null;
                                                                                }
                                                                                rating = double.parse(val.toString());
                                                                                return '';
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 15.0),
                                                                            child:
                                                                                Text("Mark complete"),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: Text(
                                                                            'No'),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child: Text(
                                                                            'Yes'),
                                                                        onPressed:
                                                                            () async {
                                                                          // print(
                                                                          //     " USER ID : {${user.uid}}");
                                                                          // print(
                                                                          //     " USER ID : {${session.consId}}");
                                                                          if (user.uid !=
                                                                              session.consId) {
                                                                            if (double.parse(controller.text.toString()) > 5 ||
                                                                                double.parse(controller.text.toString()) < 0) {
                                                                              showSnack('Please enter between 0 and 5');
                                                                            } else {
                                                                              await _databaseService.sessCollection.doc(sessid).update({
                                                                                'completed': true,
                                                                                "rating": controller.text.toString()
                                                                              });
                                                                              setState(() {
                                                                                completed = true;
                                                                                text = "Session Completed";
                                                                                color = Colors.green;
                                                                              });
                                                                              Navigator.pop(context);
                                                                              await _databaseService.orderCollection.doc(oid).update({
                                                                                'pending': false,
                                                                              });
                                                                            }
                                                                          } else {
                                                                            showSnack('You cannot complete your own session.');
                                                                          }
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ));
                                                        }
                                                      },
                                                      child: Text(completed
                                                          ? "Session completed"
                                                          : 'Mark as Complete'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        print('INSIDE NO LENGTH');
                        return Center(
                          child: Text('You have no Sessions.'),
                        );
                      }
                    } else {
                      print('INSIDE NO DATA');
                      return Center(
                        child: Text('You have no Sessions.'),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
