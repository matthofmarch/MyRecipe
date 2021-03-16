import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card.dart';

class PlannedMealsList extends StatelessWidget {
  final List<Meal> meals;

  PlannedMealsList({@required this.meals});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star_border,size: 35,),
              SizedBox(width: 8,),
              Padding(
                padding: const EdgeInsets.only(bottom : 3.0),
                child: Text("Winners", style: Theme.of(context).textTheme.headline3,),
              )
            ]),
        SizedBox(height: 16,),
        if (meals.isEmpty) Center(child: Text("No Winner selected on this day!", style: Theme.of(context).textTheme.headline6,))
        else SizedBox(height: 16,),
        ... meals.map((meal) => Column(children: [
          RecipeCard(meal.recipe),
          SizedBox(height: 16,)
        ])),
        SizedBox(height: 8,),
        Center(child: Icon(Icons.keyboard_arrow_down,size: 30,))
    ],);
  }
}
