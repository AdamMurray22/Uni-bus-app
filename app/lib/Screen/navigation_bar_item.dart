import 'package:app/Screen/route_screen.dart';
import 'package:app/Screen/timetable_screen.dart';
import 'package:app/Sorts/heap_sort.dart';
import 'package:app/Sorts/comparator.dart';
import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'map_screen.dart';

/// Defines the different screens for the navigation bar.
enum NavigationBarItem {
  mapScreen(0, Icon(Icons.home), "Home", MapScreen()),
  routeScreen(1, Icon(Icons.arrow_upward), "Route", RouteScreen()),
  timetableScreen(2, Icon(Icons.access_time), "Timetable", TimetableScreen()),
  aboutScreen(3, Icon(Icons.info_outline), "About", AboutScreen());

  const NavigationBarItem(this.position, this.icon, this.label, this.screen);

  final int position; // The position in the nav bar, starting from 0.
  final Icon icon;
  final String label;
  final Widget screen;

  static int _selectedIndexBottomNavBar = 0;

  /// Returns the selected index in the nav bar.
  static int getSelectedIndex()
  {
    return _selectedIndexBottomNavBar;
  }

  /// Sets the selected index in the nav bar.
  static setSelectedIndex(int index)
  {
    _selectedIndexBottomNavBar = index;
  }

  /// Returns the enums in the order of the navigation bar.
  static List<NavigationBarItem> getValuesInOrder() {
    List<NavigationBarItem> items = NavigationBarItem.values;
    HeapSort<NavigationBarItem> sort =
        HeapSort<NavigationBarItem>((item1, item2) {
      return item1.position <= item2.position ? Comparator.before : Comparator.after;
    });
    return sort.sort(items);
  }

  /// Returns the screens in order.
  static List<Widget> getScreensInOrder()
  {
    List<Widget> screens = [];
    for (NavigationBarItem item in getValuesInOrder())
    {
      screens.add(item.screen);
    }
    return screens;
  }
}
