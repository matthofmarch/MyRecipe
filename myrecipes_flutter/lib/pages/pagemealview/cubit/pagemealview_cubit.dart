import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:meta/meta.dart';
import 'package:models/model.dart';
import 'dart:core';

part 'pagemealview_state.dart';


class PagemealviewCubit extends Cubit<PagemealviewState> {
  final MealRepository _mealRepository;

  PagemealviewCubit(this._mealRepository) : super(PagemealviewInitial());

  Future load() async{
    emit(PagemealviewLoading());
    try{
      var accepted = await _mealRepository.getAccepted();
      emit(PagemealviewSuccess(accepted));
    }catch(e){
      print(e);
      emit(PagemealviewFailure());
    }
  }
}
