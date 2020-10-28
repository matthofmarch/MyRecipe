import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/screens/login/login.dart';
import 'package:myrecipes_flutter/splash/splash.dart';
import 'package:myrecipes_flutter/theme.dart';

class Entry extends StatelessWidget {
  const Entry({
    Key key,
    @required this.authRepository,
  }) :  assert(authRepository != null),
        super(key: key);

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(value: authRepository,
      child: AuthGuard(),
    );
  }
}

class AuthGuard extends StatefulWidget {
  @override
  _AuthGuardState createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return Scaffold(body: Login());
      },
      onGenerateRoute: (_) => SplashPage.route(),

    );
  }
}

