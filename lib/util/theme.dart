import 'package:flutter/material.dart';

final darkTheme = baseTheme(ThemeData.dark());
final lightTheme = baseTheme(ThemeData.light());

ThemeData baseTheme(ThemeData themeData) {
  return themeData.copyWith(
    primaryColor: Colors.orange,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: themeData.brightness,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.orange,
      labelPadding: const EdgeInsets.only(
        left: 8,
        right: 16,
      ),
      padding: const EdgeInsets.all(0),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80),
      ),
    ),
  );
}
