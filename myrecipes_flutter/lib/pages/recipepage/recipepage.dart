import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/addrecipe/addrecipe.dart';
import 'package:myrecipes_flutter/views/recipelist/recipelist.dart';
import 'dart:developer' as dev;
import 'package:recipe_repository/recipe_repository.dart';

class RecipePage extends StatelessWidget {
  final _searchController = TextEditingController();

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
                body: RecipeList(recipes),
                floatingActionButton: FloatingActionButton(
                  child: Icon(context.platformIcons.add),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddRecipe(),
                    ));
                    BlocProvider.of<RecipepageCubit>(context).loadRecipes();
                  },
                ),
                extendBodyBehindAppBar: true,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(98),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextField(
                            onChanged: (value) => BlocProvider.of<RecipepageCubit>(context).filter(_searchController.text),
                            controller: _searchController,
                            decoration: InputDecoration(
                                hintText: "Search recipes",
                                contentPadding: EdgeInsets.all(6),
                                fillColor: Theme.of(context).dialogBackgroundColor,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                suffixIcon: GestureDetector(onTap: () => BlocProvider.of<RecipepageCubit>(context).filter(_searchController.text),child: Icon(Icons.search)),
                                focusColor: Theme.of(context).colorScheme.surface
                            ),
                          ),
                            /*material: (context, platform) => MaterialTextFieldData(
                              decoration:
                              InputDecoration(
                                hintText: "Search recipes",
                                contentPadding: EdgeInsets.all(6),
                                  fillColor: Theme.of(context).colorScheme.surface,
                                  filled: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                  suffixIcon: GestureDetector(onTap: () => BlocProvider.of<RecipepageCubit>(context).filter(_searchController.text),child: Icon(Icons.search, color: Theme.of(context).scaffoldBackgroundColor,)),
                                  focusColor: Theme.of(context).colorScheme.surface
                              ),
                            ),
                          ),*/
                        ),
                        SizedBox(height: 4,),
                        Flexible(
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            scrollDirection: Axis.horizontal,
                              children: ["Bio", "Vegan", "Gluten-free", "Keto", "Mischkost"]
                                  .map((e) => Card(child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.eco),
                                        Text(e),
                                      ],
                                    ),
                                  )))
                                  .toList()),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }

            return Container();
          },
        ));
  }
}
