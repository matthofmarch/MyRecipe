import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/screens/home/cubit/home_cubit.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
        create: (context) =>
            HomeCubit(RepositoryProvider.of<AuthRepository>(context)),
        child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => Container(

                  child: Center(child: PlatformText("Home")),
                )));
  }
}
