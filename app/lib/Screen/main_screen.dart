import 'package:app/Screen/map_screen.dart';
import 'package:app/Screen/timetable_screen.dart';
import 'package:flutter/material.dart';

import 'about_screen.dart';

/// This holds the screen for the application.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// This class contains the GUI structure for the app.
class _MainScreenState extends State<MainScreen> {
  late final Widget _mapScreen;
  late final Widget _timetableScreen;
  late final Widget _aboutScreen;

  final List<Widget> screenList = [];
  int _selectedIndexBottomNavBar = 0;

  @override
  initState()
  {
    super.initState();
    _mapScreen = const MapScreen();
    _timetableScreen = const TimetableScreen();
    _aboutScreen = const AboutScreen();

    screenList.add(_mapScreen);
    screenList.add(_timetableScreen);
    screenList.add(_aboutScreen);
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
          "Uni Bus",
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
          index: _selectedIndexBottomNavBar,
          children: screenList
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndexBottomNavBar,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndexBottomNavBar = index;
          });
        },
      ),
    );
  }
}