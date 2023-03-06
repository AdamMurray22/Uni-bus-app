import 'dart:io';

import 'package:app/Map/user_icon_enum.dart';
import 'package:app/MapData/map_data_loader.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../MapData/bus_stop.dart';
import '../MapData/feature.dart';
import '../MapData/map_data.dart';
import '../Permissions/location_permissions_handler.dart';

/// Encapsulates the map created through open layers and the map.html file so
/// that the rest of the dart code can interact with the ma easily.
class OpenLayersMap
{
  late final WebViewController _webViewController;
  // The function to be run whenever a marker is clicked.
  Function(String)? _markerClickedFunction;

  /// The constructor creating the webview controller and loading the map.
  OpenLayersMap()
  {
    _webViewController = _createWebViewController();
    _loadMap();
  }

  /// Assigns a function to be run when a marker on the map is clicked.
  onMarkerClicked(Function(String) markerClicked)
  {
    _markerClickedFunction = markerClicked;
  }

  /// Returns the webview controller.
  WebViewController getController()
  {
    return _webViewController;
  }

  toggleU1Markers(bool visible)
  {
    String jsObject = "{visible: $visible}";
    _webViewController.runJavaScript("toggleShowU1Markers($jsObject)");
  }

  toggleU2Markers(bool visible)
  {
    String jsObject = "{visible: $visible}";
    _webViewController.runJavaScript("toggleShowU2Markers($jsObject)");
  }

  toggleUniBuildingMarkers(bool visible)
  {
    String jsObject = "{visible: $visible}";
    _webViewController.runJavaScript("toggleShowUniBuildings($jsObject)");
  }

  toggleLandmarkMarkers(bool visible)
  {
    String jsObject = "{visible: $visible}";
    _webViewController.runJavaScript("toggleShowLandmarks($jsObject)");
  }

  // Creates the webview controller
  WebViewController _createWebViewController()
  {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Creates the channel for javascript to call a dart method
      ..addJavaScriptChannel("MarkerClickedDart", onMessageReceived: (JavaScriptMessage markerIdMessage) {
        _markerClicked(markerIdMessage.message);
      })
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            // When the page finishes loading it sets the data to be loaded into the map.
            MapDataLoader.getDataLoader().onDataLoaded((mapData)
            {
              _addMarkers(mapData);
            });
            _addUserLocationIcon();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {return NavigationDecision.navigate;},
        ),
      );
  }

  // Loads map.html from the respective platforms location.
  _loadMap()
  {
    String relativePath = "assets/open-layers-map/map.html";
    if (Platform.isAndroid) {
      _webViewController.loadFile(
          "file:///android_asset/flutter_assets/$relativePath"); // Android file path
    }
    else if (Platform.isIOS)
    {
      // TODO: Add the absolute path for ios
      _webViewController.loadFile(
          "$relativePath"); // IOS file path
    }
  }

  // Adds the markers to the map.
  _addMarkers(MapData mapData)
  {
    for(BusStop busStop in mapData.getBusStops())
    {
      _addU1BusStopMarker(busStop.id, busStop.long, busStop.lat);
    }
    for(Feature uniBuilding in mapData.getUniBuildings())
    {
      _addUniBuildingMarker(uniBuilding.id, uniBuilding.long, uniBuilding.lat);
    }
    for(Feature landmark in mapData.getLandmarks())
    {
      _addLandmarkMarker(landmark.id, landmark.long, landmark.lat);
    }
  }

  // Adds the U1 bus stops.
  _addU1BusStopMarker(String id, double long, double lat)
  {
    String jsObject = "{id: '$id', longitude: $long, latitude: $lat}";
    _webViewController.runJavaScript("addU1BusStopMarker($jsObject)");
  }

  // Adds the U2 bus stops.
  _addU2BusStopMarker(String id, double long, double lat)
  {
    String jsObject = "{id: '$id', longitude: $long, latitude: $lat}";
    _webViewController.runJavaScript("addU2BusStopMarker($jsObject)");
  }

  // Adds the uni buildings.
  _addUniBuildingMarker(String id, double long, double lat)
  {
    String jsObject = "{id: '$id', longitude: $long, latitude: $lat}";
    _webViewController.runJavaScript("addUniBuildingMarker($jsObject)");
  }
  // Adds the landmarks.
  _addLandmarkMarker(String id, double long, double lat)
  {
    String jsObject = "{id: '$id', longitude: $long, latitude: $lat}";
    _webViewController.runJavaScript("addLandmarkMarker($jsObject)");
  }

  // This is called when a marker on the map gets clicked.
  _markerClicked(String markerId)
  {
    if (_markerClickedFunction == null)
    {
      return;
    }
    _markerClickedFunction!(markerId);
  }

  // Adds the users location to the map as a marker and sets for it be updated
  // whenever the user moves.
  _addUserLocationIcon() async
  {
    LocationPermissionsHandler handler = LocationPermissionsHandler.getHandler();
    Location location = handler.getLocation();

    if (await handler.hasPermission())
    {
      LocationData currentLocation = await location.getLocation();
      String jsObject = "{id: '${UserIcon.id.name}', longitude: ${currentLocation.longitude}, latitude: ${currentLocation.latitude}}";
      _webViewController.runJavaScript("addUserIcon($jsObject)");
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      String jsObject = "{id: '${UserIcon.id.name}', longitude: ${currentLocation.longitude}, latitude: ${currentLocation.latitude}}";
      _webViewController.runJavaScript("updateUserIcon($jsObject)");
    });
  }
}