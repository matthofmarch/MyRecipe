import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/addrecipe/addrecipe.dart';
import 'package:recipe_repository/recipe_repository.dart';

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
              return Container(child: Center(child: CircularProgressIndicator()));
            }
            if (state is RecipepageSuccess) {
              final recipes = state.recipes;

              return Scaffold(
                appBar: AppBar(
                  title: Text("MyRecipes"),
                  toolbarHeight: 40,
                ),
                body: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: Column(
                            children: [
                              if (recipe.image != null) Builder(builder: (context) {
                                final image = CachedNetworkImage(
                                    imageUrl: recipe.image,
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) => Text("When I grow up, I want to be an Image"),
                                    errorWidget: (context, url, error) => Container(),
                                );

                                return image != null ?
                                   Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, left: 4, right: 4),
                                    child: AspectRatio(
                                        aspectRatio: 3 / 2,
                                        child: image
                                    ),
                                  ):Text("Image not available");


                                }),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: Text(recipe.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                            maxLines: 2)),
                                    Row(
                                      children: [
                                        Icon(PlatformIcons(context).clockSolid),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                            "${recipe.cookingTimeInMin} Minutes"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
