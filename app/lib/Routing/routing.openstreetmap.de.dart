import 'package:app/Routing/routing_server.dart';
import 'package:app/Routing/location.dart';

/// The routing server at the address https://routing.openstreetmap.de/.
/// This is the server run by foggis.
class RoutingOpenstreetmapDe implements RoutingServer
{
  @override
  Uri getUri(Location startLocation, Location endLocation)
  {
    String linkPrefix = 'https://routing.openstreetmap.de/routed-foot/route/v1/foot/';
    String linkLocationData = '${startLocation.getLongitude()},${startLocation.getLatitude()};${endLocation.getLongitude()},${endLocation.getLatitude()}';
    String linkSuffix = '?overview=full&geometries=geojson&steps=true';
    String link = '$linkPrefix$linkLocationData$linkSuffix';
    Uri uri = Uri.parse(link);
    return uri;
  }
}