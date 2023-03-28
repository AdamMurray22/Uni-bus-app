/// Defines the ids for the map layers.
enum MapDataId
{
  u1("U1-"),
  uniBuilding("UB-"),
  landmark("LM-"),
  userLocation("UL-"),
  route("RT-"),
  destination("DN-");

  const MapDataId(this.idPrefix);
  final String idPrefix;

  /// Returns the MapDataId enum that corresponds to the given id.
  static MapDataId getMapDataIdEnumFromId(String id)
  {
    for (MapDataId mapDataId in MapDataId.values)
    {
      if (id.startsWith(mapDataId.idPrefix))
      {
        return mapDataId;
      }
    }
    throw Exception("Id not found.");
  }
}