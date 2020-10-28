library auth_repository;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
//export "package:auth_repository/auth_repository.dart";

class AuthRepository {
  final String _loginUrl;
  final String _signUpUrl;

  AuthRepository(this._loginUrl, this._signUpUrl);

  Future<String> login(String email, String password) async {
    var res = await http.post(
      _loginUrl,
      headers: {
        'Content-type' : 'application/json',
        //'Accept': 'application/json',
      },
      body: jsonEncode({"Email": email, "Password": password}),
    );
    if (res.statusCode == 200) return res.body;
    return null;
  }

  Future<bool> signUp(String email, String password) async {
    var res = await http.post(_signUpUrl, body: {email, password});

    return res.statusCode == 200;
  }
}
