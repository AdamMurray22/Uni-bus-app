import 'package:location/location.dart';

/// This handles requesting permission to use the users location.
class LocationPermissionsHandler
{
  // This instance of itself is to make it a singleton.
  static LocationPermissionsHandler? _handler;
  late Location _location;

  // Private constructor to be called only once.
  LocationPermissionsHandler._()
  {
    _location = Location();
  }

  /// Returns the only instance of LocationPermissionsHandler, creates a new
  /// instance if one does not yet exist.
  static LocationPermissionsHandler getHandler()
  {
    _handler ??= LocationPermissionsHandler._();
    return _handler!;
  }

  /// Returns the Location object that can be used to get the users current
  /// location at any time.
  Location getLocation()
  {
    return _location;
  }

  /// Asks the user for permission to get their location.
  requestLocationPermission() async
  {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  /// Returns if the application has permission to access the users location.
  Future<bool> hasPermission() async {
    if (!await _location.serviceEnabled()) {
      return false;
    }
    return await _location.hasPermission() != PermissionStatus.denied;
  }
}