import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main_screen.dart';
import '../Map/open_layers_map.dart';
/// This class contains the GUI structure for the screen that contains the map.
class MapScreenState extends State<MainScreen> {
  // The instance of our map
  late final OpenLayersMap _map;

  /// Constructor for MapScreenState creates the map.
  MapScreenState()
  {
    _map = OpenLayersMap();
  }

  /// Builds the GUI and places the map inside.
  @override
  Widget build(BuildContext context) {

    _map.onMarkerClicked((markerId)
    {
      // TODO: Add implementation for what happens when a marker is clicked
    });

    return Scaffold(
      body: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Color(0x1f000000),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Color(0x4d9e9e9e), width: 1)
          ),
          child: WebViewWidget(controller: _map.getController()) // Map
      ),
    );
  }
}