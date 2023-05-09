import 'package:app/MapData/feature.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Feature Tests', () {

    test('toDisplayInfoScreen() valid display format', () {
      Feature feature = Feature("UB-1", "name", 50, 40);
      Tuple2<List<String>, List<String>> displayInfo = feature.toDisplayInfoScreen();
      expect(displayInfo.item1, ["name"]);
      expect(displayInfo.item2, []);
    });

    test('==() == true', () {
      Feature feature1 = Feature("UB-1", "name", 50, 40);
      Feature feature2 = Feature("UB-1", "name", 50, 40);
      expect(feature1 == feature2, true);
    });

    test('==() == false', () {
      Feature feature1 = Feature("UB-1", "name", 50, 40);
      Feature feature2 = Feature("UB-2", "other name", 50, 40);
      expect(feature1 == feature2, false);
    });
  });
}
