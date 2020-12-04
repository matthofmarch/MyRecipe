library auth_repository;

import 'dart:async';
import 'dart:convert';
import 'package:auth_repository/jwt_util.dart';
import 'package:auth_repository/models/login_result.dart';
import 'package:auth_repository/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _loginUrl;
  final String _signUpUrl;
  final storage = FlutterSecureStorage();

  final _userController = StreamController<User>();
  Stream<User> get userStream async*{
    yield* _userController.stream;
  }

  AuthRepository(this._loginUrl, this._signUpUrl){
    print("New repo was created\n\n");
  }

  Future<void> login(String email, String password) async {
    var res = await http.post(
      _loginUrl,
      headers: {
        'Content-type' : 'application/json',
        //'Accept': 'application/json',
      },
      body: jsonEncode({"Email": email, "Password": password}),
    );
    if (res.statusCode != 200) throw Exception("Could not login");

    var loginResult = LoginResult.fromJson(jsonDecode(res.body));
    await storage.write(key: "access_token", value: loginResult.token);
    await storage.write(key: "refresh_token", value: loginResult.refreshToken);

    updateUserWithAccessToken(loginResult.token);
  }


  updateUserWithAccessToken(String accessToken){
    try{
      final jwtUtil = JwtUtil();
      var claims = jwtUtil.parseJwt(accessToken);
      var email = claims["sub"];
      var user = User(email: email, accessToken: accessToken);
      print(email);
      _userController.add(user);
    } catch(e){
      print(e);
      _userController.add(null);
    }
  }

  Future<void> signup(String email, String password) async {
    var res = await http.post(_signUpUrl, body: {email, password});
    if(res.statusCode != 200)
      throw Exception("Could not sign up");
  }

  void logout() async{
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    _userController.add(null);
  }

  Future<void> tryOpenSession() async {
    var accessToken = await storage.read(key: "access_token");
    updateUserWithAccessToken(accessToken);
  }


}
