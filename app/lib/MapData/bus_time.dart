/// Time that a bus arrives at a bus stop
class BusTime
{
  late final String _time;
  late final int _hour;
  late final int _minute;
  late final int _totalMins;
  late bool _isBusRunning;

  /// The constructor assigning the time
  /// Must be in the format HH:MM.
  BusTime(String time)
  {
    _time = time;
    if (int.tryParse(time.substring(0, 2)) == null ||
        int.tryParse(time.substring(3, 5)) == null ||
        time[2] != ':')
    {
      throw ArgumentError("That is not a valid time in the format HH:MM.");
    }
    _hour = int.parse(time.substring(0, 2));
    _hour == 0 ? _hour = 24 : _hour;
    _minute = int.parse(time.substring(3, 5));
    _totalMins = _minute + (_hour * 60);
  }

  /// Returns whether the BusTime is later in the day than the current time.
  bool later()
  {
    return laterThanGiven(DateTime.now());
  }

  /// Returns whether the BusTime is later in the day than the given time.
  bool laterThanGiven(DateTime now)
  {
    return _getCurrentTimeInMins(now) <= _totalMins;
  }

  /// Returns the time as a String.
  String toDisplayString()
  {
    return toDisplayStringWithTime(DateTime.now());
  }

  /// Returns the time as a String.
  String toDisplayStringWithTime(DateTime now)
  {
    if (!_isBusRunning)
    {
      return _time;
    }
    String displayString = _time;
    int currentTotalMins = _getCurrentTimeInMins(now);
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

  /// Sets whether the buses are running on that day.
  setIsBusRunning(bool isBusRunning)
  {
    _isBusRunning = isBusRunning;
  }

  // Returns the current time of day in minutes.
  int _getCurrentTimeInMins(DateTime now)
  {
    int currentHour = now.hour;
    if (currentHour == 0) currentHour = 24;
    int currentMinute = now.minute;
    return currentMinute + (currentHour * 60);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BusTime &&
              runtimeType == other.runtimeType &&
              _time == other._time;

  @override
  int get hashCode => _time.hashCode;
}