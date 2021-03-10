import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/presentation/view_models/pages/recipe_page/recipe_page_cubit.dart';

class RecipeSearchBar extends StatelessWidget {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,

      child: TextField(
        onChanged: (value) =>
            BlocProvider.of<RecipepageCubit>(context)
                .filter(_searchController.text),
        controller: _searchController,

        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: GestureDetector(
                onTap: () =>
                    BlocProvider.of<RecipepageCubit>(context)
                        .filter(_searchController.text),
                child: Icon(Icons.search_outlined,size: 25,)),
            hintText: 'Search here...',
            hintStyle: TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 18
            )
        ),
      ),
    );
  }
    /*TextField(
        onChanged: (value) =>
            BlocProvider.of<RecipepageCubit>(context)
                .filter(_searchController.text),
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search recipes",
          hintStyle: TextStyle(height: 1.1),
          fillColor:
              Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(20))),
          suffixIcon: GestureDetector(
              onTap: () =>
                  BlocProvider.of<RecipepageCubit>(context)
                      .filter(_searchController.text),
              child: Icon(Icons.search)),
        ),
      ),*/
}