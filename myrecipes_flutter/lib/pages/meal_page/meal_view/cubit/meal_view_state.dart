part of 'meal_view_cubit.dart';

class MealViewState extends Equatable {
  final DateTime currentDate;
  final bool showCalendar;
  final bool forceReload;

  MealViewState(this.currentDate, this.showCalendar, this.forceReload);

  @override
  List<Object> get props => [currentDate, showCalendar];
}
