import 'package:app/MapData/bus_time.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'bus_time_test.mocks.dart';

@GenerateMocks([DateTime])void main() {
  group('Bus Time Tests', () {

    test('BusTime() invalid time', () {
      expect(() => BusTime("time", 1),
        throwsA(
          isA<ArgumentError>().having(
                (error) => error.message,
            'message',
            'time is not a valid time in the format HH:MM.',
          ),
        ),
      );
    });

    test('BusTime() valid time', () {
      expect(() => BusTime("15:32", 1), returnsNormally);
    });

    BusTime time = BusTime("15:32", 1);

    test('getTimeAsMins()', () {
      expect(time.getTimeAsMins(), 932);
    });

    test('.laterThanGiven() same time returns true', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("15:22", 1);

      expect(time.laterThanGiven(date), true);
    });

    test('.laterThanGiven() earlier time returns false', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("14:22", 1);

      expect(time.laterThanGiven(date), false);
    });

    test('.laterThanGiven() later time returns true', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("16:22", 1);

      expect(time.laterThanGiven(date), true);
    });

    test('.toDisplayStringWithTime() same time returns time returns time and mins till bus time', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("15:22", 1);
      time.setIsBusRunning(true);

      expect(time.toDisplayStringWithTime(date), "15:22 (0mins)");
    });

    test('.toDisplayStringWithTime() earlier time returns time', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("14:22", 1);
      time.setIsBusRunning(true);

      expect(time.toDisplayStringWithTime(date), "14:22");
    });

    test('.toDisplayStringWithTime() later time returns time', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("16:25", 1);
      time.setIsBusRunning(true);

      expect(time.toDisplayStringWithTime(date), "16:25");
    });

    test('.toDisplayStringWithTime() within 45min time returns time and mins till bus time', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("16:01", 1);
      time.setIsBusRunning(true);

      expect(time.toDisplayStringWithTime(date), "16:01 (39mins)");
    });

    test('.toDisplayStringWithTime() within 45min time but bus is not running returns time', () async {
      final date = MockDateTime();

      when(date.hour).thenAnswer((realInvocation) => 15);
      when(date.minute).thenAnswer((realInvocation) => 22);

      BusTime time = BusTime("16:01", 1);
      time.setIsBusRunning(false);

      expect(time.toDisplayStringWithTime(date), "16:01");
    });
  });
}
