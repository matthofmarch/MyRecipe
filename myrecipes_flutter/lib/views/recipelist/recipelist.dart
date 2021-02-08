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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/update_recipe/update_recipe.dart';
import 'package:myrecipes_flutter/views/recipeCard/RecipeCard.dart';
import 'package:myrecipes_flutter/views/recipeDetails/recipe_detail.dart';
import 'package:myrecipes_flutter/views/recipelist/cubit/recipelist_cubit.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
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
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final recipe = widget.recipes[index];
        return GestureDetector(
          onLongPress: () => showRecipeOptions(context, recipe),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RecipeDetail(
                  recipe: recipe,
                ),
              ),
            );
          },
          child: Column(children: [
            RecipeCard(recipe),
            SizedBox(
              height: 20,
            )
          ]),
        );
      }, childCount: widget.recipes.length),
    );
  }

  Future<void> proposeMeal(BuildContext context, Recipe recipe) async {
    final dateTime = await PlatformDatePicker.showDate(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));

    Navigator.of(context).pop();

    if (dateTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No date selected")));
      return;
    }

    try {
      await RepositoryProvider.of<MealRepository>(context)
          .propose(recipe.id, dateTime);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Meal planned")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Could not plan meal"),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  deleteRecipe(String id) async {
    try {
      final res =
          await RepositoryProvider.of<RecipeRepository>(context).delete(id);
      if (res) {
        setState(() {
          widget.recipes.removeWhere((r) => r.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Deleted Recipe"),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Could not delete Recipe"),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
    Navigator.of(context).pop();
  }

  editRecipe(Recipe recipe) async {
    final update = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UpdateRecipe(recipe)));

    if (update != null)
      setState(() {
        widget.recipes.removeWhere((element) => element.id == update.id);
        widget.recipes.add(update);
      });
    Navigator.of(context).pop();
  }

  Future showRecipeOptions(BuildContext context, Recipe recipe) async {
    await showBarModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            PlatformButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text("Plan"),
                ],
              ),
              materialFlat: (context, platform) => MaterialFlatButtonData(),
              onPressed: () => proposeMeal(context, recipe),
            ),
            PlatformButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(context.platformIcons.pen), Text("Edit")],
              ),
              materialFlat: (context, platform) => MaterialFlatButtonData(),
              onPressed: () => editRecipe(recipe),
            ),
            PlatformButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(context.platformIcons.delete),
                    Text("Delete")
                  ],
                ),
                materialFlat: (context, platform) => MaterialFlatButtonData(),
                onPressed: () => deleteRecipe(recipe.id))
          ]);
        });
  }
}
