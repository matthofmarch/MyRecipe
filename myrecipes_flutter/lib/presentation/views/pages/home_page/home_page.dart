import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/presentation/views/screens/user_settings/user_settings.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/memberships_card/memberships_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Household"),
            actions: [
              IconButton(icon: Icon(Icons.settings_outlined), onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserSettings(),
                  ),
                );
              },)
            ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            MembershipsCard(),
          ],
        ));
  }
}
