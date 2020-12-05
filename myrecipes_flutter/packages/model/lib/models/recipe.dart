import 'dart:convert';

import 'package:collection/collection.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final int cookingTimeInMinutes;
  final List<String> ingredientNames;
  final String image;
  final bool addToGroupPool;
  Recipe({
    this.id,
    this.name,
    this.description,
    this.cookingTimeInMinutes,
    this.ingredientNames,
    this.image,
    this.addToGroupPool,
  });

  Recipe copyWith({
    String id,
    String name,
    String description,
    int cookingTimeInMinutes,
    List<String> ingredientNames,
    String image,
    bool addToGroupPool,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cookingTimeInMinutes: cookingTimeInMinutes ?? this.cookingTimeInMinutes,
      ingredientNames: ingredientNames ?? this.ingredientNames,
      image: image ?? this.image,
      addToGroupPool: addToGroupPool ?? this.addToGroupPool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cookingTimeInMinutes': cookingTimeInMinutes,
      'ingredientNames': ingredientNames,
      'image': image,
      'addToGroupPool': addToGroupPool,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      cookingTimeInMinutes: map['cookingTimeInMinutes'],
      ingredientNames: List<String>.from(map['ingredientNames']),
      image: map['image'],
      addToGroupPool: map['addToGroupPool'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, description: $description, cookingTimeInMinutes: $cookingTimeInMinutes, ingredientNames: $ingredientNames, image: $image, addToGroupPool: $addToGroupPool)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is Recipe &&
        o.id == id &&
        o.name == name &&
        o.description == description &&
        o.cookingTimeInMinutes == cookingTimeInMinutes &&
        listEquals(o.ingredientNames, ingredientNames) &&
        o.image == image &&
        o.addToGroupPool == addToGroupPool;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        cookingTimeInMinutes.hashCode ^
        ingredientNames.hashCode ^
        image.hashCode ^
        addToGroupPool.hashCode;
  }
}
