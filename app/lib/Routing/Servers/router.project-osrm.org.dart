import 'package:app/Routing/Servers/routing_server.dart';
import 'package:app/Routing/location.dart';
import 'package:http/http.dart' as http;

/// The routing server at the address http://router.project-osrm.org/.
/// This is only a driving server.
class RouterProjectOSRM implements RoutingServer
{
  @override
  Future<String> getResponseBody(Location startLocation, Location endLocation)
  async {
    Uri uri = _getUri(startLocation, endLocation);
    http.Response response = await http.get(uri);
    return response.body;
  }

  Uri _getUri(Location startLocation, Location endLocation)
  {
    String linkPrefix = 'http://router.project-osrm.org/route/v1/driving/';
    String linkLocationData = '${startLocation.getLongitude()},${startLocation.getLatitude()};${endLocation.getLongitude()},${endLocation.getLatitude()}';
    String linkSuffix = '?overview=full&geometries=geojson';
    String link = '$linkPrefix$linkLocationData$linkSuffix';
    Uri uri = Uri.parse(link);
    return uri;
  }
}