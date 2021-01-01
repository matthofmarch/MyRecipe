import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/meal_view.dart';

part 'meal_view_state.dart';

class MealViewCubit extends Cubit<MealViewState> {
  MealViewCubit() : super(MealViewState(DateTime.now(), true, true)); //TODO remove unnecessary invocation

  var _currentDate = DateTime.now();
  DateTime get currentDate => _currentDate;
  set currentDateSilent (value){
    print("MealViewCubit.currentDate silently set to $currentDate");
    _currentDate = value;
    emitInteraction(forceReload: false);
  }
  set currentDate (value){
    print("MealViewCubit.currentDate set to $currentDate");
    _currentDate = value;
    emitInteraction(forceReload: true);
  }

  var _showCalendar = true;

  get showCalendar => _showCalendar;

  set showCalendar(value) {
    _showCalendar = value;
    emitInteraction();
  }

  void emitInteraction({forceReload = false}) {
    emit(MealViewState(_currentDate, showCalendar, forceReload));
  }
}
