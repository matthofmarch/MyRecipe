import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/screens/update_recipe/update_recipe.dart';
import 'package:myrecipes_flutter/views/recipeCard/RecipeCard.dart';
import 'package:myrecipes_flutter/views/recipeDetails/recipe_detail.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeList extends StatefulWidget {
  final List<Recipe> _recipes;

  const RecipeList(this._recipes) : super();

  @override
  _RecipeListState createState() => _RecipeListState(_recipes);
}

class _RecipeListState extends State<RecipeList> {
  List<Recipe> _recipes;

  _RecipeListState(this._recipes);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: EdgeInsets.only(top: 130),
          itemCount: _recipes.length,
          itemBuilder: (context, index) {
            final recipe = _recipes[index];
            return GestureDetector(
                onLongPress: () async {
                  await showPlatformModalSheet(
                      context: context,
                      builder: (context) {
                        var popupContent = [
                          PlatformButton(
                              materialFlat: (context, platform) =>
                                  MaterialFlatButtonData(),
                              onPressed: () async {
                                final update = await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => UpdateRecipe(recipe)));

                                if(update != null) setState(() {
                                    _recipes.removeWhere(
                                            (element) => element.id == update.id);
                                    _recipes.add(update);
                                  });
                                Navigator.of(context).pop();

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(context.platformIcons.pen),
                                  PlatformText("Edit")
                                ],
                              )),
                          PlatformButton(
                            materialFlat: (context, platform) =>
                                MaterialFlatButtonData(),
                            onPressed: () async {
                              try {
                                final res = await RepositoryProvider.of<
                                        RecipeRepository>(context)
                                    .delete(recipe.id);
                                if (res) {
                                  setState(() {
                                    _recipes.removeAt(index);
                                  });
                                  Fluttertoast.showToast(
                                      msg: "Deleted Recipe",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } catch (e) {}
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(context.platformIcons.delete),
                                PlatformText("Delete")
                              ],
                            ),
                          ),
                        ];

                        switch (Theme.of(context).platform) {
                          case TargetPlatform.iOS:
                            return CupertinoActionSheet(
                              actions: popupContent,
                            );
                            break;
                          default:
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: popupContent,
                            );
                            break;
                        }
                      });
                },
                child: RecipeCard(
                  recipe: recipe,
                  onClickCallback: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecipeDetail(
                          recipe: recipe,
                        ),
                      ),
                    );
                  },
                ));
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 20,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.only(left: 10, right: 10, top: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.search), onPressed: null),
              Text(
                "Search recipe",
                style: TextStyle(color: Colors.grey),
              ),
              IconButton(icon: Icon(Icons.filter_alt), onPressed: null)
            ],
          ),
        ),
      ],
    );
/*    return ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onLongPress: () async {
                try {
                  final res =
                      await RepositoryProvider.of<RecipeRepository>(context)
                          .delete(recipe.id);
                  if (res) {
                    setState(() {
                      _recipes.removeAt(index);
                    });
                    Fluttertoast.showToast(
                        msg: "Deleted Recipe",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } catch (e) {}
              },
              child: Card(
                child: Column(
                  children: [
                    if (recipe.image != null)
                      Builder(builder: (context) {
                        final image = CachedNetworkImage(
                          imageUrl: recipe.image,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) =>
                              Text("When I grow up, I want to be an Image"),
                          errorWidget: (context, url, error) => Container(),
                        );

                        return image != null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, left: 4, right: 4),
                                child: AspectRatio(
                                    aspectRatio: 3 / 2, child: image),
                              )
                            : Text("Image not available");
                      }),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Text(recipe.name,
                                  style: Theme.of(context).textTheme.headline6,
                                  maxLines: 2)),
                          Row(
                            children: [
                              Icon(PlatformIcons(context).clockSolid),
                              SizedBox(
                                width: 4,
                              ),
                              Text("${recipe.cookingTimeInMin} Minutes"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });*/
  }
}
