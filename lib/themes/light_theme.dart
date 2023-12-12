import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    primary: Colors.pink,
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ),
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
);
