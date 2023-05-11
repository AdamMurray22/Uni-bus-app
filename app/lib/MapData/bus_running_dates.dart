import 'package:app/MapData/term_dates.dart';

import 'national_holiday.dart';

/// Stores the dates that the bus is running.
class BusRunningDates
{
  final Set<TermDates> _termDates;
  final Set<NationalHoliday> _nationalHolidays;

  BusRunningDates(this._termDates, this._nationalHolidays);

  /// Returns true if the bus is running on the current day, otherwise false.
  bool isBusRunning()
  {
    return isBusRunningOnDate(DateTime.now());
  }

  /// Returns true if the bus is running on the given day, otherwise false.
  bool isBusRunningOnDate(DateTime today)
  {
    // Checks if the current day is a week day or weekend.
    if (today.weekday >= 6)
    {
      return false;
    }
    // Checks if the current day is a national holiday.
    for (NationalHoliday holiday in _nationalHolidays)
    {
      if (holiday.isToday(today))
      {
        return false;
      }
    }
    // Checks if the current day is within one of the bus running dates.
    for (TermDates date in _termDates)
    {
      if (date.givenDateValid(today))
      {
        return true;
      }
    }
    return false;
  }
}