import 'package:app/Routing/location.dart';
import 'package:test/test.dart';

void main() {
  group('Routing Location Tests', () {

    test('.getLongitude() valid Longitude', () {
      Location location = Location(50, 64);
      expect(location.getLongitude(), 50);
    });

    test('.getLatitude() valid Latitude', () {
      Location location = Location(50, 64);
      expect(location.getLatitude(), 64);
    });
  });
}
