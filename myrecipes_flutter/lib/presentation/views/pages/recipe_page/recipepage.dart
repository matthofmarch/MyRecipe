import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/recipe_repository/recipe_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/pages/recipe_page/recipe_page_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/screens/add_recipe/add_recipe.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/recipe_grid/recipe_grid.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/search_and_filter/filter_order_recipe.dart';

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
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddRecipe(),
                    ));
                    BlocProvider.of<RecipepageCubit>(context).loadRecipes();
                  },
                ),
                body: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        elevation: 0.0,
                        stretch: true,
                        snap: true,
                        floating: true,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: Container(
                          margin: const EdgeInsets.all(5),
                          child: TextField(
                            onChanged: (value) =>
                                BlocProvider.of<RecipepageCubit>(context)
                                    .filter(_searchController.text),
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search recipes",
                              hintStyle: TextStyle(height: 1.1),
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              filled: true,
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                  onTap: () =>
                                      BlocProvider.of<RecipepageCubit>(context)
                                          .filter(_searchController.text),
                                  child: Icon(Icons.search)),
                            ),
                          ),

                        ),
                      ),
                      _makeFilterHeader(context),
                      RecipeGrid(recipes)
                    ],
                  ),
                ),
              );
            }
            return null;
          },
        ));
  }

  _makeTagHeader(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: ListView(
              padding: EdgeInsets.only(bottom: 10),
              scrollDirection: Axis.horizontal,
              children: ["Bio", "Vegan", "Gluten-free", "Keto", "Mischkost"]
                  .map((e) => Card(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2),
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
    );
  }
  _makeFilterHeader(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _SliverAppBarDelegate(
        PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: FliterOrderRecipe()
        ),
      ),
      pinned: true,
    );
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
