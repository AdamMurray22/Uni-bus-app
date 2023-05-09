import 'package:app/Exceptions/map_data_id_not_found_exception.dart';
import 'package:app/Map/map_data_id_enum.dart';
import 'package:test/test.dart';

void main() {
  group('Map Data Id Tests', () {
    test('.getMapDataIdEnumFromId() valid U1 bus route', () {
      expect(MapDataId.getMapDataIdEnumFromId("U1-000123"), MapDataId.u1);
    });

    test('.getMapDataIdEnumFromId() valid uni building', () {
      expect(MapDataId.getMapDataIdEnumFromId("UB-873949"), MapDataId.uniBuilding);
    });

    test('.getMapDataIdEnumFromId() valid landmark', () {
      expect(MapDataId.getMapDataIdEnumFromId("LM-9052"), MapDataId.landmark);
    });

    test('.getMapDataIdEnumFromId() valid user location', () {
      expect(MapDataId.getMapDataIdEnumFromId("UL-93455-"), MapDataId.userLocation);
    });

    test('.getMapDataIdEnumFromId() valid route', () {
      expect(MapDataId.getMapDataIdEnumFromId("RT-i9025"), MapDataId.route);
    });

    test('.getMapDataIdEnumFromId() valid destination', () {
      expect(MapDataId.getMapDataIdEnumFromId("DN-0890243"), MapDataId.destination);
    });

    test('.getMapDataIdEnumFromId() invalid id', () {
      expect(
        () => MapDataId.getMapDataIdEnumFromId("invalid"),
        throwsA(
          isA<MapDataIdNotFoundException>().having(
            (error) => error.message,
            'message',
            'Id not found.',
          ),
        ),
      );
    });
  });
}
