import 'package:app/MapData/feature.dart';
import 'package:app/MapData/map_data_loader.dart';
import 'package:app/Sorts/comparator.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Map/map_data_id_enum.dart';
import '../Map/open_layers_map.dart';
import '../MapData/map_data.dart';
import '../Sorts/heap_sort.dart';
import '../wrapper/bool_wrapper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({required this.onShowTimeTableButtonPressed, super.key});

  final VoidCallback onShowTimeTableButtonPressed;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapDataLoader _dataLoader = MapDataLoader.getDataLoader();
  late final HeapSort<DropDownValueModel> _dropDownSort;

  late final OpenLayersMap _mapController;
  late final SingleValueDropDownController _dropDownController;
  late List<DropDownValueModel> _dropDownList = [];
  final Map<MapDataId, BoolWrapper> valueCheckMap = {};
  final List<Text> _featureInfo = [];
  String _featureInfoTitle = "";

  List<String> _infoText = [];
  late final MaterialButton _seeFullTimeTableButton;
  MaterialButton? _seeFullTimeTableButtonHolder;
  bool _featureInfoVisible = false;
  final BoolWrapper _u1ValueCheck = BoolWrapper(true);
  final BoolWrapper _uniBuildingValueCheck = BoolWrapper(true);
  final BoolWrapper _landmarkValueCheck = BoolWrapper(true);

  _MapScreenState() {
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
  }

  @override
  initState() {
    valueCheckMap[MapDataId.u1] = _u1ValueCheck;
    valueCheckMap[MapDataId.uniBuilding] = _uniBuildingValueCheck;
    valueCheckMap[MapDataId.landmark] = _landmarkValueCheck;
    _mapController = OpenLayersMap();
    _dropDownController = SingleValueDropDownController();
    _dataLoader.onDataLoaded((mapData) {
      setState(() {
        for (Feature feature in mapData.getAllFeatures()) {
          _dropDownList
              .add(DropDownValueModel(name: feature.name, value: feature.id));
        }
        _dropDownList = _dropDownSort.sort(_dropDownList);
      });
    });
    _seeFullTimeTableButton = MaterialButton(
      onPressed: () {
          widget.onShowTimeTableButtonPressed();
      },
      color: const Color(0xffffffff),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side:
        BorderSide(color: Color(0xff808080), width: 1),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      textColor: const Color(0xff000000),
      height: 40,
      minWidth: 140,
      child: const Text(
        textAlign: TextAlign.center,
        "See full timetable here",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mapController.onMarkerClicked((markerId) {
      setState(() {
        _showMapFeatureInfoPanel(markerId);
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          DropDownTextField(
            controller: _dropDownController,
            clearOption: true,
            enableSearch: true,
            textFieldDecoration: const InputDecoration(hintText: "Search"),
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
            dropDownList: _dropDownList,
            onChanged: (value) {
              if (value == "") {
                setState(() {
                  _featureInfoVisible = false;
                });
                return;
              }
              MapDataId valueId = MapDataId.getMapDataIdEnumFromId(value.value);
              setState(() {
                _showMapFeatureInfoPanel(value.value);
                if (!valueCheckMap[valueId]!.value) {
                  _mapCheckBoxChange(valueId, true);
                }
              });
              _mapController.setMapCentreZoom(
                  _getMapData().getFeaturesMap()[value.value]!);
            },
          ),
          Stack(children: [
            Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7059,
                decoration: BoxDecoration(
                  color: const Color(0x1f000000),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: WebViewWidget(controller: _mapController)),
            Visibility(
              visible: _featureInfoVisible, // not visible if set false
              child: Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.7059,
                decoration: BoxDecoration(
                  color: const Color(0xff999999),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: Stack(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ListTile(
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              alignment: Alignment.topRight,
                              onPressed: () {
                                setState(() {
                                  _featureInfoVisible = false;
                                  _featureInfoTitle = "";
                                  _featureInfo.clear();
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 5, 10),
                                    child: Text(
                                      _featureInfoTitle,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: _featureInfo),
                                ]),
                          ),
                        ]),
                    Positioned(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: _seeFullTimeTableButtonHolder,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "U1",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Checkbox(
                  onChanged: (value) {
                    _mapCheckBoxChange(MapDataId.u1, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _u1ValueCheck.value,
                ),
                const Text(
                  "Uni buildings",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Checkbox(
                  onChanged: (value) {
                    _mapCheckBoxChange(MapDataId.uniBuilding, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _uniBuildingValueCheck.value,
                ),
                const Text(
                  "Landmarks",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Checkbox(
                  onChanged: (value) {
                    _mapCheckBoxChange(MapDataId.landmark, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _landmarkValueCheck.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Displays the info panel.
  _showMapFeatureInfoPanel(String markerId) {
    _featureInfoTitle = "";
    _featureInfo.clear();
    _featureInfoVisible = true;
    MapData mapData = _getMapData();
    Feature? feature = mapData.getFeaturesMap()[markerId];
    if (feature == null) {
      return;
    }
    _infoText = feature.toDisplayInfoScreen();
    _featureInfoTitle = _infoText[0];
    _infoText.removeAt(0);
    for (String info in _infoText) {
      _featureInfo.add(Text(
        info,
        textAlign: TextAlign.start,
        overflow: TextOverflow.clip,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 17,
          color: Color(0xff000000),
        ),
      ));
    }
    _seeFullTimeTableButtonHolder = MapDataId.getMapDataIdEnumFromId(markerId) == MapDataId.u1 ? _seeFullTimeTableButton : null;
  }

  // Toggles the checkbox and markers for that checkbox.
  _mapCheckBoxChange(MapDataId id, bool value) {
    setState(() {
      valueCheckMap[id]?.value = value;
    });
    _mapController.toggleMarkers(id, value);
  }

  // Returns the MapData
  MapData _getMapData() {
    return _dataLoader.getMapData();
  }
}
