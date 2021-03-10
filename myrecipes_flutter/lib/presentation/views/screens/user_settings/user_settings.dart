import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';

class UserSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var auth_repo = RepositoryProvider.of<AuthRepository>(context);
    var email = auth_repo.authState.email;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle,size: 50,color: Theme.of(context).primaryColorDark,),
                  SizedBox(width: 5,),
                  Text(email,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ]
              ),
            ],
          )
        ),
      ],
    );
  }
}
