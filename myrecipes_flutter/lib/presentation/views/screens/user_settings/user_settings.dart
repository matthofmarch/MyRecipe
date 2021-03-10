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
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
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
                SizedBox(height: 15,),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Account Settings",style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 30),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                child: Row(
                                  children: [
                                    Icon(Icons.vpn_key_outlined),
                                    SizedBox(width: 12,),
                                    Expanded(child: Text("Change Password",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.headline4.color))),
                                    Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ),
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.email_outlined),
                                    SizedBox(width: 12,),
                                    Expanded(child: Text("Change email",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.headline4.color, fontSize: 20))),
                                    Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Application Settings", style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 30),),
                        SizedBox(height: 12,),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.nights_stay_outlined),
                                  SizedBox(width: 8,),
                                  Expanded(child: Text("Dark Mode",style: Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.headline4.color))),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ],
    );
  }
}
