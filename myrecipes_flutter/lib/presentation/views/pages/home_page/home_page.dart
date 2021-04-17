import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/user_repository/user_repository.dart';
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
            IconButton(
              icon: Icon(Icons.settings_outlined),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserSettings(),
                  ),
                );
              },
            )
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            MembershipsCard(),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        await RepositoryProvider.of<UserRepository>(context)
                            .leaveGroup();
                        await RepositoryProvider.of<AuthRepository>(context)
                            .refreshAsync();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Didn't work")));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Leave Group ",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.error,
                        )
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                )),
          ],
        ));
  }
}
