import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:meta/meta.dart';
import 'package:models/model.dart';
import 'dart:core';

part 'meals_state.dart';


class MealsCubit extends Cubit<MealsState> {
  final MealRepository _mealRepository;

  MealsCubit(this._mealRepository) : super(MealsInitial());

  Future load() async{
    emit(MealsLoading());
    try{
      var accepted = await _mealRepository.getAccepted();
      emit(MealsSuccess(accepted));
    }catch(e){
      print(e);
      emit(MealsFailure());
    }
  }
}
