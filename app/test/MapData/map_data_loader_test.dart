import 'package:app/Exceptions/loading_not_finished_exception.dart';
import 'package:app/MapData/map_data_loader.dart';
import 'package:test/test.dart';

void main() {
  group('Map Data Loader Tests', () {

    test('.getDataLoader() Returns same loader', () {
      MapDataLoader loaderOne = MapDataLoader.getDataLoader();
      MapDataLoader loaderTwo = MapDataLoader.getDataLoader();
      expect(loaderOne, loaderTwo);
    });

    MapDataLoader loader = MapDataLoader.getDataLoader();
    test('.loadingFinished() Returns loading finished', () {
      expect(loader.loadingFinished(), false);
    });

    test('NationalHoliday() invalid date', () {
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
  });
}
