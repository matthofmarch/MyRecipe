import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_repository/meal_repository.dart';

import 'cubit/meals_cubit.dart';
import 'meals_calendar/meal_calendar.dart';

class MealsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealsCubit>(
      create: (context) =>
          MealsCubit(RepositoryProvider.of<MealRepository>(context)),
      child: BlocBuilder<MealsCubit, MealsState>(
          builder: (context, state) {
        if (state is MealsInitial) {
          BlocProvider.of<MealsCubit>(context).load();
          return Container();
        }
        if (state is MealsLoading) {
          return CircularProgressIndicator();
        }
        if (state is MealsSuccess) {
          return _makeCalendar(context, state);
        }
        return Container();
      }),
    );
  }

  Widget _makeCalendar(BuildContext context, MealsSuccess state) {
    return Scaffold(
      body: MealCalendar(state.meals, DateTime.now())
    );
  }
}


