import 'package:flutter/material.dart';
import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import 'map_widget.dart';

class RouteMapWidget extends MapWidget {
  const RouteMapWidget({this.markerClickedFunction, super.key});
  // The function to be run whenever a marker is clicked.
  final Function(String)? markerClickedFunction;

  @override
  State<MapWidget> createState() => RouteMapWidgetState();
}

/// The route screen state.
class RouteMapWidgetState extends MapWidgetState<RouteMapWidget> {

  /// Sets the values for the map set up.
  @override
  void initState() {
    mapPath = 'assets/open-layers-map/route_map.html';
    onPageFinished = (url) async {
      setMapCentreZoom(MapCentreEnum.lat.value, MapCentreEnum.long.value,
          MapCentreEnum.initZoom.value);
      _assignLayerIds();
      addUserLocationIcon();
    };
    super.initState();
  }

  // Assigns an id to each layer to be referenced later.
  _assignLayerIds() {
    String userLocation = MapDataId.userLocation.idPrefix;
    String route = MapDataId.route.idPrefix;
    String jsObject =
        "{UserLocation: '$userLocation', Route: '$route'}";
    webViewController.runJavascript("mapIdsToLayers($jsObject)");
  }
}
