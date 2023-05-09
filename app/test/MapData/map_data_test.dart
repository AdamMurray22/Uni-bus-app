import 'package:app/MapData/bus_running_dates.dart';
import 'package:app/MapData/bus_stop.dart';
import 'package:app/MapData/feature.dart';
import 'package:app/MapData/map_data.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Map Data Tests', () {
    Map<String, BusStop> busStops = {
      "U1-1":BusStop("U1-1", "bus1", 50, 60, {}, {}, false),
      "U1-2":BusStop("U1-2", "bus2", 70, 80, {}, {}, false),
    };
    Map<String, Feature> features = {
      "LM-1":Feature("LM-1", "bus1", 10, 20),
      "UB-2":Feature("UB-2", "bus2", 30, 40),
    };
    Map<String, Feature> allFeatures = {...busStops, ...features};
    MapData data = MapData(Tuple4(allFeatures.values.toSet(), {}, {}, BusRunningDates({}, {})));

    test('getAllBusStops()', () {
      expect(data.getAllBusStops(), busStops.values);
    });

    test('getAllFeatures()', () {
      expect(data.getAllFeatures(), allFeatures.values.toSet());
    });

    test('getFeaturesMap()', () {
      expect(data.getFeaturesMap(), allFeatures);
    });
  });
}
