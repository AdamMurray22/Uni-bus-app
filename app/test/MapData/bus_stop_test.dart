import 'package:app/MapData/bus_stop.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Bus Stop Tests', () {

    test('toDisplayInfoScreen() valid display format with separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {BusTime("11:13")}, true);
      Tuple2<List<String>, List<String>> displayInfo = feature.toDisplayInfoScreen();
      expect(displayInfo.item1, ["bus1", "Departures:"]);
      expect(displayInfo.item2, ["11:13"]);
    });

    test('toDisplayInfoScreen() valid display format with out separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {}, true);
      Tuple2<List<String>, List<String>> displayInfo = feature.toDisplayInfoScreen();
      expect(displayInfo.item1, ["bus1"]);
      expect(displayInfo.item2, ["11:11"]);
    });

    test('getHasSeparateArrDepTimes() with out separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {}, true);
      expect(feature.getHasSeparateArrDepTimes(), false);
    });

    test('getHasSeparateArrDepTimes() with separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {BusTime("11:13")}, true);
      expect(feature.getHasSeparateArrDepTimes(), true);
    });

    test('getDepartureTimes() with out separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {}, true);
      expect(feature.getDepartureTimes(), [BusTime("11:11")]);
    });

    test('getDepartureTimes() with separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {BusTime("11:13")}, true);
      expect(feature.getDepartureTimes(), [BusTime("11:13")]);
    });

    test('getArrivalTimes() with out separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {}, true);
      expect(feature.getArrivalTimes(), [BusTime("11:11")]);
    });

    test('getArrivalTimes() with separate dep', () {
      BusStop feature = BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11")}, {BusTime("11:13")}, true);
      expect(feature.getArrivalTimes(), [BusTime("11:11")]);
    });
  });
}
