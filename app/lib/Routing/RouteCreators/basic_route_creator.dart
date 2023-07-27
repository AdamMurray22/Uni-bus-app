import 'dart:convert';

import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/Servers/routing_server.dart';
import 'package:app/Routing/walking_route.dart';
import '../location.dart';

/// This is a route creator that only takes the start and end locations into account.
class BasicRouteCreator extends RouteCreator
{

  /// Assigns default Server.
  BasicRouteCreator() : super();

  /// Allows for non default server.
  BasicRouteCreator.setServer(RoutingServer server) : super.setServer(server);

  /// This creates the fastest walking route from the start to the end locations.
  @override
  Future<WalkingRoute> createRoute(Location from, Location to)
  async {
    Map<String, dynamic> jsonResponse = await getJsonResponse(from, to);
    return decodeJson(jsonResponse);
  }
}