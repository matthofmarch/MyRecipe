import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/daily_meal_planner_widgets/plannedMeals.dart';

import '../../../view_models/pages/meal_page/meals_cubit.dart';
import '../../../view_models/pages/meal_page/meals_cubit.dart';
import '../../widgets/daily_meal_planner_widgets/plannedMeals.dart';

class DailyMealPlanner extends StatelessWidget {
  final date;
  List<Meal> meals;
  List<Meal> _acceptedMeals = List<Meal>.empty(growable: true);
  List<Meal> _proposedMeals = List<Meal>.empty(growable: true);

  final MealsCubit mealsCubit;
  final BuildContext mealsContext;


  DailyMealPlanner(this.mealsCubit,{@required this.date, @required this.meals, this.mealsContext}){
    meals = meals.where((meal) => mealOnCurrentDay(meal, date),).toList();
    meals.forEach((meal) {
      if(meal.accepted){
        _acceptedMeals.add(meal);
      }
      else{
        _proposedMeals.add(meal);
      }
    });
    _proposedMeals.sort((a,b) => getDifferenceOfVotes(b).compareTo(getDifferenceOfVotes(a)));
  }

  @override
  Widget build(BuildContext context) {
    var mealRepository = RepositoryProvider.of<MealRepository>(context);

    return BlocBuilder(
      cubit: mealsCubit,
      builder: (context, state) => Stack(children: [
        Scaffold(
            appBar: AppBar(
              title: Text("Leaderboard"),
              actions: [],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                      padding: EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Column(children: [
                            PlannedMealsList(mealsCubit,meals: _acceptedMeals, isLeaderboard: false, mealContext: mealsContext,),
                            PlannedMealsList(mealsCubit,meals: _proposedMeals, isLeaderboard: true, mealContext: mealsContext, addToAccepted: addMealToAcceptedList, deleteFromUnaccepted: deleteMealFromUnaccepted,)
                          ],);
                        }, childCount: 1),
                      ),
                  ),
                ]
              ),
            ))
      ]),
    );
  }

  addMealToAcceptedList(Meal meal){
    _acceptedMeals.add(meal);
    print("added");
  }
  deleteMealFromUnaccepted(Meal meal){
    _proposedMeals.remove(meal);
    print("deleted");
  }
  mealOnCurrentDay(Meal meal, DateTime date) =>
      meal.date.isAfter(DateTime(date.year, date.month, date.day)) &&
          meal.date.isBefore(
              DateTime(date.year, date.month, date.day).add(Duration(days: 1)));

  int getDifferenceOfVotes(Meal meal) {
    var diff = 0;
    meal.votes.forEach((m) {
      if(m.voteIsPositive){
        diff++;
      }
      else{
        diff--;
      }
    });
    return diff;
  }
}
