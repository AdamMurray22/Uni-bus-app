import 'package:app/MapData/bus_stop.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:app/Routing/RouteCreators/bus_route_estimator.dart';
import 'package:app/Routing/location.dart';
import 'package:app/Wrapper/date_time_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';

import 'bus_route_estimator_test.mocks.dart';

@GenerateMocks([DateTimeWrapper])
void main() {
  group('Bus Route Estimator Tests', () {

    test('.getEntireEstimate() route correctly estimated', () async {
      final dateTimeWrapper = MockDateTimeWrapper();

      BusStop busStop1 = BusStop("U1-1", "Prince", -1.05857233024616, 50.7925695232834,
          {}, {BusTime("13:22", 1)}, true, 0);
      BusStop busStop3 = BusStop("U1-3", "GetOff", -1.09238477219601, 50.7953755013164,
          {BusTime("13:32", 1)}, {}, true, 0);
      busStop1.setNextBusStop(busStop3);
      busStop1.setPrevBusStop(busStop3);
      busStop3.setNextBusStop(busStop1);
      busStop3.setPrevBusStop(busStop1);
      Set<BusStop> busStops = {busStop1, busStop3};
      Location startLocation = Location(-1.0572793226769477, 50.79220425608969);
      Location endLocation = Location(-1.099776858978281, 50.797431554668776);

      when(dateTimeWrapper.now()).thenAnswer((_) => DateTime(2023, 03, 15, 13, 20, 30));

      BusRouteEstimator estimator = BusRouteEstimator.setDateTime(busStops, dateTimeWrapper);

      Tuple3<double, BusStop, BusStop> test = estimator.getEntireEstimate(startLocation, endLocation)!;

      expect(1164.7406387964352, test.item1);
      expect(busStop1, test.item2);
      expect(busStop3, test.item3);
    });

    test('.getEntireEstimate() route null', () async {
      final dateTimeWrapper = MockDateTimeWrapper();

      BusStop busStop1 = BusStop("U1-1", "Prince", -1.05857233024616, 50.7925695232834,
          {}, {BusTime("13:22", 1)}, true, 0);
      BusStop busStop3 = BusStop("U1-3", "GetOff", -1.09238477219601, 50.7953755013164,
          {BusTime("13:32", 1)}, {}, true, 0);
      busStop1.setNextBusStop(busStop3);
      busStop1.setPrevBusStop(busStop3);
      busStop3.setNextBusStop(busStop1);
      busStop3.setPrevBusStop(busStop1);
      Set<BusStop> busStops = {busStop1, busStop3};
      Location startLocation = Location(-1.0572793226769477, 50.79220425608969);
      Location endLocation = Location(-1.099776858978281, 50.797431554668776);

      when(dateTimeWrapper.now()).thenAnswer((_) => DateTime(2023, 03, 15, 14, 20, 30));

      BusRouteEstimator estimator = BusRouteEstimator.setDateTime(busStops, dateTimeWrapper);

      Tuple3<double, BusStop, BusStop>? test = estimator.getEntireEstimate(startLocation, endLocation);

      expect(test, null);
    });

    test('.getEntireEstimate() no bus stops', () async {
      final dateTimeWrapper = MockDateTimeWrapper();
      Set<BusStop> busStops = {};
      Location startLocation = Location(-1.0572793226769477, 50.79220425608969);
      Location endLocation = Location(-1.099776858978281, 50.797431554668776);

      when(dateTimeWrapper.now()).thenAnswer((_) => DateTime(2023, 03, 15, 14, 20, 30));

      BusRouteEstimator estimator = BusRouteEstimator.setDateTime(busStops, dateTimeWrapper);

      Tuple3<double, BusStop, BusStop>? test = estimator.getEntireEstimate(startLocation, endLocation);

      expect(test, null);
    });
  });
}