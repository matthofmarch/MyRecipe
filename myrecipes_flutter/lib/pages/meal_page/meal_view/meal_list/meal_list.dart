import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:models/model.dart';

class MealList extends StatelessWidget {
  List<Meal> _meals;

  MealList(this._meals);

  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      childrenDelegate: SliverChildBuilderDelegate(_makeMealListItem,
          childCount: _meals.length),
    );
  }

  Widget _makeMealListItem(context, index) {
    return SizedBox(
      height: 100,
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: _meals[index].recipe.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Text(_meals[index].recipe.name),
                    Text(_meals[index].recipe.cookingTimeInMin.toString()),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _meals[index].recipe.description,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
