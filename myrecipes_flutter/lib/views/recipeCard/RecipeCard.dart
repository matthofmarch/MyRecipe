import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:models/model.dart';

import '../../theme.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard(this.recipe);

  Widget _makeDecoratedImage(
          BuildContext context, ImageProvider imageProvider) =>
      Container(
          decoration: BoxDecoration(
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: recipe.id,
                child: recipe.image != null
                    ? CachedNetworkImage(
                        imageUrl: recipe.image,
                        fit: BoxFit.fitWidth,
                        imageBuilder: (context, imageProvider) =>
                            _makeDecoratedImage(context, imageProvider),
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Text("Could not load image"),
                      )
                    : _makeDecoratedImage(
                        context, AssetImage("assets/placeholder-image.png")),
              ),
            ),
            Expanded(
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
                      Icon(PlatformIcons(context).clockSolid),
                      Text("${recipe.cookingTimeInMin} min"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
