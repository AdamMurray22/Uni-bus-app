/// Defines the lat, long and zoom's for the map.
enum MapCentreEnum
{
  lat(50.7958),
  long(-1.0960),
  initZoom(17),
  markerClickedZoom(19);

  const MapCentreEnum(this.value);
  final double value;
}