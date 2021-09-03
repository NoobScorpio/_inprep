import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'constants.dart';

class HtmlView extends StatefulWidget {
  @override
  _HtmlViewState createState() => _HtmlViewState();
}

class _HtmlViewState extends State<HtmlView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('Terms and Conditions'),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            HtmlWidget(khtml),
          ],
        ),
      ),
    );
  }
}
