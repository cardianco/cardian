import QtQuick 2.15
import QtQuick.Controls 2.15

import QtLocation 5.15
import QtPositioning 5.15

import Qomponent 0.1

MapItemGroup {
    id: control

    property font font
    property font subscriptFont
    property bool dragging: false
    property color color: palette.button

    property alias model: itemView.model

    MapPolygon {
        color: control.color
        border.color: control.color
        border.width: 1
        opacity: 0.5

        path: Array(model.count).fill().map(function(_, i) {
            const {latitude, longitude} = model.get(i);
            return QtPositioning.coordinate(latitude, longitude);
        });
    }

    MapItemView {
        id: itemView
        model: activePolygon

        delegate: MapQuickItem {
            required property var index
            required property var latitude
            required property var longitude

            anchorPoint{x: 5; y: sourceItem.height - 2}

            coordinate: draghandler.active ? coordinate :
                                             QtPositioning.coordinate(latitude, longitude)

            sourceItem: Row {
                Label {
                    text: '\ue195'

                    font: control.font
                    color: Qomponent.alpha(control.color, 0.3)

                    style: Text.Outline
                    styleColor: palette.buttonText

                    transform: Rotation {
                        angle: draghandler.active * -22
                        origin{x: -10; y:20}
                        Behavior on angle {SmoothedAnimation{}}
                    }
                }
                Label { text: index; font: subscriptFont }
            }

            onCoordinateChanged: {
                if(draghandler.active && -1 < index) {
                    const {latitude, longitude} = coordinate;
                    control.model.set(index, {longitude, latitude});
                }
            }

            TapHandler { onLongPressed: control.model.remove(index) }

            DragHandler {
                id: draghandler
                dragThreshold: 1
                onActiveChanged: control.dragging = active
                grabPermissions: PointerHandler.CanTakeOverFromAnything
            }
        }
    }
}
