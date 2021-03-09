import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recipelist_state.dart';

class RecipelistCubit extends Cubit<RecipelistState> {
  RecipelistCubit() : super(RecipelistInitial());
}
