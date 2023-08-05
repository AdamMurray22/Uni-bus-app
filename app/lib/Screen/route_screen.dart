import 'dart:math';

import 'package:app/Location/location_handler.dart';
import 'package:app/Routing/RouteCreators/advanced_route_creator.dart';
import 'package:app/Routing/routing_status_enum.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../Map/map_data_id_enum.dart';
import '../Map/route_map_widget.dart';
import '../MapData/feature.dart';
import '../MapData/map_data_loader.dart';
import '../Routing/estimate_straight_line_distance.dart';
import '../Sorts/heap_sort.dart';
import '../Sorts/comparator.dart';
import '../Routing/location.dart' as location;

/// This holds the route screen.
class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key , this.pingMapFunction, this.pingRoutingFunction});

  final Function(String)? pingMapFunction;
  final Function(String)? pingRoutingFunction;

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

  String _nextTurn = "";
  String _totalDistance = "";
  String _totalTime = "";

  RoutingStatus _currentlyRouting = RoutingStatus.notRouting;

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
    _dataLoader.onDataLoaded((mapData) async {
      _fromDropDownList.clear();
      if (await LocationHandler.getHandler().hasPermission()) {
        _fromDropDownList.add(DropDownValueModel(
            name: "Current Location", value: MapDataId.userLocation.idPrefix));
      }
      List<DropDownValueModel> fromList = [];
      setState(() {
        for (Feature feature in mapData.getAllFeatures()) {
          fromList
              .add(DropDownValueModel(name: feature.name, value: feature.id));
          _toDropDownList
              .add(DropDownValueModel(name: feature.name, value: feature.id));
        }
        fromList = _dropDownSort.sort(fromList);
        _fromDropDownList.addAll(fromList);
        _toDropDownList = _dropDownSort.sort(_toDropDownList);
      });
    });

    _mapWidget = RouteMapWidget(
      key: _mapStateKey,
      pingTileServerFunction: widget.pingMapFunction,
      pingRoutingServerFunction: widget.pingRoutingFunction,
      routeScreenUpdateFunction: (route)
      {
        setState(() {
          if (route.getNextTurn() != null)
          {
            _nextTurn = "Turn ${route.getNextTurn()} in ${route.getDisplayDistanceTillNextTurn()}";
          }
          else
          {
            _nextTurn = "";
          }
          _totalDistance = "${route.getTotalDisplayDistance()} total";
          _totalTime = route.getTotalDisplayTime();
        });
      },
    );
    _dataLoader.onDataLoaded((mapData) async {
      setState(() {
        _mapStateKey.currentState?.setRouteCreator(AdvancedRouteCreator(mapData.getAllBusStops()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget routeInfoScreen;
    if (_currentlyRouting == RoutingStatus.notRouting)
    {
        routeInfoScreen = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ],
        );
    }
    else if (_currentlyRouting == RoutingStatus.userLocationRouting)
    {
      routeInfoScreen = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(_nextTurn),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_totalTime),
                  const SizedBox(width: 3),
                  Text(_totalDistance),
                ]),
            ],
          ),
          const SizedBox(width: 5),
          MaterialButton(
            onPressed: () {
              _endRoute();
            },
            color: const Color(0xffffffff),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Color(0xff808080), width: 1),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textColor: const Color(0xff000000),
            height: 40,
            minWidth: 140,
            child: const Text(
              "End Route",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      );
    }
    else
    {
      routeInfoScreen = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_totalTime),
                const SizedBox(width: 3),
                Text(_totalDistance),
              ]),
          const SizedBox(width: 5),
          MaterialButton(
            onPressed: () {
              _endRoute();
            },
            color: const Color(0xffffffff),
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Color(0xff808080), width: 1),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textColor: const Color(0xff000000),
            height: 40,
            minWidth: 140,
            child: const Text(
              "End Route",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ],
      );
    }

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
            Container(
                child: routeInfoScreen),
          ]),
    );
  }

  // Gets the chosen start and end for the route and creates it.
  _createRoute() async {
    LocationHandler locationHandler = LocationHandler.getHandler();
    String? nullableFromId = _fromRouteDropDownController.dropDownValue?.value;
    String? nullableToId = _toRouteDropDownController.dropDownValue?.value;
    if (nullableFromId == null || nullableToId == null) {
      return;
    }
    String fromId = nullableFromId;
    String toId = nullableToId;
    bool isUserLocation = (fromId == MapDataId.userLocation.idPrefix);
    await locationHandler.removeOnRouteLocationChanged();
    location.Location fromLocation = await _getFromLocation(fromId);
    location.Location toLocation = _getToLocation(toId);
    _mapStateKey.currentState?.setCurrentRoute(fromId, toId);
    await _mapStateKey.currentState
        ?.createRoute(fromLocation, toLocation, fromId, toId);
    if (isUserLocation) {
      String currentFromId = fromId;
      String currentToId = toId;
      await locationHandler.onRouteLocationChanged((locationData) async {
        await _updateRoute(currentFromId, currentToId);
      });
      _currentlyRouting = RoutingStatus.userLocationRouting;
    } else {
      _currentlyRouting = RoutingStatus.nonUserLocationRouting;
    }
    setState(() {
    });
  }

  // Updates the route on the map.
  _updateRoute(String fromId, String toId) async {
    location.Location fromLocation = await _getFromLocation(fromId);
    location.Location toLocation = _getToLocation(toId);
    double distanceToDestination = EstimateStraightLineDistance.estimateStraightLineDistance(fromLocation, toLocation);
    if (distanceToDestination < 30) { // 30 metres.
      _endRoute();
      return;
    }
    await _mapStateKey.currentState
        ?.createRoute(fromLocation, toLocation, fromId, toId);
  }

  // Returns the from location.
  Future<location.Location> _getFromLocation(String fromId) async {
    Map<String, Feature> features =
        MapDataLoader.getDataLoader().getMapData().getFeaturesMap();
    bool isUserLocation = (fromId == MapDataId.userLocation.idPrefix);
    location.Location? fromLocation;
    if (isUserLocation) {
      LocationHandler handler = LocationHandler.getHandler();
      LocationData data = (await handler.getLocationData())!;
      double long = data.longitude!;
      double lat = data.latitude!;
      fromLocation = location.Location(long, lat);
    } else {
      Feature feature = features[fromId]!;
      fromLocation = location.Location(feature.long, feature.lat);
    }
    return fromLocation;
  }

  // Returns the to location.
  location.Location _getToLocation(String toId) {
    Map<String, Feature> features =
        MapDataLoader.getDataLoader().getMapData().getFeaturesMap();
    location.Location? toLocation;
    Feature feature = features[toId]!;
    toLocation = location.Location(feature.long, feature.lat);
    return toLocation;
  }

  // Ends the route.
  _endRoute() async {
    await _mapStateKey.currentState?.endRoute();
    LocationHandler.getHandler().removeOnRouteLocationChanged();
    setState(() {
      _currentlyRouting = RoutingStatus.notRouting;
    });
  }
}
