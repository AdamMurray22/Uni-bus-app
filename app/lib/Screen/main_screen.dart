import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../Map/map_data_id_enum.dart';
import '../Map/open_layers_map.dart';

/// This holds the screen for the application.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

/// This class contains the GUI structure for the app.
class MainScreenState extends State<MainScreen> {
  // The instance of our map
  late final OpenLayersMap _mapController;

  bool _u1ValueCheck = true;
  bool _uniBuildingValueCheck = true;
  bool _landmarkValueCheck = true;
  int _selectedIndexBottomNavBar = 0;

  /// Constructor for MapScreenState creates the map.
  MainScreenState() {
    _mapController = OpenLayersMap();
  }

  /// Builds the GUI and places the map inside.
  @override
  Widget build(BuildContext context) {
    _mapController.onMarkerClicked((markerId) {
      // TODO: Add implementation for what happens when a marker is clicked
    });
    return Scaffold(
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.74,
              decoration: BoxDecoration(
                color: const Color(0x1f000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
              ),
              child: WebViewWidget(controller: _mapController) // Map
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "U1",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Checkbox(
                  onChanged: (value) {
                    setState(() {
                      _u1ValueCheck = value!;
                    });
                    _mapController.toggleMarkers(MapDataId.u1, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _u1ValueCheck,
                ),
                const Text(
                  "Uni building",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Checkbox(
                  onChanged: (value) {
                    setState(() {
                      _uniBuildingValueCheck = value!;
                    });
                    _mapController.toggleMarkers(MapDataId.uniBuilding, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _uniBuildingValueCheck,
                ),
                const Text(
                  "Landmarks",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Checkbox(
                  onChanged: (value) {
                    setState(() {
                      _landmarkValueCheck = value!;
                    });
                    _mapController.toggleMarkers(MapDataId.landmark, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _landmarkValueCheck,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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