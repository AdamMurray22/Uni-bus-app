import 'package:app/MapData/bus_stop.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:tuple/tuple.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'bus_stop_test.mocks.dart';

@GenerateMocks([BusTime])
void main() {
  group('Bus Stop Tests', () {
    test('toDisplayInfoScreen() valid display format with separate dep and later time',
        () {
      final busTime1 = MockBusTime();
      final busTime2 = MockBusTime();

      when(busTime1.toDisplayString()).thenAnswer((realInvocation) => "11:11");
      when(busTime1.later()).thenAnswer((realInvocation) => true);
      when(busTime1.getTimeAsMins()).thenAnswer((realInvocation) => 676);
      when(busTime1.setIsBusRunning(true)).thenReturn(null);

      when(busTime2.toDisplayString()).thenAnswer((realInvocation) => "11:13");
      when(busTime2.later()).thenAnswer((realInvocation) => true);
      when(busTime2.getTimeAsMins()).thenAnswer((realInvocation) => 678);
      when(busTime2.setIsBusRunning(true)).thenReturn(null);

      BusStop busStop = BusStop(
          "U1-1", "bus1", 50, 60, {busTime1}, {busTime2}, true);

      Tuple2<List<String>, List<String>> displayInfo =
          busStop.toDisplayInfoScreen();
      expect(displayInfo.item1, ["bus1", "Departures:"]);
      expect(displayInfo.item2, ["11:13"]);
    });

    test(
        'toDisplayInfoScreen() valid display format without separate dep and later time',
        () {
          final busTime1 = MockBusTime();

          when(busTime1.toDisplayString()).thenAnswer((realInvocation) => "11:11");
          when(busTime1.later()).thenAnswer((realInvocation) => true);
          when(busTime1.getTimeAsMins()).thenAnswer((realInvocation) => 676);
          when(busTime1.setIsBusRunning(true)).thenReturn(null);

      BusStop busStop =
          BusStop("U1-1", "bus1", 50, 60, {busTime1}, {}, true);

      Tuple2<List<String>, List<String>> displayInfo =
          busStop.toDisplayInfoScreen();
      expect(displayInfo.item1, ["bus1"]);
      expect(displayInfo.item2, ["11:11"]);
    });

    test('toDisplayInfoScreen() valid display format with separate dep and without later time',
            () {
          final busTime1 = MockBusTime();
          final busTime2 = MockBusTime();

          when(busTime1.toDisplayString()).thenAnswer((realInvocation) => "11:11");
          when(busTime1.later()).thenAnswer((realInvocation) => false);
          when(busTime1.getTimeAsMins()).thenAnswer((realInvocation) => 676);
          when(busTime1.setIsBusRunning(true)).thenReturn(null);

          when(busTime2.toDisplayString()).thenAnswer((realInvocation) => "11:13");
          when(busTime2.later()).thenAnswer((realInvocation) => false);
          when(busTime2.getTimeAsMins()).thenAnswer((realInvocation) => 678);
          when(busTime2.setIsBusRunning(true)).thenReturn(null);

          BusStop busStop = BusStop(
              "U1-1", "bus1", 50, 60, {busTime1}, {busTime2}, true);

          Tuple2<List<String>, List<String>> displayInfo =
          busStop.toDisplayInfoScreen();
          expect(displayInfo.item1, ["bus1", "Departures:"]);
          expect(displayInfo.item2, []);
        });

    test(
        'toDisplayInfoScreen() valid display format without separate dep and without later time',
            () {
          final busTime1 = MockBusTime();

          when(busTime1.toDisplayString()).thenAnswer((realInvocation) => "11:11");
          when(busTime1.later()).thenAnswer((realInvocation) => false);
          when(busTime1.getTimeAsMins()).thenAnswer((realInvocation) => 676);
          when(busTime1.setIsBusRunning(true)).thenReturn(null);

          BusStop busStop =
          BusStop("U1-1", "bus1", 50, 60, {busTime1}, {}, true);

          Tuple2<List<String>, List<String>> displayInfo =
          busStop.toDisplayInfoScreen();
          expect(displayInfo.item1, ["bus1"]);
          expect(displayInfo.item2, []);
        });

    test('getHasSeparateArrDepTimes() with out separate dep', () {
      BusStop feature =
          BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11", 1)}, {}, true);
      expect(feature.getHasSeparateArrDepTimes(), false);
    });

    test('getHasSeparateArrDepTimes() with separate dep', () {
      BusStop feature = BusStop(
          "U1-1", "bus1", 50, 60, {BusTime("11:11", 1)}, {BusTime("11:13", 1)}, true);
      expect(feature.getHasSeparateArrDepTimes(), true);
    });

    test('getDepartureTimes() with out separate dep', () {
      BusStop feature =
          BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11", 1)}, {}, true);
      expect(feature.getDepartureTimes(), [BusTime("11:11", 1)]);
    });

    test('getDepartureTimes() with separate dep', () {
      BusStop feature = BusStop(
          "U1-1", "bus1", 50, 60, {BusTime("11:11", 1)}, {BusTime("11:13", 1)}, true);
      expect(feature.getDepartureTimes(), [BusTime("11:13", 1)]);
    });

    test('getArrivalTimes() with out separate dep', () {
      BusStop feature =
          BusStop("U1-1", "bus1", 50, 60, {BusTime("11:11", 1)}, {}, true);
      expect(feature.getArrivalTimes(), [BusTime("11:11", 1)]);
    });

    test('getArrivalTimes() with separate dep', () {
      BusStop feature = BusStop(
          "U1-1", "bus1", 50, 60, {BusTime("11:11", 1)}, {BusTime("11:13", 1)}, true);
      expect(feature.getArrivalTimes(), [BusTime("11:11", 1)]);
    });
  });
}
