import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:models/model.dart';


class MealRepository{
  final HttpClientWithInterceptor _client;

  final String _baseUrl;

  MealRepository(this._client, this._baseUrl);

  Future<List<Meal>>getAccepted() async{
    var url = "$_baseUrl/api/Mealplan";

    final response = await _client.get(url);
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      final meals = List<Meal>.from(body.map((x) => Meal.fromMap(x)));
      return meals;
    }
    throw Exception("$url got ${response.statusCode}");
  }
}
