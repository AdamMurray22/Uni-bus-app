import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main_screen.dart';
import '../Map/open_layers_map.dart';

/// This class contains the GUI structure for the screen that contains the map.
class MapScreenState extends State<MainScreen> {
  // The instance of our map
  late final OpenLayersMap _map;

  bool _u1ValueCheck = true;
  bool _u2ValueCheck = true;
  bool _uniBuildingValueCheck = true;
  bool _landmarkValueCheck = true;

  /// Constructor for MapScreenState creates the map.
  MapScreenState() {
    _map = OpenLayersMap();
  }

  /// Builds the GUI and places the map inside.
  @override
  Widget build(BuildContext context) {
    _map.onMarkerClicked((markerId) {
      // TODO: Add implementation for what happens when a marker is clicked
    });
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff3a57e8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "AppBar",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            color: Color(0xff000000),
          ),
        ),
        leading: const Icon(
          Icons.arrow_back,
          color: Color(0xff212435),
          size: 24,
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
              child: WebViewWidget(controller: _map.getController()) // Map
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
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _u1ValueCheck,
                ),
                const Text(
                  "U2",
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
                      _u2ValueCheck = value!;
                    });
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _u2ValueCheck,
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
    );
  }
}
