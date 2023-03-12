import 'bus_time.dart';
import 'feature.dart';

/// Holds the information for a bus stop.
class BusStop extends Feature
{
  final List<BusTime> times;
  /// The constructor assigning the id, name, longitude and latitude.
  BusStop(super. id, super.name, super.long, super.lat, this.times);
}