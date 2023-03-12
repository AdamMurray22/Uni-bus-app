import 'package:tuple/tuple.dart';

import '../Map/map_data_id_enum.dart';
import 'bus_stop.dart';
import 'bus_time.dart';
import 'feature.dart';

/// Holds all the information that is retrieved from the backend.
class MapData
{
  late final Map<String, Feature> _features;

  /// The constructor creating the Map of features.
  MapData(Tuple2<Set<Feature>, Map<String, List<BusTime>>> mapData)
  {
    Set<Feature> features = mapData.item1;
    Map<String, List<BusTime>> busTimes = mapData.item2;
    _features = {};
    for (Feature feature in features)
    {
      if (MapDataId.getMapDataIdEnumFromId(feature.id) == MapDataId.u1)
      {
        feature = BusStop(feature.id, feature.name, feature.long, feature.lat, busTimes[feature.id]!);
      }
      _features[feature.id] = feature;
    }
  }

  /// Returns a set of all the features.
  Iterable<Feature> getAllFeatures()
  {
    return _features.values;
  }
}