import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_repository/meal_repository.dart';

import 'cubit/pagemealview_cubit.dart';
import 'pagemealcontent/PageMealContent.dart';

class PageMealView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PagemealviewCubit>(
      create: (context) =>
          PagemealviewCubit(RepositoryProvider.of<MealRepository>(context)),
      child: BlocBuilder<PagemealviewCubit, PagemealviewState>(
          builder: (context, state) {
        if (state is PagemealviewInitial) {
          BlocProvider.of<PagemealviewCubit>(context).load();
          return Container();
        }
        if (state is PagemealviewLoading) {
          return CircularProgressIndicator();
        }
        if (state is PagemealviewSuccess) {
          return _makeCalendar(context, state);
        }
        return Container();
      }),
    );
  }

  Widget _makeCalendar(BuildContext context, PagemealviewSuccess state) {
    return MealCalendar(state.meals, DateTime.now());
  }
}
