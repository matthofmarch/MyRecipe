import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:meta/meta.dart';
import 'package:models/model.dart';
import 'dart:core';

part 'meals_state.dart';


class MealsCubit extends Cubit<MealsState> {
  final MealRepository _mealRepository;
  List<Meal> _meals;

  MealsCubit(this._mealRepository) : super(MealsInitial());

  Future<void> load() async{
    emit(MealsLoading());
    try{
      var acceptedMeals = await _mealRepository.getAccepted();
      var proposedMeals = await _mealRepository.getProposed();
      _meals = acceptedMeals.followedBy(proposedMeals).toList();
      emit(MealsInteractable(_meals));
    }catch(e){
      print(e);
      emit(MealsFailure());
    }
  }
}
