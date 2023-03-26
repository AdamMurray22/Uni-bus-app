import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import '../MapData/feature.dart';
import '../MapData/map_data.dart';
import '../MapData/map_data_loader.dart';
import 'map_widget.dart';

class MainMapWidget extends MapWidget {
  const MainMapWidget({this.markerClickedFunction, super.key});

  // The function to be run whenever a marker is clicked.
  final Function(String)? markerClickedFunction;

  @override
  State<MapWidget> createState() => MainMapWidgetState();
}

/// The main map screen state.
class MainMapWidgetState extends MapWidgetState<MainMapWidget> {

  /// Sets the values for the map set up.
  @override
  void initState() {
    mapPath = 'assets/open-layers-map/main_map.html';
    onPageFinished = (url) async {
      setMapCentreZoom(MapCentreEnum.lat.value, MapCentreEnum.long.value,
          MapCentreEnum.initZoom.value);
      // When the page finishes loading it sets the data to be loaded into the map.
      MapDataLoader.getDataLoader().onDataLoaded((mapData) {
        _addMarkers(mapData);
      });
      addUserLocationIcon();
      _loadBusRouteGeoJson();
    };
    javascriptChannels.add(JavascriptChannel(
        name: 'MarkerClickedDart',
        onMessageReceived: (JavascriptMessage markerIdMessage) {
          _markerClicked(markerIdMessage.message);
        }));
    super.initState();
  }

  /// Toggles the visibility of the U1 bus stop markers on the map.
  toggleMarkers(MapDataId layerId, bool visible) {
    String jsObject = "{layerId: '${layerId.idPrefix}', visible: $visible}";
    webViewController.runJavascript("toggleShowLayers($jsObject)");
  }

  /// Centres and zooms the map around the given marker.
  setMapCentreAndZoom(Feature marker) {
    setMapCentreZoom(
        marker.lat, marker.long, MapCentreEnum.markerClickedZoom.value);
  }

  // Assigns an id to each layer used by this map to be referenced later.
  @override
  assignLayerIds() {
    String u1 = MapDataId.u1.idPrefix;
    String uniBuilding = MapDataId.uniBuilding.idPrefix;
    String landmark = MapDataId.landmark.idPrefix;
    String userLocation = MapDataId.userLocation.idPrefix;
    String jsObject =
        "{U1: '$u1', UniBuilding: '$uniBuilding', Landmark: '$landmark', UserLocation: '$userLocation'}";
    webViewController.runJavascript("mapIdsToLayers($jsObject)");
  }

  // Adds the markers to the map.
  _addMarkers(MapData mapData) {
    for (Feature feature in mapData.getAllFeatures()) {
      addMarker(feature.typeId, feature.id, feature.long, feature.lat);
    }
  }

  // This is called when a marker on the map gets clicked.
  _markerClicked(String markerId) {
    if (widget.markerClickedFunction == null) {
      return;
    }
    widget.markerClickedFunction!(markerId);
  }

  //Displays the bus route on the map.
  _loadBusRouteGeoJson() async {
    String busRouteJson = await rootBundle
        .loadString(join("assets", "open-layers-map/Bus_Route.geojson"));
    String jsObject = "{busRoute: `$busRouteJson`}";
    webViewController.runJavascript("drawBusRouteLines($jsObject)");
  }
}
