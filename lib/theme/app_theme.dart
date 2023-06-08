import 'package:flutter/material.dart';

class AppTheme {
  static const Color brightness = Colors.grey;
  static const Color primary = Colors.grey;
  static const Color onPrimary = Colors.grey;
  static const Color secondary = Colors.green;
  static const Color onSecondary = Colors.grey;
  static const Color error = Colors.red;
  static const Color onError = Colors.red;
  static const Color background = Colors.blue;
  static const Color onBackground = Colors.blue;
  static const Color surface = Colors.indigo;
  static const Color onSurface = Colors.indigo;

  static final ThemeData defaultTheme = ThemeData.light().copyWith(
      // Estilo de la AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.lightBlue,
        elevation: 1,
      ),
      cardColor: Colors.amber.shade200);

  static final ThemeData adminTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      elevation: 1,
    ),
    cardColor: Colors.amber.shade200,
  );
}
