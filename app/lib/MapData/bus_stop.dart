import 'package:app/Sorts/comparator.dart';
import 'package:app/Sorts/heap_sort.dart';
import 'package:tuple/tuple.dart';

import 'bus_time.dart';
import 'feature.dart';

/// Holds the information for a bus stop.
class BusStop extends Feature
{
  late final BusStop _prevBusStop;
  late final BusStop _nextBusStop;
  late final List<BusTime> _arrTimes;
  late final List<BusTime> _depTimes;
  late final bool _separateArrDepTimes;
  final bool _isBusRunning;

  /// The constructor assigning the id, name, longitude and latitude.
  BusStop(super. id, super.name, super.long, super.lat, Iterable<BusTime> arrBusTimes, Iterable<BusTime> depBusTimes, this._isBusRunning)
  {
    HeapSort<BusTime> sortBusTimes = HeapSort<BusTime>((BusTime time1, BusTime time2)
    {
      return time1.getTimeAsMins() <= time2.getTimeAsMins() ? Comparator.before : Comparator.after;
    });
    for (BusTime time in {...arrBusTimes, ...depBusTimes})
    {
      time.setIsBusRunning(_isBusRunning);
    }
    _arrTimes = sortBusTimes.sort(arrBusTimes);
    if (depBusTimes.isNotEmpty)
    {
      _depTimes = sortBusTimes.sort(depBusTimes);
      _separateArrDepTimes = true;
    }
    else
    {
      _depTimes = _arrTimes;
      _separateArrDepTimes = false;
    }
  }

  /// Returns the bus stop in a format to be displayed on the info screen.
  @override
  Tuple2<List<String>, List<String>> toDisplayInfoScreen()
  {
    List<String> titleList = super.toDisplayInfoScreen().item1;
    List<String> displayList = super.toDisplayInfoScreen().item2;
    if (_separateArrDepTimes)
    {
      titleList.add("Departures:");
    }
    int i = 0;
    for (BusTime time in _depTimes)
    {
      if (!_isBusRunning || time.later())
      {
        if (i <= 20) {
          displayList.add(time.toDisplayString());
          i++;
        }
      }
    }
    return Tuple2(titleList, displayList);
  }

  /// Returns the departure times.
  List<BusTime> getDepartureTimes()
  {
    return _depTimes;
  }

  /// Returns the arrival times.
  List<BusTime> getArrivalTimes()
  {
    return _arrTimes;
  }

  /// Returns whether the bus stop has separate arrival and departure times.
  bool getHasSeparateArrDepTimes()
  {
    return _separateArrDepTimes;
  }

  /// Sets the previous bus stop on the route.
  setPrevBusStop(BusStop prevBusStop)
  {
    _prevBusStop = prevBusStop;
  }

  /// Sets the next bus stop on the route.
  setNextBusStop(BusStop nextBusStop)
  {
    _nextBusStop = nextBusStop;
  }

  /// Returns the next bus to depart this bus stop on the day.
  BusTime? getNextBusDeparture()
  {
    return getNextBusDepartureAfterTime(DateTime.now());
  }

  /// Returns the next bus to depart this bus stop after the given time on the day.
  BusTime? getNextBusDepartureAfterTime(DateTime time)
  {
    if (!_isBusRunning)
    {
      return null;
    }
    for (BusTime busTime in _depTimes)
    {
      if (busTime.laterThanGiven(time))
      {
        return busTime;
      }
    }
  }
}