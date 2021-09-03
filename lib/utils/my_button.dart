import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final child;
  final onPressed;
  final color;
  final textColor;
  final height;
  final minWidth;
  final padding;
  MyButton(
      {this.padding,
      this.height,
      @required this.color,
      @required this.child,
      @required this.onPressed,
      this.minWidth,
      @required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding != null
          ? padding
          : const EdgeInsets.only(right: 80.0, left: 80),
      child: SizedBox(
        height: height != null ? height : 50.0,
        width: minWidth != null ? minWidth : 250.0,
        child: RaisedButton(
          
          textColor: textColor,
          color: color,
          onPressed: onPressed,
          child: child,
           shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                // side: BorderSide(color: Colors.red)
                              ),
        ),
      ),
    );
  }
}
