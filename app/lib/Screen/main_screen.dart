import 'package:app/Screen/MainMapScreen/map_screen.dart';
import 'package:flutter/material.dart';

import 'navigation_bar_item.dart';

/// This holds the screen for the application.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// This class contains the GUI structure for the app.
class _MainScreenState extends State<MainScreen> {

  /// Creates the screens accessed through the nav bar.
  @override
  initState() {
    super.initState();
    MapScreen.onShowTimeTableButtonPressed = () {
      setState(() {
        NavigationBarItem.setSelectedIndex(NavigationBarItem.timetableScreen.position);
      });
    };
  }

  /// Builds the GUI and places the map inside.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff009a96),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Uni Bus Portsmouth",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xff000000),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0x1f000000),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
        ),
        child: IndexedStack(
            index: NavigationBarItem.getSelectedIndex(), children: NavigationBarItem.getScreensInOrder()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _addItemsToBottomNavigationBar(),
        currentIndex: NavigationBarItem.getSelectedIndex(),
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            NavigationBarItem.setSelectedIndex(index);
          });
        },
      ),
    );
  }

  // Returns the navigation bar items in order.
  List<BottomNavigationBarItem> _addItemsToBottomNavigationBar() {
    List<BottomNavigationBarItem> navBarItems = [];
    for (NavigationBarItem item in NavigationBarItem.getValuesInOrder()) {
      navBarItems.add(BottomNavigationBarItem(
        icon: item.icon,
        label: item.label,
      ));
    }
    return navBarItems;
  }
}
