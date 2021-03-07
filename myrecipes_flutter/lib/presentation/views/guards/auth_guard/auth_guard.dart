import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/guards/auth_guard/auth_guard_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/guards/household_guard/household_guard.dart';
import 'package:myrecipes_flutter/presentation/views/screens/login/login.dart';

class AuthGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthGuardCubit>(
      create: (context) =>
          AuthGuardCubit(RepositoryProvider.of<AuthRepository>(context)),
      child: BlocBuilder<AuthGuardCubit, AuthGuardState>(
          builder: (context, state) {
        if (state is AuthGuardAuthenticated) {
          return HouseholdGuard();
        }
        if (state is AuthGuardUnauthenticated) {
          return Login();
        }
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
