import 'package:intl/intl.dart';

import '../Sorts/heap_sort.dart';
import 'package:app/Sorts/comparator.dart';
class BusRunningDate
{
  late final String _startDate;
  late final String _endDate;

  /// Constructor requires a start date and end date both in the form:
  /// YYYY/MM/DD.
  BusRunningDate(String startDate, String endDate)
  {
    HeapSort<String> sort = HeapSort<String>((item1, item2)
    {
      return Comparator.alphabeticalComparator(item1, item2);
    });
    List<String> dates = sort.sort([_startDate, _startDate]);
    if (dates[0] != _startDate)
    {
      throw Exception("End date given was before the given start date.");
    }
    _startDate = startDate;
    _endDate = endDate;
  }

  /// Returns if the current date is between the start and end dates.
  bool currentDateValid()
  {
    HeapSort<String> sort = HeapSort<String>((item1, item2)
    {
        return Comparator.alphabeticalComparator(item1, item2);
    });
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String currentDate = formatter.format(DateTime.now());
    List<String> dates = sort.sort([_startDate, _startDate, currentDate]);
    return dates[1] == currentDate;
  }
}