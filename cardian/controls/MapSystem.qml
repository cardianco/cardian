import QtQuick 2.15
import QtQuick.Controls 2.15

import QtLocation 5.15
import QtPositioning 5.15

import cardian 0.1

Control {
    id: control

    property alias map: map
    property alias center: map.center
    property alias bearing: map.bearing
    property alias zoomLevel: map.zoomLevel

    property var currentUserLocation: undefined // QtPositioning.coordinate(36.3162, 59.5408)
    property string token: "pk.eyJ1Ijoic21yNzYiLCJhIjoiY2t3dzVtN2ZvMDBmeDJ2bGFqcGR5em1leiJ9.SpNKEOM_dOgZyLTv154K_A"

    property var polygons: [
//        [[36.3162, 59.5408], [36.3112, 59.5338], [36.3112, 59.5458]]
    ];

    property var mapBoxLayersStyle: [
        {id:'land',                style: [{backgroundColor: ''}]},
        {id:'national-park',       style: [{fillColor: ''}]},
        {id:'landuse',             style: [{fillColor: '#0a6b8f'}]},
        {id:'pitch-outline',       style: [{lineColor: ''}]},
        {id:'waterway',            style: [{lineColor: ''}]},
        {id:'water',               style: [{fillColor: ''}]},
        {id:'building',            style: [{fillColor: ''}, {fillColorOutline: ''}]},
        {id:'road-path',           style: [{lineColor: ''}]},
        {id:'road-simple',         style: [{lineColor: ''}, {lineWidth: null}]},
        {id:'road-label-simple',   style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'state-label',         style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'country-label',       style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'continent-label',     style: [{textColor: ''}, {textHaloColor: ''}]},
        {id:'natural-point-label', style: [{textColor: ''}, {textHaloColor: ''}, {iconOpacity: 0}]},
    ];

    property Component paintParam: MapParameter {
        type:'paint'
        property string layer
        property string fillColor
//        property string textColor
//        property string textHaloColor
//        property string backgroundColor
//        property string fillColorOutline
    }

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

    onMapBoxLayersStyleChanged: {
        const filter = (obj => Object.values(obj)[0] ? obj : null);
        mapBoxLayersStyle.forEach(layer => {
            const args = layer.style.reduce((c, v) => Object.assign(c, filter(v)), {});
            if(Object.keys(args).length) {
                const obj = paintParam.createObject(map, Object.assign(args, {layer: layer.id}));
                map.addMapParameter(obj)
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

        plugin: Plugin {
            locales: "fa_IR"
            preferred: ["mapboxgl", "osm"]

            PluginParameter {
                name: 'mapboxgl.access_token'
                value: control.token
            }

            PluginParameter {
                name: 'mapboxgl.mapping.additional_style_urls'
                value: 'qrc:/style.json'
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

        Repeater {
            model: polygons
            MapPolygon {
                color: control.palette.highlight
                border.color: '#fff'
                border.width: 4
                opacity: 0.5
                path: modelData.map(v => {return {latitude: v[0], longitude: v[1]}})
            }
        }

        MapQuickItem {
            id: userLocation
            sourceItem: Label {
                text: '\ue079'; font: Fonts.icon
                color: control.palette.text
            }
            coordinate: control.currentUserLocation ?? QtPositioning.coordinate()
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height
        }

        MouseArea {
            anchors.fill: parent
            // BUG: It seems that there is no possible way to set the 'ClosedHand' shape solely by dragging.
            cursorShape: pressed || map.gesture.panActive ? Qt.ClosedHandCursor : Qt.OpenHandCursor
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
