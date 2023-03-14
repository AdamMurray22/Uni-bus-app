import 'package:app/MapData/bus_stop.dart';
import 'package:app/MapData/feature.dart';
import 'package:tuple/tuple.dart';

import '../Database/database_loader.dart';
import 'bus_time.dart';
import 'map_data.dart';

/// This loads the information from the backend and allows the frontend to
/// access it.
class MapDataLoader
{
  static MapDataLoader? _mapDataLoader;
  late MapData _data;
  bool _loadingFinished = false;

  final List<Function(MapData)> _dataLoadedFunctions = [];

  MapDataLoader._();

  static MapDataLoader getDataLoader()
  {
    _mapDataLoader ??= MapDataLoader._();
    return _mapDataLoader!;
  }

  /// This loads the information and if
  /// onDataLoaded() has been called it runs the
  /// function given to onDataLoaded().
  load() async
  {
    DatabaseLoader loader = DatabaseLoader.getDataBaseLoader();
    Tuple2<Set<Feature>, Map<String, List<BusTime>>> mapData = await loader.load();
    _data = MapData(mapData);


    _loadingFinished = true;
    for (Function(MapData) dataLoadedFunction in _dataLoadedFunctions)
    {
      dataLoadedFunction(_data);
    }
  }

  /// Sets the function to be called once the information has finished being
  /// loaded, if it has already finished being loaded then it runs the function.
  onDataLoaded(Function(MapData) dataLoaded)
  {
    _dataLoadedFunctions.add(dataLoaded);
    if (_loadingFinished)
    {
      dataLoaded(_data);
    }
  }

  /// Returns whether the loading has finished.
  bool loadingFinished()
  {
    return _loadingFinished;
  }

  /// Returns the map data. Only to be used once the data has already been loaded.
  MapData getMapData()
  {
    return _data;
  }
}