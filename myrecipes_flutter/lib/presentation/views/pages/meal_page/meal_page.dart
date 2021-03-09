import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/pages/meal_page/meals_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/meal_view/meal_view.dart';

/**
 * This page shows views that show meals
 * As one of its *children is meal_calendar- which should not be rebuild-
 *  we must add some custom building logic
 */
class MealPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealsCubit>(
      create: (context) =>
          MealsCubit(RepositoryProvider.of<MealRepository>(context)),
      child: BlocBuilder<MealsCubit, MealsState>(
          buildWhen: (previous, current) =>
              previous is! MealsInteractable || current is! MealsInteractable,
          builder: (context, state) {
            if (state is MealsInitial) {
              BlocProvider.of<MealsCubit>(context).load();
              return Container();
            }
            if (state is MealsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is MealsInteractable) {
              print(Theme.of(context).brightness);
              return MealView(state.meals);
            }
            return Container();
          }),
    );
  }
}
