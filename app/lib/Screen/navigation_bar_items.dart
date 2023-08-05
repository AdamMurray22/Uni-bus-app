import 'package:app/Screen/route_screen.dart';
import 'package:app/Screen/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'about_screen.dart';
import 'map_screen.dart';

/// Defines the different screens for the navigation bar.
class NavigationBarItems
{
  final List<Tuple2<NavigationBarItemEnum, StatefulWidget>> _itemsInOrder = [];
  late final Tuple2<NavigationBarItemEnum, MapScreen> mapScreen;
  late final Tuple2<NavigationBarItemEnum, RouteScreen> routeScreen;
  late final Tuple2<NavigationBarItemEnum, TimetableScreen> timetableScreen;
  late final Tuple2<NavigationBarItemEnum, AboutScreen> aboutScreen;

  NavigationBarItems({required Function() mapScreenFunction,
      Function(String)? pingMainMapServerFunction,
      Function(String)? pingRouteMapServerFunction,
      Function(String)? pingRoutingServerFunction})
  {
    mapScreen = Tuple2(NavigationBarItemEnum.mapScreen, MapScreen(
      onShowTimeTableButtonPressed: mapScreenFunction,
      pingMapFunction: pingMainMapServerFunction,
    ));
    routeScreen = Tuple2(NavigationBarItemEnum.routeScreen, RouteScreen(
      pingMapFunction: pingRouteMapServerFunction,
      pingRoutingFunction: pingRoutingServerFunction,
    ));
    timetableScreen = const Tuple2(NavigationBarItemEnum.timetableScreen, TimetableScreen());
    aboutScreen = const Tuple2(NavigationBarItemEnum.aboutScreen, AboutScreen());
    _itemsInOrder.add(mapScreen);
    _itemsInOrder.add(routeScreen);
    _itemsInOrder.add(timetableScreen);
    _itemsInOrder.add(aboutScreen);
  }

  int _selectedIndexBottomNavBar = 0;

  /// Returns the selected index in the nav bar.
  int getSelectedIndex()
  {
    return _selectedIndexBottomNavBar;
  }

  /// Sets the selected index in the nav bar.
  setSelectedIndex(int index)
  {
    _selectedIndexBottomNavBar = index;
  }

  /// Returns the enums in the order of the navigation bar.
  List<Tuple2<NavigationBarItemEnum, StatefulWidget>> getValuesInOrder() {
    return _itemsInOrder;
  }

  /// Returns the screens in order.
  List<Widget> getScreensInOrder()
  {
    List<Widget> screens = [];
    for (Tuple2<NavigationBarItemEnum, StatefulWidget> barItem in getValuesInOrder())
    {
      screens.add(barItem.item2);
    }
    return screens;
  }
}
enum NavigationBarItemEnum {
  mapScreen(0, Icon(Icons.home), "Home"),
  routeScreen(1, Icon(Icons.arrow_upward), "Route"),
  timetableScreen(2, Icon(Icons.access_time), "Timetable"),
  aboutScreen(3, Icon(Icons.info_outline), "About");

  const NavigationBarItemEnum(this.position, this.icon, this.label);

  final int position; // The position in the nav bar, starting from 0.
  final Icon icon;
  final String label;
}
