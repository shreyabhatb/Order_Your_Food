import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6C3483); // Example: purple
  static const Color accentColor = Color(0xFFF7CA18); // Example: yellow
  static const Color backgroundColor = Color(0xFFF5EEF8);

  static ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: accentColor,
      primary: primaryColor,
      background: backgroundColor,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: primaryColor,
    ),
  );
}
