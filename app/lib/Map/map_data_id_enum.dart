/// Defines the ids for the map layers
enum MapDataId
{
  u1("U1-"),
  u2("U2-"),
  uniBuilding("UB-"),
  landmark("LM-"),
  userLocation("UserIcon");

  const MapDataId(this.id);
  final String id;
}