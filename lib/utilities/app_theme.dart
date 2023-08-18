// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  //Default constructor syntax
  AppTheme._();

  static final ThemeData lightTheme = ThemeData();
}

Color _iconColor = Colors.blueAccent.shade200;

const Color _lightPrimaryColor = Colors.amber;
const Color _lightPrimaryVariantColor = Color.fromARGB(255, 96, 75, 75);
const Color _lightSecondaryColor = Colors.green;
const Color _lightOnPrimaryColor = Colors.black;
const TextTheme _lightTextTheme = TextTheme(
  headline1: _lightScreenHeadingTextStyle,
  bodyText1: _lightScreenTaskNameTextStyle,
  bodyText2: _lightScreenTaskDurationTextStyle,
);

const TextStyle _lightScreenHeadingTextStyle =
    TextStyle(fontSize: 48.0, color: _lightOnPrimaryColor);
const TextStyle _lightScreenTaskNameTextStyle =
    TextStyle(fontSize: 20.0, color: _lightOnPrimaryColor);
const TextStyle _lightScreenTaskDurationTextStyle =
    TextStyle(fontSize: 16.0, color: Colors.grey);

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: _lightPrimaryVariantColor,
  appBarTheme: const AppBarTheme(
    color: _lightPrimaryVariantColor,
    iconTheme: IconThemeData(color: _lightOnPrimaryColor),
  ),
  colorScheme: const ColorScheme.light(
    primary: _lightPrimaryColor,
    primaryVariant: _lightPrimaryVariantColor,
    secondary: _lightSecondaryColor,
    onPrimary: _lightOnPrimaryColor,
  ),
  iconTheme: IconThemeData(
    color: _iconColor,
  ),
  textTheme: _lightTextTheme,
);
