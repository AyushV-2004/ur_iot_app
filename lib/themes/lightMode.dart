import 'package:flutter/material.dart';

ThemeData lightMode=ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.black87,
    secondary: Colors.black87,
    inversePrimary: Colors.black,
  ),
      textTheme: ThemeData.light().textTheme.apply(
  bodyColor: Colors.grey[800],
  displayColor: Colors.black,
),
);