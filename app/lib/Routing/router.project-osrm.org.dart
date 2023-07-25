import 'package:app/Routing/routing_server.dart';
import 'package:app/Routing/location.dart';

/// The routing server at the address http://router.project-osrm.org/.
/// This is only a driving server.
class RoutingOpenstreetmapDe implements RoutingServer
{
  @override
  Uri getUri(Location startLocation, Location endLocation)
  {
    String linkPrefix = 'http://router.project-osrm.org/route/v1/driving/';
    String linkLocationData = '${startLocation.getLongitude()},${startLocation.getLatitude()};${endLocation.getLongitude()},${endLocation.getLatitude()}';
    String linkSuffix = '?overview=full&geometries=geojson';
    String link = '$linkPrefix$linkLocationData$linkSuffix';
    Uri uri = Uri.parse(link);
    return uri;
  }
}