import 'package:intl/intl.dart';

import '../Sorts/heap_sort.dart';
import 'package:app/Sorts/comparator.dart';

/// The term dates for when the bus runs.
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
    if (!_correctFormat(_startDate) || !_correctFormat(_endDate))
    {
      throw ArgumentError("Start or End date is not in the format YYYY/MM/DD.");
    }
    HeapSort<String> sort = HeapSort<String>(Comparator.alphabeticalComparator());
    List<String> dates = sort.sort([_startDate, _endDate]);
    if (dates[0] != _startDate)
    {
      throw ArgumentError("End date given was before the given start date.");
    }
  }

  /// Returns if the given date is between the start and end dates.
  bool givenDateValid(DateTime date)
  {
    HeapSort<String> sort = HeapSort<String>(Comparator.alphabeticalComparator());
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String dateString = formatter.format(date);
    List<String> dates = sort.sort([_startDate, _endDate, dateString]);
    return dates[1] == dateString;
  }

  // Returns if a given string is a date in the format YYYY/MM/DD.
  bool _correctFormat(String date)
  {
    if (date.length != 10)
    {
      return false;
    }
    if (date[4] != '/' || date[7] != '/')
    {
      return false;
    }
    String year = date.substring(0, 4);
    if (int.tryParse(year) == null)
    {
      return false;
    }
    String month = date.substring(5, 7);
    if (int.tryParse(month) == null)
    {
      return false;
    }
    int monthAsInt = int.parse(month);
    if (monthAsInt < 0 || monthAsInt > 12)
    {
      return false;
    }
    String day = date.substring(8, 10);
    if (int.tryParse(day) == null)
    {
      return false;
    }
    int dayAsInt = int.parse(day);
    if (dayAsInt < 0 || dayAsInt > 31)
    {
      return false;
    }
    return true;
  }
}