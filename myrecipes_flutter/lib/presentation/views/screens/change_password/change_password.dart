import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/user_repository/user_repository.dart';

class ChangePasswordScreen extends StatelessWidget {
  var _confirmNewPasswordController = TextEditingController();
  var _oldPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();

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
                    controller: _oldPasswordController,
                    decoration: InputDecoration(labelText: "Old password"),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(labelText: "New password"),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    decoration:
                        InputDecoration(labelText: "Confirm new password"),
                    obscureText: true,
                    validator: (value) {
                      if (_confirmNewPasswordController.text !=
                          _newPasswordController.text) {
                        return 'Passwords must match';
                      }
                      return null;
                    },
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
                              .changePassword(_newPasswordController.text,
                                  _oldPasswordController.text);
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
