/// Error for when the map data id enum cannot be found from an id String.
class MapDataIdNotFoundException extends Error
{
  String message;
  MapDataIdNotFoundException(this.message);
}