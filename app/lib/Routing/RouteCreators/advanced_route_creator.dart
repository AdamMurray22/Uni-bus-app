import 'dart:convert';
import 'dart:math';

import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../Servers/routing_server.dart';
import '../location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  final Set<BusStop> _busStops;
  String? _busRouteGeoJson;

  /// Assigns default Server.
  AdvancedRouteCreator(this._busStops) : super();

  /// Allows for non default server.
  AdvancedRouteCreator.setServer(this._busStops, RoutingServer server) : super.setServer(server);

  /// Creates the fastest route from the start to the end, this route may
  /// include taking the bus.
  @override
  Future<WalkingRoute> createRoute(Location from, Location to)
  async {
    WalkingRoute basicRoute = await _getWalkingRoute(from, to);

    Tuple3<double, BusStop, BusStop>? busRouteEstimate = _getEntireEstimate(from, to);
    if (busRouteEstimate == null)
    {
      return basicRoute;
    }
    double busRouteEstimateTime = busRouteEstimate.item1;
    if (busRouteEstimateTime > basicRoute.getTotalSeconds())
    {
      return basicRoute;
    }

    WalkingRoute? busRoute = await _getBusRoute(from, to, busRouteEstimate);
    if (busRoute == null)
    {
      return basicRoute;
    }
    if (busRoute.getTotalSeconds() > basicRoute.getTotalSeconds())
    {
      return basicRoute;
    }
    return busRoute;
  }

  // Returns the walking route between two location.
  Future<WalkingRoute> _getWalkingRoute(Location from, Location to)
  async {
    Map<String, dynamic> jsonResponse = await getJsonResponse(from, to);
    WalkingRoute route = decodeJson(jsonResponse);
    return route;
  }

  // Returns the complete route including the bus leg.
  Future<WalkingRoute?> _getBusRoute(Location journeyStart, Location journeyEnd, Tuple3<double, BusStop, BusStop> estimateRoute)
  async {
    BusStop deppBusStop = estimateRoute.item2;
    WalkingRoute firstLeg = await _getWalkingRoute(journeyStart, Location(deppBusStop.long, deppBusStop.lat));
    DateTime busStopDep = DateTime.now().add(Duration(seconds: firstLeg.getTotalSeconds().ceil()));
    BusTime? busDeparture = deppBusStop.getNextBusDepartureAfterTime(busStopDep);
    if (busDeparture == null)
    {
      return null;
    }

    BusStop arrBusStop = estimateRoute.item3;
    BusTime? busArrival = arrBusStop.getArrivalTimeOnRoute(busDeparture.getRouteNumber());
    if (busArrival == null)
    {
      return null;
    }
    int busLegTime = busArrival.getTimeAsMins() - busDeparture.getTimeAsMins();
    double busLegTimeSeconds = busLegTime * 60;
    List<String> busLegGeoJson = _getBusLegGeoJson(deppBusStop, arrBusStop, journeyStart);

    WalkingRoute secondLeg = await _getWalkingRoute(Location(arrBusStop.long, arrBusStop.lat), journeyEnd);
    double currentTimeInSecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch / 1000;
    double timeTillBusDeparts = (busDeparture.getTimeAsDateTime().millisecondsSinceEpoch / 1000) - currentTimeInSecondsSinceEpoch;
    WalkingRoute completeRoute =
      WalkingRoute([...firstLeg.getGeometries(), ...secondLeg.getGeometries(), ...busLegGeoJson],
          timeTillBusDeparts + secondLeg.getTotalSeconds() + busLegTimeSeconds,
          firstLeg.getTotalDistance() + secondLeg.getTotalDistance(),
          firstLeg.getDistanceTillNextTurn(), firstLeg.getNextTurn());
    return completeRoute;
  }

  // Gets the complete estimate for the time in seconds for the route taking
  // the bus (if applicable).
  Tuple3<double, BusStop, BusStop>? _getEntireEstimate(Location journeyStart, Location journeyEnd)
  {
    Tuple2<double, BusStop>? closestBusStopWithTime = _getClosestBusStop(journeyStart, _busStops);
    if (closestBusStopWithTime == null)
    {
      return null;
    }
    double firstLegSmallestTime = closestBusStopWithTime.item1;
    BusStop firstLegClosestBusStop = closestBusStopWithTime.item2;
    DateTime busStopDep = DateTime.now().add(Duration(seconds: firstLegSmallestTime.ceil()));
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
    double currentTimeInSecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch / 1000;
    double timeTillBusDeparts = (busDeparture.getTimeAsDateTime().millisecondsSinceEpoch / 1000) - currentTimeInSecondsSinceEpoch;
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
    return _estimateStraightLineDistance(fromLocation, toLocation) / 1.6; // 1.6m/s is an overestimate of typical walking speed of an adult.
  }

  // Estimates the straight line distance of 2 points in m.
  double _estimateStraightLineDistance(Location fromLocation, Location toLocation)
  {
    double x = (fromLocation.getLatitude() - toLocation.getLatitude()) *
        cos((fromLocation.getLongitude() + toLocation.getLongitude()) / 2);
    double y = (fromLocation.getLongitude() - toLocation.getLongitude());
    double d = sqrt(x * x + y * y) * 6371000;
    d = d / 100;
    return d;
  }

  List<String> _getBusLegGeoJson(BusStop departBusStop, BusStop arriveBusStop, Location currentLocation)
  {
    return [];
  }

  Future<String> _getBusRouteGeoJson()
  async {
    _busRouteGeoJson ??= await _loadBusRouteGeoJson();
    return _busRouteGeoJson!;
  }

  //Displays the bus route on the map.
  Future<String> _loadBusRouteGeoJson() async {
      String busRouteJson = await rootBundle
          .loadString(join("assets", "open-layers-map/Bus_Route.geojson"));
      return jsonDecode(busRouteJson);
  }
}