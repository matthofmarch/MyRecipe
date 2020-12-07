import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/auth_guard/cubit/auth_guard_cubit.dart';
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
              appBar: AppBar(
                title: PlatformText("MyRecipes"),
                actions: [PlatformIconButton(
                  icon: Icon(Icons.logout),
                  onPressed: (){
                    RepositoryProvider.of<AuthRepository>(context).logout();
                  },
                )],
                toolbarHeight: 40,
              ),
                  body: Column(
                    children: [
                      MembershipsView(),
                      Flexible(child: Container())
                    ],
                  )
                )));
  }
}
