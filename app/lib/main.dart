import 'package:flutter/material.dart';

import 'MapData/map_data_loader.dart';
import 'Location/location_handler.dart';
import 'Screen/main_screen.dart';

/// Target for start of application.
void main() {
  runApp(const MyApp());
}

/// The entire application is started from this class.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MapDataLoader.getDataLoader().load();
    LocationHandler.getHandler().requestLocationPermission();
    return const MaterialApp(
        home: MainScreen()
    );
  }
}