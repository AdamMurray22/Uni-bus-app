import 'package:intl/intl.dart';

class NationalHoliday
{
  late final String _date;

  /// Constructor requires a date in the form:
  /// YYYY/MM/DD.
  NationalHoliday(this._date);

  /// Returns if the current date is this national holiday.
  bool isToday()
  {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    String currentDate = formatter.format(DateTime.now());
    return _date == currentDate;
  }
}