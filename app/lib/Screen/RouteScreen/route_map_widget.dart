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

class RouteMapWidget extends StatefulWidget {
  const RouteMapWidget({this.markerClickedFunction, super.key});
  // The function to be run whenever a marker is clicked.
  final Function(String)? markerClickedFunction;

  @override
  State<RouteMapWidget> createState() => RouteMapWidgetState();
}

/// The route screen state.
class RouteMapWidgetState extends State<RouteMapWidget> {
  late final WebViewPlusController _controllerPlus;
  late final WebViewController _controller;

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
        initialUrl: 'assets/open-layers-map/route_map.html',
        onWebViewCreated: (controller) async {
          _controllerPlus = controller;
          _controller = _controllerPlus.webViewController;
        },
        onPageFinished: (url) {
          _setMapCentreZoom(MapCentreEnum.lat.value, MapCentreEnum.long.value,
              MapCentreEnum.initZoom.value);
          _assignLayerIds();
          //_addUserLocationIcon();
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
    String userLocation = MapDataId.userLocation.idPrefix;
    String route = MapDataId.route.idPrefix;
    String jsObject =
        "{UserLocation: '$userLocation', Route: '$route'}";
    _controller.runJavascript("mapIdsToLayers($jsObject)");
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
}
