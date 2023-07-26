import 'package:flutter/material.dart';
import 'package:app/Routing/router.project-osrm.org.dart';
import 'package:app/Routing/routing_server.dart';

import '../Routing/location.dart';

/// The template for a route creator.
abstract class RouteCreator
{
  @protected
  RoutingServer routingServer = RoutingOpenstreetmapDe();

  /// This creates a route from the start to the end locations.
  Future<String> createRoute(Location from, Location to);
}