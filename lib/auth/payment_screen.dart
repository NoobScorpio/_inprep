import 'package:InPrep/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class PaymentScreen extends StatefulWidget {
  final cost;
  final name;
  final date;
  final time;
  PaymentScreen({this.cost, this.name, this.date, this.time});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // InAppWebViewController webView;
  String url = "";
  double progress = 0;
  final GlobalKey<ScaffoldState> globKeyPay = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String _loadHTML() {
      return '''
  <html>
  <body onload="document.f.submit();">
  <form id="f" name="f" method="get" action="https://paypal-testing-inprep.herokuapp.com/?price=${widget.cost}&date=${widget.date ?? ""}&name=${widget.name}&time=${widget.time ?? ""}">
  <input type="hidden" name="price" value="${widget.cost}"/>
  <input type="hidden" name="date" value="${widget.date ?? ""}"/>
  <input type="hidden" name="name" value="${widget.name ?? ""}"/>
  <input type="hidden" name="time" value="${widget.time}"/>
  </form>
  </body>
  </html>
  ''';
    }

    //https://paypal-testing-inprep.herokuapp.com/success?price=45&paymentId=PAYID-L7AARAY4WL67464YX728883H&token=EC-3DS88345PC817013J&PayerID=2SAVKT252CYY8
    return Scaffold(
      key: globKeyPay,
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: WebView(
        onPageFinished: (page) async {
          if (page.contains('/success')) {
            print('SUCCSESS PAGE');
            // showSnack('You will be redirected to App shortly');
            var id = page.toString().substring(
                page.toString().indexOf('=P') + 1,
                page.toString().indexOf('&t'));
            print(id);
            showToast(context, "You will be redirected to App shortly");
            var boolTrue = false;
            await Future.delayed(Duration(seconds: 2)).then((value) {
              boolTrue = true;
              Navigator.pop(context, id);
            });
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text("Payment"),
                      content: Text(boolTrue
                          ? "Payment was successsfull"
                          : "Payment was not successsfull"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('ok'),
                          onPressed: () async {
                            Navigator.pop(context, id);
                          },
                        ),
                      ],
                    ));
            Navigator.pop(context, id);
          }
          // }
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
