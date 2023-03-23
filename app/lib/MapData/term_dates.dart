import 'package:intl/intl.dart';

import '../Sorts/heap_sort.dart';
import 'package:app/Sorts/comparator.dart';

class TermDates
{
  late final String _startDate;
  late final String _endDate;

  /// Constructor requires a start date and end date both in the form:
  /// YYYY/MM/DD.
  TermDates(String startDate, String endDate)
  {
    _startDate = startDate;
    _endDate = endDate;
    HeapSort<String> sort = HeapSort<String>(Comparator.alphabeticalComparator());
    List<String> dates = sort.sort([_startDate, _endDate]);
    if (dates[0] != _startDate)
    {
      throw Exception("End date given was before the given start date.");
    }
  }

  /// Returns if the current date is between the start and end dates.
  bool currentDateValid()
  {
    HeapSort<String> sort = HeapSort<String>(Comparator.alphabeticalComparator());
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String currentDate = formatter.format(DateTime.now());
    List<String> dates = sort.sort([_startDate, _endDate, currentDate]);
    return dates[1] == currentDate;
  }
}