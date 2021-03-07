import 'dart:convert';

import 'recipe.dart';

class UserRecipe extends Recipe {
  final String username;

  UserRecipe({
    this.username,
    id,
    name,
    description,
    cookingTimeInMin,
    ingredientNames,
    image,
    addToGroupPool,
  }) : super(
            id: id,
            name: name,
            description: description,
            image: image,
            ingredientNames: ingredientNames,
            addToGroupPool: addToGroupPool,
            cookingTimeInMin: cookingTimeInMin);

  UserRecipe._fromRecipe({this.username, Recipe recipe})
      : super(
            id: recipe.id,
            name: recipe.name,
            description: recipe.description,
            image: recipe.image,
            ingredientNames: recipe.ingredientNames,
            addToGroupPool: recipe.addToGroupPool,
            cookingTimeInMin: recipe.cookingTimeInMin);

  @override
  Map<String, dynamic> toMap() => super.toMap()..addAll({'username': username});
  factory UserRecipe.fromMap(Map<String, dynamic> map) =>
      UserRecipe._fromRecipe(
          username: map['username'],
          recipe: Recipe(
            id: map['id'],
            name: map['name'],
            description: map['description'],
            cookingTimeInMin: map['cookingTimeInMin'],
            ingredientNames: List<String>.from(map['ingredientNames']),
            image: map['image'],
            addToGroupPool: map['addToGroupPool'],
          ));

  factory UserRecipe.fromJson(String source) =>
      UserRecipe.fromMap(json.decode(source));

  @override
  List<Object> get props => super.props..addAll([username]);
}
