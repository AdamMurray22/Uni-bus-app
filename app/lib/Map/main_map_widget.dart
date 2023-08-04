import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'bus_route_geojson_loader.dart';
import 'map_centre_enum.dart';
import 'map_data_id_enum.dart';
import '../MapData/feature.dart';
import '../MapData/map_data.dart';
import '../MapData/map_data_loader.dart';
import 'map_widget.dart';

class MainMapWidget extends MapWidget {
  const MainMapWidget({super.markerClickedFunction, super.key});

  @override
  MapWidgetState<MainMapWidget> createState() => MainMapWidgetState();
}

/// The main map screen state.
class MainMapWidgetState extends MapWidgetState<MainMapWidget> {

  /// Sets the values for the map set up.
  @override
  void initState() {
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
    super.initState();
  }

  /// Centres and zooms the map around the given marker.
  setMapCentreAndZoom(Feature marker) {
    setMapCentreZoom(
        marker.lat, marker.long, MapCentreEnum.markerClickedZoom.value);
  }

  // Assigns an id to each layer used by this map to be referenced later.
  @override
  createLayers() {
    createGeoJsonLayer(MapDataId.u1Route.idPrefix, "blue", 8);
    createMakerLayer(MapDataId.u1.idPrefix, "U1BusStopMarker.png", 0.1, true);
    createMakerLayer(MapDataId.uniBuilding.idPrefix, "UniBuildingMarker.png", 0.1, true);
    createMakerLayer(MapDataId.landmark.idPrefix, "LandmarkMarker.png", 0.1, true);
    createMakerLayer(MapDataId.userLocation.idPrefix, "UserIcon.png", 0.1, false);
  }

  // Adds the markers to the map.
  _addMarkers(MapData mapData) {
    for (Feature feature in mapData.getAllFeatures()) {
      addMarker(feature.typeId.idPrefix, feature.id, feature.long, feature.lat);
    }
  }

  // Displays the bus route on the map.
  _loadBusRouteGeoJson() async {
    String busRouteJson = await BusRouteGeoJsonLoader.getBusRouteGeoJsonLoader().getBusRouteGeoJsonAsString();
    await addGeoJson(MapDataId.u1Route.idPrefix, busRouteJson);
  }
}