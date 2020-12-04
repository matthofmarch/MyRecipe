import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/screens/login/cubit/login_cubit.dart';
import 'package:myrecipes_flutter/screens/signup/cubit/signup_cubit.dart';
import 'package:myrecipes_flutter/screens/signup/signup.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login() {
    _emailController.text = "test1@test.test";
    _passwordController.text = "Pass123\$";
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocProvider(
        create: (context) =>
            LoginCubit(RepositoryProvider.of<AuthRepository>(context)),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          return PlatformScaffold(
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Image.asset("assets/undraw_eating_together.svg")),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [
                      PlatformTextField(
                        controller: _emailController,
                        material: (context, platform) => MaterialTextFieldData(
                            decoration: InputDecoration(labelText: "Email")),
                        cupertino: (context, platform) =>
                            CupertinoTextFieldData(placeholder: "Email"),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      PlatformTextField(
                        obscureText: true,
                        controller: _passwordController,
                        material: (context, platform) => MaterialTextFieldData(
                            decoration: InputDecoration(labelText: "Password")),
                        cupertino: (context, platform) =>
                            CupertinoTextFieldData(placeholder: "Password"),
                      ),
                    ]),
                  ),
                  FlatButton(
                      onPressed: () => BlocProvider.of<LoginCubit>(context)
                          .login(
                              _emailController.text, _passwordController.text),
                      child: Text("Login")),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("You don't have an account? "),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider<SignupCubit>(
                                      create: (_) => SignupCubit(
                                          RepositoryProvider.of(context)),
                                      child: Signup())));
                        },
                        child: Text("Sign Up"))
                  ])
                ]),
          );
        }));
  }
}
