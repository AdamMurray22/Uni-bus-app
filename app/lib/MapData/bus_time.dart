/// Time that a bus arrives at a bus stop
class BusTime
{
  late final String _time;
  late final int _hour;
  late final int _minute;
  late final int _totalMins;

  /// The constructor assigning the time
  BusTime(String time)
  {
    _time = time;
    _hour = int.parse(time.substring(0, 2));
    _hour == 0 ? _hour = 24 : _hour;
    _minute = int.parse(time.substring(3, 5));
    _totalMins = _minute + (_hour * 60);
  }

  /// Returns whether the BusTime is later in the day than the current time.
  bool later()
  {
    return _getCurrentTimeInMins() <= _totalMins;
  }

  /// Returns the time as a String.
  String toDisplayString()
  {
    String displayString = _time;
    int currentTotalMins = _getCurrentTimeInMins();
    if (_totalMins - currentTotalMins >= 0 && _totalMins - currentTotalMins <= 45)
    {
      displayString = "$displayString (${_totalMins - currentTotalMins}mins)";
    }
    return displayString;
  }

  /// Returns the time of this BusTime in minutes.
  /// Times before 1am are given as if their hour is 24 instead of 0.
  int getTimeAsMins()
  {
    return _totalMins;
  }

  // Returns the current time of day in minutes.
  int _getCurrentTimeInMins()
  {
    int currentHour = DateTime.now().hour;
    if (currentHour == 0) currentHour = 24;
    int currentMinute = DateTime.now().minute;
    return currentMinute + (currentHour * 60);
  }
}