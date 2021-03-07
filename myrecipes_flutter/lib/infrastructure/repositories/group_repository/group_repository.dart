import 'dart:convert';

import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:myrecipes_flutter/domain/models/group.dart';

class GroupRepository {
  final HttpClientWithInterceptor _client;
  final String _baseUrl;

  GroupRepository(this._client, this._baseUrl);

  Future<Group> getGroup() async {
    var url = "$_baseUrl/api/Group/getGroupForUser";

    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final group = Group.fromMap(body);
      return group;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<String> getInviteCode() async {
    var url = "$_baseUrl/api/InviteCode";

    final response = await _client.post(url);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body);
      return jsonResult["code"];
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<String> joinWithInviteCode(String inviteCode) async {
    var url =
        "$_baseUrl/api/InviteCode/acceptInviteCode?inviteCode=${inviteCode}";

    final response = await _client.get(url, headers: {"accept": "*/*"});
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body);
      return jsonResult["code"];
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<Group> getGroupForUser() async {
    var url = "$_baseUrl/api/Group/getGroupForUser";

    final response = await _client.get(url);
    if (response.statusCode == 200) {
      return Group.fromJson(response.body);
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<void> create(String name) async {
    var url = "$_baseUrl/api/Group";
    var requestBody = jsonEncode({"name": name});
    final response = await _client.post(url, body: requestBody);
    if (response.statusCode == 201) {
      return;
    }
    throw Exception("$url got ${response.statusCode}");
  }
}
