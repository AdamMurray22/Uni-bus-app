import 'dart:convert';

import 'package:app/Routing/RouteCreators/bus_route_geo_json_maker.dart';
import 'package:app/Routing/RouteCreators/bus_route_estimator.dart';
import 'package:app/Routing/RouteCreators/bus_route_geo_json_trimmer.dart';
import 'package:app/Routing/RouteCreators/route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:app/Wrapper/date_time_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../Map/bus_route_geojson_loader.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../Servers/routing_server.dart';
import '../geo_json_geometry.dart';
import '../location.dart';

/// Creates the indented route using the bus timetable.
class AdvancedRouteCreator extends RouteCreator
{
  DateTimeWrapper _dateTime = DateTimeWrapper();
  late BusRouteEstimator busRouteEstimator;
  late BusRouteGeoJsonMaker busRouteGeoJsonMaker;
  BusRouteGeoJsonTrimmer? _busRouteGeoJsonTrimmer;

  /// Assigns default Server.
  AdvancedRouteCreator(Set<BusStop> busStops) : super() {
    busRouteEstimator = BusRouteEstimator(busStops);
    busRouteGeoJsonMaker = BusRouteGeoJsonMaker();
  }

  /// Allows for non default server and BusRouteGeoJsonLoader and DateTime.
  /// Used for testing purposes only.
  @protected
  AdvancedRouteCreator.setServer(Set<BusStop> busStops, RoutingServer server,
      BusRouteGeoJsonLoader busRouteGeoJsonLoader, this._dateTime)
      : super.setServer(server) {
    busRouteEstimator = BusRouteEstimator.setDateTime(busStops, _dateTime);
    busRouteGeoJsonMaker =
        BusRouteGeoJsonMaker.setGeoJsonLoader(busRouteGeoJsonLoader);
  }

  /// Creates the fastest route from the start to the end, this route may
  /// include taking the bus.
  @override
  Future<WalkingRoute> createRoute(Location from, Location to) async {
    if (_busRouteGeoJsonTrimmer != null)
    {
      WalkingRoute? route = await _busRouteGeoJsonTrimmer?.continueBusRoute(from);
      if (route != null)
      {
        return route;
      }
      _busRouteGeoJsonTrimmer = null;
    }
    return await _generateRoute(from, to);
  }

  // Generates a new route.
  Future<WalkingRoute> _generateRoute(Location from, Location to) async {
    WalkingRoute basicRoute = await _getWalkingRoute(from, to);

    Tuple3<double, BusStop, BusStop>? busRouteEstimate =
      busRouteEstimator.getEntireEstimate(from, to);
    if (busRouteEstimate == null) {
      return basicRoute;
    }
    double busRouteEstimateTime = busRouteEstimate.item1;
    if (busRouteEstimateTime > basicRoute.getTotalSeconds()) {
      return basicRoute;
    }

    Tuple2<WalkingRoute, BusRouteGeoJsonTrimmer?>? busRouteWithTrimmer = await _getBusRoute(from, to, busRouteEstimate);
    if (busRouteWithTrimmer == null) {
      return basicRoute;
    }
    WalkingRoute busRoute = busRouteWithTrimmer.item1;
    if (busRoute.getTotalSeconds() > basicRoute.getTotalSeconds()) {
      return basicRoute;
    }

    _busRouteGeoJsonTrimmer = busRouteWithTrimmer.item2;
    return busRoute;
  }

  // Returns the walking route between two location.
  Future<WalkingRoute> _getWalkingRoute(Location from, Location to) async {
    Map<String, dynamic> jsonResponse = await getJsonResponse(from, to);
    WalkingRoute route = decodeWalkingRouteJson(jsonResponse);
    return route;
  }

