import 'package:app/MapData/term_dates.dart';

import 'national_holiday.dart';

class BusRunningDates
{
  Set<TermDates> termDates;
  Set<NationalHoliday> nationalHolidays;

  BusRunningDates(this.termDates, this.nationalHolidays);

  bool isBusRunning()
  {
    // Checks if the current day is a week day or weekend.
    if (DateTime.now().weekday >= 6)
    {
      return false;
    }
    // Checks if the current day is a national holiday.
    for (NationalHoliday holiday in nationalHolidays)
    {
      if (holiday.isToday())
      {
        return false;
      }
    }
    // Checks if the current day is within one of the bus running dates.
    for (TermDates date in termDates)
    {
      if (date.currentDateValid())
      {
        return true;
      }
    }
    return false;
  }
}