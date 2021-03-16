import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/presentation/view_models/widgets/meal_view/meal_view_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/screens/daily_meal_planner/daily_meal_planner.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_detail.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/util/network_or_default_image.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/util/rounded_image.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/vote_summary/vote_summary.dart';

int kPageIndentation = 1000;

class MealCalendar extends StatelessWidget {
  List<Meal> meals;
  DateTime viewInitialDate;

  Function(Meal meal) showMealOptions;

  MealCalendar(this.meals, this.viewInitialDate,
      {Key key, this.showMealOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.custom(
      controller: PageController(
          viewportFraction:
              0.94 / ((MediaQuery.of(context).size.width ~/ 320) * 2 + 1),
          initialPage: kPageIndentation),
      onPageChanged: (newPageIndex) {
        BlocProvider.of<MealViewCubit>(context, listen: false)
                .currentDateSilent =
            viewInitialDate
                .add(Duration(days: newPageIndex - kPageIndentation));
      },
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final indentedIndex = index - kPageIndentation;
          DateTime columnDate =
              viewInitialDate.add(Duration(days: indentedIndex));

          return Row(
            children: [
              VerticalDivider(
                indent: 20,
                endIndent: 20,
                width:
                    0, //Else one will see more of the most-left column than the one on the right
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Builder(builder: (context) {
                      voteSum(Meal meal) => meal.votes.fold<int>(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              (element.voteIsPositive ? 1 : -1));
                      meals
                          .sort((m1, m2) => voteSum(m1).compareTo(voteSum(m2)));
                      final mealsForDay = meals
                          .where((m) => mealOnCurrentDay(m, columnDate))
                          .map((m) => _mealCard(context, m))
                          .toList();

                      return ListView(
                          padding: EdgeInsets.only(top: 44),
                          children: mealsForDay.isNotEmpty
                              ? mealsForDay
                              : [
                                  Text(
                                    "No meals",
                                    textAlign: TextAlign.center,
                                  )
                                ]);
                    }),
                    _makeDateBadge(context, columnDate)
                  ],
                ),
              ),
            ],
          );
        },
      ),
      pageSnapping: true,
    );
  }

  mealOnCurrentDay(Meal meal, DateTime date) =>
      meal.date.isAfter(DateTime(date.year, date.month, date.day)) &&
      meal.date.isBefore(
          DateTime(date.year, date.month, date.day).add(Duration(days: 1)));

  Widget _mealCard(BuildContext context, Meal meal) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              recipe: meal.recipe,
            ),
          ),
        );
      },
      onLongPress: () => showMealOptions(meal),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Card(
          margin: EdgeInsets.all(4),
          //color: meal.accepted ? Theme.of(context).cardColor : Theme.of(context).cardColor.withAlpha(0x10),
          key: Key("meal-calendar-card_${meal.mealId}"),
          shadowColor: meal.accepted ? Colors.green : Colors.red,
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(2),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomAbrounding.image(
                    NetworkOrDefaultImage(meal.recipe.image),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VoteSummary(meal),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Proposed by jfd",
                                    style: Theme.of(context).textTheme.caption),
                                Text(
                                  "${meal.recipe.name}",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _makeDateBadge(BuildContext context, DateTime columnDate) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DailyMealPlanner(date: columnDate, meals: meals,)));
      },
      child: Badge(
        child: Chip(
          label: Text(
            DateFormat("E, d.").format(columnDate),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          shape: StadiumBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          elevation: 5,
        ),
        position: BadgePosition.topEnd(top: 5.0, end: 5.0),
        badgeColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
