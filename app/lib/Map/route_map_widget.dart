import 'package:app/Routing/RouteCreators/basic_route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../Routing/RouteCreators/route_creator.dart';
import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import 'map_widget.dart';

import '../Routing/location.dart';

class RouteMapWidget extends MapWidget {
  const RouteMapWidget({required this.routeScreenUpdateFunction, super.key});

  // The function to be run whenever a route is updated.
  final Function(WalkingRoute) routeScreenUpdateFunction;

  @override
  State<RouteMapWidget> createState() => RouteMapWidgetState();
}

/// The route screen state.
class RouteMapWidgetState extends MapWidgetState<RouteMapWidget> {
  RouteCreator routeCreator = BasicRouteCreator();
  Tuple2<String, String>? _currentRoute;

  /// Sets the current route.
  setCurrentRoute(String fromId, String toId)
  {
    _currentRoute = Tuple2(fromId, toId);
  }

  /// Creates the route between the given locations.
  createRoute(Location from, Location to, String fromId, String toId) async {
    if (!(_currentRoute?.item1 == fromId && _currentRoute?.item2 == toId))
    {
      return;
    }
    WalkingRoute route = await routeCreator.createRoute(from, to);
    _loadRouteGeoJson(route.getGeometries());
    widget.routeScreenUpdateFunction(route);
  }

  /// Removes the route.
  endRoute(String? fromId, String? toId) async {
    webViewController.runJavascript("removeRoute()");
    _currentRoute = null;
    if (fromId != null)
    {
      String jsObjectFrom =
          "{layerId: '${MapDataId
          .destination
          .idPrefix}', id: '${MapDataId.destination.idPrefix}s'}";
      webViewController.runJavascript("removeMarker($jsObjectFrom)");
    }
    if (toId != null) {
      String jsObjectTo =
          "{layerId: '${MapDataId
          .destination
          .idPrefix}', id: '${MapDataId.destination.idPrefix}'}";
      webViewController.runJavascript("removeMarker($jsObjectTo)");
    }
  }

  /// Adds the destination marker.
  addDestinationMarker(Location location)
  {
    updateMarker(MapDataId.destination, MapDataId.destination.idPrefix, location.getLongitude(), location.getLatitude());
  }

  /// Adds the start marker.
  addStartMarker(Location location)
  {
    updateMarker(MapDataId.destination, "${MapDataId.destination.idPrefix}s", location.getLongitude(), location.getLatitude());
  }

  /// Sets the RouteCreator.
  setRouteCreator(RouteCreator routeCreator)
  {
    this.routeCreator = routeCreator;
  }

  /// Sets the values for the map set up.
  @override
  void initState() {
    mapPath = 'assets/open-layers-map/route_map.html';
    onPageFinished = (url) async {
      setMapCentreZoom(MapCentreEnum.lat.value, MapCentreEnum.long.value,
          MapCentreEnum.initZoom.value);
      addUserLocationIcon();
    };
    super.initState();
  }

  // Assigns an id to each layer used by this map to be referenced later.
  @override
  assignLayerIds() {
    String userLocation = MapDataId.userLocation.idPrefix;
    String route = MapDataId.route.idPrefix;
    String destination = MapDataId.destination.idPrefix;
    String jsObject =
        "{UserLocation: '$userLocation', Route: '$route', Destination: '$destination'}";
    webViewController.runJavascript("mapIdsToLayers($jsObject)");
  }

  // Displays the route on the map.
  _loadRouteGeoJson(List<String> routeGeometries) {
    webViewController.runJavascript("removeRoute()");
    for (String routeGeometry in routeGeometries)
    {
      String jsObject = "{route: `$routeGeometry`}";
      webViewController.runJavascript("addRoute($jsObject)");
    }
  }
}
