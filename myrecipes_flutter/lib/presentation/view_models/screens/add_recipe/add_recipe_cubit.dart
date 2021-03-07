import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/ingredient_repository/ingredient_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/recipe_repository/recipe_repository.dart';

part 'add_recipe_state.dart';

class AddRecipeCubit extends Cubit<AddRecipeState> {
  RecipeRepository _recipeRepository;
  List<String> _ingredients;
  IngredientRepository _ingredientRepository;
  List<int> _selectedIngredientsIndexes;

  AddRecipeCubit(this._recipeRepository, this._ingredientRepository)
      : super(AddRecipeInitial());

  Future reload({File image}) async {
    if (_ingredients == null) {
      _ingredients = await _ingredientRepository.get();
    }
    emit(AddRecipeInteraction(_ingredients, image: image));
  }

  silentSetSelectedIngredients(List<int> selected) =>
      _selectedIngredientsIndexes = selected;

  Future<Recipe> submit(Recipe recipe, File image) async {
    emit(AddRecipeSubmitting(_ingredients, image: image));
    try {
      var recipeResult = await _recipeRepository.add(recipe, image);
      emit(AddRecipeSuccess(recipeResult));
      return recipeResult;
    } catch (e) {
      print(e);
      emit(AddRecipeFailure());
    }
  }
}
