import 'package:app/Routing/geo_json_geometry.dart';

class WalkingRoute
{
  final List<GeoJsonGeometry> _geometries;
  final double _totalSeconds;
  final double _totalDistance;
  final double? _distanceTillNextTurn;
  late final String? _nextTurn;

  /// Constructor removes "" or '' from the first and last positions of nextTurn.
  WalkingRoute(this._geometries, this._totalSeconds, this._totalDistance, this._distanceTillNextTurn, String? nextTurn)
  {
    if (nextTurn == null || nextTurn == 'null')
    {
      _nextTurn = null;
      return;
    }
    if (nextTurn.length > 1) {
      if (nextTurn[0] == '"' || nextTurn[0] == "'") {
        nextTurn = nextTurn.substring(1);
      }
      if (nextTurn[nextTurn.length - 1] == '"' ||
          nextTurn[nextTurn.length - 1] == "'") {
        nextTurn = nextTurn.substring(0, nextTurn.length - 1);
      }
    }
    _nextTurn = nextTurn;
  }

  /// Returns a geojson of the route geometry.
  List<GeoJsonGeometry> getGeometries()
  {
    return _geometries;
  }

  /// Returns the time remaining in seconds.
  double getTotalSeconds()
  {
    return _totalSeconds;
  }

  /// Returns the total distance remaining in meters.
  double getTotalDistance()
  {
    return _totalDistance;
  }

  /// Returns the distance till the next turn in meters.
  double? getDistanceTillNextTurn()
  {
    return _distanceTillNextTurn;
  }

  /// Returns the next turn.
  String? getNextTurn()
  {
    return _nextTurn;
  }

  /// Returns the total time in whole minutes with a space and then the word
  /// mins after it.
  /// E.g. 70 seconds would be "1 min"
  /// E.g. 170 seconds would be "2 mins"
  String getTotalDisplayTime()
  {
    String displayTime = "";
    int time = (_totalSeconds / 60).floor();
    if (time <= 1)
    {
      displayTime = "${time.toString()} min";
    }
    else
    {
      displayTime = "${time.toString()} mins";
    }
    return displayTime;
  }

  /// Returns the total distance rounded down to the metre
  /// If its less than a km it is in metres with a m after it
  /// else its in km with a km after it.
  /// E.g. 100.4 metres becomes 100m
  /// E.g. 1532.5 metres becomes 1.532km
  String getTotalDisplayDistance()
  {
    return _formatDistance(_totalDistance)!;
  }

  /// Returns the distance till the next turn rounded down to the metre
  /// If its less than a km it is in metres with a m after it
  /// else its in km with a km after it.
  /// E.g. 100.4 metres becomes 100m
  /// E.g. 1532.5 metres becomes 1.532km
  String? getDisplayDistanceTillNextTurn()
  {
    return _formatDistance(_distanceTillNextTurn);
  }

  // Formats the distance given.
  String? _formatDistance(double? distance)
  {
    if (distance == null)
    {
      return null;
    }
    String distanceStr = "";
    if (distance >= 1000)
    {
      distanceStr = "${distance.floor() / 1000}km";
    }
    else
    {
      distanceStr = "${distance.floor()}m";
    }
    return distanceStr;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WalkingRoute &&
              runtimeType == other.runtimeType &&
              _geometries == other._geometries &&
              _totalSeconds == other._totalSeconds &&
              _totalDistance == other._totalDistance &&
              _distanceTillNextTurn == other._distanceTillNextTurn &&
              _nextTurn == other._nextTurn;

  @override
  int get hashCode => _geometries.hashCode;
}