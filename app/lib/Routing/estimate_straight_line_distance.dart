import 'dart:math' as math;

import 'location.dart';

class EstimateStraightLineDistance
{
  /// Estimates the straight line distance of 2 points in m.
  static double estimateStraightLineDistance(Location fromLocation, Location toLocation)
  {
    return distance(fromLocation.getLatitude(), toLocation.getLatitude(),
        fromLocation.getLongitude(), toLocation.getLongitude());
  }

  static double toRadians(
      double angleIn10thofaDegree)
  {
    // Angle in 10th
    // of a degree
    return (angleIn10thofaDegree *
        math.pi) / 180;
  }
  static double distance(double lat1,
      double lat2,
      double lon1,
      double lon2)
  {

    // The math module contains
    // a function named toRadians
    // which converts from degrees
    // to radians.
    lon1 = toRadians(lon1);
    lon2 = toRadians(lon2);
    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);

    // Haversine formula
    double dlon = lon2 - lon1;
    double dlat = lat2 - lat1;
    num a = math.pow(math.sin(dlat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) *
            math.pow(math.sin(dlon / 2),2);

    double c = 2 * math.asin(math.sqrt(a));

    // Radius of earth in
    // kilometers. Use 3956
    // for miles
    double r = 6371;

    // calculate the result
    return (c * r) * 1000;
  }
}