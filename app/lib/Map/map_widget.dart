import 'dart:developer';

import 'package:app/Map/tile_server.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../Location/location_handler.dart';
import 'map_data_id_enum.dart';

abstract class MapWidget extends StatefulWidget {
  const MapWidget({this.markerClickedFunction, super.key});

  // The function to be run whenever a marker is clicked.
  final Function(String)? markerClickedFunction;
}

/// The route screen state.
abstract class MapWidgetState<E extends MapWidget> extends State<E> {

  final String _mapPath = "assets/open-layers-map/map.html";
  late final WebViewPlus _webView;
  late final WebViewPlusController _controllerPlus;
  late final WebViewController _webViewController;
  @protected
  late final Function(String)? onPageFinished;
  final Set<JavascriptChannel> _javascriptChannels = {};

  final TileServer _tileServer = TileServer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", "");

  /// Creates the webview with the map.
  @override
  void initState() {
    _javascriptChannels.add(JavascriptChannel(
        name: 'MarkerClickedDart',
        onMessageReceived: (JavascriptMessage markerIdMessage) {
          _markerClicked(markerIdMessage.message);
        }));
    _webView = WebViewPlus(
      serverPort: 5353,
      initialUrl: _mapPath,
      javascriptChannels: _javascriptChannels,
      onWebViewCreated: (controller) async {
        _controllerPlus = controller;
        _webViewController = _controllerPlus.webViewController;
      },
      onPageFinished: (url)
      async {
        await _addTileServer();
        await createLayers();
        onPageFinished?.call(url);
      },
      javascriptMode: JavascriptMode.unrestricted,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _webView,
    );
  }

  @protected
  createLayers();

  _addTileServer()
  async {
    String jsObject = "{url: '${_tileServer.url}', attribution: '${_tileServer.attribution}'}";
    await _webViewController.runJavascript("addOSMTileServer($jsObject)");
  }

  /// Centres and zooms the map around the given lat, long and zoom.
  @protected
  setMapCentreZoom(double lat, double long, double zoom) async {
    String jsObject = "{lat: $lat, long: $long, zoom: $zoom}";
    await _webViewController.runJavascript("setCentreZoom($jsObject)");
  }

  /// Adds the markers.
  @protected
  createMakerLayer(String layerId, String image, double size, bool markersClickable)
  async {
    String jsObject =
        "{layerId: '$layerId', image: '$image', markerSize: '$size', markersClickable: $markersClickable}";
    await _webViewController.runJavascript("createMakerLayer($jsObject)");
  }

  /// Adds the markers.
  @protected
  createGeoJsonLayer(String layerId, String colour, int width)
  async {
    String jsObject =
        "{layerId: '$layerId', colour: '$colour', width: $width}";
    await _webViewController.runJavascript("createGeoJsonLayer($jsObject)");
  }

  /// Adds a marker.
  @protected
  addMarker(String layerId, String id, double long, double lat)
  async {
    String jsObject =
        "{layerId: '$layerId', id: '$id', longitude: $long, latitude: $lat}";
    await _webViewController.runJavascript("addMarker($jsObject)");
  }

  /// Adds a marker.
  @protected
  removeMarker(String layerId, String id)
  async {
    String jsObject =
        "{layerId: '$layerId', id: '$id'}";
    await _webViewController.runJavascript("removeMarker($jsObject)");
  }

  /// Updates the position of the marker.
  @protected
  updateMarker(String layerId, String id, double long, double lat) async {
    String jsObject =
        "{layerId: '$layerId', id: '$id', longitude: $long, latitude: $lat}";
    await _webViewController.runJavascript("updateMarker($jsObject)");
  }

  /// Toggles the visibility of the U1 bus stop markers on the map.
  toggleMarkers(String layerId, bool visible) async {
    String jsObject = "{layerId: '$layerId', visible: $visible}";
    await _webViewController.runJavascript("toggleShowLayers($jsObject)");
  }

  /// Adds the users location to the map as a marker and sets for it be updated
  /// whenever the user moves.
  @protected
   addUserLocationIcon() async {
    LocationHandler handler =
      LocationHandler.getHandler();
    handler.onLocationChanged((LocationData currentLocation) {
      updateMarker(MapDataId.userLocation.idPrefix, MapDataId.userLocation.idPrefix,
          currentLocation.longitude!, currentLocation.latitude!);
    });
  }

  /// Adds the geo json.
  @protected
  addGeoJson(String layerId, String geoJson)
  async {
    String jsObject = "{layerId: '$layerId', geoJson: '$geoJson'}";
    await _webViewController.runJavascript("addGeoJson($jsObject)");
  }

  /// Adds the geo json with given colour.
  @protected
  addGeoJsonWithColour(String layerId, String geoJson, String colour)
  async {
    String jsObject = "{layerId: '$layerId', geoJson: '$geoJson', colour: '$colour'}";
    await _webViewController.runJavascript("addGeoJsonWithColour($jsObject)");
  }

  /// Clears the geoJson layer.
  @protected
  clearGeoJsonLayer(String layerId)
  async {
    String jsObject = "{layerId: '$layerId'}";
    await _webViewController.runJavascript("clearGeoJsonLayer($jsObject)");
  }

  // This is called when a marker on the map gets clicked.
  _markerClicked(String markerId) {
    if (widget.markerClickedFunction == null) {
      return;
    }
    widget.markerClickedFunction!(markerId);
  }
}
