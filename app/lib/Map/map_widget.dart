import 'package:app/Map/tile_server.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../Location/location_handler.dart';
import 'map_data_id_enum.dart';

abstract class MapWidget extends StatefulWidget {
  const MapWidget({super.key});
}

/// The route screen state.
abstract class MapWidgetState<E extends StatefulWidget> extends State<E> {

  @protected
  String mapPath = "";
  @protected
  late final WebViewPlus webView;
  @protected
  late final WebViewPlusController controllerPlus;
  @protected
  late final WebViewController webViewController;
  @protected
  late final Function(String)? onPageFinished;
  @protected
  final Set<JavascriptChannel> javascriptChannels = {};

  TileServer tileServer = TileServer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", "");

  /// Creates the webview with the map.
  @override
  void initState() {
    webView = WebViewPlus(
      serverPort: 5353,
      initialUrl: mapPath,
      javascriptChannels: javascriptChannels,
      onWebViewCreated: (controller) async {
        controllerPlus = controller;
        webViewController = controllerPlus.webViewController;
      },
      onPageFinished: (url)
      {
        assignLayerIds();
        onPageFinished?.call(url);
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: webView,
    );
  }

  // Assigns an id to each layer used by this map to be referenced later.
  @protected
  assignLayerIds();

  // Centres and zooms the map around the given lat, long and zoom.
  @protected
  setMapCentreZoom(double lat, double long, double zoom) {
    String jsObject = "{lat: $lat, long: $long, zoom: $zoom}";
    webViewController.runJavascript("setCentreZoom($jsObject)");
  }

  // Adds the markers.
  @protected
  addMarker(MapDataId layerId, String id, double long, double lat)
  {
    String jsObject =
        "{layerId: '${layerId
        .idPrefix}', id: '$id', longitude: $long, latitude: $lat}";
    webViewController.runJavascript("addMarker($jsObject)");
  }

  // Updates the position of the marker.
  @protected
  updateMarker(MapDataId layerId, String id, double long, double lat) {
    String jsObject =
        "{layerId: '${layerId
        .idPrefix}', id: '$id', longitude: $long, latitude: $lat}";
    webViewController.runJavascript("updateMarker($jsObject)");
  }

  // Adds the users location to the map as a marker and sets for it be updated
  // whenever the user moves.
  @protected
   addUserLocationIcon() async {
    LocationHandler handler =
      LocationHandler.getHandler();
    handler.onLocationChanged((LocationData currentLocation) {
      updateMarker(MapDataId.userLocation, MapDataId.userLocation.idPrefix,
          currentLocation.longitude!, currentLocation.latitude!);
    });
  }
}
