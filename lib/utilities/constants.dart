import 'package:flutter/material.dart';

Color kTrueWhite = const Color(0xfffafafa);

TextStyle kActiveTextStyle = const TextStyle(
  fontSize: 22.0,
  fontFamily: 'WorkSans',
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

TextStyle kInactiveTextStyle = TextStyle(
  fontSize: 22.0,
  fontFamily: 'WorkSans',
  fontWeight: FontWeight.w600,
  color: Colors.grey[350],
);

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
);
const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 40.0,
);
const kButtonTextStyle = TextStyle(
    fontSize: 30.0, fontFamily: 'Spartan MB', color: Color(0xfffafafa));
const kConditionTextStyle = TextStyle(
  fontSize: 80.0,
);
const textFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xfffafafa),
  icon: Icon(
    Icons.local_activity,
    color: Color(0xfffafafa),
  ),
  hintText: 'Enter City name',
  hintStyle: TextStyle(color: Colors.black),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide.none,
  ),
);

Color textColor = const Color(0xFF222939);

const height25 = SizedBox(
  height: 25,
);

TextStyle f14RblackLetterSpacing2 = TextStyle(
    fontSize: 14, fontFamily: 'Poppins', color: textColor, letterSpacing: 2);

TextStyle f16PW =
    const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16);

TextStyle f24Rwhitebold = const TextStyle(
    fontSize: 24,
    fontFamily: 'Poppins',
    color: Colors.white,
    fontWeight: FontWeight.bold);

TextStyle f42Rwhitebold = const TextStyle(
    fontSize: 42,
    fontFamily: 'Poppins',
    color: Colors.white,
    fontWeight: FontWeight.bold);
