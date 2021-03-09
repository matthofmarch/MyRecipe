import 'dart:convert';

import 'package:equatable/equatable.dart';

class Recipe with EquatableMixin {
  final String id;
  final String name;
  final String description;
  final int cookingTimeInMin;
  final List<String> ingredientNames;
  final String image;
  final bool addToGroupPool;

  Recipe({
    this.id,
    this.name,
    this.description,
    this.cookingTimeInMin,
    this.ingredientNames,
    this.image,
    this.addToGroupPool,
  });

  Recipe copyWith({
    String id,
    String name,
    String description,
    int cookingTimeInMin,
    List<String> ingredientNames,
    String image,
    bool addToGroupPool,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cookingTimeInMin: cookingTimeInMin ?? this.cookingTimeInMin,
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
      'cookingTimeInMin': cookingTimeInMin,
      'ingredientNames': ingredientNames,
      'image': image,
      'addToGroupPool': addToGroupPool,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      cookingTimeInMin: map['cookingTimeInMin'],
      ingredientNames: List<String>.from(map['ingredientNames']),
      image: map['image'],
      addToGroupPool: map['addToGroupPool'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  List<Object> get props => [
        id,
        name,
        description,
        cookingTimeInMin,
        ingredientNames,
        image,
        addToGroupPool
      ];
}
