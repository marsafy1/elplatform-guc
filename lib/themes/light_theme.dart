import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  secondaryHeaderColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
      primary: Colors.blue,
      secondary: Colors.indigo,
      seedColor: Colors.indigo,
      brightness: Brightness.light,
      background: Colors.white),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 60,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.notoSans(
      fontSize: 30,
      fontStyle: FontStyle.italic,
    ),
    bodyMedium: GoogleFonts.notoSans(),
    displaySmall: GoogleFonts.notoSans(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
    ),
  ),
);
