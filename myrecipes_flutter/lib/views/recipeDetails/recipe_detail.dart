import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/theme.dart';
import 'package:myrecipes_flutter/views/recipeCard/RecipeCard.dart';

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
                    color: Colors.white,
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
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Text("Could not load image"),
                            ),
                          )
                        : Container(
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: ExactAssetImage(
                                    "assets/placeholder-image.png"),
                              ),
                            ),
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
                            color: Colors.black,
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
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
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
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  boxShadow: shadowList,
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recipe.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Row(
                        children: [
                          Icon(PlatformIcons(context).clockSolid),
                          Text("${recipe.cookingTimeInMin} min"),
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
