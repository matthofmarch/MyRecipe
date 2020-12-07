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
  PlatformTabController tabController;

  @override
  void initState() {
    super.initState();
    this.tabController = PlatformTabController(initialIndex: 1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContentRootCubit>(
      create: (context) =>
          ContentRootCubit(RepositoryProvider.of<AuthRepository>(context)),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 35),
          child: ClipPath(clipper: AppBarClipper(),clipBehavior: Clip.hardEdge,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Center(child: Text("MyRecipes", style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white))),
            ),),
        ),
        body: PlatformTabScaffold(
          bodyBuilder: (context, index) => getDestinationWidget(index),
          tabController: tabController,
          items: destinations.asMap().entries.map((entry) {
            final destination = entry.value;
            return BottomNavigationBarItem(
              label: destination.label,
              icon: Icon(destination.icon),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget getDestinationWidget(int index) {
    switch (index) {
      case 0:
        return PageMealView();
      case 1:
        return RecipePage();
      default:
        return HomePage();
    }
  }
}
