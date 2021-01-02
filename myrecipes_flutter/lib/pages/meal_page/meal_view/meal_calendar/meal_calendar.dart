import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/pages/meal_page/cubit/meals_cubit.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/cubit/meal_view_cubit.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/views/vote_summary.dart';
import 'package:myrecipes_flutter/views/recipeDetails/recipe_detail.dart';

int kPageIndentation = 1000;

class MealCalendar extends StatelessWidget {
  final controller = PageController(viewportFraction: 1 / 3, initialPage: kPageIndentation);
  List<Meal> meals;
  DateTime viewInitialDate;

  MealCalendar(List<Meal> meals, DateTime initialDate, {Key key}):super(key: key){
    this.meals = meals;
    viewInitialDate = initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return PageView.custom(
        controller: controller,
        onPageChanged: (newPageIndex) {
          BlocProvider.of<MealViewCubit>(context).currentDateSilent = viewInitialDate.add(Duration(days: newPageIndex - kPageIndentation));
        },
        childrenDelegate: SliverChildBuilderDelegate(
      //make one column
      (BuildContext context, int index) {
        final indentedIndex = index - kPageIndentation;
        DateTime columnDate =
            viewInitialDate.add(Duration(days: indentedIndex));

        return Container(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      width: 1,
                      color: Theme.of(context).dividerColor))),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Badge(
                  child: Chip(
                    label: PlatformText(
                      DateFormat("E, d.").format(columnDate),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor),
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    elevation: 5,
                  ),
                  position: BadgePosition.topEnd(top: 5.0, end: 5.0),
                  badgeColor: Colors.red,
                ),
              ),
              ...meals
                  .where((m) => mealOnCurrentDay(m, columnDate))
                  .map((m) => _mealCard(context, m))
            ],
          ),
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

  _mealCard(BuildContext context, Meal meal) {
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
      child: Card(
        margin: EdgeInsets.all(4),
        key: Key("meal-calendar-card_${meal.mealId}"),
        shadowColor: Theme.of(context).shadowColor,
        elevation: 2,
        child: AspectRatio(//Make all cards have the same height
          aspectRatio: 3 / 5,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: meal.recipe.id,
                      child: Image.network(
                        meal.recipe.image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VoteSummary(
                            meal
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Text(
                              "${meal.recipe.name}",
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
