let map;
let U1BusStopMarkersLayer;
let UniBuildingMarkersLayer;
let LandmarkMarkersLayer;
let UserLocationLayer;
let layerEnum;
let IDLayersMap;
let busRouteLayer;

let createMap = function () {
    /*
    Map
    */

    map = new ol.Map({
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
    U1BusStopMarkersLayer = new ol.layer.Vector({
        source: new ol.source.Vector(),
        style: new ol.style.Style({
            image: new ol.style.Icon({
                anchor: [0.5, 1],
                scale: [0.10, 0.10],
                src: "U1BusStopMarker.png",
            }),
        }),
    });
    U1BusStopMarkersLayer.isMarkerLayer = true;

// This layer shows the uni building markers
    UniBuildingMarkersLayer = new ol.layer.Vector({
        source: new ol.source.Vector(),
        style: new ol.style.Style({
            image: new ol.style.Icon({
                anchor: [0.5, 1],
                scale: [0.10, 0.10],
                src: "UniBuildingMarker.png",
            }),
        }),
    });
    UniBuildingMarkersLayer.isMarkerLayer = true;

// This layer shows the landmark markers
    LandmarkMarkersLayer = new ol.layer.Vector({
        source: new ol.source.Vector(),
        style: new ol.style.Style({
            image: new ol.style.Icon({
                anchor: [0.5, 1],
                scale: [0.10, 0.10],
                src: "LandmarkMarker.png",
            }),
        }),
    });
    LandmarkMarkersLayer.isMarkerLayer = true;

// This layer shows the Users location
    UserLocationLayer = new ol.layer.Vector({
        source: new ol.source.Vector(),
        style: new ol.style.Style({
            image: new ol.style.Icon({
                anchor: [0.5, 1],
                scale: [0.10, 0.10],
                src: "UserIcon.png",
            }),
        }),
    });
    UserLocationLayer.isMarkerLayer = false;

// Enum to identify the type of layer
    layerEnum = {
        markerLayer: 'markerLayer',
        geoJsonLayer: 'geoJsonLayer'
    };

// Creates a hash map to map the given id's to the layers
    IDLayersMap = new Map();

// Detects if a marker has been clicked
    map.on("click", function (e) {
        let markerFound = false;
        map.forEachFeatureAtPixel(e.pixel, function (feature, layer) {
            if (layer.isMarkerLayer && markerFound == false) {
                markerClicked(feature);
                markerFound = true;
            }
        })
    });

// This layer shows drawn bus route
    busRouteLayer = new ol.layer.VectorImage({
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

    addLayers();
}

// Sets the centre of the map and the zoom
function setCentreZoom(value) {
    map.getView().setZoom(value.zoom);
    map.getView().setCenter(ol.proj.fromLonLat([value.long, value.lat]));
}

// Maps the given id's to the layers
function mapIdsToLayers(layerIds) {
    const U1Map = new Map();
    const UniBuildingMap = new Map();
    const LandmarkMap = new Map();
    const UserLocationMap = new Map();

    U1Map.set(layerEnum.markerLayer, U1BusStopMarkersLayer);
    U1Map.set(layerEnum.geoJsonLayer, busRouteLayer);
    UniBuildingMap.set(layerEnum.markerLayer, UniBuildingMarkersLayer);
    LandmarkMap.set(layerEnum.markerLayer, LandmarkMarkersLayer);
    UserLocationMap.set(layerEnum.markerLayer, UserLocationLayer);

    IDLayersMap.set(layerIds.U1, U1Map);
    IDLayersMap.set(layerIds.UniBuilding, UniBuildingMap);
    IDLayersMap.set(layerIds.Landmark, LandmarkMap);
    IDLayersMap.set(layerIds.UserLocation, UserLocationMap);
}

// Adds the markers
function addMarker(markedFeature) {
    const layer = IDLayersMap.get(markedFeature.layerId).get(layerEnum.markerLayer);
    const marker = new ol.Feature(new ol.geom.Point(ol.proj.fromLonLat([markedFeature.longitude, markedFeature.latitude])));
    marker.setId(markedFeature.id);
    layer.getSource().addFeature(marker);
}

// Toggles the visibility of the markers
function toggleShowLayers(visible) {
    const layers = Array.from(IDLayersMap.get(visible.layerId).values());
    layers.forEach(function (layer) {
        layer.setVisible(visible.visible);
    })
}

// Removes the users icon
function removeUserIcon(userPosition) {
    var source = UserLocationLayer.getSource();
    source.removeFeature(source.getFeatureById(userPosition.id));
}

// Updates the location of the users icon
function updateUserIcon(userPosition) {
    removeUserIcon(userPosition);
    addUserIcon(userPosition);
}

// Marker interaction
function markerClicked(marker) {
    MarkerClickedDart.postMessage(marker.getId());
}

// Add the given GeoJson to the map
function drawBusRouteLines(geoJson) {
    busRouteLayer.getSource().addFeatures((new ol.format.GeoJSON({
        featureProjection: 'EPSG:3857',
        dataProjection: 'EPSG:4326'
    })).readFeatures(geoJson.busRoute));
}

// Adds the layers to the map
function addLayers() {
    map.addLayer(busRouteLayer);
    map.addLayer(U1BusStopMarkersLayer);
    map.addLayer(UniBuildingMarkersLayer);
    map.addLayer(LandmarkMarkersLayer);
    map.addLayer(UserLocationLayer);
}