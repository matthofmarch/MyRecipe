import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/views/vote_summary.dart';

const kDefaultSpacing = 8.0;

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
        child: Padding(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: Row(
            children: [
              VoteSummary(_meals[index]),
              SizedBox(
                width: kDefaultSpacing,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: _meals[index].recipe.image != null
                        ? CachedNetworkImage(
                            imageUrl: _meals[index].recipe.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Text("Loading"),
                            errorWidget: (context, url, error) =>
                                Text("Could not load image"),
                          )
                        : Image.asset(
                            "assets/placeholder-image.png",
                            fit: BoxFit.cover,
                          )),
              ),
              SizedBox(
                width: kDefaultSpacing,
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
      ),
    );
  }
}
