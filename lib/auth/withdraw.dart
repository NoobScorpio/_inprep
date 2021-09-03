import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Withdraw extends StatefulWidget {
  final email, amount, oid;
  Withdraw({
    this.email,
    this.amount,
    this.oid,
  });
  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  Random r = Random();
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;
  final GlobalKey<ScaffoldState> globKeyPay = new GlobalKey<ScaffoldState>();
  void showSnack(text) {
    globKeyPay.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 5),
    ));
  }

  //${widget.amount}
  @override
  Widget build(BuildContext context) {
    String _loadHTML() {
      return '''
  <html>
  <body onload="document.f.submit();">
  <form id="f" name="f" method="get" action="https://payout-inprep.herokuapp.com/pay?price=${widget.amount}&email=${widget.email}&id=${widget.oid + r.nextDouble().toString()}">
  <input type="hidden" name="price" value="${widget.amount}"/>
  <input type="hidden" name="email" value="${widget.email}"/>
  <input type="hidden" name="id" value="${widget.oid + r.nextDouble().toString()}"/>

  </form>
  </body>
  </html>
  ''';
    }

    //https://paypal-testing-inprep.herokuapp.com/success?price=45&paymentId=PAYID-L7AARAY4WL67464YX728883H&token=EC-3DS88345PC817013J&PayerID=2SAVKT252CYY8
    return Scaffold(
      key: globKeyPay,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Withdraw'),
      ),
      body: WebView(
        onPageFinished: (page) async {
          print("THIS IS THE PAGE $page");
          if (page.contains('success')) {
            Navigator.pop(context, true);
          }
          if (page.contains('cancel')) {
            print('WITHDRAW WAS CANCELLED');
            Navigator.pop(context, false);
          }
          // if (page.contains('/success')) {
          //   print('SUCCSESS PAGE');
          //   // showSnack('You will be redirected to App shortly');
          //   var id = page.toString().substring(
          //       page.toString().indexOf('=P') + 1,
          //       page.toString().indexOf('&t'));
          //   print(id);
          //   showSnack('You will be redirected to App shortly');
          //   var boolTrue = false;
          //   await Future.delayed(Duration(seconds: 2)).then((value) {
          //     boolTrue = true;
          //     Navigator.pop(context, id);
          //   });
          //   showDialog(
          //       context: context,
          //       builder: (BuildContext context) => AlertDialog(
          //             title: Text("Payment"),
          //             content: Text(boolTrue
          //                 ? "Payment was successsfull"
          //                 : "Payment was not successsfull"),
          //             actions: <Widget>[
          //               FlatButton(
          //                 child: Text('ok'),
          //                 onPressed: () async {
          //                   Navigator.pop(context, id);
          //                 },
          //               ),
          //             ],
          //           ));
          //   Navigator.pop(context, id);
          // }
          // // }
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            // '',
            // 'https://google.com.pk'
            Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
      ),
    );
  }
}
