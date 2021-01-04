import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:models/model.dart';
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
                child: CustomAbrounding.image(NetworkOrDefaultImage(recipe.image))
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("By Andi Gyptra", maxLines: 1, overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.caption,),
                        SizedBox(width: 16,),
                        Row(children: [
                          Icon(PlatformIcons(context).clockSolid, size: 16,),
                          SizedBox(width: 4,),
                          Text("${recipe.cookingTimeInMin} min", style: Theme.of(context).textTheme.overline,),
                        ],)

                      ],
                    ),
                    Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
