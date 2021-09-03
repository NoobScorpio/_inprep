import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  final height;
  MyDivider({this.height});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0,
      child: Divider(
        height: height != null ? height : 20.0,
      ),
    );
  }
}
