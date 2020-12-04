import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/screens/signup/cubit/signup_cubit.dart';

class Signup extends StatelessWidget {
  final _emailController = TextEditingController()..text = "";
  final _passwordController = TextEditingController()..text = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) => Scaffold(
            appBar: AppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      controller: _passwordController,
                      obscureText: true,
                      material: (context, platform) => MaterialTextFieldData(
                          decoration: InputDecoration(labelText: "Password")),
                      cupertino: (context, platform) =>
                          CupertinoTextFieldData(placeholder: "Password"),
                    ),
                  ]),
                ),
                FlatButton(
                    onPressed: () => BlocProvider.of<SignupCubit>(context)
                        .signup(
                            _emailController.text, _passwordController.text),
                    child: Text("Sign Up")),
              ],
            )));
  }
}
