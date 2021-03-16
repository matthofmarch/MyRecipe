import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final colorScheme = ColorScheme(
  onPrimary: const Color(0xFFffffff),
  primary: const Color(0xFF247249),
  primaryVariant: const Color(0xFF004621),
  secondary: const Color(0xFF247249),
  secondaryVariant: const Color(0xFF004621),
  onSecondary: const Color(0xFF000000),
  background: Colors.grey[300],
  surface: Color(0xFF808080),
  onBackground: Colors.white,
  error: Colors.redAccent,
  onError: Colors.redAccent,
  onSurface: Color(0xFF241E30),
  brightness: Brightness.light,
);

get lightTheme => themes[0].copyWith(
      primaryIconTheme: IconThemeData(color: Colors.black),
      primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
    );

get darkTheme => themes[1];

final themes = [ThemeData.light(), ThemeData.dark()]
    .map((t) => t.copyWith(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(color: t.canvasColor),
        primaryColor: colorScheme.primary,
        accentColor: colorScheme.secondary,
        cardTheme: t.cardTheme.copyWith(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)))),
        inputDecorationTheme: t.inputDecorationTheme.copyWith(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          side: BorderSide(color: colorScheme.primary),
        ))))
    .toList();

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 30))
];
List<BoxShadow> shadowListDark = [
  BoxShadow(color: Colors.grey[850], blurRadius: 30, offset: Offset(0, 30))
];
List<BoxShadow> shadowGrid = [
  BoxShadow(color: Colors.grey[300], blurRadius: 5, offset: Offset(0, 10))
];
List<BoxShadow> shadowCards = [
  BoxShadow(
    color: Colors.grey[300],
    spreadRadius: 1,
    blurRadius: 4,
    offset: Offset(3, 8),
  )
];
List<BoxShadow> noShadow = [];
