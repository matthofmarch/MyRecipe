import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/domain/models/vote.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/pages/meal_page/meals_cubit.dart';

class VoteSummary extends StatefulWidget {
  Meal meal;

  VoteSummary(this.meal);

  @override
  State<StatefulWidget> createState() => VoteSummaryState();
}

class VoteSummaryState extends State<VoteSummary> {
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
                    BlocProvider.of<MealsCubit>(context).load();
                  },
                  child: Icon(Icons.arrow_drop_up_outlined,
                      color: _getUserVote(context) ?? true
                          ? Colors.green
                          : Colors.grey,
                      size: 32)),
              Text(widget.meal.votes
                  .where((e) => e.voteIsPositive)
                  .length
                  .toString()),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () async {
                    var vote = false;
                    await _vote(context, vote);
                    BlocProvider.of<MealsCubit>(context).load();
                  },
                  child: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: !(_getUserVote(context) ?? false)
                        ? Colors.red
                        : Colors.grey,
                    size: 32,
                  )),
              Text(widget.meal.votes
                  .where((e) => !e.voteIsPositive)
                  .length
                  .toString()),
            ],
          )
        ],
      ),
    );
  }

  _setUserVote(BuildContext context, bool vote) {
    if (vote == null) {
      widget.meal.votes.add(Vote(voteIsPositive: vote, username: username));
    } else if (vote) {
      if (widget.meal.votes.any((element) => element.username == username)) {
        widget.meal.votes
            .removeWhere((element) => element.username == username);
      } else {
        widget.meal.votes
            .removeWhere((element) => element.username == username);
        widget.meal.votes.add(Vote(voteIsPositive: vote, username: username));
      }
    } else if (!vote) {
      if (widget.meal.votes.any((element) => element.username == username)) {
        widget.meal.votes
            .removeWhere((element) => element.username == username);
      } else {
        widget.meal.votes
            .removeWhere((element) => element.username == username);
        widget.meal.votes.add(Vote(voteIsPositive: vote, username: username));
      }
    }
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
