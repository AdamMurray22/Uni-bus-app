import 'dart:convert';

import 'package:app/Sorts/heap_sort.dart';
import 'package:app/Sorts/comparator.dart';
import 'package:flutter/material.dart';
import '../../MapData/bus_stop.dart';
import '../../MapData/bus_time.dart';
import '../../Wrapper/date_time_wrapper.dart';
import '../estimate_straight_line_distance.dart';
import '../geo_json_geometry.dart';
import '../location.dart';
import '../walking_route.dart';

/// Trims the geo json for the bus leg of a route when the user is on the bus.
class BusRouteGeoJsonTrimmer
{
  final DateTimeWrapper _dateTime;
  late final GeoJsonGeometry _busGeoJson;
  final BusStop _startBusStop;
  final BusStop _endBusStop;
  final BusTime _arriveBusTime;
  final WalkingRoute? _finalLeg;

  /// The geo json geometry for the bus journey, the first and last bus stops
  /// on the journey, the final leg of the journey, and the time the bus
  /// arrives at the last stop on the journey.
  BusRouteGeoJsonTrimmer(GeoJsonGeometry busGeoJsonGeometry, this._startBusStop, this._endBusStop, this._finalLeg, this._arriveBusTime, this._dateTime)
  {
    _busGeoJson = _convertFromLegsToList(busGeoJsonGeometry);
  }

  // Converts the geo json from a list of legs to one long list.
  GeoJsonGeometry _convertFromLegsToList(GeoJsonGeometry busGeoJsonGeometry)
  {
    Map<String, dynamic> busGeoJson = busGeoJsonGeometry.getGeometry();
    List<dynamic> legs = busGeoJson["features"];
    legs = _sortLegs(legs);
    Map<String, dynamic> route = _stitchBusLegs(legs);
    return GeoJsonGeometry.setColour(jsonEncode(route), busGeoJsonGeometry.getColour());
  }

  /// Continues a bus Route bus trimming the geo json to the location of the user.
  Future<WalkingRoute?> continueBusRoute(Location from) async {
    if (atBusStop(from, _endBusStop))
    {
      return null;
    }
    GeoJsonGeometry? geoJson = _getGeoJson(from, _busGeoJson);
    if (geoJson == null)
    {
      if (!atBusStop(from, _startBusStop)) {
        return null;
      }
      geoJson =
          GeoJsonGeometry.setColour(jsonEncode(_addLocationToFront(from, _busGeoJson)),
              _busGeoJson.getColour());
    }
    return _createWalkingRoute(geoJson, _finalLeg);
  }

  /// Returns true if from is within 10 meters of the bus stop.
  static bool atBusStop(Location from, BusStop busStop)
  {
    double distance = EstimateStraightLineDistance.estimateStraightLineDistance(from, Location(busStop.long, busStop.lat));
    return distance < 10;
  }

  // Returns a geo json cut to the given location.
  GeoJsonGeometry? _getGeoJson(Location from, GeoJsonGeometry busGeoJsonGeometry)
  {
    bool locationFound = false;
    Map<String, dynamic> busGeoJson = busGeoJsonGeometry.getGeometry();
    List<dynamic> coordinates = busGeoJson["geometry"]["coordinates"];
    for (int i = 0; i < coordinates.length - 2; i++)
    {
      double distanceFromLocation = EstimateStraightLineDistance.estimateStraightLineDistance(from,
          Location(coordinates[i + 1][0], coordinates[i + 1][1]));
      double distanceFromLastCoordinate = EstimateStraightLineDistance.estimateStraightLineDistance(
          Location(coordinates[i][0], coordinates[i][1]),
          Location(coordinates[i + 1][0], coordinates[i + 1][1]));
      if (distanceFromLocation < distanceFromLastCoordinate)
      {
        for (int n = i; n >= 0; n--) {
          coordinates.removeAt(n);
          i--;
        }
        locationFound = true;
      }
    }
    if (!locationFound)
    {
      return null;
    }
    return GeoJsonGeometry.setColour(jsonEncode(busGeoJson), busGeoJsonGeometry.getColour());
  }

  // Adds the locations coordinates to the front of the geo json.
  Map<String, dynamic> _addLocationToFront(Location from, GeoJsonGeometry busGeoJson)
  {
    Map<String, dynamic> geoJson = busGeoJson.getGeometry();
    List<dynamic> coordinates = geoJson["geometry"]["coordinates"];
    coordinates.insert(0, [from.getLongitude(), from.getLatitude()]);
    return geoJson;
  }

  // Sort the legs in order by increasing value.
  List<dynamic> _sortLegs(List<dynamic> legs)
  {
    HeapSort<dynamic> sort = HeapSort((leg1, leg2)
    {
      int leg1Number = leg1["leg"];
      int leg2Number = leg2["leg"];
      if (leg1Number < leg2Number)
      {
        return Comparator.before;
      }
      return Comparator.after;
    });
    return sort.sort(legs);
  }

  // Stitch all the legs together into one long list of coordinates.
  Map<String, dynamic> _stitchBusLegs(List<dynamic> legs)
  {
    Map<String, dynamic> route = legs.first;
    legs.removeAt(0);
    route.remove("leg");
    List<dynamic> coordinates = route["geometry"]["coordinates"];
    for (Map<String, dynamic> leg in legs)
    {
      List<dynamic> legCoordinates = leg["geometry"]["coordinates"];
      legCoordinates.removeAt(0);
      coordinates.addAll(legCoordinates);
    }
    return route;
  }

  // Returns a bus route json with the ends overlapping the ends of the other 2 json's.
  GeoJsonGeometry _stitchRoutesTogether(GeoJsonGeometry busLeg, GeoJsonGeometry lastLeg) {
    Map<String, dynamic> lastLegJson = lastLeg.getGeometry();
    Map<String, dynamic> busLegJson = busLeg.getGeometry();
    int index = busLegJson["geometry"]["coordinates"].length - 1;
    lastLegJson["coordinates"][0] =
      busLegJson["geometry"]["coordinates"][index];
    return GeoJsonGeometry(jsonEncode(lastLegJson));
  }

  // Creates the completed WalkingRoute.
  WalkingRoute _createWalkingRoute(GeoJsonGeometry geoJson, WalkingRoute? finalLeg)
  {
    double? totalDistance = finalLeg?.getTotalDistance();
    totalDistance ??= 0;
    double? totalSeconds = finalLeg?.getTotalSeconds();
    totalSeconds ??= 0;
    totalSeconds += (_arriveBusTime.getTimeAsDateTimeGivenDateTime(_dateTime).millisecondsSinceEpoch - _dateTime.now().millisecondsSinceEpoch) / 1000;
    List<GeoJsonGeometry> geometries = [geoJson];
    if (finalLeg != null)
    {
      geometries.add(_stitchRoutesTogether(geoJson, finalLeg.getGeometries().first));
      List<GeoJsonGeometry> finalLegGeometry = finalLeg.getGeometries().sublist(1);
      geometries.addAll(finalLegGeometry);
    }
    return WalkingRoute(geometries, totalSeconds, totalDistance, null, null);
  }
}