import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/pages/home_page/home_page.dart';
import 'package:myrecipes_flutter/pages/meal_page/meal_page.dart';
import 'package:myrecipes_flutter/pages/recipepage/recipepage.dart';
import 'cubit/content_root_cubit.dart';

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
        body: getDestinationWidget(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Theme.of(context).colorScheme.primary,
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
        return MealPage();
      case 1:
        return RecipePage();
      default:
        return HomePage();
    }
  }
}
