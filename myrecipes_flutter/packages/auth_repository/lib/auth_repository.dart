library auth_repository;

import 'dart:async';
import 'dart:convert';
import 'package:auth_repository/jwt_util.dart';
import 'package:auth_repository/models/login_result.dart';
import 'package:auth_repository/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class AuthRepository{

  final storage = FlutterSecureStorage();

  final _userController = StreamController<User>.broadcast();

  var _baseUrl;
  Stream<User> get userStream async*{
    yield* _userController.stream;
  }

  //TODO dispose stream
  final authSubject = BehaviorSubject<User>();
  User get authState => authSubject.stream.value;


  AuthRepository(this._baseUrl);

  Future<void> login(String email, String password) async {
    var res = await http.post(
      "$_baseUrl/api/Auth/login",
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
      _userController.add(user);
      authSubject.value = user;
    } catch(e){
      print(e);
      _userController.add(null);
    }
  }

  Future<void> signup(String email, String password) async {
    var res = await http.post("$_baseUrl/api/Auth/register", body: {email, password});
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
