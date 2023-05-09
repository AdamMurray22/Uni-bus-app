/// Holds a routing location.
class Location
{
  final double _latitude;
  final double _longitude;

  /// Constructor for the Location setting the longitude and latitude.
  Location(this._longitude, this._latitude);

  /// Returns the latitude.
  double getLatitude()
  {
    return _latitude;
  }

  /// Returns the longitude.
  double getLongitude()
  {
    return _longitude;
  }
}