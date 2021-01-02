import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/update_recipe/update_recipe.dart';
import 'package:myrecipes_flutter/views/recipeCard/RecipeCard.dart';
import 'package:myrecipes_flutter/views/recipeDetails/recipe_detail.dart';
import 'package:myrecipes_flutter/views/recipelist/cubit/recipelist_cubit.dart';
import 'package:myrecipes_flutter/views/util/custom_platform_datepicker_sheet.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeList extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeList(this.recipes) : super();

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{ await BlocProvider.of<RecipepageCubit>(context).loadRecipes();},
        child: ListView.separated(
          itemCount: widget.recipes.length,
          itemBuilder: (context, index) {
            final recipe = widget.recipes[index];
            return GestureDetector(
                onLongPress: () async {
                  await _showRecipeOperationsBottomSheet(context, index);
                },
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeDetail(
                            recipe: recipe,
                          ),
                    ),
                  );
                },
                child: RecipeCard(recipe));
          },
          separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(
            height: 10,
          ),
        ),
      ),
    );
  }

  _showRecipeOperationsBottomSheet(BuildContext ctx, int index) async {
    return showPlatformModalSheet(
        context: ctx,
        builder: (context) {
          var popupContent = [
            PlatformButton(
              materialFlat: (context, platform) => MaterialFlatButtonData(),
              onPressed: () async {
                final dateTime = await showPlatformModalSheet<DateTime>(
                    context: context,
                    builder: (context) => CustomPlatformDatePickerSheet());
                if (dateTime != null) {
                  try {
                    await RepositoryProvider.of<MealRepository>(context)
                        .propose(widget.recipes[index].id, dateTime);
                    //Scaffold.of(ctx).showSnackBar(SnackBar(content: Text("fslkdfkl")));
                    FToast()
                      ..init(ctx).showToast(
                          msg: "Meal planned",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER_RIGHT,
                          backgroundColor:
                          Theme
                              .of(context)
                              .colorScheme
                              .primary);
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "Could not plan meal",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP_RIGHT,
                        backgroundColor: Theme
                            .of(context)
                            .colorScheme
                            .error);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text("Plan"),
                ],
              ),
            ),
            PlatformButton(
                materialFlat: (context, platform) => MaterialFlatButtonData(),
                onPressed: () async {
                  final update = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              UpdateRecipe(widget.recipes[index])));

                  if (update != null)
                    setState(() {
                      widget.recipes
                          .removeWhere((element) => element.id == update.id);
                      widget.recipes.add(update);
                    });
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(context.platformIcons.pen),
                    Text("Edit")
                  ],
                )),
            PlatformButton(
              materialFlat: (context, platform) => MaterialFlatButtonData(),
              onPressed: () async {
                try {
                  final res =
                  await RepositoryProvider.of<RecipeRepository>(context)
                      .delete(widget.recipes[index].id);
                  if (res) {
                    setState(() {
                      widget.recipes.removeAt(index);
                    });
                    Fluttertoast.showToast(
                        msg: "Deleted Recipe",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP_RIGHT,
                        backgroundColor: Theme
                            .of(context)
                            .colorScheme
                            .primary);
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: "Could not delete Recipe",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP_RIGHT,
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .error);
                }
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(context.platformIcons.delete),
                  Text("Delete")
                ],
              ),
            )
          ];

          switch (Theme
              .of(context)
              .platform) {
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
  }
}
