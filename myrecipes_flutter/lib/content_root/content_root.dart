import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:group_repository/group_repository.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import 'package:myrecipes_flutter/interceptors/bearer_interceptor.dart';
import 'package:myrecipes_flutter/pages/home_page/home.dart';
import 'package:myrecipes_flutter/pages/pagemealview/pagemealview.dart';
import 'package:myrecipes_flutter/pages/recipepage/recipepage.dart';
import 'package:meal_repository/meal_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';
import '../appbarclipper.dart';
import 'cubit/content_root_cubit.dart';

const kToolbarHeight = 35.0;
var kToolbarRelativeUpperHeight = 1/3;


class Destination {
  const Destination(this.index, this.label, this.icon);

  final String label;
  final IconData icon;
  final int index;
}

const List<Destination> destinations = const [
  Destination(0, "Calendar", Icons.calendar_today),
  Destination(1, "Cookbook", Icons.menu_book),
  Destination(2, "Home", Icons.home),
];

class ContentRoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentRootState();
}


class _ContentRootState extends State<ContentRoot> {
  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContentRootCubit>(
      create: (context) =>
          ContentRootCubit(RepositoryProvider.of<AuthRepository>(context)),
      child: Scaffold(
        appBar: AppBar(
          shape: AppBarBorder(relativeUpperHeight: kToolbarRelativeUpperHeight),
          toolbarHeight: kToolbarHeight,
          primary: false,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text("MyRecipes", style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)),
        ),
        extendBodyBehindAppBar: true,
        body: getDestinationWidget(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: destinations.asMap().entries.map((e) =>
             BottomNavigationBarItem(
              label: e.value.label,
              icon: Icon(e.value.icon),
            )).toList(),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }
        ),
      ),
    );
  }

  Widget getDestinationWidget(int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(4.0).copyWith(top: 4.0+kToolbarHeight, bottom: 0),
          child: PageMealView(),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0).copyWith(top: kToolbarHeight*kToolbarRelativeUpperHeight),
          child: RecipePage(),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(4.0).copyWith(top: 4.0+kToolbarHeight, bottom: 0),
          child: HomePage(),
        );
    }
  }
}
