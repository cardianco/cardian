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

        MapSystem {
            id: mapsystem
            anchors.fill: parent
        }

        Grid {
            x: 5; y: parent.height - height - 30
            opacity: 0.7

            Label {
                text: {
                    return mapsystem.center.latitude.toFixed(4) + '\n' +
                           mapsystem.center.longitude.toFixed(4)
                }
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
                text: "\ue07f"
                font: Fonts.icon
                rotation: -mapsystem.bearing

                HoverHandler { cursorShape: Qt.PointingHandCursor }
                TapHandler {
                    onTapped: anim.start()

                    property NumberAnimation anim: NumberAnimation {
                        target: mapsystem
                        property: "bearing"
                        to: mapsystem.bearing < 180 ? 0 : 360
                        duration: 500
                        easing.type: Easing.InOutQuad
                        onFinished: mapsystem.bearing = 0;
                    }
                }
            }

            Label {
                text: mapsystem.zoomLevel.toFixed(2)
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
                    onPressed: mapsystem.zoomLevel += 0.1;
                }
                minus {
                    text: "\ue004";
                    autoRepeat: true
                    font: Fonts.icon
                    onPressed: mapsystem.zoomLevel -= 0.1;
                }
            }

            HexagonButton {
                width: 40
                font: Qomponent.font(Fonts.icon, {pointSize: 13})
                text: mapsystem.currentUserLocation ? '\ue07a' : '\ue07b'
                onClicked: mapsystem.center = marker.coordinate
            }
        }
    }
}
