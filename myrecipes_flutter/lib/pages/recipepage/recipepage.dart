import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/pages/recipepage/cubit/recipepage_cubit.dart';
import 'package:myrecipes_flutter/screens/addrecipe/addrecipe.dart';
import 'package:myrecipes_flutter/views/recipelist/recipelist.dart';
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
                  preferredSize: Size.fromHeight(110),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                    child: Column(
                      children: [
                        Flexible(
                          child: PlatformTextField(
                            onChanged: (value) => BlocProvider.of<RecipepageCubit>(context).filter(_searchController.text),
                            controller: _searchController,
                            material: (context, platform) => MaterialTextFieldData(
                              decoration:
                              InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                  suffixIcon: GestureDetector(onTap: () => BlocProvider.of<RecipepageCubit>(context).filter(_searchController.text),child: Icon(Icons.search)),
                                  focusColor: Theme.of(context).colorScheme.surface
                              ),
                            ),
                          ),
                        ),
                        Row(
                            children: ["Bio", "Vegan", "Gluten-free"]
                                .map((e) => Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Chip(label: Text(e)),
                            ))
                                .toList())
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
