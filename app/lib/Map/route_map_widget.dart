import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import 'map_widget.dart';

import '../Routing/location.dart';

class RouteMapWidget extends MapWidget {
  const RouteMapWidget({super.key});

  @override
  State<MapWidget> createState() => RouteMapWidgetState();
}

/// The route screen state.
class RouteMapWidgetState extends MapWidgetState<RouteMapWidget> {

  createRoute(Location from, Location to) async {
    http.Response response = await _fetchORSMRoute(from, to);
    String responseBody = response.body;
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    String route = json.encode(jsonResponse['routes'][0]['geometry']);
    _loadRouteGeoJson(route);
  }

  addDestinationMarker(Location location)
  {
    addMarker(MapDataId.destination, MapDataId.destination.idPrefix, location.longitude, location.latitude);
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
    String link = 'http://router.project-osrm.org/route/v1/foot/${startLocation.longitude},${startLocation.latitude};${endLocation.longitude},${endLocation.latitude}?overview=full&geometries=geojson';
    Uri uri = Uri.parse(link);
    return await http.get(uri);
  }
}
