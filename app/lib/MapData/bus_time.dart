/// Time that a bus arrives at a bus stop
class BusTime
{
  late final String _time;
  late final int _hour;
  late final int _minute;

  /// The constructor assigning the time
  BusTime(String time)
  {
    _time = time;
    _hour = int.parse(time.substring(0, 2));
    _minute = int.parse(time.substring(3, 5));
  }

  /// Returns whether the BusTime is later in the day than the current time.
  bool later()
  {
    int currentHour = DateTime.now().hour;
    int currentMinute = DateTime.now().minute;
    if (currentHour <= _hour)
    {
      if (currentHour < _hour)
      {
        return true;
      }
      return currentMinute <= _minute;
    }
    return false;
  }

  /// Returns the time as a String.
  String toDisplayString()
  {
    int currentHour = DateTime.now().hour;
    int currentMinute = DateTime.now().minute;
    int hourDiff = _hour - currentHour;
    if (hourDiff == 0 || hourDiff == 1)
    {
      hourDiff = hourDiff * 60;
      int tempMin = _minute + hourDiff;
        if ((tempMin - currentMinute) <= 45)
        {
          return "$_time (${(_minute - currentMinute) % 60}mins)";
        }
    }
    return _time;
  }
}