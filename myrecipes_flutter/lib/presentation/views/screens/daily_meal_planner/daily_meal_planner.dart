import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/daily_meal_planner_widgets/leaderboard.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/daily_meal_planner_widgets/plannedMeals.dart';

class DailyMealPlanner extends StatelessWidget {
  final date;
  final List<Meal> meals;
  List<Meal> _acceptedMeals = List<Meal>();
  List<Meal> _proposedMeals = List<Meal>();

  DailyMealPlanner({@required this.date, @required this.meals}){
    meals.forEach((meal) {
      if(meal.accepted){
        _acceptedMeals.add(meal);
      }
      else{
        _proposedMeals.add(meal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mealRepository = RepositoryProvider.of<MealRepository>(context);

    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            title: Text("Leaderboard"),
            actions: [],
          ),
          body: CustomScrollView(
            shrinkWrap: false,
            slivers: [
              SliverPadding(
                  padding: EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        PlannedMealsList(meals: _acceptedMeals.where((meal) => mealOnCurrentDay(meal, date)).toList()),
                        MealLeaderboard(meals: _proposedMeals,)
                      ]
                    ),
                  ),
              ),
            ]
          ))
    ]);
  }

  mealOnCurrentDay(Meal meal, DateTime date) =>
      meal.date.isAfter(DateTime(date.year, date.month, date.day)) &&
          meal.date.isBefore(
              DateTime(date.year, date.month, date.day).add(Duration(days: 1)));
}
