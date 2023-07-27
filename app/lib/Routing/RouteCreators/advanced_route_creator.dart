import 'dart:math';

import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../Servers/routing_server.dart';
import '../location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  final Map<String, BusStop> _busStops;

  /// Assigns default Server.
  AdvancedRouteCreator(this._busStops) : super();

  /// Allows for non default server.
  AdvancedRouteCreator.setServer(this._busStops, RoutingServer server) : super.setServer(server);

  /// Creates the fastest route from the start to the end, this route may
  /// include taking the bus.
  @override
  Future<WalkingRoute> createRoute(Location from, Location to)
  async {
    Map<String, dynamic> jsonResponse = await getJsonResponse(from, to);
    WalkingRoute basicRoute = decodeJson(jsonResponse);
    double busRouteEstimate = _getEntireEstimate(from, to);
    return basicRoute;
  }

  // Gets the complete estimate for the time in seconds for the route taking
  // the bus (if applicable).
  double _getEntireEstimate(Location journeyStart, Location journeyEnd)
  {
    double smallestTime = double.infinity;
    BusStop? closestBusStop;
    for (BusStop busStop in _busStops.values)
    {
      Location busStopLocation = Location(busStop.long, busStop.lat);
      double estimate = _estimateStraightLineTime(journeyStart, busStopLocation);
      if (estimate < smallestTime)
      {
          smallestTime = estimate;
          closestBusStop = busStop;
      }
    }
    if (closestBusStop == null)
    {
      return double.infinity;
    }
    DateTime busStopArrival = DateTime.now().add(Duration(seconds: smallestTime.floor()));
    BusTime? busDeparture = closestBusStop.getNextBusDepartureAfterTime(busStopArrival);



    return double.infinity;
  }

  // Estimates the straight line time to walk between 2 points in s.
  double _estimateStraightLineTime(Location fromLocation, Location toLocation)
  {
    return _estimateStraightLineDistance(fromLocation, toLocation) / 1.42; // 1.42m/s is the typical walking speed of an adult.
  }

  // Estimates the straight line distance of 2 points in m.
  double _estimateStraightLineDistance(Location fromLocation, Location toLocation)
  {
    var x = (fromLocation.getLongitude() - toLocation.getLongitude()) *
        cos((fromLocation.getLatitude() + toLocation.getLatitude()) / 2);
    var y = (fromLocation.getLatitude() - toLocation.getLatitude());
    var d = sqrt(x * x + y * y) * 6371000;
    d = d / 10;
    return d;
  }
}