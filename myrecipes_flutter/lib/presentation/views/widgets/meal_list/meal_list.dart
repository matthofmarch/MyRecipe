import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/domain/models/user_recipe.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/vote_summary.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

const kDefaultSpacing = 8.0;

class MealList extends StatelessWidget {
  List<Meal> _meals;

  MealList(this._meals);

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Meal>> dateMealMap = groupBy<Meal, DateTime>(
        _meals, (r) => DateTime(r.date.year, r.date.month, r.date.day));

    return InfiniteList(
        negChildCount: 0,
        posChildCount: dateMealMap.length,
        builder: (BuildContext context, int index) {
          /// Builder requires [InfiniteList] to be returned
          return InfiniteListItem.overlay(
            /// Header builder
            headerBuilder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                        DateFormat('MMM')
                            .format(dateMealMap.keys.elementAt(index)),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                    ),
                    Text(
                        DateFormat('MM')
                            .format(dateMealMap.keys.elementAt(index)),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                    ),
                  ]
                ),
              );
            },

            /// Content builder
            contentBuilder: (BuildContext context) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,bottom: 15),
                  child: Column(children: [
                    ...dateMealMap.entries
                      .elementAt(index)
                      .value
                      .map((value) => _makeMealListItem(context, value)),
                ]),
              ));
            },
          );
        });
    /*return ListView.custom(
      childrenDelegate: SliverChildBuilderDelegate(_makeMealListItem,
          childCount: _meals.length),
    );*/
  }

  Widget _makeMealListItem(context, Meal meal) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          SizedBox(width: 60,),
          Expanded(child: RecipeCard(_recipeToUserRecipe(meal.recipe))),
          VoteSummary(meal),
          SizedBox(width: 10,)
        ]),
      ),
    );
  }

  UserRecipe _recipeToUserRecipe(Recipe recipe) {
    return UserRecipe(
        id: recipe.id,
        addToGroupPool: recipe.addToGroupPool,
        cookingTimeInMin: recipe.cookingTimeInMin,
        description: recipe.description,
        image: recipe.image,
        ingredientNames: recipe.ingredientNames,
        name: recipe.name);
  }
}
