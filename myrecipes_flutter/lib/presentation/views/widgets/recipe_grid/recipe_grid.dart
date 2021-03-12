import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/recipe_repository/recipe_repository.dart';
import 'package:myrecipes_flutter/presentation/views/screens/update_recipe/update_recipe.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_bottomsheet_card.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_card_block.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_detail.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class RecipeGrid extends StatefulWidget {
  final List<Recipe> recipes;

  const RecipeGrid(this.recipes) : super();

  @override
  _RecipeGridState createState() => _RecipeGridState();
}

class _RecipeGridState extends State<RecipeGrid> {
  @override
  Widget build(BuildContext context) {
    /*return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final recipe = widget.recipes[index];
        return GestureDetector(
          onLongPress: () async {
            await _showRecipeOperationsBottomSheet(context, index);
          },
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
    );*/
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 5 / 6,
          crossAxisSpacing: 5,
          mainAxisSpacing: 3,
          crossAxisCount: MediaQuery.of(context).size.width ~/ 160,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final recipe = widget.recipes[index];
          return GestureDetector(
              onLongPress: () async {
                await _showRecipeBottomSheet(context, recipe);
              },
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecipeDetail(
                      recipe: recipe,
                    ),
                  ),
                );
              },
              child: RecipeCardBlock(recipe));
        }, childCount: widget.recipes.length),
      ),
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
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Meal planned")));
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
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
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Deleted Recipe"),
        ));
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
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

  Future _showRecipeBottomSheet(BuildContext context, Recipe recipe) async {
    await showBarModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(onTap: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => RecipeDetail(recipe: recipe)));
              },child: RecipeBottomSheetCard(recipe)),
              SizedBox(height: 15,),
              Text(
                "Actions",
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: _recipeBottomSheetActions(recipe),
              )
            ]),
          );
        });
  }
  _recipeBottomSheetActions(Recipe recipe){
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await proposeMeal(context, recipe);
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Plan Meal",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            editRecipe(recipe);
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Edit Recipe",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            deleteRecipe(recipe.id);
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever, size: 18,color: Theme.of(context).colorScheme.error),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Delete Recipe",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5,),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch ,
              children: [
                MaterialButton(
                  height: 55,
                  color: Theme.of(context).colorScheme.background,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",style: Theme.of(context).textTheme.subtitle1,),
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}
