import 'package:app/Routing/Servers/routing.openstreetmap.de.dart';
import 'package:flutter/material.dart';
import 'package:app/Routing/Servers/routing_server.dart';
import 'package:app/Routing/walking_route.dart';

import '../location.dart';

/// The template for a route creator.
abstract class RouteCreator
{
  @protected
  RoutingServer routingServer = RoutingOpenstreetmapDe();

  /// Assigns default Server.
  RouteCreator()
  {
    routingServer = RoutingOpenstreetmapDe();
  }

  /// Allows for non default server.
  RouteCreator.setServer(this.routingServer);

  /// This creates a route from the start to the end locations.
  Future<WalkingRoute> createRoute(Location from, Location to);
}