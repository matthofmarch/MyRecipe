library auth_repository;

import 'dart:async';
import 'dart:convert';
import 'package:auth_repository/jwt_util.dart';
import 'package:auth_repository/models/login_result.dart';
import 'package:auth_repository/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

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

    checkAuthState();
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

  Future<void> checkAuthState() async {
    try{
      String accessToken = await storage.read(key: kAccessTokenName);
      if(accessToken == null){
        _authSubject.sink.add(null);
        return;
      }
      final jwtUtil = JwtUtil();
      var claims = jwtUtil.parseJwt(accessToken);

      //Somehow the expiration gives seconds and not milliseconds since 1970
      var expiration = DateTime.fromMillisecondsSinceEpoch(claims["exp"]*1000, isUtc: true);
      if(DateTime.now().isAfter(expiration)){
        tryRefresh();
        return;
        //Abandon: Refresh will call again when it has a new token
      }

      var user = getUserFromAccessToken(accessToken);
      _authSubject.sink.add(user);
    } catch(e){
      print(e);
      _authSubject.sink.add(null);
    }
  }

  User getUserFromAccessToken(String accessToken){
    final jwtUtil = JwtUtil();
    var claims = jwtUtil.parseJwt(accessToken);
    var email = claims["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
    return User(email: email, accessToken: accessToken);
  }

  Future<void> tryRefresh() async {
    if(_currentlyRefreshing)
      return;

    //Replace with mutex later
    _currentlyRefreshing = true;
    //Don't actually catch errors here, just ensure to remove the refreshing flag afterwards
    try{
      var accessToken = await storage.read(key: kAccessTokenName);
      var refreshToken = await storage.read(key: kRefreshTokenName);
      if(accessToken == null || refreshToken == null){
        print("No tokens available");
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
        print("Server returned ${res.statusCode}");
        _authSubject.value = null;
        return;
      }

      var loginResult = LoginResult.fromJson(jsonDecode(res.body));
      await storage.write(key: kAccessTokenName, value: loginResult.token);
      await storage.write(key: kRefreshTokenName, value: loginResult.refreshToken);
      _currentlyRefreshing = false;

      checkAuthState();
    }catch(e){
      throw e;
    }
    finally{
      _currentlyRefreshing = false;
    }
  }

  Future<void> tryOpenSession() async {
    checkAuthState();
  }

  void dispose(){
    _authSubject.close();
  }


}
