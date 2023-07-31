import 'package:tuple/tuple.dart';
import 'package:app/Routing/location.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../../Wrapper/date_time_wrapper.dart';
import '../estimate_straight_line_distance.dart';
import 'package:flutter/material.dart';

/// Produces an estimate of the time for a route using the bus.
class BusRouteEstimator
{
  DateTimeWrapper _dateTime = DateTimeWrapper();
  final Set<BusStop> _busStops;

  /// Assigns the bus stops used for this route.
  BusRouteEstimator(this._busStops);

  /// Used for testing purposes only.
  @protected
  BusRouteEstimator.setDateTime(this._busStops, this._dateTime);

  /// Gets the complete estimate for the time in seconds for the route taking
  /// the bus (if applicable).
  Tuple3<double, BusStop, BusStop>? getEntireEstimate(Location journeyStart, Location journeyEnd)
  {
    Tuple2<double, BusStop>? closestBusStopWithTime = _getClosestBusStop(journeyStart, _busStops);
    if (closestBusStopWithTime == null)
    {
      return null;
    }
    double firstLegSmallestTime = closestBusStopWithTime.item1;
    BusStop firstLegClosestBusStop = closestBusStopWithTime.item2;
    DateTime busStopDep = _dateTime.now().add(Duration(seconds: firstLegSmallestTime.ceil()));
    BusTime? busDeparture = firstLegClosestBusStop.getNextBusDepartureAfterTime(busStopDep);
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
    double busLegTimeSeconds = busLegTime * 60;
    double currentTimeInSecondsSinceEpoch = _dateTime.now().millisecondsSinceEpoch / 1000;
    double timeTillBusDeparts = (busDeparture.getTimeAsDateTimeGivenDateTime(_dateTime).millisecondsSinceEpoch / 1000) - currentTimeInSecondsSinceEpoch;
    double totalEstimate = timeTillBusDeparts + secondLegSmallestTime + busLegTimeSeconds;
    return Tuple3<double, BusStop, BusStop>(totalEstimate, firstLegClosestBusStop, secondLegClosestBusStop);
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
    return EstimateStraightLineDistance.estimateStraightLineDistance(fromLocation, toLocation) / 1; // 1m/s is an underestimate of typical walking speed of an adult.
  }
}