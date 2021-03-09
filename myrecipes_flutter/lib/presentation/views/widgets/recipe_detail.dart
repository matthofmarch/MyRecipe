import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/domain/models/user_recipe.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/util/rounded_image.dart';
import 'package:myrecipes_flutter/theme.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;

  RecipeDetail({this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 10),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    return recipe.image != null
                        ? Hero(
                            tag: recipe.id,
                            child: CachedNetworkImage(
                              imageUrl: recipe.image,
                              fit: BoxFit.fitWidth,
                              imageBuilder: (context, imageProvider) =>
                                  CustomAbrounding.provider(imageProvider),
                              errorWidget: (context, url, error) =>
                                  Text("Could not load image"),
                            ),
                          )
                        : CustomAbrounding.provider(
                            ExactAssetImage("assets/placeholder-image.png"),
                          );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 55),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
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
                            indent: 35,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          if (recipe.description != null)
                            Text(
                              recipe.description,
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 55),
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
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
                                    badgeColor: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .color,
                                    elevation: 0,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ingredients,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ).toList()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 150,
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? shadowList
                      : null),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recipe.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.watch_later),
                          Text("${recipe.cookingTimeInMin} min"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.person),
                          Text("${(recipe as UserRecipe).username}")
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
