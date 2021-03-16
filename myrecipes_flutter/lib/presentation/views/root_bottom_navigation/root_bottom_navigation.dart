import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/infrastructure/repositories/auth_repository/auth_repository.dart';
import 'package:myrecipes_flutter/presentation/view_models/root_bottom_navigation/root_bottom_navigation_cubit.dart';
import 'package:myrecipes_flutter/presentation/views/pages/home_page/home_page.dart';
import 'package:myrecipes_flutter/presentation/views/pages/meal_page/meal_page.dart';
import 'package:myrecipes_flutter/presentation/views/pages/recipe_page/recipepage.dart';

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

class RootBottomNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootBottomNavigationState();
}

class _RootBottomNavigationState extends State<RootBottomNavigation> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContentRootCubit>(
      create: (context) =>
          ContentRootCubit(RepositoryProvider.of<AuthRepository>(context)),
      child: Scaffold(
        body: getDestinationWidget(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Theme.of(context).colorScheme.primary,
            items: destinations
                .asMap()
                .entries
                .map((e) => BottomNavigationBarItem(
                      label: e.value.label,
                      icon: Icon(e.value.icon),
                    ))
                .toList(),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            }),
      ),
    );
  }

  Widget getDestinationWidget(int index) {
    switch (index) {
      case 0:
        return MealPage();
      case 1:
        return RecipePage();
      default:
        return HomePage();
    }
  }
}
