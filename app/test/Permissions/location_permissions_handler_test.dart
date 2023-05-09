import 'package:app/Permissions/location_permissions_handler.dart';
import 'package:test/test.dart';

void main() {
  group('Location Permissions Handler Tests', () {

    test('.getHandler() Returns same handler', () {
      LocationPermissionsHandler handlerOne = LocationPermissionsHandler.getHandler();
      LocationPermissionsHandler handlerTwo = LocationPermissionsHandler.getHandler();
      expect(handlerOne, handlerTwo);
    });
  });
}
