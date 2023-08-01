import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../Map/bus_route_geojson_loader.dart';
import '../../MapData/bus_stop.dart';
import '../estimate_straight_line_distance.dart';
import '../location.dart';

/// Generates the geo json for the bus leg of a route.
class BusRouteGeoJsonMaker {
  BusRouteGeoJsonLoader _busRouteGeoJsonLoader =
      BusRouteGeoJsonLoader.getBusRouteGeoJsonLoader();

  /// Uses default geo json loader.
  BusRouteGeoJsonMaker();

  /// Used for testing purposes only.
  @protected
  BusRouteGeoJsonMaker.setGeoJsonLoader(this._busRouteGeoJsonLoader);

  /// Returns all of the bus GeoJson for this route.
  Future<Tuple2<String, Tuple2<int, int>>> getBusLegGeoJson(
      BusStop departBusStop, BusStop arriveBusStop) async {
    Map<String, dynamic> busRouteGeoJson =
        await _busRouteGeoJsonLoader.getBusRouteGeoJson();
    List<dynamic> busRouteFeaturesJson = busRouteGeoJson["features"];
    Tuple2<List<dynamic>, Tuple2<int, int>>
        busRouteJsonWithStartingAndEndingLegNumbers =
        _getBusRouteLegs(departBusStop, arriveBusStop, busRouteFeaturesJson);
    busRouteFeaturesJson = busRouteJsonWithStartingAndEndingLegNumbers.item1;
    String busRouteFeaturesJsonString = json.encode(
        {"type": "FeatureCollection", "features": busRouteFeaturesJson});
    return Tuple2(busRouteFeaturesJsonString,
        busRouteJsonWithStartingAndEndingLegNumbers.item2);
  }

  // Returns the legs of the bus route on the current journey.
  Tuple2<List<dynamic>, Tuple2<int, int>> _getBusRouteLegs(
      BusStop departBusStop,
      BusStop arriveBusStop,
      List<dynamic> busRouteFeaturesJson) {
    int startingLeg = _departBusStopLeg(departBusStop, busRouteFeaturesJson);
    busRouteFeaturesJson = _removeBeforeLegs(startingLeg, busRouteFeaturesJson);
    int endingLeg = _arriveBusStopLeg(arriveBusStop, busRouteFeaturesJson);
    busRouteFeaturesJson = _removeAfterLegs(endingLeg, busRouteFeaturesJson);
    return Tuple2(busRouteFeaturesJson, Tuple2(startingLeg, endingLeg));
  }

  // Returns the closest start of a leg to the departing bus stop.
  int _departBusStopLeg(
      BusStop departBusStop, List<dynamic> busRouteFeaturesJson) {
    Iterable<Tuple2<int, List<dynamic>>> legs =
        busRouteFeaturesJson.map<Tuple2<int, List<dynamic>>>(
            (e) => Tuple2(e["leg"], e["geometry"]["coordinates"][0]));
    int? closestLeg;
    double closestLegDistance = double.infinity;
    for (Tuple2<int, List<dynamic>> leg in legs) {
      Location legStartLocation = Location(leg.item2[0], leg.item2[1]);
      Location departBusStopLocation =
          Location(departBusStop.long, departBusStop.lat);
      double legStartDistanceToDepBusStop =
          EstimateStraightLineDistance.estimateStraightLineDistance(
              departBusStopLocation, legStartLocation);
      if (legStartDistanceToDepBusStop < closestLegDistance) {
        closestLeg = leg.item1;
        closestLegDistance = legStartDistanceToDepBusStop;
      }
    }
    if (closestLeg == null) {
      throw ArgumentError("Bus Route GeoJson empty");
    }
    return closestLeg;
  }

  // Returns the closest end of a leg to the arriving bus stop.
  int _arriveBusStopLeg(
      BusStop arriveBusStop, List<dynamic> busRouteFeaturesJson) {
    Iterable<Tuple2<int, List<dynamic>>> legs =
        busRouteFeaturesJson.map<Tuple2<int, List<dynamic>>>((e) => Tuple2(
            e["leg"],
            e["geometry"]["coordinates"]
                [e["geometry"]["coordinates"].length - 1]));
    int? closestLeg;
    double closestLegDistance = double.infinity;
    for (Tuple2<int, List<dynamic>> leg in legs) {
      Location legStartLocation = Location(leg.item2[0], leg.item2[1]);
      Location departBusStopLocation =
          Location(arriveBusStop.long, arriveBusStop.lat);
      double legStartDistanceToDepBusStop =
          EstimateStraightLineDistance.estimateStraightLineDistance(
              departBusStopLocation, legStartLocation);
      if (legStartDistanceToDepBusStop < closestLegDistance) {
        closestLeg = leg.item1;
        closestLegDistance = legStartDistanceToDepBusStop;
      }
    }
    if (closestLeg == null) {
      throw ArgumentError("Bus Route GeoJson empty");
    }
    return closestLeg;
  }

  // Returns the GeoJson with the legs before the given number removed.
  List<dynamic> _removeBeforeLegs(
      int startingLeg, List<dynamic> busRouteFeaturesJson) {
    busRouteFeaturesJson.removeWhere((element) => element["leg"] < startingLeg);
    return busRouteFeaturesJson;
  }

  // Returns the GeoJson with the legs after the given number removed.
  List<dynamic> _removeAfterLegs(
      int endLeg, List<dynamic> busRouteFeaturesJson) {
    busRouteFeaturesJson.removeWhere((element) => element["leg"] > endLeg);
    return busRouteFeaturesJson;
  }
}
