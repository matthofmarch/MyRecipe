library auth_repository;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auth_repository/jwt_util.dart';
import 'package:auth_repository/models/login_result.dart';
import 'package:auth_repository/models/refresh_result.dart';
import 'package:auth_repository/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  final storage = FlutterSecureStorage();
  var _baseUrl;

  final _authSubject = BehaviorSubject<User>();

  User get authState => _authSubject.value;

  Stream<User> get authStateStream => _authSubject.stream;

  AuthRepository(this._baseUrl);

  Future<void> login(String email, String password) async {
    var res = await http.post(
      "$_baseUrl/api/Auth/login",
      headers: {
        'Content-type': 'application/json',
      },
      body: jsonEncode({"email": email, "password": password}),
    );
    if (res.statusCode != 200) throw Exception("Could not login");

    var loginResult = LoginResult.fromJson(jsonDecode(res.body));
    await storage.write(key: "access_token", value: loginResult.token);
    await storage.write(key: "refresh_token", value: loginResult.refreshToken);

    updateUserWithAccessToken(loginResult.token);
  }

  updateUserWithAccessToken(String accessToken) {
    try {
      final jwtUtil = JwtUtil();
      var claims = jwtUtil.parseJwt(accessToken);
      var expiration = claims["exp"];
      if (DateTime.now()
          .isAfter(DateTime.fromMillisecondsSinceEpoch(expiration * 1000))) {
        refreshAccessToken();
        return;
      }
      var email = claims["sub"];
      var user = User(email: email, accessToken: accessToken);
      _authSubject.sink.add(user);
    } catch (e) {
      print(e);
      _authSubject.sink.add(null);
    }
  }

  bool tokenExpired(String token) {
    final jwtUtil = JwtUtil();
    var claims = jwtUtil.parseJwt(token);
    var expiration = claims["exp"];
    return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(expiration * 1000));
  }

  Future<void> signup(String email, String password) async {
    var res =
        await http.post("$_baseUrl/api/Auth/register", body: {email, password});
    if (res.statusCode != 200) throw Exception("Could not sign up");
  }

  Future logout() async {
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    _authSubject.add(null);
  }

  Future<void> tryOpenSession() async {
    var accessToken = await storage.read(key: "access_token");
    updateUserWithAccessToken(accessToken);
  }

  Future<void> refreshAccessToken() async {
    final url = "$_baseUrl/api/Auth/refresh";
    var refreshToken = await storage.read(key: "refresh_token");
    var token = await storage.read(key: "access_token");

    var res = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'token': token, 'refreshToken': refreshToken}),
    );
    if (res.statusCode != 200)
      throw Exception("Could not refresh access token");

    var refreshResult = RefreshResult.fromJson(jsonDecode(res.body));
    await storage.write(key: "access_token", value: refreshResult.token);
    await storage.write(
        key: "refresh_token", value: refreshResult.refreshToken);
    updateUserWithAccessToken(refreshResult.token);
  }

  void dispose() {
    _authSubject.close();
  }
}
