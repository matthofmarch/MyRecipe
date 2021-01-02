import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(), //openSansTextTheme(),
  //primaryColorDark: const Color(0xFF0097A7),
  //primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFF247249),
  primaryColorLight: const Color(0xFF55a175),
  primaryColorDark: const Color(0xFF004621),
  accentColor: const Color(0xFF544a31),


  scaffoldBackgroundColor: Colors.grey[100],
  dividerColor: Colors.grey,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
  ),
  //cardColor: Colors.brown.shade50,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  platform: TargetPlatform.android
);

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0,30))
];
