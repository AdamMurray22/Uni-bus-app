import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

class BusRouteGeoJsonLoader
{
  static BusRouteGeoJsonLoader? _loader;
  Tuple2<String, Map<String, dynamic>>? _busRouteGeoJson;

  // Private constructor to create a singleton.
  BusRouteGeoJsonLoader._();

  /// Returns the only instance of the BusRouteGeoJsonLoader.
  static BusRouteGeoJsonLoader getBusRouteGeoJsonLoader()
  {
    _loader ??= BusRouteGeoJsonLoader._();
    return _loader!;
  }

  /// Returns the complete bus route GeoJson as loaded from the file.
  Future<Map<String, dynamic>> getBusRouteGeoJson()
  async {
    _busRouteGeoJson ??= await _loadBusRouteGeoJson();
    return _busRouteGeoJson!.item2;
  }

  /// Returns the complete bus route GeoJson as loaded from the file as a String.
  Future<String> getBusRouteGeoJsonAsString()
  async {
    _busRouteGeoJson ??= await _loadBusRouteGeoJson();
    return _busRouteGeoJson!.item1;
  }

  // Loads the bus route GeoJson.
  // Call _getBusRouteGeoJson() instead.
  Future<Tuple2<String, Map<String, dynamic>>> _loadBusRouteGeoJson() async {
    String busRouteJson = await rootBundle
        .loadString(join("assets", "open-layers-map/Bus_Route.geojson"));
    return Tuple2(busRouteJson, jsonDecode(busRouteJson));
  }
}