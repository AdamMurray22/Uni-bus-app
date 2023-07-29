import 'package:app/MapData/bus_stop.dart';
import 'package:app/Routing/RouteCreators/advanced_route_creator.dart';
import 'package:app/Routing/Servers/routing_server.dart';
import 'package:app/Routing/geo_json_geometry.dart';
import 'package:app/Routing/location.dart';
import 'package:app/Routing/walking_route.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'basic_route_creator_test.mocks.dart';

@GenerateMocks([RoutingServer])
void main() {
  group('Basic Route Creator Tests', () {

    test('.createRoute() route correctly created with no bus stops', () async {
      final server = MockRoutingServer();

      Set<BusStop> busStops = {};

      // Use Mockito to return a successful response when it calls the
      // routing server.
      Location location1 = Location(-1.0983533,50.798795);
      Location location2 = Location(-1.0980056609821778,50.797919492099254);
      when(server.getResponseBody(location1, location2)).thenAnswer((_) async =>
      '{"code":"Ok","routes":[{"geometry":{"coordinates":[[-1.098122,50.798742],[-1.098221,50.798569],[-1.098227,50.798557],[-1.098252,50.798471],[-1.098508,50.798057],[-1.098558,50.797978],[-1.098814,50.79759],[-1.098853,50.79753],[-1.098766,50.797509],[-1.098543,50.797487],[-1.098396,50.797472],[-1.098324,50.797469],[-1.098275,50.797067],[-1.098146,50.797102],[-1.098055,50.797128],[-1.097876,50.797359],[-1.097795,50.797519],[-1.097711,50.797502],[-1.097438,50.797936],[-1.097399,50.797943],[-1.097484,50.797997],[-1.097606,50.798028],[-1.097646,50.797951]],"type":"LineString"},"legs":[{"steps":[{"geometry":{"coordinates":[[-1.098122,50.798742],[-1.098221,50.798569],[-1.098227,50.798557],[-1.098252,50.798471],[-1.098508,50.798057],[-1.098558,50.797978],[-1.098814,50.79759],[-1.098853,50.79753]],"type":"LineString"},"maneuver":{"bearing_after":200,"bearing_before":0,"location":[-1.098122,50.798742],"modifier":"right","type":"depart"},"mode":"walking","driving_side":"right","name":"Lion Terrace","intersections":[{"out":0,"entry":[true],"bearings":[200],"location":[-1.098122,50.798742]},{"out":2,"in":0,"entry":[false,true,true],"bearings":[15,30,195],"location":[-1.098252,50.798471]},{"out":1,"in":0,"entry":[false,true,true],"bearings":[15,195,285],"location":[-1.098508,50.798057]},{"out":1,"in":0,"entry":[false,true,true],"bearings":[15,210,285],"location":[-1.098558,50.797978]},{"out":1,"in":0,"entry":[false,true,true],"bearings":[30,195,285],"location":[-1.098814,50.79759]}],"weight":12.389999999,"duration":115.599999999,"distance":144.5},{"geometry":{"coordinates":[[-1.098853,50.79753],[-1.098766,50.797509],[-1.098543,50.797487],[-1.098396,50.797472],[-1.098324,50.797469]],"type":"LineString"},"maneuver":{"bearing_after":105,"bearing_before":201,"location":[-1.098853,50.79753],"modifier":"left","type":"turn"},"mode":"walking","driving_side":"right","name":"","intersections":[{"out":1,"in":0,"entry":[false,true,true,true],"bearings":[15,105,180,300],"location":[-1.098853,50.79753]}],"weight":3.81,"duration":30.5,"distance":38.1},{"geometry":{"coordinates":[[-1.098324,50.797469],[-1.098275,50.797067]],"type":"LineString"},"maneuver":{"bearing_after":174,"bearing_before":95,"location":[-1.098324,50.797469],"modifier":"right","type":"turn"},"mode":"walking","driving_side":"right","name":"","intersections":[{"out":1,"in":2,"entry":[true,true,false],"bearings":[90,180,270],"location":[-1.098324,50.797469]}],"weight":4.49,"duration":35.9,"distance":44.9},{"geometry":{"coordinates":[[-1.098275,50.797067],[-1.098146,50.797102],[-1.098055,50.797128],[-1.097876,50.797359],[-1.097795,50.797519],[-1.097711,50.797502]],"type":"LineString"},"maneuver":{"bearing_after":66,"bearing_before":174,"location":[-1.098275,50.797067],"modifier":"left","type":"turn"},"mode":"walking","driving_side":"right","name":"","intersections":[{"out":1,"in":0,"entry":[false,true,true],"bearings":[0,60,225],"location":[-1.098275,50.797067]},{"out":1,"in":2,"entry":[true,true,false],"bearings":[15,60,240],"location":[-1.098146,50.797102]},{"out":0,"in":2,"entry":[true,true,false],"bearings":[15,75,210],"location":[-1.097876,50.797359]}],"weight":7.04,"duration":56.4,"distance":70.5},{"geometry":{"coordinates":[[-1.097711,50.797502],[-1.097438,50.797936],[-1.097399,50.797943]],"type":"LineString"},"maneuver":{"bearing_after":21,"bearing_before":74,"location":[-1.097711,50.797502],"modifier":"left","type":"turn"},"mode":"walking","driving_side":"right","name":"","intersections":[{"out":0,"in":2,"entry":[true,true,false],"bearings":[15,105,255],"location":[-1.097711,50.797502]}],"weight":5.49,"duration":43.9,"distance":54.8},{"geometry":{"coordinates":[[-1.097399,50.797943],[-1.097484,50.797997],[-1.097606,50.798028]],"type":"LineString"},"maneuver":{"bearing_after":310,"bearing_before":35,"location":[-1.097399,50.797943],"modifier":"left","type":"turn"},"mode":"walking","driving_side":"right","name":"","intersections":[{"out":2,"in":1,"entry":[true,false,true],"bearings":[90,210,315],"location":[-1.097399,50.797943]}],"weight":1.78,"duration":14.2,"distance":17.8},{"geometry":{"coordinates":[[-1.097606,50.798028],[-1.097646,50.797951]],"type":"LineString"},"maneuver":{"bearing_after":196,"bearing_before":292,"location":[-1.097606,50.798028],"modifier":"left","type":"turn"},"mode":"walking","driving_side":"right","name":"","intersections":[{"out":2,"in":1,"entry":[true,false,true],"bearings":[15,120,195],"location":[-1.097606,50.798028]}],"weight":0.9,"duration":7.2,"distance":9},{"geometry":{"coordinates":[[-1.097646,50.797951],[-1.097646,50.797951]],"type":"LineString"},"maneuver":{"bearing_after":0,"bearing_before":198,"location":[-1.097646,50.797951],"modifier":"right","type":"arrive"},"mode":"walking","driving_side":"right","name":"","intersections":[{"in":0,"entry":[true],"bearings":[18],"location":[-1.097646,50.797951]}],"weight":0,"duration":0,"distance":0}],"summary":"Lion Terrace","weight":35.9,"duration":303.7,"distance":379.6}],"weight_name":"routability","weight":35.9,"duration":303.7,"distance":379.6}],"waypoints":[{"hint":"YFdigIlGlZbNAAAATAAAAAAAAAAfAgAAnsijQQ2n8kAAAAAAwwNZQqMAAAA9AAAAAAAAALIBAABIAAAAdj7v_5YgBwOPPe__yyAHAwAAPwEKQCFz","distance":17.327875572,"name":"Lion Terrace","location":[-1.098122,50.798742]},{"hint":"XAb8l14G_JcAAAAAWgAAAAAAAAAAAAAAAAAAAMdLEEEAAAAAAAAAAAAAAABIAAAAAAAAAAAAAABIAAAAUkDv_38dBwPqPu__Xx0HAwAALwEKQCFz","distance":25.641497556,"name":"","location":[-1.097646,50.797951]}]}');

      WalkingRoute testRoute = WalkingRoute([GeoJsonGeometry('{"coordinates":[[-1.098122,50.798742],[-1.098221,50.798569],[-1.098227,50.798557],[-1.098252,50.798471],[-1.098508,50.798057],[-1.098558,50.797978],[-1.098814,50.79759],[-1.098853,50.79753],[-1.098766,50.797509],[-1.098543,50.797487],[-1.098396,50.797472],[-1.098324,50.797469],[-1.098275,50.797067],[-1.098146,50.797102],[-1.098055,50.797128],[-1.097876,50.797359],[-1.097795,50.797519],[-1.097711,50.797502],[-1.097438,50.797936],[-1.097399,50.797943],[-1.097484,50.797997],[-1.097606,50.798028],[-1.097646,50.797951]],"type":"LineString"}')],
          303.7, 379.6, 144.5, '"right"');

      AdvancedRouteCreator routeCreator = AdvancedRouteCreator.setServer(busStops, server);
      WalkingRoute route = await routeCreator.createRoute(location1, location2);

      expect(route.getGeometries(), testRoute.getGeometries());
      expect(route.getDistanceTillNextTurn(), testRoute.getDistanceTillNextTurn());
      expect(route.getNextTurn(), testRoute.getNextTurn());
      expect(route.getTotalDistance(), testRoute.getTotalDistance());
      expect(route.getTotalSeconds(), testRoute.getTotalSeconds());
    });
  });
}