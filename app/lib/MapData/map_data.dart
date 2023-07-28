import 'package:app/Sorts/heap_sort.dart';
import 'package:app/Sorts/comparator.dart';
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
  MapData(Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>, Map<String, List<BusTime>>, BusRunningDates> mapData)
  {
    Set<Feature> features = mapData.item1;
    Map<String, int> busStopOrder = mapData.item2;
    Map<String, List<BusTime>> busArrTimes = mapData.item3;
    Map<String, List<BusTime>> busDepTimes = mapData.item4;
    BusRunningDates busRunningDates = mapData.item5;
    _busStops = {};
    _otherFeatures = {};
    bool isBusRunning = busRunningDates.isBusRunning();

    for (Feature feature in features)
    {
      if (MapDataId.getMapDataIdEnumFromId(feature.id) == MapDataId.u1)
      {
        BusStop busStop = _createBusStop(feature, busStopOrder, busArrTimes, busDepTimes, isBusRunning);
        _busStops[feature.id] = busStop;
      }
      else {
        _otherFeatures[feature.id] = feature;
      }
    }

    _sortBusStops(_busStops.values);
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

  // Creates a bus stop.
  BusStop _createBusStop(Feature feature, Map<String, int> busStopOrder,
      Map<String, List<BusTime>> busArrTimes,
      Map<String, List<BusTime>> busDepTimes, bool isBusRunning)
  {
    BusStop busStop = BusStop(feature.id, feature.name,
        feature.long, feature.lat,
        busArrTimes[feature.id]??[], busDepTimes[feature.id]??[],
        isBusRunning, busStopOrder[feature.id]!);
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
    return busStop;
  }

  _sortBusStops(Iterable<BusStop> busStops)
  {
    if (busStops.isEmpty)
    {
      return;
    }
    HeapSort<BusStop> sort = HeapSort((busStop1, busStop2)
    {
      int order1 = busStop1.getBusStopOrder();
      int order2 = busStop2.getBusStopOrder();
      if (order1 < order2)
      {
        return Comparator.before;
      }
      else if (order1 > order2)
      {
        return Comparator.after;
      }
      return Comparator.same;
    });

    List<BusStop> sortedBusStops = sort.sort(busStops);
    BusStop firstBusStop = sortedBusStops[0];
    BusStop prevBusStop = sortedBusStops[0];
    for (int i = 1; i < sortedBusStops.length; i++)
    {
      sortedBusStops[i].setPrevBusStop(prevBusStop);
      prevBusStop.setNextBusStop(sortedBusStops[i]);
      prevBusStop = sortedBusStops[i];
    }
    firstBusStop.setPrevBusStop(prevBusStop);
    prevBusStop.setNextBusStop(firstBusStop);
  }
}