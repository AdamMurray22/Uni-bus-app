import '../Map/map_data_id_enum.dart';
import 'bus_stop.dart';
import 'feature.dart';

/// Holds all the information that is retrieved from the backend.
class MapData
{
  late final Map<String, Feature> _features;

  /// The constructor creating the Map of features.
  MapData(Set<Feature> features)
  {
    _features = {};

    for (Feature feature in features)
    {
      _features[feature.id] = feature;
    }
  }

  /// Returns a set of all the features.
  Iterable<Feature> getAllFeatures()
  {
    return _features.values;
  }
}