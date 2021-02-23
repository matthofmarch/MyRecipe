import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/screens/signup/cubit/signup_cubit.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
        create: (context) => SignupCubit(RepositoryProvider.of(context)),
        child: BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
          if (state is SignupInitial) {
            Future.delayed(Duration(milliseconds: 0),
                () => BlocProvider.of<SignupCubit>(context).load());
            return Container();
          }
          if (state is SignupInteraction) {
            return _makeInteraction(context, state);
          }
          if (state is SignupProgress)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (state is SignUpSuccess) {
            Future.delayed(
                Duration(milliseconds: 500), () => Navigator.of(context).pop());
            return Center(child: Icon(Icons.check));
          }
          if (state is SignUpFailure) {
            Future.delayed(
                Duration(milliseconds: 500),
                () => BlocProvider.of<SignupCubit>(context)
                    .load(previousEmail: state.previousEmail));
            return Center(
                child: Icon(
              Icons.error,
              color: Theme.of(context).errorColor,
            ));
          }
          return null;
        }));
  }

  _makeInteraction(BuildContext context, SignupInteraction state) {
    final _emailController = TextEditingController(text: state.previousEmail);
    final _passwordController = TextEditingController();
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
              ]),
            ),
            FlatButton(
                onPressed: () => BlocProvider.of<SignupCubit>(context)
                    .signup(_emailController.text, _passwordController.text),
                child: Text("Sign Up")),
          ],
        ));
  }
}
