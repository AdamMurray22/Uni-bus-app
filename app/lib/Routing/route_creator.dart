import 'package:app/Routing/routing.openstreetmap.de.dart';
import 'package:flutter/material.dart';
import 'package:app/Routing/routing_server.dart';
import 'package:app/Routing/walking_route.dart';

import '../Routing/location.dart';

/// The template for a route creator.
abstract class RouteCreator
{
  @protected
  RoutingServer routingServer = RoutingOpenstreetmapDe();

  /// This creates a route from the start to the end locations.
  Future<WalkingRoute> createRoute(Location from, Location to);
}