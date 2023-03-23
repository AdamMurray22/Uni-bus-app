import 'package:app/Sorts/comparator.dart';
import 'package:app/Sorts/heap_sort.dart';

import 'bus_time.dart';
import 'feature.dart';

/// Holds the information for a bus stop.
class BusStop extends Feature
{
  late final List<BusTime> arrTimes;
  late final List<BusTime> depTimes;
  late final bool separateArrDepTimes;
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
    arrTimes = sortBusTimes.sort(arrBusTimes);
    if (depBusTimes.isNotEmpty)
    {
      depTimes = sortBusTimes.sort(depBusTimes);
      separateArrDepTimes = false;
    }
    else
    {
      depTimes = arrTimes;
      separateArrDepTimes = true;
    }
  }

  /// Returns the bus stop in a format to be displayed on screen.
  @override
  List<String> toDisplay()
  {
    List<String> displayList = super.toDisplay();
    int i = 0;
    for (BusTime time in depTimes)
    {
      if (!_isBusRunning || time.later())
      {
        if (i <= 20) {
          displayList.add(time.toDisplayString());
          i++;
        }
      }
    }
    return displayList;
  }
}