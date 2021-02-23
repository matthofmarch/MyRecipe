import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:models/model.dart';

class VoteSummary extends StatefulWidget {
  Meal meal;

  VoteSummary(this.meal);

  @override
  State<StatefulWidget> createState() => VoteSummaryState();
}

class VoteSummaryState extends State<VoteSummary> {
  int positiveVotes;
  int negativeVotes;
  bool userVote;

  @override
  void initState() {
    // TODO: implement initState
    positiveVotes = widget.meal.votes.where((e) => e.voteIsPositive).length;
    negativeVotes = widget.meal.votes.where((e) => e.voteIsPositive).length;
    _getUserVote(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        await _vote(context, false);
                        setState(() {
                          if (userVote == null)
                            positiveVotes++;
                          else if (userVote == true)
                            positiveVotes--;
                          else if (userVote == false) {
                            positiveVotes++;
                            negativeVotes--;
                          }

                          userVote = userVote == null
                              ? true
                              : userVote
                                  ? null
                                  : true;
                        });
                      },
                      child: Icon(Icons.arrow_drop_up_outlined,
                          color: userVote ?? true ? Colors.green : Colors.grey,
                          size: 24)),
                  Text("$positiveVotes"),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () async {
                        await _vote(context, false);
                        setState(() {
                          if (userVote == null)
                            negativeVotes++;
                          else if (userVote == false)
                            negativeVotes--;
                          else if (userVote == true) {
                            negativeVotes++;
                            positiveVotes--;
                          }

                          userVote = userVote == null
                              ? false
                              : !userVote
                                  ? null
                                  : false;
                        });
                      },
                      child: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: !(userVote ?? false) ? Colors.red : Colors.grey,
                        size: 24,
                      )),
                  Text("$negativeVotes"),
                ],
              )
            ],
          ),
        ));
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
    await RepositoryProvider.of<MealRepository>(context)
        .vote(widget.meal.mealId, isPositive);
  }
}
