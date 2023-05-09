import 'package:app/MapData/bus_time.dart';
import 'package:test/test.dart';

void main() {
  group('Bus Time Tests', () {

    test('BusTime() invalid time', () {
      expect(() => BusTime("time"),
        throwsA(
          isA<ArgumentError>().having(
                (error) => error.message,
            'message',
            'That is not a valid time in the format HH:MM.',
          ),
        ),
      );
    });

    test('BusTime() valid time', () {
      expect(() => BusTime("15:32"), returnsNormally);
    });

    BusTime time = BusTime("15:32");

    test('getTimeAsMins()', () {
      expect(time.getTimeAsMins(), 932);
    });
  });
}
