import '../../MapData/bus_stop.dart';
import '../estimate_straight_line_distance.dart';
import '../geo_json_geometry.dart';
import '../location.dart';
import '../walking_route.dart';

/// Trims the geo json for the bus leg of a route when the user is on the bus.
class BusRouteGeoJsonTrimmer
{
  GeoJsonGeometry _busGeoJson;
  BusStop _startBusStop;
  BusStop _endBusStop;
  WalkingRoute? _finalLeg;

  BusRouteGeoJsonTrimmer(this._busGeoJson, this._startBusStop, this._endBusStop, this._finalLeg);

  /// Continues a bus Route bus trimming the geojson to the location of the user.
  Future<WalkingRoute?> continueBusRoute(Location from) async {
    if (atBusStop(from, _endBusStop!))
    {
      return null;
    }
    return null;
  }

  /// Returns true if from is within 10 meters of the bus stop.
  static atBusStop(Location from, BusStop busStop)
  {
    double distance = EstimateStraightLineDistance.estimateStraightLineDistance(from, Location(busStop.long, busStop.lat));
    return distance < 10;
  }
}