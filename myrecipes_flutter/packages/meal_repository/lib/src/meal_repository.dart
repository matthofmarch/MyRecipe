import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:models/model.dart';


class MealRepository{
  final HttpClientWithInterceptor _client;

  MealRepository(this._client){}

  Future<List<Meal>>getAccepted() async{
    var url = "https://vm133.htl-leonding.ac.at:5000/api/Mealplan";

    final response = await _client.get(url);
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      final meals = List<Meal>.from(body.map((x) => Meal.fromMap(x)));
      return meals;
    }
    throw Exception("$url got ${response.statusCode}");
  }
}
