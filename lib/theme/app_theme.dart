import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData adminTheme = ThemeData(
    primarySwatch: MaterialColor(0xFF509A66, {
      50: Color(0xFFD7DBA9),
      100: Color(0xFFCCD3A0),
      200: Color(0xFFC1CB96),
      300: Color(0xFFB6C38D),
      400: Color(0xFFABBB83),
      500: Color(0xFFA0B37A),
      600: Color(0xFF95AB70),
      700: Color(0xFF8AA367),
      800: Color(0xFF7FAA5D),
      900: Color(0xFF74A254),
    }),
    scaffoldBackgroundColor: Color(0xFFFAF8E3),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF509A66),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: Color(0xFF509A66),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFFCD3324),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );

  final ThemeData defaultTheme = ThemeData(
    primarySwatch: MaterialColor(0xFF238CA9, {
      50: Color(0xFFDCE2C6),
      100: Color(0xFFD5DBC0),
      200: Color(0xFFCED4B9),
      300: Color(0xFFC7CEB2),
      400: Color(0xFFC0C7AB),
      500: Color(0xFFB9C0A4),
      600: Color(0xFFB2B99D),
      700: Color(0xFFABB296),
      800: Color(0xFFA4AB8F),
      900: Color(0xFF9D9E89),
    }),
    scaffoldBackgroundColor: Color(0xFF2F728E),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF146A99),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: Color(0xFF146A99),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF174956),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}
