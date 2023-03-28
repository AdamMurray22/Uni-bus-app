import 'package:app/Permissions/location_permissions_handler.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../Map/map_data_id_enum.dart';
import '../Map/route_map_widget.dart';
import '../MapData/feature.dart';
import '../MapData/map_data_loader.dart';
import '../Sorts/heap_sort.dart';
import '../Sorts/comparator.dart';
import '../Routing/location.dart' as location;

/// This holds the route screen.
class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

// The route screen state.
class _RouteScreenState extends State<RouteScreen> {
  final MapDataLoader _dataLoader = MapDataLoader.getDataLoader();
  late final HeapSort<DropDownValueModel> _dropDownSort;
  final GlobalKey<RouteMapWidgetState> _mapStateKey = GlobalKey();
  late final RouteMapWidget _mapWidget;

  late final SingleValueDropDownController _fromRouteDropDownController;
  late final SingleValueDropDownController _toRouteDropDownController;
  final List<DropDownValueModel> _fromDropDownList = [];
  List<DropDownValueModel> _toDropDownList = [];

  @override
  void initState() {
    // Sorts the drop down list to show the uni buildings, then the bus stops,
    // then the landmarks. With all three groups sorted alphabetically.
    _dropDownSort = HeapSort<DropDownValueModel>(
            (DropDownValueModel model1, DropDownValueModel model2) {
          int assignIntFromMapDataId(MapDataId id) {
            if (id == MapDataId.uniBuilding) {
              return 0;
            } else if (id == MapDataId.u1) {
              return 1;
            } else {
              return 2;
            }
          }

          MapDataId model1Id = MapDataId.getMapDataIdEnumFromId(model1.value);
          MapDataId model2Id = MapDataId.getMapDataIdEnumFromId(model2.value);
          int idValue1 = assignIntFromMapDataId(model1Id);
          int idValue2 = assignIntFromMapDataId(model2Id);
          if (idValue1 == idValue2) {
            return Comparator.alphabeticalComparator()
                .call(model1.name, model2.name);
          } else if (idValue1 < idValue2) {
            return Comparator.before;
          } else {
            return Comparator.after;
          }
        });

    _fromRouteDropDownController = SingleValueDropDownController();
    _toRouteDropDownController = SingleValueDropDownController();
    _dataLoader.onDataLoaded((mapData) {
      setState(() {
        for (Feature feature in mapData.getAllFeatures()) {
          _fromDropDownList
              .add(DropDownValueModel(name: feature.name, value: feature.id));
          _toDropDownList
              .add(DropDownValueModel(name: feature.name, value: feature.id));
        }
        List<DropDownValueModel> fromList = _dropDownSort.sort(_fromDropDownList);
        _fromDropDownList.clear();
        _fromDropDownList
            .add(DropDownValueModel(name: "Current Location", value: MapDataId.userLocation.idPrefix));
        _fromDropDownList.addAll(fromList);
        _toDropDownList = _dropDownSort.sort(_toDropDownList);
      });
    });

    _mapWidget = RouteMapWidget(
      key: _mapStateKey,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: DropDownTextField(
                controller: _fromRouteDropDownController,
                clearOption: true,
                enableSearch: true,
                textFieldDecoration: const InputDecoration(hintText: "From"),
                searchDecoration:
                    const InputDecoration(hintText: "Enter location here"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 5,
                dropDownList: _fromDropDownList,
                onChanged: (value) {
                  if (value == "") {
                    return;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: DropDownTextField(
                controller: _toRouteDropDownController,
                clearOption: true,
                enableSearch: true,
                textFieldDecoration: const InputDecoration(hintText: "To"),
                searchDecoration:
                    const InputDecoration(hintText: "Enter location here"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 5,
                dropDownList: _toDropDownList,
                onChanged: (value) {
                  if (value == "") {
                    return;
                  }
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height * 0.69694) - 48,
                decoration: BoxDecoration(
                  color: const Color(0x1f000000),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: _mapWidget),
            MaterialButton(
              onPressed: () {
                _createRoute();
              },
              color: const Color(0xffffffff),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: Color(0xff808080), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textColor: const Color(0xff000000),
              height: 40,
              minWidth: 140,
              child: const Text(
                "Route",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ]),
    );
  }

  // Gets the chosen start and end for the route and creates it.
  _createRoute() async {
    Map<String, Feature> features = MapDataLoader.getDataLoader().getMapData().getFeaturesMap();
    String fromId = _fromRouteDropDownController.dropDownValue!.value;
    String toId = _toRouteDropDownController.dropDownValue!.value;
    bool isUserLocation = (fromId == MapDataId.userLocation.idPrefix);
    _addRoute(fromId, toId);
    Feature toLocation = features[toId]!;
    _mapStateKey.currentState?.addDestinationMarker(location.Location(toLocation.long, toLocation.lat));
    if (isUserLocation)
    {
      LocationPermissionsHandler.getHandler().onLocationChanged((locationData)
      {
        _addRoute(fromId, toId);
      });
    }
  }

  _addRoute(String fromId, String toId) async {
    Map<String, Feature> features = MapDataLoader.getDataLoader().getMapData().getFeaturesMap();
    bool isUserLocation = fromId == MapDataId.userLocation.idPrefix;
    location.Location? fromLocation;
    location.Location? toLocation;
    if (isUserLocation)
    {
      LocationPermissionsHandler handler = LocationPermissionsHandler.getHandler();
      LocationData data = await handler.getLocationData();
      double? long = data.longitude;
      double? lat = data.latitude;
      if (long == null) return;
      if (lat == null) return;
      fromLocation = location.Location(long, lat);
    }
    else {
      Feature feature = features[fromId]!;
      fromLocation = location.Location(feature.long, feature.lat);
    }
    Feature feature = features[toId]!;
    toLocation = location.Location(feature.long, feature.lat);
    _mapStateKey.currentState?.createRoute(fromLocation, toLocation);
  }
}