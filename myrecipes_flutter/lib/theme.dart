import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(), //openSansTextTheme(),
  //primaryColorDark: const Color(0xFF0097A7),
  //primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFF38A169),
  accentColor: const Color(0xFF5A67D8),
  scaffoldBackgroundColor: Colors.brown[50],
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  platform: TargetPlatform.android

);
