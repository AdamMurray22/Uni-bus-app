import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../Map/map_data_id_enum.dart';
import '../Map/route_map_widget.dart';
import '../MapData/feature.dart';
import '../MapData/map_data_loader.dart';
import '../Sorts/heap_sort.dart';
import '../Sorts/comparator.dart';

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
  late final SingleValueDropDownController _fromRouteDropDownController;
  late final SingleValueDropDownController _toRouteDropDownController;
  late List<DropDownValueModel> _fromDropDownList = [];
  late List<DropDownValueModel> _toDropDownList = [];

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
            .add(const DropDownValueModel(name: "Current Location", value: MapDataId.userLocation));
        _fromDropDownList.addAll(fromList);
        _toDropDownList = _dropDownSort.sort(_toDropDownList);
      });
    });
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
                height: MediaQuery.of(context).size.height * 0.69694,
                decoration: BoxDecoration(
                  color: const Color(0x1f000000),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: RouteMapWidget()),
          ]),
    );
  }
}