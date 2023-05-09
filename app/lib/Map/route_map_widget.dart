import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import 'map_widget.dart';

import '../Routing/location.dart';

class RouteMapWidget extends MapWidget {
  const RouteMapWidget({super.key});

  @override
  State<RouteMapWidget> createState() => RouteMapWidgetState();
}

/// The route screen state.
class RouteMapWidgetState extends MapWidgetState<RouteMapWidget> {
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
    http.Response response = await _fetchORSMRoute(from, to);
    String responseBody = response.body;
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    String route = json.encode(jsonResponse['routes'][0]['geometry']);
    _loadRouteGeoJson(route);
  }

  /// Adds the destination marker.
  addDestinationMarker(Location location)
  {
    updateMarker(MapDataId.destination, MapDataId.destination.idPrefix, location.getLongitude(), location.getLatitude());
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

  //Displays the route on the map.
  _loadRouteGeoJson(String routeGeometry) {
    String jsObject = "{route: `$routeGeometry`}";
    webViewController.runJavascript("addRoute($jsObject)");
  }

  Future<http.Response> _fetchORSMRoute(Location startLocation, Location endLocation) async {
    String linkPrefix = 'https://routing.openstreetmap.de/routed-foot/route/v1/foot/';
    //String linkPrefix = 'http://router.project-osrm.org/route/v1/driving/'; Alternative server
    String linkLocationData = '${startLocation.getLongitude()},${startLocation.getLatitude()};${endLocation.getLongitude()},${endLocation.getLatitude()}';
    String linkSuffix = '?overview=full&geometries=geojson';
    String link = '$linkPrefix$linkLocationData$linkSuffix';
    Uri uri = Uri.parse(link);
    return await http.get(uri);
  }
}
