import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/addrecipe/addrecipe.dart';
import 'package:recipe_repository/recipe_repository.dart';

import 'RecipeCard.dart';

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
              final recipes = state.recipes;

              return Scaffold(
                appBar: AppBar(
                  title: Text("Recipes"),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  textTheme: Theme.of(context).textTheme,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.filter_alt),
                      onPressed: null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: null,
                    ),
                  ],
                ),
                body: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return RecipeCard(
                        recipe: recipe,
                        onClickCallback: () => print("Clicked recipe Card"),
                      );
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

            return Container();
          },
        ));
  }
}
