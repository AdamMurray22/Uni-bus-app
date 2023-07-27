class WalkingRoute
{
  final String _geometry;
  final double _totalSeconds;
  final double _totalDistance;
  final double _distanceTillNextTurn;
  final String _nextTurn;

  WalkingRoute(this._geometry, this._totalSeconds, this._totalDistance, this._distanceTillNextTurn, this._nextTurn);

  /// Returns a geojson of the route geometry.
  String getGeometry()
  {
    return _geometry;
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
  double getDistanceTillNextTurn()
  {
    return _distanceTillNextTurn;
  }

  /// Returns the next turn.
  String getNextTurn()
  {
    return _nextTurn;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WalkingRoute &&
              runtimeType == other.runtimeType &&
              _geometry == other._geometry &&
              _totalSeconds == other._totalSeconds &&
              _totalDistance == other._totalDistance &&
              _distanceTillNextTurn == other._distanceTillNextTurn &&
              _nextTurn == other._nextTurn;

  @override
  int get hashCode => _geometry.hashCode;
}