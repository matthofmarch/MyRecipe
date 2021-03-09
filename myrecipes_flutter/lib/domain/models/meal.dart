import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:myrecipes_flutter/domain/models/user_recipe.dart';

import 'recipe.dart';
import 'vote.dart';

class Meal with EquatableMixin {
  final String mealId;
  final String initiatorName;
  final Recipe recipe;
  final DateTime date;
  final bool accepted;
  final List<Vote> votes;

  Meal({
    this.mealId,
    this.initiatorName,
    this.recipe,
    this.date,
    this.accepted,
    this.votes,
  });

  Meal copyWith({
    String mealId,
    String initiatorName,
    Recipe recipe,
    DateTime date,
    bool accepted,
    List<Vote> votes,
  }) {
    return Meal(
      mealId: mealId ?? this.mealId,
      initiatorName: initiatorName ?? this.initiatorName,
      recipe: recipe ?? this.recipe,
      date: date ?? this.date,
      accepted: accepted ?? this.accepted,
      votes: votes ?? this.votes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealId': mealId,
      'initiatorName': initiatorName,
      'recipe': recipe?.toMap(),
      'date': date?.millisecondsSinceEpoch,
      'accepted': accepted,
      'votes': votes?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Meal(
      mealId: map['mealId'],
      initiatorName: map['initiatorName'],
      recipe: Recipe.fromMap(map['recipe']),
      date: HttpDate.parse(map["date"]).toLocal(),
      accepted: map['accepted'],
      votes: List<Vote>.from(map['votes']?.map((x) => Vote.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Meal.fromJson(String source) => Meal.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      mealId,
      initiatorName,
      recipe,
      date,
      accepted,
      votes,
    ];
  }
}
