part of 'add_recipe_cubit.dart';

abstract class AddRecipeState extends Equatable {
  const AddRecipeState();

  @override
  List<Object> get props => [];
}

class AddRecipeInitial extends AddRecipeState {}

class AddRecipeInteraction extends AddRecipeState {
  File image;
  List<String> ingredients;
  List<int> selectedIngredients = List<int>();

  AddRecipeInteraction(this.ingredients,
      {this.image, this.selectedIngredients});

  @override
  List<Object> get props => [image, ingredients];
}

class AddRecipeSubmitting extends AddRecipeInteraction {
  AddRecipeSubmitting(ingredients, {image, selectedIngredients})
      : super(ingredients,
            image: image, selectedIngredients: selectedIngredients);
}

class AddRecipeFailure extends AddRecipeState {}

class AddRecipeSuccess extends AddRecipeState {
  Recipe recipe;

  AddRecipeSuccess(this.recipe);

  @override
  List<Object> get props => [recipe];
}
