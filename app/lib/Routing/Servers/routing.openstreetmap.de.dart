import 'package:app/Routing/Servers/routing_server.dart';
import 'package:app/Routing/location.dart';
import 'package:http/http.dart' as http;

/// The routing server at the address https://routing.openstreetmap.de/.
/// This is the server run by foggis.
class RoutingOpenstreetmapDe extends RoutingServer
{
  final String _uriDomains = 'routing.openstreetmap.de';

  RoutingOpenstreetmapDe({super.pingRoutingServerFunction});

  @override
  Future<String> getResponseBody(Location startLocation, Location endLocation)
  async {
    Uri uri = _getUri(startLocation, endLocation);
    http.Response response = await http.get(uri);
    return response.body;
  }

  Uri _getUri(Location startLocation, Location endLocation)
  {
    String linkPrefix = 'https://routing.openstreetmap.de/routed-foot/route/v1/foot/';
    String linkLocationData = '${startLocation.getLongitude()},${startLocation.getLatitude()};${endLocation.getLongitude()},${endLocation.getLatitude()}';
    String linkSuffix = '?overview=full&geometries=geojson&steps=true';
    String link = '$linkPrefix$linkLocationData$linkSuffix';
    Uri uri = Uri.parse(link);
    return uri;
  }

  @override
  String getUriDomains()
  {
    return _uriDomains;
  }
}