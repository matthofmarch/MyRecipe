import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';

class IngredientRepository{
  final HttpClientWithInterceptor _client;

  final String _baseUrl;

  IngredientRepository(this._client, this._baseUrl);

  Future<List<String>>get() async{
    var url = "$_baseUrl/api/Ingredient";

    final response = await _client.get(url);
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      final ingredients = List<String>.from(body);
      return ingredients;
    }
    throw Exception("$url got ${response.statusCode}");
  }
}
