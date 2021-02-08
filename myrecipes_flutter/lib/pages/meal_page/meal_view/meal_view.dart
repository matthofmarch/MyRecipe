import 'dart:io';

import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:models/model.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/cubit/meal_view_cubit.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/meal_calendar/meal_calendar.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_view/meal_list/meal_list.dart';
import 'package:myrecipes_flutter/views/appbar/CustomDefaultAppBar.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class MealView extends StatelessWidget {
  List<Meal> meals;

  MealView(this.meals);

  @override
  Widget build(BuildContext rootContext) {
    return BlocProvider<MealViewCubit>(
      create: (context) => MealViewCubit(),
      child: Scaffold(
        appBar: CustomDefaultAppBar(
          title: BlocBuilder<MealViewCubit, MealViewState>(
            builder: (context, state) => GestureDetector(
              onTap: () async {
                print(Theme.of(context).brightness);
                DateTime pickedDate = await PlatformDatePicker.showDate(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2021));

                if (pickedDate != null)
                  BlocProvider.of<MealViewCubit>(context).currentDate = pickedDate;
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
                ? MealCalendar(meals, state.currentDate, )
                : MealList(meals)),
      ),
    );
  }

  _showMealOptions(BuildContext context){
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Meal Actions",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(context.platformIcons.pen), Text("Delete")],
            ),
            SizedBox(height: 8,),
            if(RepositoryProvider.of<AuthRepository>(context).authState.isAdmin)
              PlatformButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(context.platformIcons.checkMark), Text("Accept")],
                ),
                materialFlat: (context, platform) => MaterialFlatButtonData(),
                onPressed: () {},
              )
          ],
        );
      },
    );
  }
}