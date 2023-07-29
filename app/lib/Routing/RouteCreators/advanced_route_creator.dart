import 'dart:convert';

import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:app/Wrapper/date_time_wrapper.dart';
import 'package:tuple/tuple.dart';
import '../../Map/bus_route_geojson_loader.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../Servers/routing_server.dart';
import '../estimate_straight_line_distance.dart';
import '../geo_json_geometry.dart';
import '../location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  BusRouteGeoJsonLoader _busRouteGeoJsonLoader = BusRouteGeoJsonLoader.getBusRouteGeoJsonLoader();
  DateTimeWrapper _dateTime = DateTimeWrapper();
  final Set<BusStop> _busStops;

  /// Assigns default Server.
  AdvancedRouteCreator(this._busStops) : super();

  /// Allows for non default server and BusRouteGeoJsonLoader and DateTime.
  AdvancedRouteCreator.setServer(this._busStops, RoutingServer server, this._busRouteGeoJsonLoader, this._dateTime) : super.setServer(server);

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
    WalkingRoute route = decodeWalkingRouteJson(jsonResponse);
    return route;
  }

  // Returns the complete route including the bus leg.
  Future<WalkingRoute?> _getBusRoute(Location journeyStart, Location journeyEnd, Tuple3<double, BusStop, BusStop> estimateRoute)
  async {
    BusStop deppBusStop = estimateRoute.item2;
    WalkingRoute firstLeg = await _getWalkingRoute(journeyStart, Location(deppBusStop.long, deppBusStop.lat));
    DateTime busStopDep = _dateTime.now().add(Duration(seconds: firstLeg.getTotalSeconds().ceil()));
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
    Tuple2<String, Tuple2<int, int>> busLegGeoJsonWithStartingAndEndingLegNumbers =
      await _getBusLegGeoJson(deppBusStop, arrBusStop);
    String busLegGeoJson = busLegGeoJsonWithStartingAndEndingLegNumbers.item1;

    WalkingRoute secondLeg = await _getWalkingRoute(Location(arrBusStop.long, arrBusStop.lat), journeyEnd);
    busLegGeoJson =
        _stitchRoutesTogether(busLegGeoJson, firstLeg.getGeometries().first,
            secondLeg.getGeometries().first, busLegGeoJsonWithStartingAndEndingLegNumbers.item2);
    GeoJsonGeometry busLegGeoJsonGeometry = GeoJsonGeometry.setColour(busLegGeoJson, "purple");

    double currentTimeInSecondsSinceEpoch = _dateTime.now().millisecondsSinceEpoch / 1000;
    double timeTillBusDeparts = (busDeparture.getTimeAsDateTimeGivenDateTime(_dateTime).millisecondsSinceEpoch / 1000) - currentTimeInSecondsSinceEpoch;
    WalkingRoute completeRoute =
      WalkingRoute({...firstLeg.getGeometries(), ...secondLeg.getGeometries(), busLegGeoJsonGeometry},
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

  // Returns all of the bus GeoJson for this route.
  Future<Tuple2<String, Tuple2<int, int>>> _getBusLegGeoJson(BusStop departBusStop, BusStop arriveBusStop)
  async {
    Map<String, dynamic> busRouteGeoJson = await _busRouteGeoJsonLoader.getBusRouteGeoJson();
    List<dynamic> busRouteFeaturesJson = busRouteGeoJson["features"];
    Tuple2<List<dynamic>, Tuple2<int, int>> busRouteJsonWithStartingAndEndingLegNumbers =
      _getBusRouteLegs(departBusStop, arriveBusStop, busRouteFeaturesJson);
    busRouteFeaturesJson = busRouteJsonWithStartingAndEndingLegNumbers.item1;
    String busRouteFeaturesJsonString = json.encode({"type": "FeatureCollection", "features": busRouteFeaturesJson});
    return Tuple2(busRouteFeaturesJsonString, busRouteJsonWithStartingAndEndingLegNumbers.item2);
  }

  Tuple2<List<dynamic>, Tuple2<int, int>> _getBusRouteLegs(BusStop departBusStop, BusStop arriveBusStop, List<dynamic> busRouteFeaturesJson)
  {
    int startingLeg = _departBusStopLeg(departBusStop, busRouteFeaturesJson);
    busRouteFeaturesJson = _removeBeforeLegs(startingLeg, busRouteFeaturesJson);
    int endingLeg = _arriveBusStopLeg(arriveBusStop, busRouteFeaturesJson);
    busRouteFeaturesJson = _removeAfterLegs(endingLeg, busRouteFeaturesJson);
    return Tuple2(busRouteFeaturesJson, Tuple2(startingLeg, endingLeg));
  }

  // Returns the closest start of a leg to the departing bus stop.
  int _departBusStopLeg(BusStop departBusStop, List<dynamic> busRouteFeaturesJson)
  {
    Iterable<Tuple2<int, List<dynamic>>> legs =
      busRouteFeaturesJson.map<Tuple2<int, List<dynamic>>>((e) => Tuple2(e["leg"], e["geometry"]["coordinates"][0]));
    int? closestLeg;
    double closestLegDistance = double.infinity;
    for (Tuple2<int, List<dynamic>> leg in legs)
    {
      Location legStartLocation = Location(leg.item2[0], leg.item2[1]);
      Location departBusStopLocation = Location(departBusStop.long, departBusStop.lat);
      double legStartDistanceToDepBusStop = EstimateStraightLineDistance.estimateStraightLineDistance(departBusStopLocation, legStartLocation);
      if (legStartDistanceToDepBusStop < closestLegDistance)
      {
          closestLeg = leg.item1;
          closestLegDistance = legStartDistanceToDepBusStop;
      }
    }
    if (closestLeg == null)
    {
      throw ArgumentError("Bus Route GeoJson empty");
    }
    return closestLeg;
  }

  // Returns the closest end of a leg to the arriving bus stop.
  int _arriveBusStopLeg(BusStop arriveBusStop, List<dynamic> busRouteFeaturesJson)
  {
    Iterable<Tuple2<int, List<dynamic>>> legs =
      busRouteFeaturesJson.map<Tuple2<int, List<dynamic>>>((e) => Tuple2(e["leg"],
          e["geometry"]["coordinates"][e["geometry"]["coordinates"].length - 1]));
    int? closestLeg;
    double closestLegDistance = double.infinity;
    for (Tuple2<int, List<dynamic>> leg in legs)
    {
      Location legStartLocation = Location(leg.item2[0], leg.item2[1]);
      Location departBusStopLocation = Location(arriveBusStop.long, arriveBusStop.lat);
      double legStartDistanceToDepBusStop = EstimateStraightLineDistance.estimateStraightLineDistance(departBusStopLocation, legStartLocation);
      if (legStartDistanceToDepBusStop < closestLegDistance)
      {
        closestLeg = leg.item1;
        closestLegDistance = legStartDistanceToDepBusStop;
      }
    }
    if (closestLeg == null)
    {
      throw ArgumentError("Bus Route GeoJson empty");
    }
    return closestLeg;
  }

  // Returns the GeoJson with the legs before the given number removed.
  List<dynamic> _removeBeforeLegs(int startingLeg, List<dynamic> busRouteFeaturesJson)
  {
    busRouteFeaturesJson.removeWhere((element) => element["leg"] < startingLeg);
    return busRouteFeaturesJson;
  }

  // Returns the GeoJson with the legs after the given number removed.
  List<dynamic> _removeAfterLegs(int endLeg, List<dynamic> busRouteFeaturesJson)
  {
    busRouteFeaturesJson.removeWhere((element) => element["leg"] > endLeg);
    return busRouteFeaturesJson;
  }

  // Returns a bus route json with the ends overlapping the ends of the other 2 jsons.
  String _stitchRoutesTogether(String busLegStr, GeoJsonGeometry firstLeg, GeoJsonGeometry lastLeg, Tuple2<int, int> legs)
  {
    Map<String, dynamic> firstLegJson = firstLeg.getGeometry();
    Map<String, dynamic> lastLegJson = lastLeg.getGeometry();
    Map<String, dynamic> busLeg = jsonDecode(busLegStr);
    List<dynamic> busLegFeatures = busLeg["features"];
    for (Map<String, dynamic> element in busLegFeatures) {
      if (element["leg"] == legs.item1)
      {
        element["geometry"]["coordinates"][0] = firstLegJson["coordinates"][firstLegJson["coordinates"].length - 1];
      }
      if (element["leg"] == legs.item2)
      {
        element["geometry"]["coordinates"][element["geometry"]["coordinates"].length - 1] = lastLegJson["coordinates"][0];
      }
    }
    return jsonEncode(busLeg);
  }
}