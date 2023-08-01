import 'dart:math';

import 'location.dart';

class EstimateStraightLineDistance
{
  /// Estimates the straight line distance of 2 points in m.
  static double estimateStraightLineDistance(Location fromLocation, Location toLocation)
  {
    double x = (fromLocation.getLatitude() - toLocation.getLatitude()) *
        cos((fromLocation.getLongitude() + toLocation.getLongitude()) / 2);
    double y = (fromLocation.getLongitude() - toLocation.getLongitude());
    double d = sqrt(x * x + y * y) * 6371000;
    d = d / 100;
    return d;
  }
}