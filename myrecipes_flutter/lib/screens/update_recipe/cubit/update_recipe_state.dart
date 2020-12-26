part of 'update_recipe_cubit.dart';


abstract class UpdateRecipeState extends Equatable {
  const UpdateRecipeState();
  @override
  List<Object> get props => [];
}

class UpdateRecipeInitial extends UpdateRecipeState {}

class UpdateRecipeInteraction extends UpdateRecipeState {
  File selectedImage;
  List<String> ingredients;
  List<String> selectedIngredients;
  String oldImageUri;

  UpdateRecipeInteraction(this.ingredients, {this.selectedImage, this.selectedIngredients, this.oldImageUri});

  @override
  List<Object> get props =>[selectedImage, ingredients, oldImageUri];
}
class UpdateRecipeSubmitting extends UpdateRecipeState {}
class UpdateRecipeFailure extends UpdateRecipeState {}
class UpdateRecipeSuccess extends UpdateRecipeState {}
