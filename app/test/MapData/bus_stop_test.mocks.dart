// Mocks generated by Mockito 5.4.0 from annotations
// in app/test/MapData/bus_stop_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/MapData/bus_stop.dart' as _i3;
import 'package:app/MapData/bus_time.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [BusTime].
///
/// See the documentation for Mockito's code generation for more information.
class MockBusTime extends _i1.Mock implements _i2.BusTime {
  MockBusTime() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool later() => (super.noSuchMethod(
        Invocation.method(
          #later,
          [],
        ),
        returnValue: false,
      ) as bool);
  @override
  bool laterThanGiven(DateTime? now) => (super.noSuchMethod(
        Invocation.method(
          #laterThanGiven,
          [now],
        ),
        returnValue: false,
      ) as bool);
  @override
  String toDisplayString() => (super.noSuchMethod(
        Invocation.method(
          #toDisplayString,
          [],
        ),
        returnValue: '',
      ) as String);
  @override
  String toDisplayStringWithTime(DateTime? now) => (super.noSuchMethod(
        Invocation.method(
          #toDisplayStringWithTime,
          [now],
        ),
        returnValue: '',
      ) as String);
  @override
  int getTimeAsMins() => (super.noSuchMethod(
        Invocation.method(
          #getTimeAsMins,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  dynamic setIsBusRunning(bool? isBusRunning) =>
      super.noSuchMethod(Invocation.method(
        #setIsBusRunning,
        [isBusRunning],
      ));
  @override
  dynamic setBusStop(_i3.BusStop? busStop) =>
      super.noSuchMethod(Invocation.method(
        #setBusStop,
        [busStop],
      ));
  @override
  dynamic setPrevBusTimeOnRoute(_i2.BusTime? busTime) =>
      super.noSuchMethod(Invocation.method(
        #setPrevBusTimeOnRoute,
        [busTime],
      ));
  @override
  dynamic setNextBusTimeOnRoute(_i2.BusTime? busTime) =>
      super.noSuchMethod(Invocation.method(
        #setNextBusTimeOnRoute,
        [busTime],
      ));
}
