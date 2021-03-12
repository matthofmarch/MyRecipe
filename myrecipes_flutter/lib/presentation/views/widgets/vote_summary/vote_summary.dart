import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';

class VoteSummary extends StatefulWidget {
  Meal meal;

  VoteSummary(this.meal);

  @override
  State<StatefulWidget> createState() => VoteSummaryState();
}

class VoteSummaryState extends State<VoteSummary> {
  int positiveVotes;
  int negativeVotes;
  bool userVote = null;

  @override
  void initState() {
    // TODO: implement initState
    positiveVotes = widget.meal.votes.where((e) => e.voteIsPositive).length;
    negativeVotes = widget.meal.votes.where((e) => !e.voteIsPositive).length;
    _getUserVote(context);
  }

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
                    await _vote(context, true);
                    setState(() {
                      if (userVote == null) {
                        positiveVotes++;
                        userVote = false;
                      } else if (!userVote) {
                        positiveVotes--;
                        userVote = null;
                      } else if (userVote) {
                        positiveVotes++;
                        positiveVotes--;
                        userVote = true;
                      }
                    });
                  },
                  child: Icon(Icons.arrow_drop_up_outlined,
                      color: userVote ?? true ? Colors.green : Colors.grey,
                      size: 32)),
              Text("$positiveVotes"),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () async {
                    await _vote(context, false);
                    setState(() {
                      if (userVote == null) {
                        negativeVotes++;
                        userVote = true;
                      } else if (!userVote) {
                        negativeVotes--;
                        userVote = null;
                      } else if (userVote) {
                        negativeVotes++;
                        positiveVotes--;
                        userVote = false;
                      }
                    });
                  },
                  child: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: !(userVote ?? false) ? Colors.red : Colors.grey,
                    size: 32,
                  )),
              Text("$negativeVotes"),
            ],
          )
        ],
      ),
    );
  }

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
