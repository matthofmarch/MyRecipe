import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Container()
        ),
      ],
    );
  }
}
