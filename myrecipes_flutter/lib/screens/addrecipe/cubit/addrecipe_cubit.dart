import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:models/model.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'addrecipe_state.dart';

class AddrecipeCubit extends Cubit<AddrecipeState> {
  RecipeRepository _recipeRepository;
  List<String> _ingredients;
  IngredientRepository _ingredientRepository;
  List<int> _selectedIngredientsIndexes;

  AddrecipeCubit(this._recipeRepository, this._ingredientRepository)
      : super(AddrecipeInitial());

  Future reload({File image}) async {
    if (_ingredients == null) {
      _ingredients = await _ingredientRepository.get();
    }
    emit(AddrecipeInteraction(_ingredients, image: image));
  }

  silentSetSelectedIngredients(List<int> selected) =>
      _selectedIngredientsIndexes = selected;

  Future<Recipe> submit(Recipe recipe, File image) async {
    emit(AddrecipeSubmitting(_ingredients, image: image));
    try {
      var recipeResult = await _recipeRepository.add(recipe, image);
      emit(AddrecipeSuccess(recipeResult));
      return recipeResult;
    } catch (e) {
      print(e);
      emit(AddrecipeFailure());
    }
  }
}
