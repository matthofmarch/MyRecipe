import 'package:flutter/material.dart';

class CustomDefaultAppBar extends AppBar {
  CustomDefaultAppBar({actions, title, leading}):super(toolbarHeight: 40, title: title, actions: actions, leading: leading,);
}
