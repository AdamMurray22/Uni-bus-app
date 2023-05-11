import 'package:app/Permissions/location_permissions_handler.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'location_permissions_handler_test.mocks.dart';

@GenerateMocks([Location])
@GenerateMocks([LocationData])
void main() {
  group('Location Permissions Handler Tests', () {

    test('.getHandler() Returns same handler', () {
      LocationPermissionsHandler handlerOne = LocationPermissionsHandler.getHandler();
      LocationPermissionsHandler handlerTwo = LocationPermissionsHandler.getHandler();
      expect(handlerOne, handlerTwo);
    });

    test('.hasPermission() True', () async {
      final location = MockLocation();

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.granted);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.hasPermission(), true);
    });

    test('.hasPermission() Service disabled', () async {
      final location = MockLocation();

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.granted);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => false);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.hasPermission(), false);
    });

    test('.hasPermission() Permission denied', () async {
      final location = MockLocation();

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.denied);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.hasPermission(), false);
    });

    test('.getLongitude() Permission granted', () async {
      final location = MockLocation();
      final locationData = MockLocationData();

      when(locationData.longitude).thenReturn(50);

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.granted);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);
      when(location.getLocation()).thenAnswer((realInvocation) async => locationData);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.getLongitude(), 50);
    });

    test('.getLongitude() Permission denied', () async {
      final location = MockLocation();
      final locationData = MockLocationData();

      when(locationData.longitude).thenReturn(50);

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.denied);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);
      when(location.getLocation()).thenAnswer((realInvocation) async => locationData);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.getLongitude(), null);
    });

    test('.getLatitude() Permission granted', () async {
      final location = MockLocation();
      final locationData = MockLocationData();

      when(locationData.latitude).thenReturn(50);

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.granted);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);
      when(location.getLocation()).thenAnswer((realInvocation) async => locationData);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.getLatitude(), 50);
    });

    test('.getLatitude() Permission denied', () async {
      final location = MockLocation();
      final locationData = MockLocationData();

      when(locationData.latitude).thenReturn(50);

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.denied);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);
      when(location.getLocation()).thenAnswer((realInvocation) async => locationData);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.getLatitude(), null);
    });

    test('.getLocationData() Permission granted', () async {
      final location = MockLocation();
      final locationData = MockLocationData();

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.granted);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);
      when(location.getLocation()).thenAnswer((realInvocation) async => locationData);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.getLocationData(), isA<LocationData>());
    });

    test('.getLocationData() Permission denied', () async {
      final location = MockLocation();
      final locationData = MockLocationData();

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.denied);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => true);
      when(location.getLocation()).thenAnswer((realInvocation) async => locationData);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.getLocationData(), null);
    });

    test('.requestLocationPermission() Permission denied', () async {
      final location = MockLocation();

      when(location.hasPermission()).thenAnswer((realInvocation) async => PermissionStatus.denied);
      when(location.serviceEnabled()).thenAnswer((realInvocation) async => false);
      when(location.requestService()).thenAnswer((realInvocation) async => false);
      when(location.requestPermission()).thenAnswer((realInvocation) async => PermissionStatus.denied);

      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandlerWithLocation(location);
      expect(await handler.requestLocationPermission(), null);
    });
  });
}
