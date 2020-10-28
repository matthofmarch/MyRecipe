import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/main.dart';
import 'package:myrecipes_flutter/screens/login/cubit/login_cubit.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({Key key}): super(key: key){
    _emailController.text = "test1@test.test";
    _passwordController.text = "Pass123\$";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=> LoginCubit(context.repository<AuthRepository>()),
      child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              print(state.jwt);
              storage.write(key: "jwt", value: state.jwt);
            } else if(state is LoginError)
              print("fail");

            if (true) {
              return Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password")),
                  FlatButton(onPressed: () => context.bloc<LoginCubit>().login(
                    _emailController.text,
                    _passwordController.text
                  ), child: Text("Login"))
                ],
              );
            }
          }),
    );
  }
}
