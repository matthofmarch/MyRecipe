import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary = const Color(0xFF2B5A4D);
const secondary = const Color(0xFF38A19D);

final theme = ThemeData(
  textTheme: GoogleFonts.latoTextTheme(), //openSansTextTheme(),
  //primaryColorDark: const Color(0xFF0097A7),
  //primaryColorLight: const Color(0xFFB2EBF2),
  appBarTheme: AppBarTheme(
    
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primary,
  ),
  primaryColor: primary,
  accentColor: secondary,
  scaffoldBackgroundColor: Colors.grey[50],
  dividerColor: Colors.grey,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
  ),
  //cardColor: Colors.brown.shade50,
  iconTheme: IconThemeData(color: primary),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0,30))
];
