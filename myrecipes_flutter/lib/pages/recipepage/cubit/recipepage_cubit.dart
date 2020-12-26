import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:models/model.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipepage_state.dart';

class RecipepageCubit extends Cubit<RecipepageState> {
  final RecipeRepository _recipeRepository;

  RecipepageCubit(this._recipeRepository) : super(RecipepageInitial());

  Future loadRecipes() async{
    emit(RecipepageProgress());
    try{
      final recipes = await _recipeRepository.all();
      emit(RecipepageSuccess(recipes));
    }catch(e){
      emit(RecipepageFailure());
    }
  }
}
