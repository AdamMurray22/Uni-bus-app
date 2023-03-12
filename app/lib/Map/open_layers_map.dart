import 'dart:io';

import 'package:app/Map/map_data_id_enum.dart';
import 'package:app/MapData/map_data_loader.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../MapData/feature.dart';
import '../MapData/map_data.dart';
import '../Permissions/location_permissions_handler.dart';

/// Encapsulates the map created through open layers and the map.html file so
/// that the rest of the dart code can interact with the ma easily.
class OpenLayersMap extends WebViewController {
  // The function to be run whenever a marker is clicked.
  Function(String)? _markerClickedFunction;

  /// The constructor creating the webview controller and loading the map.
  OpenLayersMap() : super() {
    //_webViewController =
    _createWebViewController();
    _loadMap();
  }

  /// Assigns a function to be run when a marker on the map is clicked.
  onMarkerClicked(Function(String) markerClicked) {
    _markerClickedFunction = markerClicked;
  }

  /// Toggles the visibility of the U1 bus stop markers on the map.
  toggleMarkers(MapDataId layerId, bool visible) {
    String jsObject = "{layerId: '${layerId.idPrefix}', visible: $visible}";
    runJavaScript("toggleShowMarkers($jsObject)");
  }

  /// Sets up the controller for our map.
  _createWebViewController() {
    setJavaScriptMode(JavaScriptMode.unrestricted);
    // Creates the channel for javascript to call a dart method
    addJavaScriptChannel("MarkerClickedDart",
        onMessageReceived: (JavaScriptMessage markerIdMessage) {
          _markerClicked(markerIdMessage.message);
        });
    // Sets the Navigation Delegate that adds the map data to the map once it
    // has loaded
    setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          _assignLayerIds();
          // When the page finishes loading it sets the data to be loaded into the map.
          MapDataLoader.getDataLoader().onDataLoaded((mapData) {
            _addMarkers(mapData);
          });
          _addUserLocationIcon();
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  // Loads map.html from the respective platforms location.
  _loadMap() {
    String relativePath = "assets/open-layers-map/map.html";
    if (Platform.isAndroid) {
      loadFile(
          "file:///android_asset/flutter_assets/$relativePath"); // Android file path
    } else if (Platform.isIOS) {
      // TODO: Add the absolute path for ios
      loadFile("$relativePath"); // IOS file path
    }
  }

  _assignLayerIds() {
    String u1 = MapDataId.u1.idPrefix;
    String uniBuilding = MapDataId.uniBuilding.idPrefix;
    String landmark = MapDataId.landmark.idPrefix;
    String userLocation = MapDataId.userLocation.idPrefix;
    String jsObject =
        "{U1: '$u1', UniBuilding: '$uniBuilding', Landmark: '$landmark', UserLocation: '$userLocation'}";
    runJavaScript("mapIdsToLayers($jsObject)");
  }

  // Adds the markers to the map.
  _addMarkers(MapData mapData) {
    for (Feature feature in mapData.getAllFeatures()) {
      _addMarker(feature.typeId, feature.id, feature.long, feature.lat);
    }
  }

  // Adds the U1 bus stops.
  _addMarker(MapDataId layerId, String id, double long, double lat) {
    String jsObject =
        "{layerId: '${layerId.idPrefix}', id: '$id', longitude: $long, latitude: $lat}";
    runJavaScript("addMarker($jsObject)");
  }

  // This is called when a marker on the map gets clicked.
  _markerClicked(String markerId) {
    if (_markerClickedFunction == null) {
      return;
    }
    _markerClickedFunction!(markerId);
  }

  // Adds the users location to the map as a marker and sets for it be updated
  // whenever the user moves.
  _addUserLocationIcon() async {
    LocationPermissionsHandler handler =
        LocationPermissionsHandler.getHandler();
    Location location = handler.getLocation();

    if (await handler.hasPermission()) {
      LocationData currentLocation = await location.getLocation();
      _addMarker(MapDataId.userLocation, MapDataId.userLocation.idPrefix,
          currentLocation.longitude!, currentLocation.latitude!);
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _addMarker(MapDataId.userLocation, MapDataId.userLocation.idPrefix,
          currentLocation.longitude!, currentLocation.latitude!);
    });
  }
}
