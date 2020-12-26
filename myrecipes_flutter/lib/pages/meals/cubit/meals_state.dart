part of 'meals_cubit.dart';

@immutable
abstract class MealsState extends Equatable {
  const MealsState();

  @override
  List<Object> get props =>[];
}

class MealsInitial extends MealsState {}

class MealsLoading extends MealsState {

}

class MealsFailure extends MealsState {}
class MealsSuccess extends MealsState {
  final List<Meal> meals;

  const MealsSuccess(this.meals);

  @override
  List<Object> get props => [meals];
}
