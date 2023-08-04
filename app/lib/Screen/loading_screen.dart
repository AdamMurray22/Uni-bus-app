import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../MapData/map_data_loader.dart';
import 'main_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _index = 0;
  late IndexedStack stack;

  late MainScreen _mainScreen;

  bool _alertShown = false;
  bool _mapDataLoaded = false;
  bool _mainMapLoaded = false;
  bool _routeMapLoaded = false;
  bool _routingServerLoaded = false;

  _loadingUpdated() {
    if (!_alertShown &&
        _mapDataLoaded &&
        _mainMapLoaded &&
        _routeMapLoaded &&
        _routingServerLoaded) {
      setState(() {
        _index = 1;
      });
    }
  }

  Future<void> _showAlert() async {
    _alertShown = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Failed to connect to server'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please try again later'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  initState() {
    super.initState();
    MapDataLoader.getDataLoader().onDataLoadingCompleted((loadedSuccessfully) {
      if (!loadedSuccessfully) {
        _showAlert();
        return;
      }
      _mapDataLoaded = true;
      _loadingUpdated();
    });
    _mainScreen = MainScreen(
      pingMainMapServerFunction: (url) async {
        PingData result = await Ping(url, count: 1).stream.first;
        if (result.error != null) {
          _showAlert();
          return;
        }
        _mainMapLoaded = true;
        _loadingUpdated();
      },
      pingRouteMapServerFunction: (url) async {
        PingData result = await Ping(url, count: 1).stream.first;
        if (result.error != null) {
          _showAlert();
          return;
        }
        _routeMapLoaded = true;
        _loadingUpdated();
      },
      pingRoutingServerFunction: (url) async {
        PingData result = await Ping(url, count: 1).stream.first;
        if (result.error != null) {
          _showAlert();
          return;
        }
        _routingServerLoaded = true;
        _loadingUpdated();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    IndexedStack stack = IndexedStack(index: _index, children: [
      Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0xff7030A0),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            const Text(
              "Uni bus",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
            const Text(
              "Portsmouth",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            const Text(
              "Loading...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
      MaterialApp(home: _mainScreen),
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: stack,
    );
  }
}
