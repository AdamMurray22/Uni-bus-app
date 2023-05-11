import 'package:app/MapData/national_holiday.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'national_holiday_test.mocks.dart';

@GenerateMocks([DateTime])
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

    test('.isToday() returns true', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      NationalHoliday holiday = NationalHoliday("2023/03/10");

      expect(holiday.isToday(date), true);
    });

    test('.isToday() returns false', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      NationalHoliday holiday = NationalHoliday("2023/02/21");

      expect(holiday.isToday(date), false);
    });
  });
}
