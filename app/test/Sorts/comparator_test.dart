import 'package:app/Sorts/comparator.dart';
import 'package:test/test.dart';

void main() {
  group('Comparator Tests', () {

    Comparator Function(String string1, String string2) comparator = Comparator.alphabeticalComparator();

    test('.alphabeticalComparator() before String first', () {
      expect(comparator("A First String", "The Second String"), Comparator.before);
    });

    test('.alphabeticalComparator() before String second', () {
      expect(comparator("The Second String", "A First String"), Comparator.after);
    });

    test('.alphabeticalComparator() same valid Strings', () {
      expect(comparator("String", "String"), Comparator.same);
    });

    test('.alphabeticalComparator() empty Strings', () {
      expect(comparator("", ""), Comparator.same);
    });

    test('.alphabeticalComparator() first String empty', () {
      expect(comparator("", "not empty"), Comparator.before);
    });

    test('.alphabeticalComparator() second String empty', () {
      expect(comparator("not empty", ""), Comparator.after);
    });
  });
}