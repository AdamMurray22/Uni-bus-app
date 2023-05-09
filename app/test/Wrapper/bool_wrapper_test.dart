import 'package:app/Wrapper/bool_wrapper.dart';
import 'package:test/test.dart';

void main() {
  group('Bool Wrapper Tests', () {

    test('getValue() true', () {
      expect(BoolWrapper(true).getValue(), true);
    });

    test('getValue() false', () {
      expect(BoolWrapper(false).getValue(), false);
    });

    test('.setValue().getValue() true', () {
      BoolWrapper boolean = BoolWrapper(true);
      boolean.setValue(true);
      expect(boolean.getValue(), true);
    });

    test('.setValue().getValue() false', () {
      BoolWrapper boolean = BoolWrapper(true);
      boolean.setValue(false);
      expect(boolean.getValue(), false);
    });
  });
}
