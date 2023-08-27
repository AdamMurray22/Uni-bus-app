import 'package:app/MapData/bus_running_dates.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:app/MapData/feature.dart';
import 'package:tuple/tuple.dart';
import 'data_loader.dart';

/// Loader that loads the map data from an aws database.
class AWSDataLoader implements DataLoader
{
  static AWSDataLoader? _awsDataLoader;
  final String _relativePath = "database/map_info.db";
  Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>, Map<String, List<BusTime>>,
      BusRunningDates>? _data;

  AWSDataLoader._();

  /// Returns the only instance of AWSDataLoader.
  static AWSDataLoader getAWSDataLoader() {
    _awsDataLoader ??= AWSDataLoader._();
    return _awsDataLoader!;
  }

  /// Loads the data and saves the result to be given for future calls.
  @override
  Future<Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>, Map<String, List<BusTime>>, BusRunningDates>> load() {
    // TODO: implement load
    throw UnimplementedError();
  }

}