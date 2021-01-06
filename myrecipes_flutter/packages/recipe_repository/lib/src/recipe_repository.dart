import 'dart:convert';
import 'dart:io';
import 'package:auth_repository/auth_repository.dart';
import 'package:http/http.dart' as http;

import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:models/model.dart';
import 'package:models/models/user_recipe.dart';

class RecipeRepository {
  final HttpClientWithInterceptor _client;
  final AuthRepository _authRepository;
  final String _baseUrl;

  RecipeRepository(this._client, this._baseUrl, this._authRepository) {}

  Future<List<Recipe>> getOwnRecipes() async {
    var url = "$_baseUrl/api/Recipes";

    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final recipes = List<Recipe>.from(body.map((x) => Recipe.fromMap(x)));
      return recipes;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<List<UserRecipe>> getGroupRecipes() async {
    var url = "$_baseUrl/api/Recipes/group";

    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final recipes = List<UserRecipe>.from(body.map((x) => UserRecipe.fromMap(x)));
      return recipes;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<Recipe> add(Recipe recipe, File image) async {
    final addRecipeUrl = "$_baseUrl/api/Recipes";

    if (image != null) {
      recipe = recipe.copyWith(image: await uploadImage(image));
    }

    final response = await _client.post(addRecipeUrl, body: json.encode({
      "name": recipe.name,
      "description": recipe.description,
      "cookingTimeInMin": recipe.cookingTimeInMin,
      "addToGroupPool": recipe.addToGroupPool,
      "ingredientNames": recipe.ingredientNames,
      "image": recipe.image
    }));
    if (response.statusCode == 200) {
      return recipe;
    }
    throw Exception("$addRecipeUrl got ${response.statusCode}");
  }

  //TODO Use HttpInterceptor asap
  Future<String> uploadImage(File image) async {
    var imageUploadUrl = "$_baseUrl/api/Recipes/uploadImage";
    var file = await http.MultipartFile.fromPath("image", image.path);
    var request = http.MultipartRequest("POST", Uri.parse(imageUploadUrl));
    request.files.add(file);
    request.headers.addAll({"Authorization": "Bearer ${_authRepository.authState.accessToken}"});
    final response = await _client.send(request);
    if (response.statusCode == 200) {
      var data = await response.stream.first;
      var jsonResult = jsonDecode(String.fromCharCodes(data));
      return jsonResult["uri"];
    }
    throw Exception("$imageUploadUrl got ${response.statusCode}");
  }

  Future<bool> delete(String id) async {
    var url = "$_baseUrl/api/Recipes";

    final response = await _client.delete("$url/$id");
    if (response.statusCode == 204) {
      return true;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<Recipe> single(String recipeId)async {
    var url = "$_baseUrl/api/Recipes/$recipeId";
    final response = await _client.get(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final recipe = Recipe.fromJson(body);
      return recipe;
    }
    throw Exception("$url got ${response.statusCode}");
  }

  Future<Recipe> put(Recipe recipe, {File image}) async{
    if (image != null) {
      recipe = recipe.copyWith(image: await uploadImage(image));
    }

    final addRecipeUrl = "$_baseUrl/api/Recipes/${recipe.id}";
    final response = await _client.put(addRecipeUrl, body: recipe.toJson());
    if (response.statusCode == 204) {
      return recipe;
    }
    throw Exception("$addRecipeUrl got ${response.statusCode}");
  }
}