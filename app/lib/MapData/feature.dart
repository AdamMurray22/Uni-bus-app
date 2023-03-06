/// Holds the information for a feature on the map.
class Feature
{
  final String id;
  final String name;
  final double long;
  final double lat;

  /// The constructor assigning the id, name, longitude and latitude.
  Feature(this.id, this.name, this.long, this.lat);
}