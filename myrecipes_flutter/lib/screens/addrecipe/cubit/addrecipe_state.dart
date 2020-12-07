part of 'addrecipe_cubit.dart';

abstract class AddrecipeState extends Equatable {
  const AddrecipeState();
  @override
  List<Object> get props => [];
}

class AddrecipeInitial extends AddrecipeState {
  File image;

  AddrecipeInitial(this.image);

  @override
  List<Object> get props =>[image];

}
class AddrecipeSubmitting extends AddrecipeState {}
class AddrecipeFailure extends AddrecipeState {}
class AddrecipeSuccess extends AddrecipeState {
  Recipe recipe;

  AddrecipeSuccess(this.recipe);

  @override
  List<Object> get props => [recipe];
}
