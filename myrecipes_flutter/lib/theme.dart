import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary = const Color(0xFF38A169);
const secondary = const Color(0xFF5A67D8);
const success = const Color(0xFF34D399);

final theme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(), //openSansTextTheme(),
  //primaryColorDark: const Color(0xFF0097A7),
  //primaryColorLight: const Color(0xFFB2EBF2),
  appBarTheme: AppBarTheme(
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primary,
  ),
  primaryColor: primary,
  accentColor: secondary,
  scaffoldBackgroundColor: Colors.brown[50],
  dividerColor: Colors.grey,
  // Success color
  primaryColorLight: success,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
    )
  ),
  //cardColor: Colors.brown.shade50,
  iconTheme: IconThemeData(color: primary),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  platform: TargetPlatform.android,
);
