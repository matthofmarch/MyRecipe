import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:group_repository/group_repository.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/env_config.dart';
import 'package:myrecipes_flutter/interceptors/jsoncontent_interceptor.dart';
import 'package:myrecipes_flutter/retry_policy/expired_token_retry_policy.dart';
import 'package:myrecipes_flutter/splash/splash.dart';
import 'package:myrecipes_flutter/theme.dart';

import 'package:recipe_repository/recipe_repository.dart';
import 'auth_guard/auth_guard.dart';
import 'interceptors/bearer_interceptor.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseUrl = EnvConfig.API_URL;
    final authRepository = AuthRepository(baseUrl);

    return RepositoryProvider<AuthRepository>(
        create: (context) => authRepository,
        child: Builder(builder: (context) {
          final httpClient = HttpClientWithInterceptor.build(interceptors: [
            BearerInterceptor(RepositoryProvider.of<AuthRepository>(context)),
            JsonContentInterceptor()
          ], retryPolicy: ExpiredTokenRetryPolicy(RepositoryProvider.of<AuthRepository>(context)));
          return MultiRepositoryProvider(
              providers: [
                RepositoryProvider<MealRepository>(
                    create: (context) => MealRepository(httpClient,baseUrl)),
                RepositoryProvider(
                    create: (context) => RecipeRepository(httpClient, baseUrl, RepositoryProvider.of<AuthRepository>(context))),
                RepositoryProvider(
                    create: (context) => GroupRepository(httpClient,baseUrl)),
                RepositoryProvider(
                    create: (context) => IngredientRepository(httpClient,baseUrl))
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                navigatorKey: key,
                home: AuthGuard(),
                onGenerateRoute: (_) => SplashPage.route(),
              ));
        }));
  }
}
