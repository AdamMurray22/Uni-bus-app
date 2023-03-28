import 'dart:async';

import 'package:location/location.dart';

/// This handles requesting permission to use the users location.
class LocationPermissionsHandler {
  // This instance of itself is to make it a singleton.
  static LocationPermissionsHandler? _handler;
  late Location _location;
  final Set<Function(LocationData)> _onLocationChangedFunctions = {};
  late StreamSubscription _locationStream;

  // Private constructor to be called only once.
  LocationPermissionsHandler._() {
    _location = Location();
    _locationStream = _location.onLocationChanged.listen(null);
  }

  /// Returns the only instance of LocationPermissionsHandler, creates a new
  /// instance if one does not yet exist.
  static LocationPermissionsHandler getHandler() {
    _handler ??= LocationPermissionsHandler._();
    return _handler!;
  }

  Future<double?> getLongitude() async {
    LocationData locationData = await _location.getLocation();
    return locationData.longitude;
  }

  Future<double?> getLatitude() async {
    LocationData locationData = await _location.getLocation();
    return locationData.latitude;
  }

  Future<LocationData> getLocationData() async {
    return await _location.getLocation();
}

  /// Asks the user for permission to get their location.
  requestLocationPermission() async {
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

  /// Adds a function to call when location updates are received.
  onLocationChanged(Function(LocationData) onChanged) async {
    _onLocationChangedFunctions.add(onChanged);
    if (await hasPermission()) {
      _location.onLocationChanged.listen((LocationData locationData) {
        onChanged(locationData);
      });
    }
  }

  /// Adds a function to call when location updates are received.
  onRouteLocationChanged(Function(LocationData) onChanged) {
    _locationStream.onData((locationData)
    {
      onChanged(locationData);
    });
  }

  removeOnRouteLocationChanged() {
    _locationStream.onData(null);
  }

  // Adds all _onLocationChangedFunctions to be called on a location update.
  _addLocationChanged() {
    _location.onLocationChanged.listen((locationData) {
      for (Function(LocationData) function in _onLocationChangedFunctions) {
        function(locationData);
      }
    });
  }
}
