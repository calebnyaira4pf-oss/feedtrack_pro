import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.grey.shade100,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
  );
}