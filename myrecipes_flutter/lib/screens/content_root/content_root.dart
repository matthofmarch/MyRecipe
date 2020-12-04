import 'dart:math';

import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:myrecipes_flutter/screens/home/home.dart';
import 'package:myrecipes_flutter/screens/pagemealview/pagemealview.dart';

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
/*  List<Key> _destinationKeys;
  List<AnimationController> _faders;
  AnimationController _hide;*/
  int _currentIndex = 1;

  PlatformTabController tabController;

  @override
  void initState() {
    super.initState();
    this.tabController = PlatformTabController(initialIndex: 0);
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
      child: PlatformTabScaffold(
        appBarBuilder: (context, index) => PlatformAppBar(
          title: PlatformText("MyRecipes"),
          trailingActions: [
            PlatformIconButton(
              icon: Icon(Icons.logout),
              onPressed: () =>
                  BlocProvider.of<ContentRootCubit>(context).logout(),
            )
          ],
        ),
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
    );
  }

  Widget getDestinationWidget(int destinationIndex) {
    switch (destinationIndex) {
      case 0:
        return Center(
          child: PlatformText("0"),
        );
      case 1:
        return PageMealView();
      default:
        return Home();
    }
  }
}
