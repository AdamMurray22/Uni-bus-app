import 'package:app/MapData/national_holiday.dart';
import 'package:test/test.dart';

void main() {
  group('National Holiday Tests', () {

    test('NationalHoliday() invalid date', () {
        expect(() => NationalHoliday("2023/02/21"), returnsNormally);
      });

    test('NationalHoliday() invalid date', () {
      expect(
            () => NationalHoliday("2023/0f2/21"),
        throwsA(
          isA<ArgumentError>().having(
                (error) => error.message,
            'message',
            'Date is not in the format YYYY/MM/DD.',
          ),
        ),
      );
    });
  });
}
