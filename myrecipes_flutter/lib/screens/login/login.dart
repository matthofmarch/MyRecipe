import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrecipes_flutter/screens/login/cubit/login_cubit.dart';
import 'package:myrecipes_flutter/screens/signup/signup.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController()..text = "test1@test.test";
  final TextEditingController _passwordController = TextEditingController()..text = "Pass123\$";

  Login();

  @override
  Widget build(BuildContext buildContext) {
    return BlocProvider(
        create: (context) => LoginCubit(RepositoryProvider.of<AuthRepository>(context)),
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          return PlatformScaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        child: SvgPicture.asset("assets/undraw_eating_together.svg")),
                    PlatformText("MyRecipes", style: Theme.of(context).textTheme.headline4,),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(children: [
                          PlatformTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
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
                    ),
                    PlatformButton(

                        onPressed: () => BlocProvider.of<LoginCubit>(context)
                            .login(
                                _emailController.text, _passwordController.text),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Login"),
                            Icon(PlatformIcons(context).forward)
                          ],
                        ),
                      color: Theme.of(context).primaryColor,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("You don't have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => Signup()));
                          },
                          child: Text("Sign Up"))
                    ])
                  ]),
            ),
          );
        }));
  }
}
