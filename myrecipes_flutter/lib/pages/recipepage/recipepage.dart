import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:models/models/recipe.dart';
import 'package:myrecipes_flutter/content_root/content_root.dart' as root;
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/addrecipe/addrecipe.dart';
import 'package:myrecipes_flutter/screens/update_recipe/update_recipe.dart';
import 'package:recipe_repository/recipe_repository.dart';

const kCardContentSpacing = 8.0;

class RecipePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            RecipepageCubit(RepositoryProvider.of<RecipeRepository>(context)),
        child: BlocBuilder<RecipepageCubit, RecipepageState>(
          builder: (context, state) {
            if (state is RecipepageInitial) {
              BlocProvider.of<RecipepageCubit>(context).loadRecipes();
              return Container();
            }
            if (state is RecipepageProgress) {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (state is RecipepageSuccess) {

              return _makeRecipeList(context, state);
            }

            return Container();
          },
        ));
  }

  Widget _makeRecipeList(BuildContext context, RecipepageSuccess state){
    final recipes = state.recipes;
    return Scaffold(
      body: ListView.builder(
        //This padding combined with the one in content_root ensures that the list folds into the toolbar nicely
          padding: EdgeInsets.only(
              top: 4 +
                  root.kToolbarHeight *
                      (1 - root.kToolbarRelativeUpperHeight)),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return _makeRecipeCard(context, recipe);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(context.platformIcons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddRecipe(),
          ));
          BlocProvider.of<RecipepageCubit>(context).loadRecipes();
        },
      ),
    );
  }

  Widget _makeRecipeCard(BuildContext context, Recipe recipe) => FlatButton(
        onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => UpdateRecipe(recipe))),
        padding: EdgeInsets.all(0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(kCardContentSpacing),
            child: Column(
              children: [
                if (recipe.image != null)
                  AspectRatio(
                      aspectRatio: 3 / 2,
                      child: CachedNetworkImage(
                        imageUrl: recipe.image,
                        fit: BoxFit.fitWidth,
                      )),
                SizedBox(
                  height: kCardContentSpacing,
                ),
                Row(
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
              ],
            ),
          ),
        ),
      );
}
