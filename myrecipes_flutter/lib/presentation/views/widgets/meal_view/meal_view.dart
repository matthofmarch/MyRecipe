import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myrecipes_flutter/domain/models/meal.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/meal_repository/meal_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/pages/meal_page/meals_cubit.dart';
import 'package:myrecipes_flutter/presentation/view_models/widgets/meal_view/meal_view_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/meal_calendar/meal_calendar.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/meal_list/meal_list.dart';
import 'package:myrecipes_flutter/presentation/views/widgets/vote_summary/vote_summary.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class MealView extends StatelessWidget {
  List<Meal> meals;

  MealView(this.meals);

  @override
  Widget build(BuildContext rootContext) {
    return BlocProvider<MealViewCubit>(
      create: (context) => MealViewCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<MealViewCubit, MealViewState>(
            buildWhen: (previous, current) =>
                previous.currentDate != current.currentDate,
            builder: (context, state) => GestureDetector(
              onTap: () async {
                print(Theme.of(context).brightness);
                DateTime pickedDate = await PlatformDatePicker.showDate(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(9999));

                if (pickedDate != null)
                  BlocProvider.of<MealViewCubit>(context, listen: false)
                      .currentDate = pickedDate;
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined),
                  SizedBox(
                    width: 5,
                  ),
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
            ),
          ],
        ),
        body: BlocBuilder<MealViewCubit, MealViewState>(
            buildWhen: (previous, current) =>
                previous.showCalendar != current.showCalendar ||
                current.forceReload,
            builder: (context, state) => state.showCalendar
                ? MealCalendar(
                    meals,
                    state.currentDate,
                    showMealOptions: _showMealOptions,
                  )
                : MealList(meals)),
      ),
    );
  }

  _showMealOptions(BuildContext context, Meal meal) {
    var mealsCubit = BlocProvider.of<MealsCubit>(context);
    showBarModalBottomSheet(
        context: context,
        builder: (_) {
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
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [VoteSummary(meal)],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.delete), Text("Delete")],
                ),
                SizedBox(
                  height: 8,
                ),
                if (RepositoryProvider.of<AuthRepository>(context)
                    .authState
                    .isAdmin)
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.check), Text("Accept")],
                    ),
                    onPressed: () async {
                      await RepositoryProvider.of<MealRepository>(context)
                          .acceptMealProposal(meal.mealId, true);
                      BlocProvider.of<MealsCubit>(context).load();
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
        });
  }
}
