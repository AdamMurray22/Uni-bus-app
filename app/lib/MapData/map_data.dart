import 'package:tuple/tuple.dart';

import '../Map/map_data_id_enum.dart';
import 'bus_running_dates.dart';
import 'bus_stop.dart';
import 'bus_time.dart';
import 'feature.dart';

/// Holds all the information that is retrieved from the backend.
class MapData
{
  late final Map<String, BusStop> _busStops;
  late final Map<String, Feature> _otherFeatures;

  /// The constructor creating the Map of features.
  MapData(Tuple4<Set<Feature>, Map<String, List<BusTime>>, Map<String, List<BusTime>>, BusRunningDates> mapData)
  {
    Set<Feature> features = mapData.item1;
    Map<String, List<BusTime>> busArrTimes = mapData.item2;
    Map<String, List<BusTime>> busDepTimes = mapData.item3;
    BusRunningDates busRunningDates = mapData.item4;
    _busStops = {};
    _otherFeatures = {};
    bool isBusRunning = busRunningDates.isBusRunning();
    for (Feature feature in features)
    {
      if (MapDataId.getMapDataIdEnumFromId(feature.id) == MapDataId.u1)
      {
        BusStop busStop = BusStop(feature.id, feature.name, feature.long, feature.lat, busArrTimes[feature.id]??[], busDepTimes[feature.id]??[], isBusRunning);
        for (BusTime busTime in busStop.getArrivalTimes())
        {
          busTime.setBusStop(busStop);
        }
        if (busStop.getHasSeparateArrDepTimes())
        {
          for (BusTime busTime in busStop.getDepartureTimes())
          {
            busTime.setBusStop(busStop);
          }
        }
        _busStops[feature.id] = busStop;
      }
      else {
        _otherFeatures[feature.id] = feature;
      }
    }
  }

  /// Returns an Iterable of all the features.
  Set<Feature> getAllFeatures()
  {
    return {..._otherFeatures.values, ..._busStops.values};
  }

  /// Returns a map of all the features id to the features.
  Map<String, Feature> getFeaturesMap()
  {
    return {..._otherFeatures, ..._busStops};
  }

  /// Returns an Iterable of all  the bus stops.
  Set<BusStop> getAllBusStops()
  {
    return _busStops.values.toSet();
  }

  /// Returns a map of all the features id to the features.
  Map<String, BusStop> getBusStopsMap()
  {
    return _busStops;
  }
}