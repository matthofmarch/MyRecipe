import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme(
  onPrimary: const Color(0xFFffffff),
  primary: const Color(0xFF247249),
  primaryVariant: const Color(0xFF004621),
  secondary: const Color(0xFF798c1f),
  secondaryVariant: const Color(0xFF4a5f00),
  onSecondary: const Color(0xFF000000),
  background: Colors.grey[300],

  surface: Color(0xFF808080),
  onBackground: Colors.white,
  error: Colors.redAccent,
  onError: Colors.redAccent,
  onSurface: Color(0xFF241E30),
  brightness: Brightness.light,
);

final theme = ThemeData(
  textTheme: GoogleFonts.robotoTextTheme(), //openSansTextTheme(),
  colorScheme: colorScheme,

  appBarTheme: AppBarTheme(
    color: colorScheme.primary
  ),
  dividerColor: Colors.grey,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))
    ),
  ),  //cardColor: Colors.brown.shade50,
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
