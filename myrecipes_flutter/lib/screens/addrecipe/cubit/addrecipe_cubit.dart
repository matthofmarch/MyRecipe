import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/model.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'addrecipe_state.dart';

class AddrecipeCubit extends Cubit<AddrecipeState> {
  RecipeRepository _recipeRepository;

  AddrecipeCubit(this._recipeRepository) : super(AddrecipeInitial(null));

  void useImage(File image) {
    emit(AddrecipeInitial(image));
  }

  Future<Recipe> addRecipe(Recipe recipe, File image)async{
    emit(AddrecipeSubmitting());
    try{
      var recipeResult = await _recipeRepository.addRecipe(recipe, image);
      emit(AddrecipeSuccess(recipeResult));
    }catch(e){
      print(e);
      emit(AddrecipeFailure());
    }
  }
}
