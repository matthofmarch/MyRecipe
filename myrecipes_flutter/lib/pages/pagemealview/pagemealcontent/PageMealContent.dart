import 'dart:math';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/views/recipeDetails/recipe_detail.dart';

int kPageIdentation = 1000;

@immutable
class MealCalendar extends StatefulWidget {
  final DateTime originalDate;
  final List<Meal> meals;
  PageController controller =
      PageController(viewportFraction: 1 / 3, initialPage: kPageIdentation);

  MealCalendar(this.meals, this.originalDate);

  @override
  _MealCalendarState createState() => _MealCalendarState();
}

class _MealCalendarState extends State<MealCalendar> {
  int _pageOffset = 0;

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = widget.originalDate.add(Duration(days: _pageOffset));
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          child: Text(DateFormat.yMMMMd().format(currentDate),
              style: Theme.of(context).textTheme.headline6),
          onPressed: () async {
            final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100));
            if (pickedDate != null) {
              setState(() {
                _pageOffset =
                    pickedDate.difference(widget.originalDate).inDays.round();
                widget.controller.jumpToPage(kPageIdentation + _pageOffset);
              });
            }
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textTheme: Theme.of(context).textTheme,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_sharp),
            onPressed: null,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: PageView.custom(
            controller: widget.controller,
            onPageChanged: (newPageIndex) {
              setState(() {
                _pageOffset = newPageIndex - kPageIdentation;
              });
            },
            childrenDelegate: SliverChildBuilderDelegate(
              //make one column
              (BuildContext context, int index) {
                final indentedIndex = index - kPageIdentation;
                DateTime columnDate =
                    widget.originalDate.add(Duration(days: indentedIndex));

                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              width: 1,
                              color: Theme.of(context).dividerColor))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Badge(
                          child: Chip(
                            label: PlatformText(
                              DateFormat("E, d.").format(columnDate),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            elevation: 5,
                          ),
                          position: BadgePosition.topEnd(top: 5.0, end: 5.0),
                          badgeColor: Colors.red,
                        ),
                      ),
                      ...widget.meals
                          .where((m) => mealOnCurrentDay(m, columnDate))
                          .map((m) => _mealCard(context, m))
                    ],
                  ),
                );
              },
            ),
            pageSnapping: true,
          )),
        ],
      ),
    );
  }

  mealOnCurrentDay(Meal meal, DateTime date) =>
      meal.date.isAfter(DateTime(date.year, date.month, date.day)) &&
      meal.date.isBefore(
          DateTime(date.year, date.month, date.day).add(Duration(days: 1)));

  _mealCard(BuildContext context, Meal meal) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              recipe: meal.recipe,
            ),
          ),
        );
      },
      child: Padding(
        key: Key(meal.mealId),
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Card(
            shadowColor: Theme.of(context).shadowColor,
            elevation: 2,
            child: AspectRatio(
              aspectRatio: 3 / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        meal.recipe.image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${meal.recipe.name}",
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              "${meal.recipe.description}",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
