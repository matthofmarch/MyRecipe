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
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (state is RecipepageSuccess) {
              final recipes = state.recipes;
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(context.platformIcons.add),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddRecipe(),
                    ));
                    BlocProvider.of<RecipepageCubit>(context).loadRecipes();
                  },
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: Container(
                        margin: const EdgeInsets.all(4.0),
                        child: TextFormField(
                          onChanged: (value) =>
                              BlocProvider.of<RecipepageCubit>(context)
                                  .filter(_searchController.text),
                          controller: _searchController,
                          decoration: InputDecoration(
                              hintText: "Search recipes",
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32))),
                              suffixIcon: GestureDetector(
                                  onTap: () =>
                                      BlocProvider.of<RecipepageCubit>(context)
                                          .filter(_searchController.text),
                                  child: Icon(Icons.search)),),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        PreferredSize(
                          preferredSize: Size.fromHeight(40),
                          child: ListView(
                              padding: EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              children: [
                                "Bio",
                                "Vegan",
                                "Gluten-free",
                                "Keto",
                                "Mischkost"
                              ]
                                  .map((e) => Card(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                                        child: Row(
                                          children: [
                                            Icon(Icons.eco),
                                            Text(e),
                                          ],
                                        ),
                                      )))
                                  .toList()),
                        ),
                      ),
                      pinned: true,
                    ),
                    RecipeList(recipes)
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final PreferredSize _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
