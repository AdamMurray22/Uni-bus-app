import 'package:intl/intl.dart';

/// This represents a day when the bus isnt running.
class NationalHoliday
{
  late final String _date;

  /// Constructor requires a date in the form:
  /// YYYY/MM/DD.
  NationalHoliday(String date)
  {
    if (!_correctFormat(date))
    {
      throw ArgumentError("Date is not in the format YYYY/MM/DD.");
    }
    _date = date;
  }

  /// Returns if the current date is this national holiday.
  bool isToday(DateTime today)
  {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String currentDate = formatter.format(today);
    return _date == currentDate;
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