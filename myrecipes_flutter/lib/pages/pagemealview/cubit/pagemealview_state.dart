part of 'pagemealview_cubit.dart';

@immutable
abstract class PagemealviewState extends Equatable {
  const PagemealviewState();

  @override
  List<Object> get props =>[];
}

class PagemealviewInitial extends PagemealviewState {}

class PagemealviewLoading extends PagemealviewState {

}

class PagemealviewFailure extends PagemealviewState {}
class PagemealviewSuccess extends PagemealviewState {
  final List<Meal> meals;

  const PagemealviewSuccess(this.meals);

  @override
  List<Object> get props => [meals];
}
