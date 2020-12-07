import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/views/members/memberships.dart';

import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePageCubit>(
        create: (context) =>
            HomePageCubit(RepositoryProvider.of<AuthRepository>(context)),
        child: BlocBuilder<HomePageCubit, HomeState>(
            builder: (context, state) => Scaffold(

                  body: Column(
                    children: [
                      MembershipsView(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Logout ", textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.red),),
                                Icon(Icons.logout, color: Colors.red,)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                )));
  }
}
