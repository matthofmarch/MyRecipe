library auth_repository;

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:myrecipes_flutter/domain/models/auth/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dtos/login_result.dart';
import 'jwt_util.dart';

const kAccessTokenName = "access_token";
const kRefreshTokenName = "refresh_token";

class AuthRepository {
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
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
        'Content-type': 'application/json',
      },
      body: jsonEncode({"Email": email, "Password": password}),
    );
    if (res.statusCode != 200) throw Exception("Could not login");

    var loginResult = LoginResult.fromJson(jsonDecode(res.body));
    final storage = await sharedPreferences;
    await storage.setString(kAccessTokenName, loginResult.token);
    await storage.setString(kRefreshTokenName, loginResult.refreshToken);

    checkAuthStateAsync();
  }

  Future<void> signup(String email, String password) async {
    var requestBody = jsonEncode({"email": email, "password": password});
    var res = await http.post(
      "$_baseUrl/api/Auth/register",
      body: requestBody,
      headers: {
        'Content-type': 'application/json',
      },
    );
    if (res.statusCode != 200) throw Exception("Could not sign up");
  }

  Future<void> logout() async {
    final storage = await sharedPreferences;
    await storage.remove(kAccessTokenName);
    await storage.remove(kRefreshTokenName);
    _authSubject.add(null);
  }

  Future<void> checkAuthStateAsync() async {
    developer.log("Checking auth state");
    final storage = await sharedPreferences;
    String accessToken = storage.getString(kAccessTokenName);
    if (accessToken == null) {
      developer.log("No access token available");
      _authSubject.sink.add(null);
      return;
    }
    var claims = JwtUtil().parseJwt(accessToken);

    //Somehow the expiration gives seconds and not milliseconds since 1970
    var expiration =
        DateTime.fromMillisecondsSinceEpoch(claims["exp"] * 1000, isUtc: true);
    if (DateTime.now().isAfter(expiration)) {
      developer.log("Access token expired at $expiration, calling refresh");
      refreshAsync();
      return;
    }

    developer.log("Token looks great, user authenticated");
    var user = getUserFromAccessToken(accessToken);
    _authSubject.add(user);
  }

  User getUserFromAccessToken(String accessToken) {
    final jwtUtil = JwtUtil();
    var claims = jwtUtil.parseJwt(accessToken);
    var email = claims[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
    var role =
        claims["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
    return User(
        email: email, accessToken: accessToken, isAdmin: role == "Admin");
  }

  Future<void> refreshAsync() async {
    if (_currentlyRefreshing) {
      developer.log("Refreshing already active, aborting");
      return;
    }

    //Replace with mutex later
    _currentlyRefreshing = true;
    developer.log("Refresh started");
    //Don't actually catch errors here, just ensure to remove the refreshing flag afterwards
    try {
      _authSubject.value = null;
      final storage = await sharedPreferences;
      String accessToken = storage.getString(kAccessTokenName);
      String refreshToken = storage.getString(kRefreshTokenName);
      if (accessToken == null || refreshToken == null) {
        developer.log("Not all tokens required for refresh available");
        return;
      }

      var res = await http.post(
        "$_baseUrl/api/Auth/refresh",
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode({"token": accessToken, "refreshToken": refreshToken}),
      );
      if (res.statusCode != 200) {
        developer.log("When refreshing, Server returned ${res.statusCode}");
        return;
      }

      var loginResult = LoginResult.fromJson(jsonDecode(res.body));
      developer.log("New access token: ${loginResult.token}");
      await storage.setString(kAccessTokenName, loginResult.token);
      developer.log("New refresh token: ${loginResult.refreshToken}");
      await storage.setString(kRefreshTokenName, loginResult.refreshToken);

      checkAuthStateAsync();
    } catch (e) {
      throw e;
    } finally {
      _currentlyRefreshing = false;
      developer.log("Refresh stopped");
    }
  }

  void dispose() {
    _authSubject.close();
  }
}
