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
    int currentHour = DateTime.now().hour;
    currentHour == 0 ? currentHour = 24 : currentHour;
    int currentMinute = DateTime.now().minute;
    int currentTotalMins = currentMinute + (currentHour * 60);
    return currentTotalMins <= _totalMins;
  }

  /// Returns the time as a String.
  String toDisplayString()
  {
    int currentHour = DateTime.now().hour;
    currentHour == 0 ? currentHour = 24 : currentHour;
    int currentMinute = DateTime.now().minute;
    int currentTotalMins = currentMinute + (currentHour * 60);
    String displayString = _time;
    if (_totalMins - currentTotalMins >= 0 && _totalMins - currentTotalMins <= 45)
    {
      displayString = "$displayString (${_totalMins - currentTotalMins}mins)";
    }
    return displayString;
  }
}