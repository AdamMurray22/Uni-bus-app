import 'package:app/Routing/RouteCreators/basic_route_creator.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:tuple/tuple.dart';
import '../Routing/RouteCreators/route_creator.dart';
import '../Routing/geo_json_geometry.dart';
import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import 'map_widget.dart';

import '../Routing/location.dart';

class RouteMapWidget extends MapWidget {
  const RouteMapWidget({required this.routeScreenUpdateFunction, super.pingTileServerFunction, super.key});

  // The function to be run whenever a route is updated.
  final Function(WalkingRoute) routeScreenUpdateFunction;

  @override
  MapWidgetState<RouteMapWidget> createState() => RouteMapWidgetState();
}

/// The route screen state.
class RouteMapWidgetState extends MapWidgetState<RouteMapWidget> {
  RouteCreator _routeCreator = BasicRouteCreator();
  Tuple2<String, String>? _currentRoute;

  /// Sets the values for the map set up.
  @override
  void initState() {
    onPageFinished = (url) async {
      await setMapCentreZoom(MapCentreEnum.lat.value, MapCentreEnum.long.value,
          MapCentreEnum.initZoom.value);
      await addUserLocationIcon();
    };
    super.initState();
  }

  // Assigns an id to each layer used by this map to be referenced later.
  @override
  createLayers() async {
    await createGeoJsonLayer(MapDataId.route.idPrefix, "blue", 8);
    await createMakerLayer(MapDataId.destination.idPrefix, "DestinationIcon.png", 0.1, false);
    await createMakerLayer(MapDataId.userLocation.idPrefix, "UserIcon.png", 0.1, false);
  }

  /// Sets the current route.
  setCurrentRoute(String fromId, String toId)
  {
    _currentRoute = Tuple2(fromId, toId);
  }

  /// Creates the route between the given locations.
  createRoute(Location from, Location to, String fromId, String toId) async {
    if (!(_currentRoute?.item1 == fromId && _currentRoute?.item2 == toId))
    {
      return;
    }
    WalkingRoute route = await _routeCreator.createRoute(from, to);
    await _setRouteGeoJson(route.getGeometries());
    widget.routeScreenUpdateFunction(route);
  }

  /// Removes the route.
  endRoute(String? fromId, String? toId) async {
    clearGeoJsonLayer(MapDataId.route.idPrefix);
    _currentRoute = null;
    if (fromId != null)
    {
      removeMarker(MapDataId.destination.idPrefix, '${MapDataId.destination.idPrefix}s');
    }
    if (toId != null) {
      removeMarker(MapDataId.destination.idPrefix, MapDataId.destination.idPrefix);
    }
  }

  /// Adds the destination marker.
  addDestinationMarker(Location location)
  async {
    await updateMarker(MapDataId.destination.idPrefix,
        MapDataId.destination.idPrefix, location.getLongitude(), location.getLatitude());
  }

  /// Adds the start marker.
  addStartMarker(Location location)
  async {
    await updateMarker(MapDataId.destination.idPrefix,
        "${MapDataId.destination.idPrefix}s", location.getLongitude(), location.getLatitude());
  }

  /// Sets the RouteCreator.
  setRouteCreator(RouteCreator routeCreator)
  {
    _routeCreator = routeCreator;
  }

  // Displays the route on the map.
  _setRouteGeoJson(List<GeoJsonGeometry> routeGeometries) async {
    clearGeoJsonLayer(MapDataId.route.idPrefix);
    for (GeoJsonGeometry routeGeometry in routeGeometries)
    {
      if (routeGeometry.hasColour())
      {
        await addGeoJsonWithColour(MapDataId.route.idPrefix, routeGeometry.getGeometryString(), routeGeometry.getColour()!);
      }
      else
      {
        await addGeoJson(MapDataId.route.idPrefix, routeGeometry.getGeometryString());
      }
    }
  }
}
