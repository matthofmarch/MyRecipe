part of 'recipe_page_cubit.dart';

@immutable
abstract class RecipepageState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipepageInitial extends RecipepageState {}

class RecipepageProgress extends RecipepageState {}

class RecipepageFailure extends RecipepageState {}

class RecipepageSuccess extends RecipepageState {
  List<Recipe> recipes;

  RecipepageSuccess(this.recipes);

  @override
  List<Object> get props => [recipes];
}
