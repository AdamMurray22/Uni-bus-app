import 'package:app/Routing/location.dart';
import 'package:flutter/material.dart';

/// The routing server.
abstract class RoutingServer
{
  final Function(String)? pingRoutingServerFunction;

  RoutingServer({this.pingRoutingServerFunction})
  {
    pingRoutingServerFunction?.call(getUriDomains());
  }

  // Returns the completed Uri for the routing server.
  Future<String> getResponseBody(Location startLocation, Location endLocation);

  @protected
  String getUriDomains();
}