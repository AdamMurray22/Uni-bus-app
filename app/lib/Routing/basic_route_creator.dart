import 'dart:convert';

import 'package:app/Routing/route_creator.dart';
import 'package:http/http.dart' as http;
import '../Routing/location.dart';

/// This is a route creator that only takes the start and end locations into account.
class BasicRouteCreator extends RouteCreator
{
  /// This creates the fastest walking route from the start to the end locations.
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