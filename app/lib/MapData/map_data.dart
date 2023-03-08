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
    _busStops.add(BusStop("U1-3244", "Bus stop Name", -1.0802318, 50.7937047));
    _busStops.add(BusStop("U2-2342", "Bus stop Name", -1.0832318, 50.7937047));
    _uniBuildings.add(Feature("UB-24324", "Uni building Name", -1.0882318, 50.7937047));
    _landmarks.add(Feature("LM-32434", "Landmark Name", -1.0932318, 50.7937047));
  }

  /// Returns a set of all the features.
  Set<Feature> getAllFeatures()
  {
    return {..._busStops, ..._landmarks, ..._uniBuildings};
  }
}