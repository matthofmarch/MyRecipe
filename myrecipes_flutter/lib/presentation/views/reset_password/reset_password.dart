import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/user_repository/user_repository.dart';
import 'package:validators/validators.dart';

class ResetPasswordScreen extends StatelessWidget {
  var _emailController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => !isEmail(val) ? "Invalid Email" : null,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Invalid')));
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Submitting...')));
                        try {
                          await RepositoryProvider.of<UserRepository>(context)
                              .resetPassword(_emailController.text);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('OK')));
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Ain\'t work\n' + e.toString())));
                        }
                      },
                      child: Text("Submit")),
                ],
              ),
            ),
          ),
        ));
  }
}
