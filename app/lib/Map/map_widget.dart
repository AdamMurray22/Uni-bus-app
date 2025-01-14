import 'package:app/Map/tile_server.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Location/location_handler.dart';
import 'map_data_id_enum.dart';

abstract class MapWidget extends StatefulWidget {
  const MapWidget({this.markerClickedFunction, super.key, this.pingTileServerFunction});

  // The function to be run whenever a marker is clicked.
  final Function(String)? markerClickedFunction;
  // The function to be run when the tile server is selected.
  final Function(String)? pingTileServerFunction;
}

/// The route screen state.
abstract class MapWidgetState<E extends MapWidget> extends State<E> {

  final String _mapPath = "assets/open-layers-map/map.html";
  late final WebViewWidget _webView;
  late final WebViewController _webViewController;
  @protected
  late final Function(String)? onPageFinished;

  final TileServer _tileServer = TileServer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", "");

  /// Creates the webview with the map.
  @override
  void initState() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url)
          async {
            await _addTileServer();
            await createLayers();
            onPageFinished?.call(url);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('MarkerClickedDart',
          onMessageReceived: (JavaScriptMessage markerIdMessage) {
        _markerClicked(markerIdMessage.message);
      })
      ..loadFlutterAsset(_mapPath);
      _webView = WebViewWidget(controller: _webViewController);
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

  /// Adds the tile server to the map.
  _addTileServer()
  {
    String jsObject = "{url: '${_tileServer.url}', attribution: '${_tileServer.attribution}'}";
    _webViewController.runJavaScript("addOSMTileServer($jsObject)");
    widget.pingTileServerFunction?.call(_tileServer.getUrlDomains());
  }

  /// Centres and zooms the map around the given lat, long and zoom.
  @protected
  setMapCentreZoom(double lat, double long, double zoom) {
    String jsObject = "{lat: $lat, long: $long, zoom: $zoom}";
    _webViewController.runJavaScript("setCentreZoom($jsObject)");
  }

  /// Adds the markers.
  @protected
  createMakerLayer(String layerId, String image, double size, double anchorX, double anchorY, bool markersClickable)
  {
    String jsObject =
        "{layerId: '$layerId', image: '$image', markerSize: '$size', anchorX: $anchorX, anchorY: $anchorY, markersClickable: $markersClickable}";
    _webViewController.runJavaScript("createMakerLayer($jsObject)");
  }

  /// Adds the markers.
  @protected
  createGeoJsonLayer(String layerId, String colour, int width)
  {
    String jsObject =
        "{layerId: '$layerId', colour: '$colour', width: $width}";
    _webViewController.runJavaScript("createGeoJsonLayer($jsObject)");
  }

  /// Adds a marker.
  @protected
  addMarker(String layerId, String id, double long, double lat)
  {
    String jsObject =
        "{layerId: '$layerId', id: '$id', longitude: $long, latitude: $lat}";
    _webViewController.runJavaScript("addMarker($jsObject)");
  }

  /// Adds a marker.
  @protected
  removeMarker(String layerId, String id)
  {
    String jsObject =
        "{layerId: '$layerId', id: '$id'}";
    _webViewController.runJavaScript("removeMarker($jsObject)");
  }

  /// Updates the position of the marker.
  @protected
  updateMarker(String layerId, String id, double long, double lat) async {
    String jsObject =
        "{layerId: '$layerId', id: '$id', longitude: $long, latitude: $lat}";
    _webViewController.runJavaScript("updateMarker($jsObject)");
  }

  /// Toggles the visibility of the U1 bus stop markers on the map.
  toggleMarkers(String layerId, bool visible) async {
    String jsObject = "{layerId: '$layerId', visible: $visible}";
    _webViewController.runJavaScript("toggleShowLayers($jsObject)");
  }

  /// Adds the users location to the map as a marker and sets for it be updated
  /// whenever the user moves.
  @protected
   addUserLocationIcon() {
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
  {
    String jsObject = "{layerId: '$layerId', geoJson: '$geoJson'}";
    _webViewController.runJavaScript("addGeoJson($jsObject)");
  }

  /// Adds the geo json with given colour.
  @protected
  addGeoJsonWithColour(String layerId, String geoJson, String colour)
  {
    String jsObject = "{layerId: '$layerId', geoJson: '$geoJson', colour: '$colour'}";
    _webViewController.runJavaScript("addGeoJsonWithColour($jsObject)");
  }

  /// Clears the geoJson layer.
  @protected
  clearGeoJsonLayer(String layerId)
  {
    String jsObject = "{layerId: '$layerId'}";
    _webViewController.runJavaScript("clearGeoJsonLayer($jsObject)");
  }

  // This is called when a marker on the map gets clicked.
  _markerClicked(String markerId) {
    if (widget.markerClickedFunction == null) {
      return;
    }
    widget.markerClickedFunction!(markerId);
  }
}
