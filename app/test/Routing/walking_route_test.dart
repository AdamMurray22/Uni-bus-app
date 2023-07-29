import 'package:app/Routing/walking_route.dart';
import 'package:test/test.dart';

void main() {
  group('Walking Route Tests', () {

    test('.getNextTurn() valid string with ""', () {
      WalkingRoute route = WalkingRoute({}, 0, 0, 0, '"Turn"');
      expect(route.getNextTurn(), 'Turn');
    });
    test('.getNextTurn() valid string without ""', () {
      WalkingRoute route = WalkingRoute({}, 0, 0, 0, 'Turn');
      expect(route.getNextTurn(), 'Turn');
    });

    test('.getTotalDisplayTime() format 1 min', () {
      WalkingRoute route = WalkingRoute({}, 70, 0, 0, '');
      expect(route.getTotalDisplayTime(), "1 min");
    });

    test('.getTotalDisplayTime() format 2 mins', () {
      WalkingRoute route = WalkingRoute({}, 170, 0, 0, '');
      expect(route.getTotalDisplayTime(), "2 mins");
    });

    test('.getTotalDisplayDistance() format < 1km', () {
      WalkingRoute route = WalkingRoute({}, 0, 156.5541, 0, '');
      expect(route.getTotalDisplayDistance(), "156m");
    });

    test('.getTotalDisplayDistance() format > 1km', () {
      WalkingRoute route = WalkingRoute({}, 0, 1506.5541, 0, '');
      expect(route.getTotalDisplayDistance(), "1.506km");
    });

    test('.getDisplayDistanceTillNextTurn() format < 1km', () {
      WalkingRoute route = WalkingRoute({}, 0, 0, 156.5541, '');
      expect(route.getDisplayDistanceTillNextTurn(), "156m");
    });

    test('.getDisplayDistanceTillNextTurn() format > 1km', () {
      WalkingRoute route = WalkingRoute({}, 0, 0, 1506.5541, '');
      expect(route.getDisplayDistanceTillNextTurn(), "1.506km");
    });
  });
}
