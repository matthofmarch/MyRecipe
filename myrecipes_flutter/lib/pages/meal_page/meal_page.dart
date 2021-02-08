import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/meal_view.dart';
import 'dart:developer' as dev;

import 'cubit/meals_cubit.dart';
import 'meal_view/meal_calendar/meal_calendar.dart';
import 'meal_view/meal_list/meal_list.dart';

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
          buildWhen: (previous, current) => previous is! MealsInteractable || current is! MealsInteractable,
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


