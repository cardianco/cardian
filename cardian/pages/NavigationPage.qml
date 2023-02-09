import QtQuick 2.15
import QtQuick.Controls 2.15

import QtLocation 5.15
import QtPositioning 5.15

import Hive 1.0
import Qomponent 0.1
import cardian 0.1

BasePage {
    id: form

    contentData: Item {
        width: form.width
        height: form.height
        Map {
            id: map
            anchors.fill: parent

            opacity: 1.0
            zoomLevel: 14
            copyrightsVisible : false
            center: QtPositioning.coordinate(36.3162, 59.5408) // Mashhad
            color: "transparent"

            plugin: Plugin {
                name: "mapboxgl"
                locales: "fa_IR"

                PluginParameter {
                    name: 'mapboxgl.access_token'

                PluginParameter {
                    name: 'mapboxgl.access_token'
                }
                PluginParameter {
                    name: 'mapboxgl.mapping.cache.memory'
                    value: "true"
                }

                PluginParameter{
                       name: 'mapboxgl.mapping.additional_style_urls'
                }
            }
            MapParameter {
                type: "source"

                property string name: "routeSource"
                property string sourceType: "geojson"
                property string data: '{ "type": "FeatureCollection", "features": \
                    [{ "type": "Feature", "properties": {}, "geometry": { \
                    "type": "LineString", "coordinates": [[ 24.934938848018646, \
                    60.16830257086771 ], [ 24.943315386772156, 60.16227776476442 ]]}}]}'
            }

            MapParameter { type: "paint"
                property string layer: "route"
                property string lineColor: "red"
            }
//            MapParameter { type: "paint"
//                property string layer: "background"
//                property string backgroundColor: "#131314"
//            }
//            MapParameter { type: "paint"
//                property string layer: "water"
//                property string fillColor: "#28a0db"
//            }
//            MapParameter { type: "paint"
//                property string layer: "road-simple"
//                property string lineColor: Qt.darker(form.palette.button, 1.8)
//            }
//            MapParameter { type: "paint"
//                property string layer: "landuse"
//                property string fillColor: "#0a3439"
//            }
//            MapParameter { type: "paint"
//                property string layer: "building"
//                property string fillColor: "#28a0db"
//            }

            MapQuickItem {
                id: marker
                sourceItem: Text{
                    id: flag
                    text: '\ue071'//'\ue077','\ue160'
                    font.pixelSize: Math.pow(map.zoomLevel/8,3) + 14
                    font.family: Fonts.icon.family
                }
                anchorPoint.x: sourceItem.width/2
                anchorPoint.y: sourceItem.height
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: containsPress || map.gesture.panActive ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                // marker.coordinate = map.toCoordinate(Qt.point(mouse.x,mouse.y))
            }
        }

        Grid {
            x: 5; y: parent.height - height - 30
            opacity: 0.7

            Label {
                text: `${map.center.latitude.toFixed(4)}\n${map.center.longitude.toFixed(4)}`
                font: Fonts.subscript
            }
            Label { text: "© Mapbox - © OSM"; font: Fonts.subscript }
        }

        Grid {
            x: parent.width - width - 10
            y: parent.height - height - 30

            opacity: 0.7
            horizontalItemAlignment: Grid.AlignHCenter

            Label {
                text: "\ue079"
                font: Fonts.icon
                rotation: map.bearing

                AbstractButton {
                    anchors.fill: parent
                    onClicked: parent.anim.start()
                }

                property var anim: NumberAnimation {
                    target: map
                    property: "bearing"
                    to: map.bearing < 180 ? 0 : 360
                    duration: 500
                    easing.type: Easing.InOutQuad
                    onFinished: map.bearing = 0
                }
            }

            Label {
                text: map.zoomLevel.toFixed(2)
                font: Fonts.subscript
            }
        }

        Grid {
            spacing: 5
            x: parent.width - width - 5
            y: (parent.height - height)/2
            horizontalItemAlignment: Grid.AlignHCenter

            MapToolButton {
                width: 35
                plus {
                    text: "\u002b";
                    autoRepeat: true
                    font: Fonts.icon
                    onPressed: map.zoomLevel += 0.1
                }
                minus {
                    text: "\ue004";
                    autoRepeat: true
                    font: Fonts.icon
                    onPressed: map.zoomLevel -= 0.1
                }
            }

            HexagonButton {
                width: 40
                font: Qomponent.font(Fonts.icon, {pointSize: 13})
                text: marker.coordinate !== "" ? "\ue07a" : "\ue07b"
                onClicked: map.center = marker.coordinate
            }
        }
    }
}
