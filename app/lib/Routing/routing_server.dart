import 'package:app/Routing/location.dart';

/// The routing server.
abstract class RoutingServer
{
  // Returns the completed Uri for the routing server.
  Uri getUri(Location startLocation, Location endLocation);
}