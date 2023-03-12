import 'package:app/Sorts/comparator.dart';
import 'package:app/Sorts/heap_sort.dart';

import 'bus_time.dart';
import 'feature.dart';

/// Holds the information for a bus stop.
class BusStop extends Feature
{
  late final List<BusTime> times;
  /// The constructor assigning the id, name, longitude and latitude.
  BusStop(super. id, super.name, super.long, super.lat, Iterable<BusTime> busTimes)
  {
    times = HeapSort.sort(busTimes, (BusTime time1, BusTime time2)
    {
      return ComparatorValue.same;
    });
  }
}