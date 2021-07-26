import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/material.dart';

//Widget Function to return appbar

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      "Lets Chat",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontStyle: FontStyle.italic),
      //Image.asset("assets\images\logo.jpg"),
      // elevation: 0.0,
    ),
    //will shift the logo to the left-most side
    centerTitle: false,
  );
}

TextFormField textFormFieldKeyBoardTypedecoration() {
  return TextFormField(
    keyboardType: TextInputType.text,
    style: TextStyle(
      color: Colors.white,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.white,
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle mediumTextFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 18,
  );
}
