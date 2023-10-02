import QtQuick 2.15
import QtQuick.Controls 2.15

import QtLocation 5.15
import QtPositioning 5.15

import Qomponent 0.1

import cardian 0.1

import '.'

Control {
    id: control

    property alias map: map
    property alias center: map.center
    property alias bearing: map.bearing
    property alias zoomLevel: map.zoomLevel
    property alias tapInserter: tapInserter
    property alias dragablePoly: dragPoly

    property ListModel polygons: Status.polygons
    property ListModel activePolygon: ListModel {}

    property var currentUserLocation: undefined
    property var currentCarLocation: Status.location.x && Status.location.y ?
                                         QtPositioning.coordinate(Status.location.y, Status.location.x) :
                                         QtPositioning.coordinate()

    property string token: Config.mapToken

    property var mapBoxLayersStyle: [
        {id:'land',                style: [{backgroundColor: palette.window}]},
        {id:'national-park',       style: [{fillColor: ''}]},
        {id:'landuse',             style: [{fillColor: '#219188'}]},
        {id:'pitch-outline',       style: [{lineColor: ''}]},
        {id:'waterway',            style: [{lineColor: ''}]},
        {id:'water',               style: [{fillColor: ''}]},
        {id:'building',            style: [{fillColor: ''}, {fillColorOutline: ''}]},
        {id:'road-simple',         style: [{lineColor: palette.base}, {lineWidth: null}]},
        {id:'bridge-simple',       style: [{lineColor: palette.base}, {lineWidth: null}]},
        {id:'road-label-simple',   style: [{textColor: palette.text}, {textHaloColor: ''}]},
        {id:'state-label',         style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'country-label',       style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'continent-label',     style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'natural-point-label', style: [{textColor: ''}, {textHaloColor: ''}, {iconOpacity: 0}]},
        // {id:'road-path',           style: [{lineColor: palette.buttonText}]},
    ];

    /**
     * @abstract Route from start point to endpoint
     * @param path {Array}, an array containing list of point {lat: Number, lon: Number}
     */
    function route(path) {
        routeQuery.clearWaypoints();
        for(const point of path) {
            routeQuery.addWaypoint(QtPositioning.coordinate(point.lat, point.lon));
        }
    }

    /**
     * @abstract Create a MapParameter object from input args.
     * @param args {Object}, properties of MapParameter.
     */
    function mapItemFactory(args: Object): string {
        const keys = Object.keys(args);
        const source = `import QtLocation 5.15\nMapParameter { type:'paint'; ${keys.reduce((c,k) => c + `property string ${k};`, '')} }`;
        const object =  Qt.createQmlObject(source, map);
        keys.forEach(k => object[k] = args[k]);
        return object;
    }

    onMapBoxLayersStyleChanged: {
        map.clearMapItems();
        const filter = function(obj) { return Object.values(obj)[0] ? obj : null };
        mapBoxLayersStyle.forEach(function(layer) {
            /// Convert styles to a single object
            const styles = layer.style.reduce((c, v) => Object.assign(c, filter(v)), {});

            if(Object.keys(styles).length) {
                const args = Object.assign(styles, {layer: layer.id});
                map.addMapParameter(mapItemFactory(args));
            }
        });
    }

    RouteModel {
        id: routeModel

        autoUpdate: true
        query: routeQuery

        plugin: Plugin {
            name: "mapbox"
            PluginParameter { name: "mapbox.access_token"; value: control.token }
        }
    }

    RouteQuery { id: routeQuery }

    contentItem: Map {
        id: map

        opacity: 1.0
        zoomLevel: 14
        copyrightsVisible: false
        center: QtPositioning.coordinate(36.3162, 59.5408) // Mashhad
        color: "transparent"
        gesture.enabled: !dragPoly.dragging

        plugin: Plugin {
            name: 'mapboxgl'
            locales: ['en_US' ,'fa_IR']
            preferred: ["mapboxgl", 'osm', "mapbox"]

            PluginParameter {
                name: 'mapboxgl.access_token'
                value: control.token
            }

            PluginParameter {
                name: 'mapboxgl.mapping.cache.memory'
                value: false
            }

            PluginParameter {
                name: 'mapboxgl.mapping.additional_style_urls'
                value: 'qrc:/resources/mapgl/dark-style.json'
            }
        }

        TapHandler {
            id: tapInserter
            grabPermissions: TapHandler.ApprovesTakeOverByAnything
            /// TODO: Insert the new point between the nearest points.
            onTapped: event => {
                const {longitude, latitude} = map.toCoordinate(event.position);
                const {i} = JsUtils.findNearestPoint(Qt.vector2d(longitude, latitude), activePolygon);
                activePolygon.insert(i, {longitude, latitude});
            }
        }

        MapItemView {
            model: routeModel

            delegate: MapRoute {
                route: model.routeData
                line.color: "#aaF5478D"
                line.width: map.zoomLevel > 5 ? map.zoomLevel/2.8 : 0
                smooth: true
                opacity: index ? 0.3 : 1.0
            }
        }

        MapItemView {
            model: polygons

            /// TODO: Add a id number, or some pattern inside polygon.
            delegate: MapItemGroup {
                required property int index
                required property var poly

                MapPolygon {
                    opacity: 0.3
                    color: index === Config.selectedMap ? control.palette.text : control.palette.highlight
                    border.color: control.palette.window
                    border.width: 1

                    path: Array(poly.count).fill().map((_, i) => poly.get(i));
                }

                MapQuickItem {
                    anchorPoint.x: sourceItem.width/2
                    anchorPoint.y: sourceItem.height/2
                    coordinate: {
                        const {y, x} = JsUtils.polygonCenter(poly);
                        return QtPositioning.coordinate(y, x);
                    }
                    sourceItem: Label {
                        text: index + 1; font: Fonts.head
                        color: control.palette.buttonText
                        opacity: 0.6
                    }
                }
            }
        }

        MapDragPolygon {
            id: dragPoly
            model: activePolygon
            font: Fonts.btnicon
            subscriptFont: Fonts.subscript
        }

        MapQuickItem {
            coordinate: control.currentUserLocation ?? QtPositioning.coordinate()
            anchorPoint{x: 7.5; y: 7.5}
            sourceItem: Rectangle {
                width: 15; height: 15; radius: width
                color: control.palette.text
                border.color: control.palette.button
            }
        }

        MapQuickItem {
            coordinate: control.currentCarLocation ?? QtPositioning.coordinate()
            anchorPoint{x: sourceItem.width / 2; y: sourceItem.height / 2}
            sourceItem: Label {
                text: '\ue079'; font: Fonts.icon
                color: control.palette.text
            }
        }

        Shortcut {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequence: StandardKey.ZoomIn
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1);
        }

        Shortcut {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequence: StandardKey.ZoomOut
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1);
        }
    }
}
