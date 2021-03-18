import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/domain/models/vote.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/pages/meal_page/meals_cubit.dart';

import '../../../view_models/pages/meal_page/meals_cubit.dart';
import '../../../view_models/pages/meal_page/meals_cubit.dart';

class VoteSummaryBig extends StatefulWidget {
  Meal meal;

  VoteSummaryBig(this.mealsCubit,this.meal);

  final MealsCubit mealsCubit;

  @override
  State<StatefulWidget> createState() => VoteSummaryBigState();
}

class VoteSummaryBigState extends State<VoteSummaryBig> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                  onTap: () async {
                    var vote = true;
                    await _vote(context, vote);
                    widget.mealsCubit.load();
                  },
                  child: Icon(Icons.thumb_up_alt,
                      color: _getUserVote(context) ?? true
                          ? Colors.green
                          : Colors.grey,
                      size: 55)),
              SizedBox(width: 8,),
              Text(widget.meal.votes
                  .where((e) => e.voteIsPositive)
                  .length
                  .toString(),style: Theme.of(context).textTheme.headline4,),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              GestureDetector(
                  onTap: () async {
                    var vote = false;
                    await _vote(context, vote);
                    widget.mealsCubit.load();
                  },
                  child: Icon(
                    Icons.thumb_down_alt,
                    color: !(_getUserVote(context) ?? false)
                        ? Colors.red
                        : Colors.grey,
                    size: 55,
                  )),
              SizedBox(width: 8,),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(widget.meal.votes
                    .where((e) => !e.voteIsPositive)
                    .length
                    .toString(),style: Theme.of(context).textTheme.headline4,),
              ),
            ],
          )
        ],
      ),
    );
  }

  get username =>
      RepositoryProvider.of<AuthRepository>(context).authState.email;

  bool _getUserVote(BuildContext context) {
    String email =
        RepositoryProvider.of<AuthRepository>(context).authState.email;
    var first = widget.meal.votes.firstWhere(
      (element) => element.username.toUpperCase() == email.toUpperCase(),
      orElse: () => null,
    );
    return first?.voteIsPositive;
  }

  _vote(BuildContext context, bool isPositive) async {
    await RepositoryProvider.of<MealRepository>(context, listen: false)
        .vote(widget.meal.mealId, isPositive);
  }
}
