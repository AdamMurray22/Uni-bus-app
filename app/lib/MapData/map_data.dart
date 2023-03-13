import 'package:tuple/tuple.dart';

import '../Map/map_data_id_enum.dart';
import 'bus_stop.dart';
import 'bus_time.dart';
import 'feature.dart';

/// Holds all the information that is retrieved from the backend.
class MapData
{
  late final Map<String, BusStop> _busStops;
  late final Map<String, Feature> _otherFeatures;

  /// The constructor creating the Map of features.
  MapData(Tuple2<Set<Feature>, Map<String, List<BusTime>>> mapData)
  {
    Set<Feature> features = mapData.item1;
    Map<String, List<BusTime>> busTimes = mapData.item2;
    _busStops = {};
    _otherFeatures = {};
    for (Feature feature in features)
    {
      if (MapDataId.getMapDataIdEnumFromId(feature.id) == MapDataId.u1)
      {
        _busStops[feature.id] = BusStop(feature.id, feature.name, feature.long, feature.lat, busTimes[feature.id]??[]);
      }
      else {
        _otherFeatures[feature.id] = feature;
      }
    }
  }

  /// Returns an Iterable of all the features.
  Iterable<Feature> getAllFeatures()
  {
    return {..._otherFeatures.values, ..._busStops.values};
  }

  /// Returns an Iterable of all the features.
  Map<String, Feature> getFeaturesMap()
  {
    return {..._otherFeatures, ..._busStops};
  }

  /// Returns an Iterable of all  the bus stops.
  Iterable<BusStop> getAllBusStops()
  {
    return _busStops.values;
  }
}