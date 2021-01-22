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
    return Container(
      height: 95,
      decoration: MediaQuery.of(context).platformBrightness == Brightness.light ? BoxDecoration(boxShadow: shadowList) : null,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Builder(
              builder: (context) {
                return recipe.image != null
                    ? Hero(
                  tag: recipe.id,
                  child: CachedNetworkImage(
                    imageUrl: recipe.image,
                    fit: BoxFit.fitWidth,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Text("Loading"),
                    errorWidget: (context, url, error) =>
                        Text("Could not load image"),
                  ),
                )
                    : Container(
                 height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ExactAssetImage(
                          "assets/placeholder-image.png"),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              height: 95,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Theme.of(context).cardColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(PlatformIcons(context).clockSolid),
                          Text(" ${recipe.cookingTimeInMin} min"),
                        ],
                      ),
                      Text("${(recipe as UserRecipe).username}")
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
