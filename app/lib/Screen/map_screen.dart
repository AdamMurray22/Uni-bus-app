import 'package:app/MapData/feature.dart';
import 'package:app/MapData/map_data_loader.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Map/map_data_id_enum.dart';
import '../Map/open_layers_map.dart';
import '../MapData/map_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapDataLoader _dataLoader = MapDataLoader.getDataLoader();

  late final OpenLayersMap _mapController;
  final SingleValueDropDownController _dropDownController = SingleValueDropDownController();
  final List<DropDownValueModel> _dropDownList = [];
  final List<Text> _featureInfo = [];
  String _featureInfoTitle = "";

  List<String> _infoText = [];
  bool _featureInfoVisible = false;
  bool _u1ValueCheck = true;
  bool _uniBuildingValueCheck = true;
  bool _landmarkValueCheck = true;

  @override
  initState() {
    _mapController = OpenLayersMap();
    _dataLoader.onDataLoaded((mapData) {
      setState(() {
        for (Feature feature in mapData.getAllFeatures()) {
          _dropDownList
              .add(DropDownValueModel(name: feature.name, value: feature.id));
        }
      });
    });
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
              if (value == "")
              {
                setState(() {
                  _featureInfoVisible = false;
                });
                return;
              }
              setState(() {
                _showMapFeatureInfoPanel(value.value);
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: _featureInfo),
                              ]),
                        ),
                      ),
                    ]),
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
                    setState(() {
                      _u1ValueCheck = value!;
                    });
                    _mapController.toggleMarkers(MapDataId.u1, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _u1ValueCheck,
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
                    setState(() {
                      _uniBuildingValueCheck = value!;
                    });
                    _mapController.toggleMarkers(MapDataId.uniBuilding, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _uniBuildingValueCheck,
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
                    setState(() {
                      _landmarkValueCheck = value!;
                    });
                    _mapController.toggleMarkers(MapDataId.landmark, value!);
                  },
                  activeColor: Color(0xff3a57e8),
                  autofocus: false,
                  checkColor: Color(0xffffffff),
                  hoverColor: Color(0x42000000),
                  splashRadius: 20,
                  value: _landmarkValueCheck,
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
    _infoText = feature.toDisplay();
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
  }

  // Returns the MapData
  MapData _getMapData() {
    return _dataLoader.getMapData();
  }
}
