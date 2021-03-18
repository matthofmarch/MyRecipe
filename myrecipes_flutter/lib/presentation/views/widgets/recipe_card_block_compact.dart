import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/domain/models/user_recipe.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/util/network_or_default_image.dart';
import 'package:myrecipes_flutter/theme.dart';

import '../../../domain/models/user_recipe.dart';

class RecipeCardBlockCompact extends StatelessWidget {
  final UserRecipe recipe;

  RecipeCardBlockCompact(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MediaQuery.of(context).platformBrightness == Brightness.light
          ? BoxDecoration(boxShadow: shadowGrid)
          : null,
      child: Card(
        shape: Theme.of(context).cardTheme.copyWith(shape:
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          )).shape,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Hero(
                tag: recipe.id,
                child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                        bottom: Radius.circular(0),
                    ),
                    child: NetworkOrDefaultImage(recipe.image)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              recipe.name,
                              maxLines: 1,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              size: 18,
                            ),
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
                        SizedBox(
                          height: 4,
                        ),
                        if(recipe.username != null) Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 18,
                              ),
                              Text(
                                recipe.username ==
                                        RepositoryProvider.of<AuthRepository>(
                                                context)
                                            .authState
                                            .email
                                    ? "You"
                                    : recipe.username,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
