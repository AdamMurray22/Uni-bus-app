import 'dart:convert';

import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:http/http.dart' as http;
import '../../MapData/bus_stop.dart';
import '../location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  final Map<String, BusStop> _busStops;

  AdvancedRouteCreator(this._busStops);

  /// Creates the fastest route from the start to the end, this route may
  /// include taking the bus.
  @override
  Future<WalkingRoute> createRoute(Location from, Location to)
  async {
    /// TODO: Complete Class.
    return WalkingRoute("_geometry", 0, 0, 0, "_nextTurn");
  }
}