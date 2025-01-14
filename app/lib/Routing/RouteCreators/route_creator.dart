import 'dart:convert';

import 'package:app/Routing/Servers/routing.openstreetmap.de.dart';
import 'package:flutter/material.dart';
import 'package:app/Routing/Servers/routing_server.dart';
import 'package:app/Routing/walking_route.dart';

import '../geo_json_geometry.dart';
import '../location.dart';

/// The template for a route creator.
abstract class RouteCreator
{
  @protected
  late RoutingServer _routingServer;
  final Function(String)? pingRoutingServerFunction;

  /// Assigns default Server.
  RouteCreator({this.pingRoutingServerFunction})
  {
    _routingServer = RoutingOpenstreetmapDe(pingRoutingServerFunction: pingRoutingServerFunction);
  }

  /// Allows for non default server.
  RouteCreator.setServer(this._routingServer, {this.pingRoutingServerFunction});

  /// This creates a route from the start to the end locations.
  Future<WalkingRoute> createRoute(Location from, Location to);

  /// Returns the json containing all the route information.
  @protected
  Future<Map<String, dynamic>> getJsonResponse(Location from, Location to)
  async {
    String responseBody = await _fetchORSMRouteInformation(from, to);
    return jsonDecode(responseBody);
  }

  /// This extracts the information from the json and creates a WalkingRoute.
  @protected
  WalkingRoute decodeWalkingRouteJson(Map<String, dynamic> jsonResponse)
  {
    String geometry = json.encode(jsonResponse['routes'][0]['geometry']);
    double totalSeconds = double.parse(json.encode(jsonResponse['routes'][0]['duration']));
    double totalDistance = double.parse(json.encode(jsonResponse['routes'][0]['distance']));
    double distanceTillNextTurn = double.parse(json.encode(jsonResponse['routes'][0]['legs'][0]['steps'][0]['distance']));
    String nextTurn = json.encode(jsonResponse['routes'][0]['legs'][0]['steps'][0]['maneuver']['modifier']);
    return WalkingRoute([GeoJsonGeometry(geometry)], totalSeconds, totalDistance, distanceTillNextTurn, nextTurn);
  }

  // Retrieves the Route information from the server.
  Future<String> _fetchORSMRouteInformation(Location startLocation, Location endLocation) async {
    return await _routingServer.getResponseBody(startLocation, endLocation);
  }
}