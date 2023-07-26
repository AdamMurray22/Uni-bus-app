import 'dart:convert';

import 'package:app/Routing/route_creator.dart';
import 'package:http/http.dart' as http;
import '../MapData/bus_stop.dart';
import '../Routing/location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  final Map<String, BusStop> _busStops;

  AdvancedRouteCreator(this._busStops);

  /// Creates the fastest route from the start to the end, this route may
  /// include taking the bus.
  @override
  Future<String> createRoute(Location from, Location to)
  async {
    http.Response response = await _fetchORSMRoute(from, to);
    String responseBody = response.body;
    Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
    String route = json.encode(jsonResponse['routes'][0]['geometry']);
    return route;
  }

  // Retrieves the Route from the server.
  Future<http.Response> _fetchORSMRoute(Location startLocation, Location endLocation) async {
    Uri serverUri = routingServer.getUri(startLocation, endLocation);
    return await http.get(serverUri);
  }
}