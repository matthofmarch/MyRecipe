import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';

class MealRepository {
  final HttpClientWithInterceptor _client;

  final String _baseUrl;

  MealRepository(this._client, this._baseUrl);

  Future<List<Meal>> getAccepted() async {
    var url = "$_baseUrl/api/Mealplan";

    final response = await _client.get(Uri.tryParse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final meals = List<Meal>.from(body.map((x) => Meal.fromMap(x)));
      return meals;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<List<Meal>> getProposed() async {
    var url = "$_baseUrl/api/MealPropose";

    final response = await _client.get(Uri.tryParse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final meals = List<Meal>.from(body.map((x) => Meal.fromMap(x)));
      return meals;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<void> vote(String mealId, bool isPositive) async {
    var url = "$_baseUrl/api/MealVote";

    final response = await _client.post(Uri.tryParse(url),
        body: jsonEncode({
          "mealId": mealId,
          "voteEnum": isPositive ? "Approved" : "Rejected"
        }));
    if (response.statusCode == 200) {
      return;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<void> propose(String recipeId, DateTime dateTime) async {
    var url = "$_baseUrl/api/MealPropose";

    final response = await _client.post(Uri.tryParse(url),
        body: jsonEncode(
            {"recipeId": recipeId, "day": dateTime.toIso8601String()}));
    if (response.statusCode == 200) {
      return;
    }
    throw Exception("$url got ${response.statusCode}");
  }
}
