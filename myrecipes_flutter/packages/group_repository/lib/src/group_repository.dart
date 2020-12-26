import 'dart:convert';

import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:models/model.dart';

class GroupRepository{
  final HttpClientWithInterceptor _client;
  final String _baseUrl;

  GroupRepository(this._client, this._baseUrl);

  Future<Group>getGroup() async{
    var url = "$_baseUrl/api/Group/getGroupForUser";

    final response = await _client.get(url);
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      final group = Group.fromMap(body);
      return group;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<String> getInviteCode() async{
    var url = "$_baseUrl/api/InviteCode";

    final response = await _client.post(url);
    if (response.statusCode == 200) {
      var jsonResult = jsonDecode(response.body);
      return jsonResult["code"];
    }
    throw Exception("$url got ${response.statusCode}");
  }
}