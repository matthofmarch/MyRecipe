import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/cubit/meal_view_cubit.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/meal_calendar/meal_calendar.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/meal_list/meal_list.dart';

class MealView extends StatelessWidget {
  List<Meal> meals;

  MealView(this.meals);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MealViewCubit>(
      create: (context) => MealViewCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<MealViewCubit, MealViewState>(
            builder: (context, state) => GestureDetector(
              onTap: () async {
                DateTime pickedDate;
                if (Theme.of(context).platform == TargetPlatform.android) {
                  pickedDate = await showDatePicker(
                      context: context,
                      initialDate: state.currentDate,
                      lastDate: DateTime(2100),
                      firstDate: DateTime(2020));
                } else if (Theme.of(context).platform == TargetPlatform.iOS) {
                  pickedDate = await showDialog(
                      context: context,
                      builder: (context) {
                        DateTime dateTime = state.currentDate;
                        return SimpleDialog(
                          title: Text("Select date", textAlign: TextAlign.center,),
                          titlePadding: EdgeInsets.all(8),
                            contentPadding: EdgeInsets.all(8),
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 400
                                ),

                                child: StatefulBuilder(
                                  builder: (context, setState) => CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (DateTime value) {
                                      setState(() {
                                        dateTime = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              FlatButton(onPressed: () => Navigator.of(context).pop(dateTime), child: Text("Ok"),)
                            ],
                        );
                      });
                }

                if (pickedDate != null)
                  BlocProvider.of<MealViewCubit>(context).currentDate =
                      pickedDate;
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined),
                  Text(
                    DateFormat.yMEd().format(state.currentDate),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            BlocBuilder<MealViewCubit, MealViewState>(
              buildWhen: (previous, current) =>
                  previous.showCalendar != current.showCalendar,
              builder: (context, state) => GestureDetector(
                onTap: () => BlocProvider.of<MealViewCubit>(context)
                    .showCalendar = !state.showCalendar,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    state.showCalendar
                        ? Icons.list
                        : Icons.calendar_today_outlined,
                  ),
                ),
              ),
            )
          ],
        ),
        body: BlocBuilder<MealViewCubit, MealViewState>(
            buildWhen: (previous, current) =>
                previous.showCalendar != current.showCalendar ||
                current.forceReload,
            builder: (context, state) => state.showCalendar
                ? MealCalendar(meals, state.currentDate)
                : MealList(meals)),
      ),
    );
  }
}
