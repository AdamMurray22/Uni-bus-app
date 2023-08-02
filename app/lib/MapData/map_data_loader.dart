import 'package:app/MapData/feature.dart';
import 'package:tuple/tuple.dart';

import '../Database/database_loader.dart';
import '../Exceptions/loading_not_finished_exception.dart';
import 'bus_running_dates.dart';
import 'bus_time.dart';
import 'map_data.dart';

/// This loads the information from the backend and allows the frontend to
/// access it.
class MapDataLoader {
  static MapDataLoader? _mapDataLoader;
  late MapData _data;
  bool? _loadingCompletedSuccessfully;
  final List<Function(MapData)> _dataLoadedFunctions = [];
  Function(bool)? _dataLoadingCompleted;

  MapDataLoader._();

  /// Returns the only object of MapDataLoader.
  static MapDataLoader getDataLoader() {
    _mapDataLoader ??= MapDataLoader._();
    return _mapDataLoader!;
  }

  /// This loads the information and if
  /// onDataLoaded() has been called it runs the
  /// function given to onDataLoaded().
  load() async {
    loadFromLoader(DatabaseLoader.getDataBaseLoader());
  }

  /// This loads the information and if
  /// onDataLoaded() has been called it runs the
  /// function given to onDataLoaded().
  loadFromLoader(DatabaseLoader loader) async {
    Tuple5<
        Set<Feature>,
        Map<String, int>,
        Map<String, List<BusTime>>,
        Map<String, List<BusTime>>,
        BusRunningDates>? mapData;
    try {
      mapData = await loader.load();
    } on Exception catch (_, e)
    {
      _loadingCompletedSuccessfully = false;
      _dataLoadingCompleted!(false);
      return;
    }
    _data = MapData(mapData);

    // Sets _loadingFinished to true and runs any functions given to
    // MapDataLoader that should be run as soon as the data is loaded.
    _loadingCompletedSuccessfully = true;
    for (Function(MapData) dataLoadedFunction in _dataLoadedFunctions) {
      dataLoadedFunction(_data);
    }
    if (_dataLoadingCompleted != null) {
      _dataLoadingCompleted!(true);
    }
  }

  /// Sets the function to be called once the information has finished being
  /// loaded, if it has already finished being loaded then it runs the function.
  onDataLoaded(Function(MapData) dataLoaded) {
    _dataLoadedFunctions.add(dataLoaded);
    if (_loadingCompletedSuccessfully != null && _loadingCompletedSuccessfully!) {
        dataLoaded(_data);
    }
  }

  /// Sets a function to be called when the data is loaded successfully or fails to be loaded.
  onDataLoadingCompleted(Function(bool) loadingSuccessful) {
    _dataLoadingCompleted = loadingSuccessful;
    if (_loadingCompletedSuccessfully != null) {
      _dataLoadingCompleted!(_loadingCompletedSuccessfully!);
    }
  }

  /// Returns whether the loading has finished.
  bool loadingFinished() {
    return _loadingCompletedSuccessfully != null;
  }

  /// Returns the map data. Only to be used once the data has already been loaded.
  MapData getMapData() {
    if (_loadingCompletedSuccessfully == null) {
      throw LoadingNotFinishedException("Data has not finished loading yet.");
    }
    return _data;
  }
}
