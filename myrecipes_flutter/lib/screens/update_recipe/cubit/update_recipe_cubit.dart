import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/model.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';


part 'update_recipe_state.dart';

class UpdateRecipeCubit extends Cubit<UpdateRecipeState> {
  RecipeRepository _recipeRepository;
  IngredientRepository _ingredientRepository;

  List<String> _allIngredients;
  List<String> _selectedIngredients;
  File _selectedImageFile;
  String _oldImageUri;

  UpdateRecipeCubit(this._recipeRepository, this._ingredientRepository) : super(UpdateRecipeInitial());

  Future<void> initAsync(Recipe initialRecipe) async {
    _oldImageUri = initialRecipe.image;
    _allIngredients = await _ingredientRepository.get();
    _selectedIngredients = initialRecipe.ingredientNames;
    emitInteraction();
  }

  selectedIngredients(List<String> selected) => _selectedIngredients = selected;
  selectedImage(File file) {
    _selectedImageFile = file;
    emitInteraction();
  }


  Future emitInteraction() async{
    emit(UpdateRecipeInteraction(_allIngredients, selectedImage: _selectedImageFile, selectedIngredients: _selectedIngredients, oldImageUri: _oldImageUri));
  }


  Future<Recipe> submit(String name, int cookingTimeInMin, String description, String imageUrl)async{
    emit(UpdateRecipeSubmitting());
    try{
      var recipeResult = await _recipeRepository.add(Recipe(
        name:name,
        cookingTimeInMin: cookingTimeInMin,
        addToGroupPool: true,
        ingredientNames: _selectedIngredients,
        image: _selectedImageFile == null ? imageUrl:null,
        description: description
      ), _selectedImageFile);
      emit(UpdateRecipeSuccess());
      return recipeResult;
    }catch(e){
      print(e);
      emit(UpdateRecipeFailure());
    }
  }
}