import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/screens/auth_guard/cubit/auth_guard_cubit.dart';
import 'package:myrecipes_flutter/screens/content_root/content_root.dart';
import 'package:myrecipes_flutter/screens/login/login.dart';

class AuthGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthGuardCubit>(
      create: (context) =>
          AuthGuardCubit(RepositoryProvider.of<AuthRepository>(context)),
      child: BlocBuilder<AuthGuardCubit, AuthGuardState>(
        builder: (context, state) {
          if(state is AuthGuardAuthenticated){
            return ContentRoot();
          }
          if(state is AuthGuardUnauthenticated){
            return Login();
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
