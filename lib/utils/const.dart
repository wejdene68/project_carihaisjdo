import 'package:flutter/material.dart';

class Constants {
  // App Name
  static String appName = "Rhinestone";

  // Material Design Colors
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color lightAccent = const Color(0xFF3B72FF);
  static Color lightBackground = const Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = const Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = const Color(0xff707070);
  static Color textPrimary = const Color(0xFF486581);
  static Color textDark = const Color(0xFF102A43);

  static Color backgroundColor = const Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = const Color(0xFF3ABD6F);
  static Color lightGreen = const Color(0xFFA1ECBF);

  // Yellow
  static Color darkYellow = const Color(0xFF3ABD6F);
  static Color lightYellow = const Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = const Color(0xFF3B72FF);
  static Color lightBlue = const Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = const Color(0xFFFFB74D);

  // Light Theme
  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF3B72FF)),
        backgroundColor: Colors.transparent,
      ),
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        secondary: lightAccent,
        surface: lightBackground,
      ).copyWith(surface: lightBackground),
    );
  }

  // Layout Settings
  static double headerHeight = 228.5;
  static double paddingSide = 30.0;
}
