import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';

class MealRepository {
  final HttpClientWithInterceptor _client;

  final String _baseUrl;

  MealRepository(this._client, this._baseUrl);

  Future<List<Meal>> getMeals({bool accepted = null}) async {
    var url = "$_baseUrl/api/Mealplan?accepted";

    final response = await _client.get(Uri.tryParse(url),
        params: {if (accepted != null) "accepted": accepted.toString()});
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final meals = List<Meal>.from(body.map((x) => Meal.fromMap(x)));
      return meals;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<Meal> getMealById(String id) async {
    var url = "$_baseUrl/api/Mealplan/$id";
    final response = await _client.get(Uri.tryParse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final meal = Meal.fromJson(body);
      return meal;
    }
    throw Exception("$url got ${response.statusCode}");

  }
  Future<void> deleteMealById(String id) async {
    var url = "$_baseUrl/api/Mealplan/$id";
    final response = await _client.delete(Uri.tryParse(url));
    if (response.statusCode == 200) {
      return;
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

  Future<void> acceptMealProposal(String id, bool accept) async {
    var url = "$_baseUrl/api/Mealplan/accept/$id?accepted=${accept.toString()}";
    final response = await _client.put(Uri.tryParse(url));

    if (response.statusCode == 200 || response.statusCode == 204 ) {
      // final body = jsonDecode(response.body);
      // final meal = Meal.fromJson(body);
      // return meal;
      return;
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

    if (response.statusCode != 200) {
      throw Exception("$url got ${response.statusCode}");
    }
  }

  Future<void> propose(String recipeId, DateTime dateTime) async {
    var url = "$_baseUrl/api/MealPropose";

    final response = await _client.post(Uri.tryParse(url),
        body: jsonEncode(
            {"recipeId": recipeId, "day": dateTime.toIso8601String()}));
    if (response.statusCode != 200) {
      throw Exception("$url got ${response.statusCode}");
    }
  }
}
