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

class _ContentRootState extends State<ContentRoot>
    with TickerProviderStateMixin<ContentRoot> {
  List<Key> _destinationKeys;
  List<AnimationController> _faders;
  AnimationController _hide;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    _faders = destinations.map((Destination destination) {
      return AnimationController(
        vsync: this,
        duration: kThemeAnimationDuration,
      );
    }).toList();
    _faders[_currentIndex].value = 0.3;
    _destinationKeys =
        List.generate(destinations.length, (index) => GlobalKey());
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    for (var controller in _faders) controller.dispose();
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0 || !(notification is UserScrollNotification)) {
      print("Not a scroll Notification");
      return false;
    }
    final UserScrollNotification userScroll = notification;
    switch (userScroll.direction) {
      case ScrollDirection.forward:
        _hide.forward();
        break;
      case ScrollDirection.reverse:
        _hide.reverse();
        break;
      case ScrollDirection.idle:
        break;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _hide.forward();

    return BlocProvider<ContentRootCubit>(
      create: (context) =>
          ContentRootCubit(RepositoryProvider.of<AuthRepository>(context)),
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: PlatformTabScaffold(
          appBarBuilder:(context, index) =>  PlatformAppBar(
            title: PlatformText("MyRecipes"),
            trailingActions: [
              PlatformIconButton(
                icon: Icon(Icons.logout),
                onPressed: () =>
                    BlocProvider.of<ContentRootCubit>(context).logout(),
              )
            ],
          ),
          itemChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          bodyBuilder:(context, index) =>  SafeArea(
            top: true,
            child: Stack(
                fit: StackFit.expand,
                children: destinations.map((destination) {
                  final destinationIndex = destination.index;
                  final Widget view = FadeTransition(
                    opacity: _faders[destinationIndex]
                        .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                    child: KeyedSubtree(
                        key: _destinationKeys[destinationIndex],
                        child: getDestinationWidget(destinationIndex)),
                  );
                  //If same screen
                  if (destinationIndex == _currentIndex) {
                    _faders[destinationIndex].forward();
                    return view;
                  }

                  _faders[destinationIndex].reverse();
                  if (_faders[destinationIndex].isAnimating) {
                    return IgnorePointer(child: view);
                  }
                  return Offstage(child: view);
                }).toList()),
          ),
          tabController: PlatformTabController(
            android: MaterialTabControllerData(
              initialIndex: 1
            ),
            ios: CupertinoTabControllerData(
              initialIndex: 1
            )
          ),
            items: destinations.map((Destination destination) {
              return BottomNavigationBarItem(
                  label: destination.label,
                  icon: Icon(destination.icon),
                  backgroundColor: theme.colorScheme.surface);
            }).toList(),

          cupertino: (context, platform) => CupertinoTabScaffoldData(

          ),
          material: (context, platform) => MaterialTabScaffoldData(

            /*bottomSheet: ClipRect(
              child: SizeTransition(
                sizeFactor: _hide,
                axisAlignment: -1.0,
                child: BottomNavigationBar(
                    unselectedItemColor:
                        theme.colorScheme.onSurface.withOpacity(.60),
                    selectedItemColor: theme.primaryColor,
                    currentIndex: _currentIndex,
                    type: BottomNavigationBarType.shifting,
                    onTap: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    items: destinations.map((Destination destination) {
                      return BottomNavigationBarItem(
                          label: destination.label,
                          icon: Icon(destination.icon),
                          backgroundColor: theme.colorScheme.surface);
                    }).toList()),
              ),
            ),*/
          ),
        ),
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

class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
}
