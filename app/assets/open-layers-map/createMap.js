class CreateMap {
    map;
    U1BusStopMarkersLayer;
    UniBuildingMarkersLayer;
    LandmarkMarkersLayer;
    UserLocationLayer;
    layerEnum;
    IDLayersMap;
    busRouteLayer;

    constructor() {
        /*
            Map
        */

        this.map = new ol.Map({
            view: new ol.View({
                center: new ol.proj.fromLonLat([1, 1]),
                zoom: 1,
            }),
            layers: [
                new ol.layer.Tile({
                    source: new ol.source.OSM(),
                }),
            ],
            target: 'map',
        });

        // This layer shows the U1 bus stop markers
        this.U1BusStopMarkersLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    scale: [0.10, 0.10],
                    src: "U1BusStopMarker.png",
                }),
            }),
        });
        this.U1BusStopMarkersLayer.isMarkerLayer = true;

         // This layer shows the uni building markers
        this.UniBuildingMarkersLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    scale: [0.10, 0.10],
                    src: "UniBuildingMarker.png",
                }),
            }),
        });
        this.UniBuildingMarkersLayer.isMarkerLayer = true;

        // This layer shows the landmark markers
        this.LandmarkMarkersLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    scale: [0.10, 0.10],
                    src: "LandmarkMarker.png",
                }),
            }),
        });
        this.LandmarkMarkersLayer.isMarkerLayer = true;

        // This layer shows the Users location
        this.UserLocationLayer = new ol.layer.Vector({
            source: new ol.source.Vector(),
            style: new ol.style.Style({
                image: new ol.style.Icon({
                    anchor: [0.5, 1],
                    scale: [0.10, 0.10],
                    src: "UserIcon.png",
                }),
            }),
        });
        this.UserLocationLayer.isMarkerLayer = false;

        // Enum to identify the type of layer
        this.layerEnum = {
            markerLayer: 'markerLayer',
            geoJsonLayer: 'geoJsonLayer'
        };

        // Creates a hash map to map the given id's to the layers
        this.IDLayersMap = new Map();

        // Detects if a marker has been clicked
        let currentMap = this.map;
        let markerClickedMethod = this.markerClicked;
        currentMap.on("click", function (e) {
            let markerFound = false;
            currentMap.forEachFeatureAtPixel(e.pixel, function (feature, layer) {
                if (layer.isMarkerLayer && markerFound == false) {
                    markerClickedMethod(feature);
                    markerFound = true;
                }
            })
        });

        // This layer shows drawn bus route
        this.busRouteLayer = new ol.layer.VectorImage({
            source: new ol.source.Vector({
                format: new ol.format.GeoJSON(),
            }),
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: [0, 0, 255, 0.75],
                    width: 8,
                }),
            }),
        });

        this.addLayers();
    }

    // Sets the centre of the map and the zoom
    setCentreZoom(value) {
        this.map.getView().setZoom(value.zoom);
        this.map.getView().setCenter(ol.proj.fromLonLat([value.long, value.lat]));
    }

    // Maps the given id's to the layers
    mapIdsToLayers(layerIds) {
        const U1Map = new Map();
        const UniBuildingMap = new Map();
        const LandmarkMap = new Map();
        const UserLocationMap = new Map();

        U1Map.set(this.layerEnum.markerLayer, this.U1BusStopMarkersLayer);
        U1Map.set(this.layerEnum.geoJsonLayer, this.busRouteLayer);
        UniBuildingMap.set(this.layerEnum.markerLayer, this.UniBuildingMarkersLayer);
        LandmarkMap.set(this.layerEnum.markerLayer, this.LandmarkMarkersLayer);
        UserLocationMap.set(this.layerEnum.markerLayer, this.UserLocationLayer);

        this.IDLayersMap.set(layerIds.U1, U1Map);
        this.IDLayersMap.set(layerIds.UniBuilding, UniBuildingMap);
        this.IDLayersMap.set(layerIds.Landmark, LandmarkMap);
        this.IDLayersMap.set(layerIds.UserLocation, UserLocationMap);
    }

    // Adds the markers
    addMarker(markedFeature) {
        const layer = this.IDLayersMap.get(markedFeature.layerId).get(this.layerEnum.markerLayer);
        const marker = new ol.Feature(new ol.geom.Point(ol.proj.fromLonLat([markedFeature.longitude, markedFeature.latitude])));
        marker.setId(markedFeature.id);
        layer.getSource().addFeature(marker);
    }

    // Toggles the visibility of the markers
    toggleShowLayers(visible) {
        const layers = Array.from(this.IDLayersMap.get(visible.layerId).values());
        layers.forEach(function (layer) {
            layer.setVisible(visible.visible);
        })
    }

    // Removes the users icon
    removeUserIcon(userPosition) {
        const source = this.UserLocationLayer.getSource();
        source.removeFeature(source.getFeatureById(userPosition.id));
    }

    // Updates the location of the users icon
    updateUserIcon(userPosition) {
        this.removeUserIcon(userPosition);
        this.addUserIcon(userPosition);
    }

    // Marker interaction
    markerClicked(marker) {
        MarkerClickedDart.postMessage(marker.getId());
    }

    // Add the given GeoJson to the map
    drawBusRouteLines(geoJson) {
        this.busRouteLayer.getSource().addFeatures((new ol.format.GeoJSON({
            featureProjection: 'EPSG:3857',
            dataProjection: 'EPSG:4326'
        })).readFeatures(geoJson.busRoute));
    }

    // Adds the layers to the map
    addLayers() {
        this.map.addLayer(this.busRouteLayer);
        this.map.addLayer(this.U1BusStopMarkersLayer);
        this.map.addLayer(this.UniBuildingMarkersLayer);
        this.map.addLayer(this.LandmarkMarkersLayer);
        this.map.addLayer(this.UserLocationLayer);
    }
}