import 'package:flutter/material.dart';

//TEXT FORM FIELD

class MyTextFormField extends StatelessWidget {
  final validator;
  final padding;
  final maxline;
  final controller;
  final labelText;
  final prefixIcon;
  final onChanged;
  final obscureText;
  final icon;
  final hint;
  final maxLength;
  final keyboardType;
  final readOnly;
  MyTextFormField(
      {this.hint,
      this.readOnly,
      this.padding,
      this.controller,
      this.maxline,
      this.keyboardType,
      this.icon,
      this.obscureText,
      this.onChanged,
      this.labelText,
      this.validator,
      this.prefixIcon,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding != null ? padding : EdgeInsets.only(left: 15.0, right: 15.0),
      child: TextFormField(
        readOnly: readOnly == null ? false : readOnly,
        maxLength: maxLength,
        onChanged: onChanged,
        obscureText: obscureText == true ? obscureText : false,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: icon,
          hoverColor: Colors.red,
          prefixIcon: prefixIcon,
          labelText: labelText,
          // icon: Icon(Icons.search),
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(),
          ),
          //fillColor: Colors.green
        ),
        validator: validator,
        maxLines: maxline != null ? maxline : 1,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
