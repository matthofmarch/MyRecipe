import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:models/model.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'recipepage_state.dart';

class RecipepageCubit extends Cubit<RecipepageState> {
  final RecipeRepository _recipeRepository;
  List<Recipe> _recipes;

  RecipepageCubit(this._recipeRepository) : super(RecipepageInitial());

  Future loadRecipes() async {
    emit(RecipepageProgress());
    try {
      _recipes = await _recipeRepository.getGroupRecipes();
      emit(RecipepageSuccess(_recipes));
    } catch (e) {
      emit(RecipepageFailure());
    }
  }

  Future filter(String query) async {
    emit(RecipepageSuccess(_recipes
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList()));
  }
}
