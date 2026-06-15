import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(

    primarySwatch: Colors.green,

    scaffoldBackgroundColor:
        Colors.grey.shade100,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 2,
      backgroundColor: Colors.green,
    ),

    // cardTheme removed due to SDK type differences; keep default card styling
  );
}