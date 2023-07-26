import 'dart:convert';

import 'package:app/Routing/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:http/http.dart' as http;
import '../Routing/location.dart';

/// This is a route creator that only takes the start and end locations into account.
class BasicRouteCreator extends RouteCreator
{
  /// This creates the fastest walking route from the start to the end locations.
  @override
  Future<WalkingRoute> createRoute(Location from, Location to)
  async {
    Map<String, dynamic> jsonResponse = await _getJsonResponse(from, to);
    return _decodeJson(jsonResponse);
  }

  // Returns the json containing all the route information.
  Future<Map<String, dynamic>> _getJsonResponse(Location from, Location to)
  async {
    http.Response response = await _fetchORSMRoute(from, to);
    String responseBody = response.body;
    return jsonDecode(responseBody);
  }

  // Retrieves the Route from the server.
  Future<http.Response> _fetchORSMRoute(Location startLocation, Location endLocation) async {
    Uri serverUri = routingServer.getUri(startLocation, endLocation);
    return await http.get(serverUri);
  }

  // This extracts the information from the json and creates a WalkingRoute.
  WalkingRoute _decodeJson(Map<String, dynamic> jsonResponse)
  {
    String geometry = json.encode(jsonResponse['routes'][0]['geometry']);
    double totalSeconds = double.parse(json.encode(jsonResponse['routes'][0]['duration']));
    double totalDistance = double.parse(json.encode(jsonResponse['routes'][0]['distance']));
    double distanceTillNextTurn = double.parse(json.encode(jsonResponse['routes'][0]['legs'][0]['steps'][0]['distance']));
    String nextTurn = json.encode(jsonResponse['routes'][0]['legs'][0]['steps'][0]['maneuver']['modifier']);
    return WalkingRoute(geometry, totalSeconds, totalDistance, distanceTillNextTurn, nextTurn);
  }
}