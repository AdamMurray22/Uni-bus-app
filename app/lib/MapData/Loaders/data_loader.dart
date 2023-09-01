import 'package:tuple/tuple.dart';

import '../bus_running_dates.dart';
import '../bus_time.dart';
import '../feature.dart';

/// Provides an interface for the data loaders.
abstract class DataLoader
{
  /// Loads the data and saves the result to be given for future calls.
  Future<
      Tuple6<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>,
          Map<String, List<BusTime>>, BusRunningDates, Set<Map<String, dynamic>>>> load();
}