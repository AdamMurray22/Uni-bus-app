import 'package:app/MapData/term_dates.dart';
import 'package:test/test.dart';

void main() {
  group('Term dates Tests', () {
    test('.givenDateValid() valid dates', () {
      TermDates dates = TermDates("2023/02/21", "2023/02/23");
      bool validDate = dates.givenDateValid(DateTime(2023, 02, 22));
      expect(validDate, true);
    });

    test('.givenDateValid() out of term dates', () {
      TermDates dates = TermDates("2023/02/21", "2023/02/23");
      bool validDate = dates.givenDateValid(DateTime(2023, 02, 24));
      expect(validDate, false);
    });

    test('TermDates() invalid format', () {
      expect(
        () => TermDates("2023/02/21", "2023/0223"),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            'Start or End date is not in the format YYYY/MM/DD.',
          ),
        ),
      );
    });

    test('TermDates() invalid date order', () {
      expect(
            () => TermDates("2023/02/21", "2023/02/20"),
        throwsA(
          isA<ArgumentError>().having(
                (error) => error.message,
            'message',
            'End date given was before the given start date.',
          ),
        ),
      );
    });
  });
}
