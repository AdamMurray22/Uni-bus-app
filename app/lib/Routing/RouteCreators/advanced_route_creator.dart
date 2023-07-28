import 'dart:math';

import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:tuple/tuple.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../Servers/routing_server.dart';
import '../location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  final Set<BusStop> _busStops;

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
    Tuple3<double, BusTime, BusTime>? busRouteEstimate = _getEntireEstimate(from, to);
    if (busRouteEstimate == null)
    {
      return basicRoute;
    }
    double busRouteEstimateTime = busRouteEstimate.item1;
    if (busRouteEstimateTime > basicRoute.getTotalSeconds())
    {
      return basicRoute;
    }
    BusTime estimateDeppTime = busRouteEstimate.item2;
    BusTime estimateArrTime = busRouteEstimate.item3;


    return basicRoute;
  }

  // Gets the complete estimate for the time in seconds for the route taking
  // the bus (if applicable).
  Tuple3<double, BusTime, BusTime>? _getEntireEstimate(Location journeyStart, Location journeyEnd)
  {
    Tuple2<double, BusStop>? closestBusStopWithTime = _getClosestBusStop(journeyStart, _busStops);
    if (closestBusStopWithTime == null)
    {
      return null;
    }
    double firstLegSmallestTime = closestBusStopWithTime.item1;
    BusStop firstLegClosestBusStop = closestBusStopWithTime.item2;
    DateTime busStopArrival = DateTime.now().add(Duration(seconds: firstLegSmallestTime.ceil()));
    BusTime? busDeparture = firstLegClosestBusStop.getNextBusDepartureAfterTime(busStopArrival);
    if (busDeparture == null)
    {
      return null;
    }

    Set<BusStop> allDropOffBusStops = {firstLegClosestBusStop, ...firstLegClosestBusStop.getAllNextBusStops()};
    allDropOffBusStops = _removeBusStopsWithOutArrivalTimeOnRoute(busDeparture.getRouteNumber(), allDropOffBusStops);
    Tuple2<double, BusStop>? closestBusStopWithTimeToDestination = _getClosestBusStop(journeyEnd, allDropOffBusStops);
    if (closestBusStopWithTimeToDestination == null)
    {
      return null;
    }
    double secondLegSmallestTime = closestBusStopWithTimeToDestination.item1;
    BusStop secondLegClosestBusStop = closestBusStopWithTimeToDestination.item2;
    if (secondLegClosestBusStop == firstLegClosestBusStop)
    {
      return null;
    }
    BusTime busArrival = secondLegClosestBusStop.getArrivalTimeOnRoute(busDeparture.getRouteNumber())!;
    int busLegTime = busArrival.getTimeAsMins() - busDeparture.getTimeAsMins();
    double busLetTimeSeconds = busLegTime * 60;
    double totalEstimate = firstLegSmallestTime + secondLegSmallestTime + busLetTimeSeconds;
    return Tuple3<double, BusTime, BusTime>(totalEstimate, busDeparture, busArrival);
  }

  // Finds the closest bus stop, and an estimate to walk that distance,
  // to the given location using the straight line distance.
  Tuple2<double, BusStop>? _getClosestBusStop(Location otherLocation, Iterable<BusStop> busStops)
  {
    double smallestTime = double.infinity;
    BusStop? closestBusStop;
    for (BusStop busStop in busStops)
    {
      Location busStopLocation = Location(busStop.long, busStop.lat);
      double estimate = _estimateStraightLineTime(otherLocation, busStopLocation);
      if (estimate < smallestTime)
      {
        smallestTime = estimate;
        closestBusStop = busStop;
      }
    }
    if (closestBusStop == null)
    {
      return null;
    }
    return Tuple2<double, BusStop>(smallestTime, closestBusStop);
  }

  // Returns the collection of the bus stops that have a BusTime on the given route.
  Set<BusStop> _removeBusStopsWithOutArrivalTimeOnRoute(int routeNumber, Set<BusStop> busStops)
  {
    Set<BusStop> busStopsWithRoute = {};
    for (BusStop busStop in busStops)
    {
      if (busStop.getArrivalTimeOnRoute(routeNumber) != null)
      {
        busStopsWithRoute.add(busStop);
      }
    }
    return busStopsWithRoute;
  }

  // Estimates the straight line time to walk between 2 points in s.
  double _estimateStraightLineTime(Location fromLocation, Location toLocation)
  {
    return _estimateStraightLineDistance(fromLocation, toLocation) / 1; // 1m/s is an underestimate of typical walking speed of an adult.
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