  // Returns the complete route including the bus leg.
  Future<Tuple2<WalkingRoute, BusRouteGeoJsonTrimmer?>?> _getBusRoute(Location journeyStart, Location journeyEnd,
      Tuple3<double, BusStop, BusStop> estimateRoute) async {
    BusStop deppBusStop = estimateRoute.item2;
    WalkingRoute firstLeg = await _getWalkingRoute(
        journeyStart, Location(deppBusStop.long, deppBusStop.lat));
    DateTime busStopDep = _dateTime.now().add(Duration(seconds: firstLeg.getTotalSeconds().ceil()));
    BusTime? busDeparture =
        deppBusStop.getNextBusDepartureAfterTime(busStopDep);
    if (busDeparture == null) {
      return null;
    }

    BusStop arrBusStop = estimateRoute.item3;
    BusTime? busArrival =
        arrBusStop.getArrivalTimeOnRoute(busDeparture.getRouteNumber());
    if (busArrival == null) {
      return null;
    }
    int busLegTime = busArrival.getTimeAsMins() - busDeparture.getTimeAsMins();
    double busLegTimeSeconds = busLegTime * 60;
    Tuple2<String, Tuple2<int, int>>
        busLegGeoJsonWithStartingAndEndingLegNumbers =
        await busRouteGeoJsonMaker.getBusLegGeoJson(deppBusStop, arrBusStop);
    String busLegGeoJson = busLegGeoJsonWithStartingAndEndingLegNumbers.item1;

    WalkingRoute secondLeg = await _getWalkingRoute(
        Location(arrBusStop.long, arrBusStop.lat), journeyEnd);
    Tuple2<String, String> stitchedRoutes = _stitchRoutesTogether(
        busLegGeoJson,
        firstLeg.getGeometries().first,
        secondLeg.getGeometries().first,
        busLegGeoJsonWithStartingAndEndingLegNumbers.item2);
    GeoJsonGeometry busLegGeoJsonGeometry =
        GeoJsonGeometry.setColour(stitchedRoutes.item1, "purple");
    secondLeg.getGeometries().removeAt(0);

    double currentTimeInSecondsSinceEpoch =
        _dateTime.now().millisecondsSinceEpoch / 1000;
    double timeTillBusDeparts = (busDeparture
                .getTimeAsDateTimeGivenDateTime(_dateTime)
                .millisecondsSinceEpoch /
            1000) -
        currentTimeInSecondsSinceEpoch;
    WalkingRoute completeRoute = WalkingRoute([
      ...firstLeg.getGeometries(),
      busLegGeoJsonGeometry,
      GeoJsonGeometry(stitchedRoutes.item2),
      ...secondLeg.getGeometries()
    ],
        timeTillBusDeparts + secondLeg.getTotalSeconds() + busLegTimeSeconds,
        firstLeg.getTotalDistance() + secondLeg.getTotalDistance(),
        firstLeg.getDistanceTillNextTurn(),
        firstLeg.getNextTurn());

    BusRouteGeoJsonTrimmer? busRouteGeoJsonTrimmer;
    if (BusRouteGeoJsonTrimmer.atBusStop(journeyStart, deppBusStop))
    {
      busRouteGeoJsonTrimmer =
          BusRouteGeoJsonTrimmer(
              GeoJsonGeometry.setColour(busLegGeoJsonWithStartingAndEndingLegNumbers.item1, "purple"),
              deppBusStop, arrBusStop, secondLeg, busArrival, _dateTime);
    }
    return Tuple2(completeRoute, busRouteGeoJsonTrimmer);
  }

  // Returns a bus route json with the ends overlapping the ends of the other 2 jsons.
  Tuple2<String, String> _stitchRoutesTogether(String busLegStr, GeoJsonGeometry firstLeg,
      GeoJsonGeometry lastLeg, Tuple2<int, int> legs) {
    Map<String, dynamic> firstLegJson = firstLeg.getGeometry();
    Map<String, dynamic> lastLegJson = lastLeg.getGeometry();
    Map<String, dynamic> busLeg = jsonDecode(busLegStr);
    List<dynamic> busLegFeatures = busLeg["features"];
    for (Map<String, dynamic> busRoute in busLegFeatures) {
      if (busRoute["leg"] == legs.item1) {
        busRoute["geometry"]["coordinates"][0] =
            firstLegJson["coordinates"][firstLegJson["coordinates"].length - 1];
      }
      if (busRoute["leg"] == legs.item2) {
        lastLegJson["coordinates"][0] = busRoute["geometry"]["coordinates"]
                [busRoute["geometry"]["coordinates"].length - 1];
      }
    }
    return Tuple2(jsonEncode(busLeg), jsonEncode(lastLegJson));
  }
}
