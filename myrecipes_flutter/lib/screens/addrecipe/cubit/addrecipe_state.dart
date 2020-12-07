part of 'addrecipe_cubit.dart';

abstract class AddrecipeState extends Equatable {
  const AddrecipeState();
  @override
  List<Object> get props => [];
}

class AddrecipeInitial extends AddrecipeState {}

class AddrecipeInteraction extends AddrecipeState {
  File image;
  List<String> ingredients;
  List<int> selectedIngredients = List<int>();

  AddrecipeInteraction(this.ingredients, {this.image, this.selectedIngredients});

  @override
  List<Object> get props =>[image, ingredients];
}
class AddrecipeSubmitting extends AddrecipeInteraction {
  AddrecipeSubmitting(ingredients, {image, selectedIngredients}):super(ingredients, image: image, selectedIngredients: selectedIngredients);
}
class AddrecipeFailure extends AddrecipeState {}
class AddrecipeSuccess extends AddrecipeState {
  Recipe recipe;

  AddrecipeSuccess(this.recipe);

  @override
  List<Object> get props => [recipe];
}
