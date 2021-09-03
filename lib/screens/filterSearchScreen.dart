import 'package:flutter/material.dart';

class FilterSearchScreen extends StatefulWidget {
  final List<Widget> widgets;

  const FilterSearchScreen({
    this.widgets,
  }) : super();

  @override
  _FilterSearchScreenState createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
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
            children: widget.widgets,
          ),
        ],
      ),
    );
  }
}
