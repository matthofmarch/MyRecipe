import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card_block_compact.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/vote_summary/vote_summary_big.dart';

import '../recipe_card.dart';

class PlannedMealsList extends StatelessWidget {
  final List<Meal> meals;
  final bool isLeaderboard;
  var index = 1;

  PlannedMealsList({@required this.meals, @required this.isLeaderboard});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (isLeaderboard) Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Icon(Icons.poll_outlined,size: 35,),
        SizedBox(width: 8,),
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text("Leaderboard", style: Theme.of(context).textTheme.headline3,),
        ),
      ])
      else Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Icon(
          Icons.star_border,
          size: 35,
        ),
        SizedBox(
          width: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            "Winners",
            style: Theme.of(context).textTheme.headline3,
          ),
        )
      ]),
      SizedBox(
        height: 16,
      ),
      if (meals.isEmpty && !isLeaderboard)
        Center(
            child: Text(
          "No Winner selected on this day!",
          style: Theme.of(context).textTheme.headline6,
        ))
      else if(meals.isEmpty && isLeaderboard) Center(child: Text("No Suggestions for this day!",style: Theme.of(context).textTheme.headline6,))
      else
      ...meals.map((meal) {
        if(isLeaderboard){
          var res = Column(children: [
            Row(children: [
              SizedBox(width: 8,),
              Container(width: 30,child: Text(index.toString()+ ".",style: Theme.of(context).textTheme.headline4,)),
              SizedBox(width: 10,),
              Container(width: 180, height: 210,child: RecipeCardBlockCompact(meal.recipe)),
              SizedBox(width: 10,),
              VoteSummaryBig(meal)
            ]),
            SizedBox(
              height: 16,
            )
          ]);
          index++;
          return res;
        }
        else {
          return Column(children: [
            RecipeCard(meal.recipe),
            SizedBox(
              height: 16,
            )
          ]);
        }
      }),
      SizedBox(
        height: 16,
      ),
      if(!isLeaderboard) Center(
          child: Icon(
        Icons.keyboard_arrow_down,
        size: 30,
      )),
      /*Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Icon(
          Icons.poll_outlined,
          size: 35,
        ),
        SizedBox(
          width: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            "Leaderboard",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ]),
      SizedBox(
        height: 16,
      ),*/
    ]);
  }
}
