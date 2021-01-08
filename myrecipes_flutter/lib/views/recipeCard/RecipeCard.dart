import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:models/model.dart';
import 'package:models/models/user_recipe.dart';
import 'package:myrecipes_flutter/views/util/NetworkOrDefaultImage.dart';
import 'package:myrecipes_flutter/views/util/RoundedImage.dart';

import '../../theme.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                  tag: recipe.id,
                  child: CustomAbrounding.image(
                      NetworkOrDefaultImage(recipe.image))),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Flexible(
                    child: Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(height: 8,),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(PlatformIcons(context).clockSolid, size: 14,),
                              SizedBox(
                                width: 1,
                              ),
                              Flexible(
                                child: Text(
                                  "${recipe.cookingTimeInMin} min",
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.overline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8,),
                        if(recipe is UserRecipe)
                          Flexible(
                          flex: 2,
                          child: Text(
                            (recipe as UserRecipe).username,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
