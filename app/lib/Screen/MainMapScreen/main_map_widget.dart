import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../Map/map_centre_enum.dart';
import '../../Map/map_data_id_enum.dart';
import '../../MapData/feature.dart';
import '../../MapData/map_data.dart';
import '../../MapData/map_data_loader.dart';
import '../../Permissions/location_permissions_handler.dart';

class MainMapWidget extends StatefulWidget {
  const MainMapWidget({this.markerClickedFunction, super.key});
  // The function to be run whenever a marker is clicked.
  final Function(String)? markerClickedFunction;

  @override
  State<MainMapWidget> createState() => MainMapWidgetState();
}

/// The main map screen state.
class MainMapWidgetState extends State<MainMapWidget> {
  late final WebViewPlusController _controllerPlus;
  late final WebViewController _controller;

  /// Toggles the visibility of the U1 bus stop markers on the map.
  toggleMarkers(MapDataId layerId, bool visible) {
    String jsObject = "{layerId: '${layerId.idPrefix}', visible: $visible}";
    _controller.runJavascript("toggleShowLayers($jsObject)");
    }

  /// Centres and zooms the map around the given marker.
  setMapCentreZoom(Feature marker) {
    _setMapCentreZoom(
        marker.lat, marker.long, MapCentreEnum.markerClickedZoom.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewPlus(
        serverPort: 5353,
        javascriptChannels: {
          JavascriptChannel(
              name: 'MarkerClickedDart',
              onMessageReceived: (JavascriptMessage markerIdMessage) {
                _markerClicked(markerIdMessage.message);
              }),
        },
        initialUrl: 'assets/open-layers-map/main_map.html',
        onWebViewCreated: (controller) async {
          _controllerPlus = controller;
          _controller = _controllerPlus.webViewController;
        },
        onPageFinished: (url) {
          _setMapCentreZoom(MapCentreEnum.lat.value, MapCentreEnum.long.value,
              MapCentreEnum.initZoom.value);
          _assignLayerIds();
          // When the page finishes loading it sets the data to be loaded into the map.
          MapDataLoader.getDataLoader().onDataLoaded((mapData) {
            _addMarkers(mapData);
          });
          _addUserLocationIcon();
          _loadBusRouteGeoJson();
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  // Centres and zooms the map around the given lat, long and zoom.
  _setMapCentreZoom(double lat, double long, double zoom) {
    String jsObject = "{lat: $lat, long: $long, zoom: $zoom}";
    _controller.runJavascript("setCentreZoom($jsObject)");
  }

  _assignLayerIds() {
    String u1 = MapDataId.u1.idPrefix;
    String uniBuilding = MapDataId.uniBuilding.idPrefix;
    String landmark = MapDataId.landmark.idPrefix;
    String userLocation = MapDataId.userLocation.idPrefix;
    String jsObject =
        "{U1: '$u1', UniBuilding: '$uniBuilding', Landmark: '$landmark', UserLocation: '$userLocation'}";
    _controller.runJavascript("mapIdsToLayers($jsObject)");
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
        "{layerId: '${layerId
        .idPrefix}', id: '$id', longitude: $long, latitude: $lat}";
    _controller.runJavascript("addMarker($jsObject)");
  }

  // This is called when a marker on the map gets clicked.
  _markerClicked(String markerId) {
    if (widget.markerClickedFunction == null) {
      return;
    }
    widget.markerClickedFunction!(markerId);
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

  //Displays the bus route on the map.
  _loadBusRouteGeoJson() async {
    String busRouteJson = await rootBundle
        .loadString(join("assets", "open-layers-map/Bus_Route.geojson"));
    String jsObject = "{busRoute: `$busRouteJson`}";
    _controller.runJavascript("drawBusRouteLines($jsObject)");
  }
}
