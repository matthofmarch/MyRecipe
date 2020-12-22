import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/views/recipeCard/RecipeCard.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  RecipeDetail({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     color: Colors.black,
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   title: Text("Details"),
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   textTheme: Theme.of(context).textTheme,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.edit),
      //       onPressed: null,
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.calendar_today),
      //       onPressed: null,
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.delete_outline),
      //       onPressed: null,
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          RecipeCard(
            recipe: recipe,
          ),
          Card(
            margin: EdgeInsets.all(8),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    indent: 35,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if(recipe.description != null)
                    Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.food_bank),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Ingredients",
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    indent: 35,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ...recipe.ingredientNames.map(
                    (ingredients) {
                      return Row(
                        children: [
                          Badge(
                            badgeColor: Colors.black,
                            elevation: 0,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            ingredients,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      );
                    },
                  ).toList()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
