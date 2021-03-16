import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card.dart';

class MealLeaderboard extends StatelessWidget {
  final List<Meal> meals;

  MealLeaderboard({@required this.meals});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Icon(Icons.poll_outlined,size: 35,),
        SizedBox(width: 8,),
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text("Leaderboard", style: Theme.of(context).textTheme.headline3,),
        ),
      ]),
      SizedBox(height: 16,),
      /*if (meals == null || meals.isEmpty ) Text("No Suggestions for this day!",style: Theme.of(context).textTheme.headline5,) else
        ... meals.map((meal) => Column(children: [
        Row(children: [
          Icon(Icons.emoji_events),
          RecipeCard(meal.recipe)
        ]),
        SizedBox(height: 16,)
      ]))*/
    ],);
  }
}
