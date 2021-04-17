import 'dart:convert';

import 'package:http_interceptor/http_client_with_interceptor.dart';

class UserRepository {
  final HttpClientWithInterceptor _client;
  final String _baseUrl;

  UserRepository(this._client, this._baseUrl);

  Future<void> changePassword(String newPassword, String oldPassword) async {
    var url = "$_baseUrl/api/Auth/changePassword";
    final response = await _client.post(Uri.parse(url),
        body: jsonEncode(
            {"currentPassword": oldPassword, "newPassword": newPassword}));
    if (response.statusCode != 200) {
      throw Exception("$url got ${response.statusCode}");
    }
  }

  Future<void> changeEmail(String newEmail) async {
    var url = "$_baseUrl/api/Auth/changeEmail";
    var queryParameters = {"newEmail": newEmail};
    String queryString = Uri(queryParameters: queryParameters).query;
    var requestUrl = url + '?' + queryString;

    final response = await _client.get(Uri.parse(requestUrl));
    if (response.statusCode != 200) {
      throw Exception("$url got ${response.statusCode}");
    }
  }

  Future<void> resetPassword(String email) async {
    var url = "$_baseUrl/api/Auth/resetPassword";
    var queryParameters = {"email": email};
    String queryString = Uri(queryParameters: queryParameters).query;
    var requestUrl = url + '?' + queryString;

    final response = await _client.get(Uri.parse(requestUrl));
    if (response.statusCode != 200) {
      throw Exception("$url got ${response.statusCode}");
    }
  }

  Future<void> leaveGroup() async {
    var url = "$_baseUrl/api/User/leaveGroup";

    final response = await _client.put(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("$url got ${response.statusCode}");
    }
  }
}
