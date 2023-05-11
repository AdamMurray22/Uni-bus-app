import 'package:app/MapData/bus_running_dates.dart';
import 'package:app/MapData/national_holiday.dart';
import 'package:app/MapData/term_dates.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'bus_running_test.mocks.dart';

@GenerateMocks([DateTime])
void main() {
  group('Bus Running Tests', () {

    test('.isBusRunningOnDate() Tests Term Dates returns true', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      Set<TermDates> terms = {
        TermDates("2023/01/01", "2024/01/01"),
      };
      Set<NationalHoliday> nationalHolidays = {};
      BusRunningDates dates = BusRunningDates(terms, nationalHolidays);

      expect(dates.isBusRunningOnDate(date), true);
    });

    test('.isBusRunningOnDate() Tests Term Dates returns false', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      Set<TermDates> terms = {
        TermDates("2023/01/01", "2023/02/01"),
      };
      Set<NationalHoliday> nationalHolidays = {};
      BusRunningDates dates = BusRunningDates(terms, nationalHolidays);

      expect(dates.isBusRunningOnDate(date), false);
    });

    test('.isBusRunningOnDate() Tests Holidays returns true', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      Set<TermDates> terms = {
        TermDates("2023/01/01", "2024/02/01"),
      };
      Set<NationalHoliday> nationalHolidays = {
        NationalHoliday("2023/02/06"),
        NationalHoliday("2023/03/09"),
        NationalHoliday("2023/04/05"),
      };
      BusRunningDates dates = BusRunningDates(terms, nationalHolidays);

      expect(dates.isBusRunningOnDate(date), true);
    });

    test('.isBusRunningOnDate() Tests Holidays returns false', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      Set<TermDates> terms = {
      };
      Set<NationalHoliday> nationalHolidays = {
        NationalHoliday("2023/02/06"),
        NationalHoliday("2023/03/10"),
        NationalHoliday("2023/04/05"),
      };
      BusRunningDates dates = BusRunningDates(terms, nationalHolidays);

      expect(dates.isBusRunningOnDate(date), false);
    });

    test('.isBusRunningOnDate() Tests Combined returns true', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      Set<TermDates> terms = {
        TermDates("2023/01/01", "2024/02/01"),
      };
      Set<NationalHoliday> nationalHolidays = {
        NationalHoliday("2023/02/06"),
        NationalHoliday("2023/03/09"),
        NationalHoliday("2023/04/05"),
      };
      BusRunningDates dates = BusRunningDates(terms, nationalHolidays);

      expect(dates.isBusRunningOnDate(date), true);
    });

    test('.isBusRunningOnDate() Tests Combined returns false', () async {
      final date = MockDateTime();

      when(date.weekday).thenAnswer((realInvocation) => 5);
      when(date.year).thenAnswer((realInvocation) => 2023);
      when(date.month).thenAnswer((realInvocation) => 03);
      when(date.day).thenAnswer((realInvocation) => 10);

      Set<TermDates> terms = {
        TermDates("2023/01/01", "2023/02/01"),
      };
      Set<NationalHoliday> nationalHolidays = {
        NationalHoliday("2023/02/06"),
        NationalHoliday("2023/03/10"),
        NationalHoliday("2023/04/05"),
      };
      BusRunningDates dates = BusRunningDates(terms, nationalHolidays);

      expect(dates.isBusRunningOnDate(date), false);
    });
  });
}

class TermDate {
}
