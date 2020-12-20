import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:models/model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Function onClickCallback;

  RecipeCard({this.recipe, this.onClickCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickCallback,
      child: Card(
        elevation: 7,
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Builder(
              builder: (context) {
                return recipe.image != null
                    ? AspectRatio(
                        aspectRatio: 3 / 2,
                        child: CachedNetworkImage(
                          imageUrl: recipe.image,
                          fit: BoxFit.fitWidth,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Text("Loading"),
                          errorWidget: (context, url, error) =>
                              Text("Could not load image"),
                        ),
                      )
                    : Text("Image not available");
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(PlatformIcons(context).clockSolid),
                      SizedBox(
                        width: 4,
                      ),
                      Text("${recipe.cookingTimeInMin} Minutes"),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Flexible(
                    child: Text(recipe.name,
                        style: Theme.of(context).textTheme.headline5,
                        maxLines: 2),
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
