import 'package:flutter/material.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/payment.dart';
import 'package:InPrep/models/user.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPayments extends StatefulWidget {
  final user;

  const MyPayments({Key key, this.user}) : super(key: key);
  @override
  _MyPaymentsState createState() => _MyPaymentsState(user: user);
}

class _MyPaymentsState extends State<MyPayments> {
  final _databaseService = DatabaseService();
  final MyUser user;
  int total = 0;
  double pays = 0.0;
  _MyPaymentsState({this.user});

  Future<List<Payment>> getPayments() async {
    setState(() {
      total = 0;
      pays = 0;
    });
    List<Payment> payments = [];
    //print(" UID ${user.uid}");
    payments = await _databaseService.getPayments(uid: user.uid);
    // print(payments.length);
    int t = 0;
    double p = 0;
    for (var pay in payments) {
      t += 1;
      p += double.parse(pay.price);
    }
    setState(() {
      total = t;
      pays = p;
    });
    //print("MY PAYMENTs $t $p");
    return payments;
  }

  SharedPreferences preferences;
  bool dark;
  getPref() async {
    preferences = await SharedPreferences.getInstance();

    setState(() {
      dark = preferences.getBool('dark');
    });
    //print("GET BOOLEAN IN SESSIONS ${preferences.getBool('dark')}");
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('My Payments'),
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularPercentIndicator(
                              radius: 110.0,
                              lineWidth: 2.5,
                              animation: true,
                              percent: 1,
                              center: new Text(
                                "$total",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              footer: new Text(
                                "Total Payments",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularPercentIndicator(
                              radius: 110.0,
                              lineWidth: 2.5,
                              animation: true,
                              percent: 1,
                              center: new Text(
                                "\$$pays",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              footer: new Text(
                                "Money Spent",
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
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                height: 420,
                child: FutureBuilder(
                  future: getPayments(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length != 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.length ?? 1,
                            itemBuilder: (BuildContext context, int index) {
                              var pid = snapshot.data[index].pid;
                              var date =
                                  DateTime.parse(snapshot.data[index].date);
                              var newdate = DateFormat('EEEE').format(date) +
                                  ", ${date.day} " +
                                  DateFormat('MMMM').format(date) +
                                  " ${date.year}";
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 6,
                                    // color: Colors.white60,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Payment ID: ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: dark
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '$pid',
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.date_range,
                                                  color: dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '$newdate',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.monetization_on,
                                                  color: dark
                                                      ? Colors.amber
                                                      : Colors.amber,
                                                ),
                                              ),
                                              Text(
                                                '${snapshot.data[index].price}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Text('You have no Payments.'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('You have no Payments.'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
