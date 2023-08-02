import 'package:app/Screen/main_screen.dart';
import 'package:flutter/material.dart';

import 'MapData/map_data_loader.dart';
import 'Location/location_handler.dart';
import 'Screen/loading_screen.dart';
import 'Screen/map_screen.dart';
import 'Screen/navigation_bar_item.dart';

/// Target for start of application.
void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// The entire application is started from this class.
class _MyAppState extends State<MyApp>
{
  final MaterialApp _mainScreen = const MaterialApp(home: MainScreen());
  bool _mainScreenLoaded = false;
  bool _mapDataLoaded = false;

  _loadingUpdated()
  {
    if (_mapDataLoaded)
    {
      setState(() {
      _mainScreenLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    MapDataLoader.getDataLoader().load();
    LocationHandler.getHandler().requestLocationPermission();
    MapDataLoader.getDataLoader().onDataLoadingCompleted((loadedSuccessfully) {
      if (loadedSuccessfully)
      {
        _mapDataLoaded = true;
        _loadingUpdated();
      }
      else
      {

      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (_mainScreenLoaded)
    {
      return _mainScreen;
    }
    else {
      return const MaterialApp(
          home: LoadingScreen()
      );
    }
  }
}