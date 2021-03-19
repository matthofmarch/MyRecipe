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
import 'package:myrecipes_flutter/presentation/views/widgets/vote_summary/vote_summary_big.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

import '../../../../domain/models/user_recipe.dart';
import '../../../../domain/models/user_recipe.dart';
import '../../../../domain/models/vote.dart';
import '../../../../infrastructure/repositories/meal_repository/meal_repository.dart';
import '../../../view_models/pages/meal_page/meals_cubit.dart';
import '../../../view_models/widgets/meal_view/meal_view_cubit.dart';
import '../../screens/update_recipe/update_recipe.dart';
import '../recipe_bottomsheet_card.dart';
import '../recipe_detail.dart';
import '../vote_summary/vote_summary.dart';

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
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(onTap: () async {
                      await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => RecipeDetail(recipe: meal.recipe)));
                    },child: RecipeBottomSheetCard(meal.recipe)),
                  ),
                  Container(
                    height: 100,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top :15.0),
                      child: VoteSummary(meal),
                    ),
                  )
                ]
              ),
              SizedBox(height: 15,),
              Text(
                "Actions",
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: _recipeBottomSheetActions(meal,_),
              )
            ]),
          );
        });
  }
  _recipeBottomSheetActions(Meal meal, BuildContext context){
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await editRecipe(meal.recipe,context);
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 18),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Edit Recipe",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
            await RepositoryProvider.of<MealRepository>(context).deleteMealById(meal.mealId);
            BlocProvider.of<MealViewCubit>(context).emitInteraction(forceReload: true);
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey.shade300).color, width: 1)
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever, size: 18,color: Theme.of(context).colorScheme.error),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Delete Meal",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w400,color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5,),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch ,
                children: [
                  MaterialButton(
                    height: 55,
                    color: darkModeOn? Theme.of(context).backgroundColor : Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",style: Theme.of(context).textTheme.subtitle1,),
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }
  editRecipe(UserRecipe recipe, BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UpdateRecipe(recipe)));
    Navigator.of(context).pop();
  }
}
