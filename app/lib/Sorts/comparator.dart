/// The enums for the return value of a comparator.
enum Comparator {
  before,
  same,
  after;

  /// Alphabetical comparator.
  static Comparator Function(String string1, String string2) alphabeticalComparator() {
    return ((String string1, String string2) {
      string1 = string1.toLowerCase();
      string2 = string2.toLowerCase();
      if (string1 == string2) {
        return Comparator.same;
      }
      for (int i = 0; i <= string1.length; i++) {
        if (string1.length <= i) {
          return Comparator.before;
        } else if (string2.length <= i) {
          return Comparator.after;
        } else if (string1.codeUnitAt(i) < string2.codeUnitAt(i)) {
          return Comparator.before;
        } else if (string1.codeUnitAt(i) > string2.codeUnitAt(i)) {
          return Comparator.after;
        }
      }
      return Comparator.before;
    });
  }
}
