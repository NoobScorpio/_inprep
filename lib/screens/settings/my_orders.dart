import 'package:flutter/material.dart';
import 'package:InPrep/auth/withdraw.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/order.dart';
import 'package:InPrep/models/user.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrders extends StatefulWidget {
  final user;

  const MyOrders({Key key, this.user}) : super(key: key);
  @override
  _MyOrdersState createState() => _MyOrdersState(user: user);
}

class _MyOrdersState extends State<MyOrders> {
  final MyUser user;
  final _databaseService = DatabaseService();
  _MyOrdersState({this.user});
  double grossIncome = 0.0;
  double netIncome = 0.0;
  double balance = 0.0;
  TextEditingController emailController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void showSnack(text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
  }

  Future<List<Order>> getOrders() async {
    List<Order> orders = [];
    // print(" UID ${user.uid}");
    orders = await _databaseService.getOrders(uid: user.uid);
    double gross = 0, net = 0, blnc = 0;
    for (var order in orders) {
      gross += double.parse(order.price);

      if (!order.withdraw && !order.pending) {
        // net += (80 * double.parse(order.price)) / 100;
        blnc += double.parse(order.price);
        // print("NET : $net");
        // print("BALANCE : $blnc");
      }
    }
    setState(() {
      // net = (80 * grossIncome) / 100;
      grossIncome = gross;
      netIncome = gross;
      balance = blnc;
    });
    // print(
    //     "grossIncome : $grossIncome netIncome : $netIncome balance : $balance");
    // print("USER ID ${user.uid}");
    // print("@ORDER ${orders.length}");
    return orders;
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
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('My Orders'),
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
              Container(
                height: 230,
                // width: MediaQuery.of(context).size.width - 20,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularPercentIndicator(
                              radius: 110.0,
                              lineWidth: 2.5,
                              animation: true,
                              percent: 1,
                              center: new Text(
                                "\$$balance ",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              footer: new Text(
                                "Balance",
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
                              percent: 1,
                              center: new Text(
                                "\$$netIncome ",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              footer: new Text(
                                "Total",
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: 50,
                          width: 200,
                          child: FlatButton(
                            onPressed: () {
                              if (balance >= 5) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: Text("Withdraw amount"),
                                          content: Container(
                                            height: 200,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      "Please enter your paypal email"),
                                                ),
                                                TextFormField(
                                                  controller: emailController,
                                                ),
                                                // Padding(
                                                //   padding: const EdgeInsets.only(
                                                //       top: 15.0),
                                                //   child: Text(
                                                //       "5 dollars will be deducted for transaction from your balance."),
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child: Text(
                                                      "Do you want to withdraw amount \$$balance ?"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('No'),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                bool done = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => Withdraw(
                                                            oid: user.uid,
                                                            email:
                                                                emailController
                                                                    .text
                                                                    .toString()
                                                                    .trim()
                                                                    .trimRight()
                                                                    .trimRight(),
                                                            amount: balance)));
                                                if (done) {
                                                  var orders =
                                                      await _databaseService
                                                          .getOrders(
                                                              uid: user.uid);
                                                  for (var order in orders) {
                                                    if (!order.pending) {
                                                      await _databaseService
                                                          .orderCollection
                                                          .doc(order.oid)
                                                          .update({
                                                        'withdraw': true
                                                      });
                                                    }
                                                  }
                                                  showSnack(
                                                      'Withdraw has been successful');
                                                } else
                                                  showSnack(
                                                      'Withdraw was cancelled');
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ));
                              } else
                                showSnack(
                                    'Cannot withdraw amount less then 5\$.');
                            },
                            child: Text(
                              'Withdraw Amount',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                height: MediaQuery.of(context).size.height - 330,
                child: FutureBuilder(
                  future: getOrders(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length != 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.length ?? 1,
                            itemBuilder: (BuildContext context, int index) {
                              var withdraw = snapshot.data[index].withdraw;
                              var pending = snapshot.data[index].pending;
                              var oid = snapshot.data[index].oid;
                              var price =
                                  double.parse(snapshot.data[index].price)
                                      .toString();
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 320,
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
                                                'Order ID: ',
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
                                                '$oid',
                                                style: TextStyle(
                                                    color: dark
                                                        ? Colors.white
                                                        : Colors.black,
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
                                                  Icons.monetization_on,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              Text(
                                                '$price',
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
                                                  Icons.call_missed_outgoing,
                                                  color: withdraw
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                '${withdraw ? 'Cash Withdrew' : "Not Withdrawn"}',
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
                                                  Icons.timer,
                                                  color: !pending
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                '${pending ? 'Need client authorization' : "Payment authorized"}',
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
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: Text('You have no Orders.'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('You have no Orders.'),
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
