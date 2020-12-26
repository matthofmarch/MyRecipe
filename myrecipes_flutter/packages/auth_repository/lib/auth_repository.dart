library auth_repository;

import 'dart:async';
import 'dart:convert';
import 'package:auth_repository/jwt_util.dart';
import 'package:auth_repository/models/login_result.dart';
import 'package:auth_repository/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;


const kAccessTokenName="access_token";
const kRefreshTokenName="refresh_token";


class AuthRepository {
  final storage = FlutterSecureStorage();
  var _baseUrl;
  bool _currentlyRefreshing = false;


  final _authSubject = BehaviorSubject<User>();
  User get authState => _authSubject.value;
  Stream<User> get authStateStream => _authSubject.stream;

  AuthRepository(this._baseUrl);

  Future<void> login(String email, String password) async {
    var res = await http.post(
      "$_baseUrl/api/Auth/login",
      headers: {
        'Content-type' : 'application/json',
      },
      body: jsonEncode({"Email": email, "Password": password}),
    );
    if (res.statusCode != 200)
      throw Exception("Could not login");

    var loginResult = LoginResult.fromJson(jsonDecode(res.body));
    await storage.write(key: kAccessTokenName, value: loginResult.token);
    await storage.write(key: kRefreshTokenName, value: loginResult.refreshToken);

    checkAuthStateAsync();
  }

  Future<void> signup(String email, String password) async {
    var res = await http.post("$_baseUrl/api/Auth/register", body: {email, password});
    if(res.statusCode != 200)
      throw Exception("Could not sign up");
  }

  Future<void> logout() async{
    await storage.delete(key: kAccessTokenName);
    await storage.delete(key: kRefreshTokenName);
    _authSubject.add(null);
  }

  Future<void> checkAuthStateAsync() async {
    developer.log("Checking auth state");
    String accessToken = await storage.read(key: kAccessTokenName);
    if(accessToken == null){
      developer.log("No access token available");
      _authSubject.sink.add(null);
      return;
    }
    var claims = JwtUtil().parseJwt(accessToken);

    //Somehow the expiration gives seconds and not milliseconds since 1970
    var expiration = DateTime.fromMillisecondsSinceEpoch(claims["exp"]*1000, isUtc: true);
    if(DateTime.now().isAfter(expiration)){
      developer.log("Access token expired at $expiration, calling refresh");
      refreshAsync();
      return;
    }

    //Token validation (optional)

    developer.log("Token looks great, user authenticated");
    var user = getUserFromAccessToken(accessToken);
    _authSubject.add(user);
  }

  User getUserFromAccessToken(String accessToken){
    final jwtUtil = JwtUtil();
    var claims = jwtUtil.parseJwt(accessToken);
    var email = claims["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
    return User(email: email, accessToken: accessToken);
  }

  Future<void> refreshAsync() async {
    if(_currentlyRefreshing){
      developer.log("Refreshing already active, aborting");
      return;
    }

    //Replace with mutex later
    _currentlyRefreshing = true;
    developer.log("Refresh started");
    //Don't actually catch errors here, just ensure to remove the refreshing flag afterwards
    try{
      String accessToken = await storage.read(key: kAccessTokenName);
      String refreshToken = await storage.read(key: kRefreshTokenName);
      if(accessToken == null || refreshToken == null){
        developer.log("Not all tokens required for refresh available");
        return;
      }

      var res = await http.post(
        "$_baseUrl/api/Auth/refresh",
        headers: {
          'Content-type' : 'application/json',
        },
        body: jsonEncode({"token": accessToken, "refreshToken": refreshToken}),
      );
      if (res.statusCode != 200) {
        developer.log("When refreshing, Server returned ${res.statusCode}");
        _authSubject.value = null;
        return;
      }

      var loginResult = LoginResult.fromJson(jsonDecode(res.body));
      developer.log("New access token: ${loginResult.token}");
      await storage.write(key: kAccessTokenName, value: loginResult.token);
      developer.log("New refresh token: ${loginResult.refreshToken}");
      await storage.write(key: kRefreshTokenName, value: loginResult.refreshToken);

      checkAuthStateAsync();
    }catch(e){
      throw e;
    }
    finally{
      _currentlyRefreshing = false;
      developer.log("Refresh stopped");
    }
  }

  void dispose(){
    _authSubject.close();
  }


}
