import 'dart:async';

import 'package:location/location.dart';

/// This handles requesting permission to use the users location.
class LocationPermissionsHandler {
  // This instance of itself is to make it a singleton.
  static LocationPermissionsHandler? _handler;
  late Location _location;
  final Set<Function(LocationData)> _onLocationChangedFunctions = {};
  late StreamSubscription? _locationStream;

  // Private constructor to be called only once.
  LocationPermissionsHandler._() {
    _location = Location();
  }

  /// Returns the only instance of LocationPermissionsHandler, creates a new
  /// instance if one does not yet exist.
  static LocationPermissionsHandler getHandler() {
    _handler ??= LocationPermissionsHandler._();
    return _handler!;
  }

  /// Returns the longitude of the user, null if not found for any reason.
  Future<double?> getLongitude() async {
    if (!(await hasPermission()))
    {
        return null;
    }
    LocationData locationData = await _location.getLocation();
    return locationData.longitude;
  }

  /// Returns the latitude of the user, null if not found for any reason.
  Future<double?> getLatitude() async {
    if (!(await hasPermission()))
    {
      return null;
    }
    LocationData locationData = await _location.getLocation();
    return locationData.latitude;
  }

  /// Returns the location data for the user.
  Future<LocationData?> getLocationData() async {
    if (!(await hasPermission()))
    {
      return null;
    }
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
  onRouteLocationChanged(Function(LocationData) onChanged) async {
    if (_locationStream == null && await hasPermission())
    {
        _locationStream = _location.onLocationChanged.listen(null);
    }
    _locationStream?.onData((locationData)
    {
      onChanged(locationData);
    });
  }

  /// Removes the function being run when the location data updates.
  removeOnRouteLocationChanged() async {
    if (_locationStream == null && await hasPermission())
    {
    _locationStream = _location.onLocationChanged.listen(null);
    }
    _locationStream?.onData(null);
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
