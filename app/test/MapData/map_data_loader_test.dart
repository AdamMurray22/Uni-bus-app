import 'package:app/MapData/Loaders/database_loader.dart';
import 'package:app/Exceptions/loading_not_finished_exception.dart';
import 'package:app/MapData/bus_running_dates.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:app/MapData/feature.dart';
import 'package:app/MapData/map_data.dart';
import 'package:app/MapData/map_data_loader.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';

import 'map_data_loader_test.mocks.dart';

@GenerateMocks([DatabaseLoader])
void main() {
  group('Map Data Loader Tests', () {
    test('.getDataLoader() Returns same loader', () {
      MapDataLoader loaderOne = MapDataLoader.getDataLoader();
      MapDataLoader loaderTwo = MapDataLoader.getDataLoader();
      expect(loaderOne, loaderTwo);
    });

    MapDataLoader loader = MapDataLoader.getDataLoader();
    test('.loadingFinished() Before loading finished', () {
      expect(loader.loadingFinished(), false);
    });

    test('getMapData() Before loading finished', () {
      expect(
        () => loader.getMapData(),
        throwsA(
          isA<LoadingNotFinishedException>().having(
            (error) => error.message,
            'message',
            'Data has not finished loading yet.',
          ),
        ),
      );
    });

    test(
        'getMapData() after data has been loaded',
            () async {
          final databaseLoader = MockDatabaseLoader();

          Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>,
              Map<String, List<BusTime>>, BusRunningDates> mapData =
          Tuple5({}, {}, {}, {}, BusRunningDates({}, {}));
          when(databaseLoader.load()).thenAnswer((realInvocation) async => mapData);

          MapDataLoader loader = MapDataLoader.getDataLoader();
          await loader.loadFromLoader(databaseLoader);

          expect(loader.getMapData(), isA<MapData>());
        });

    test(
        'loadingFinished() after data has been loaded',
            () async {
          final databaseLoader = MockDatabaseLoader();

          Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>,
              Map<String, List<BusTime>>, BusRunningDates> mapData =
          Tuple5({}, {}, {}, {}, BusRunningDates({}, {}));
          when(databaseLoader.load()).thenAnswer((realInvocation) async => mapData);

          MapDataLoader loader = MapDataLoader.getDataLoader();
          await loader.loadFromLoader(databaseLoader);

          expect(loader.loadingFinished(), true);
        });
  });
}
