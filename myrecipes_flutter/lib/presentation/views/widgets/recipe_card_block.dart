import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/recipe.dart';
import 'package:myrecipes_flutter/domain/models/user_recipe.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/util/network_or_default_image.dart';
import 'package:myrecipes_flutter/theme.dart';

class RecipeCardBlock extends StatelessWidget {
  final Recipe recipe;

  RecipeCardBlock(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MediaQuery.of(context).platformBrightness == Brightness.light
          ? BoxDecoration(boxShadow: shadowGrid)
          : null,
      child: Card(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Hero(
                tag: recipe.id,
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
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
                              //recipe.name,
                              "hello lol lol hello halleo dffdsfff dff",
                              maxLines: 2,

                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.more_vert), onPressed: () {})
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
                        if (recipe is UserRecipe)
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 18,
                              ),
                              Text(
                                (recipe as UserRecipe).username ==
                                        RepositoryProvider.of<AuthRepository>(
                                                context)
                                            .authState
                                            .email
                                    ? "You"
                                    : (recipe as UserRecipe).username,
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
