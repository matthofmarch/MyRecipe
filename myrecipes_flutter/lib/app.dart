import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/splash/splash.dart';
import 'package:myrecipes_flutter/theme.dart';

import 'auth_guard/auth_guard.dart';

const HOSTNAME = "vm133.htl-leonding.ac.at:5000";
const PROTOCOL = "https";
class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: key,
      home: RepositoryProvider<AuthRepository>(
        create: (context) =>  AuthRepository("$PROTOCOL://$HOSTNAME/api/auth/login",
            "$PROTOCOL://$HOSTNAME/api/auth/register"),
        child: AuthGuard(),
      ),

      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
