import 'bus_stop.dart';
import 'feature.dart';

/// Holds all the information that is retrieved from the backend.
class MapData
{
  late final Set<BusStop> _busStops;
  late final Set<Feature> _uniBuildings;
  late final Set<Feature> _landmarks;

  /// The constructor creating the sets of features.
  MapData()
  {
    _busStops = <BusStop>{};
    _uniBuildings = <Feature>{};
    _landmarks = <Feature>{};
    // TODO: remove this test data
    _busStops.add(BusStop("Bus stop ID", "Bus stop Name", -1.0832318, 50.7937047));
    _uniBuildings.add(Feature("Uni building ID", "Uni building Name", -1.0882318, 50.7937047));
    _landmarks.add(Feature("Landmark ID", "Landmark Name", -1.0932318, 50.7937047));
  }

  /// Returns the set of bus stops.
  Set<BusStop> getBusStops()
  {
    return _busStops;
  }

  /// Returns the set of university buildings.
  Set<Feature> getUniBuildings()
  {
    return _uniBuildings;
  }

  /// Returns the set of landmarks.
  Set<Feature> getLandmarks()
  {
    return _landmarks;
  }
}