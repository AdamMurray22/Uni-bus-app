import 'dart:math' as math;

import 'location.dart';

class EstimateStraightLineDistance
{
  /// Estimates the straight line distance of 2 points in m.
  static double estimateStraightLineDistance(Location fromLocation, Location toLocation)
  {
    return _distance(fromLocation.getLatitude(), toLocation.getLatitude(),
        fromLocation.getLongitude(), toLocation.getLongitude());
  }

  // Angle in 10th
  // of a degree
  static double _toRadians(
      double angleIn10thofaDegree)
  {
    // Angle in 10th
    // of a degree
    return (angleIn10thofaDegree *
        math.pi) / 180;
  }
  static double _distance(double lat1,
      double lat2,
      double lon1,
      double lon2)
  {

    // The math module contains
    // a function named toRadians
    // which converts from degrees
    // to radians.
    lon1 = _toRadians(lon1);
    lon2 = _toRadians(lon2);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);

    // Haversine formula
    double dlon = lon2 - lon1;
    double dlat = lat2 - lat1;
    num a = math.pow(math.sin(dlat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) *
            math.pow(math.sin(dlon / 2),2);

    double c = 2 * math.asin(math.sqrt(a));

    // Radius of earth in kilometers.
    double r = 6371;

    // calculate the result
    return (c * r) * 1000;
  }
}