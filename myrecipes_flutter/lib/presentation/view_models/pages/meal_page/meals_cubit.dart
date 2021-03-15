import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';

part 'meals_state.dart';

class MealsCubit extends Cubit<MealsState> {
  final MealRepository _mealRepository;
  List<Meal> _meals;

  MealsCubit(this._mealRepository) : super(MealsInitial());

  Future<void> load() async {
    emit(MealsLoading());
    try {
      //TODO: Migrate to single endpoint
      var acceptedMeals = await _mealRepository.getMeals();
      var proposedMeals = await _mealRepository.getProposed();
      _meals = acceptedMeals.followedBy(proposedMeals).toList();
      emit(MealsInteractable(_meals));
    } catch (e) {
      print(e);
      emit(MealsFailure());
    }
  }
}
