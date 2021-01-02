part of 'update_recipe_cubit.dart';


abstract class UpdateRecipeState extends Equatable {
  const UpdateRecipeState();
  @override
  List<Object> get props => [];
}

class UpdateRecipeInitial extends UpdateRecipeState {}

class UpdateRecipeInteraction extends UpdateRecipeState {
  String name;
  String description;
  int cookingTimeInMin;
  File selectedImage;
  List<String> ingredients;
  List<String> selectedIngredients;
  String oldImageUri;

  UpdateRecipeInteraction(this.name, this.description, this.cookingTimeInMin, this.ingredients, {this.selectedImage, this.selectedIngredients, this.oldImageUri});

  @override
  List<Object> get props =>[name, description, cookingTimeInMin, selectedImage, ingredients, oldImageUri];
}
class UpdateRecipeSubmitting extends UpdateRecipeState {}
class UpdateRecipeFailure extends UpdateRecipeState {}
class UpdateRecipeSuccess extends UpdateRecipeState {
  Recipe recipe;
  UpdateRecipeSuccess(this.recipe);

  @override
  List<Object> get props =>[recipe];
}
