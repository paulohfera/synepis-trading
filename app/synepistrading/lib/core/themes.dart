import 'package:flutter/material.dart';

abstract class BaseTheme {
  String logo;
  Color accentColor;
  Color background;
  Color buttonColor;
  Color handleColor;

  ThemeData get themeData;
}

class DarkTheme implements BaseTheme {
  String logo = "logo.png";
  Color accentColor = Colors.blueAccent;
  Color background = Color(0xFF3d4042);
  Color buttonColor = Color(0xff8ab4f8);
  Color buttonTextColor = Colors.black;
  Color handleColor = Colors.blueAccent;

  ThemeData get themeData {
    return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: background,
        accentColor: accentColor,
        textSelectionHandleColor: handleColor);
  }
}

class LighTheme implements BaseTheme {
  String logo = "logo_preto.png";
  Color accentColor = Colors.blueAccent;
  Color background = Colors.white;
  Color buttonColor = Color(0xff8ab4f8);
  Color buttonTextColor = Colors.white;
  Color handleColor = Colors.blueAccent;

  ThemeData get themeData {
    return ThemeData.light().copyWith(
        scaffoldBackgroundColor: background,
        accentColor: accentColor,
        textSelectionHandleColor: handleColor);
  }
}
