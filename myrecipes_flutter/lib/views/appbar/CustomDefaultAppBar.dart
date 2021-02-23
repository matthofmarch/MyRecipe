import 'package:flutter/material.dart';

class CustomDefaultAppBar extends AppBar {
  CustomDefaultAppBar({actions, title, leading, elevation = 0.0}):super(title: title, actions: actions, leading: leading, elevation: elevation, backgroundColor: Colors.transparent);
}
